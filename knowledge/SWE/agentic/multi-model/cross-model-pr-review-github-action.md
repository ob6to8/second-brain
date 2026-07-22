---
id: em:9b5d41
type: snippet
title: "Cross-model PR review GitHub Action"
description: "A drop-in GitHub Actions workflow that reviews each pull request with a different model provider than the one that authored it, posting a summary review plus inline diff-anchored comments via the GitHub API."
tags: [github-actions, code-review, multi-model, openrouter, ci, snippet]
timestamp: 2026-07-21
attribution:
  when: 2026-07-21
  channel: agent-authored
  agent: "Claude Code agent, operator chat session on multi-model dev environments"
  why: "operator chose a PR-based cross-model review as the first step toward escaping single-provider lock-in; this is the concrete Shape C artifact"
---

# Cross-model PR review GitHub Action

The concrete **Shape C** artifact from
[escaping single-provider lock-in](/knowledge/SWE/agentic/multi-model/provider-agnostic-coding-agent-tooling.md):
a workflow you drop into any dev repo so that whatever model **authored** a PR
(Fable via the Claude app/Claude Code, etc.), a **different** model — Codex/GPT,
Kimi, GLM — reviews it. The review lands on the PR as a **summary plus inline
comments anchored to diff lines**, i.e. exactly what a human reviewer's comments
look like.

It routes the reviewer model through **[OpenRouter](https://openrouter.ai)** (one
endpoint → GPT/Codex, Kimi, GLM, …) so switching the reviewer is a one-line model
id change, and it keeps the harness↔model seam out of the loop by using GitHub's
own text-based review surface.

## Setup

1. Add repo secret **`OPENROUTER_API_KEY`** (Settings → Secrets → Actions).
   **Gateway-agnostic:** the reviewer call is a plain OpenAI-compatible
   `chat/completions` POST, so any endpoint of that shape drops in by changing the
   base URL + key — [LiteLLM](https://github.com/BerriAI/litellm) (self-hosted,
   own your keys), [Portkey](https://portkey.ai) or Cloudflare AI Gateway (managed,
   with logging/caching/key control), or a **provider's native endpoint** if you
   only ever want one reviewer family. OpenRouter is chosen here only because one
   key spans GPT/Codex, Kimi, and GLM, making a switch of reviewer family a
   one-line change. A single-family provider endpoint works as a reviewer but
   forfeits that cross-family switch. (Note the gateway is the *model-access* layer,
   not an agent harness — a coding agent like Pi/OpenCode sits on the *other* side
   and would be the thing authoring PRs, not the endpoint this Action POSTs to.)
2. Pick the reviewer model in `env.REVIEWER_MODEL` (e.g. `openai/gpt-5.2`,
   `moonshotai/kimi-k2`, `z-ai/glm-4.6`). Choose a **different family** than your
   usual author so the review adds an independent perspective.
3. Commit the file below to `.github/workflows/cross-model-review.yml` in the
   **target dev repo** (not required in a knowledge repo). Reviews then post
   automatically on every PR open/update.

## Notes / failure modes

- The GitHub API rejects an entire review if any inline comment references a line
  **not present in the diff**. The script instructs the model to comment only on
  added/`RIGHT`-side lines and **falls back** to a summary-only review (findings
  inlined into the body) if the batched inline post is rejected — so a mislabeled
  line never loses the whole review.
- Large diffs are truncated to a character budget; tune `MAX_DIFF_CHARS`.
- `permissions` grants `pull-requests: write` (post the review) and
  `contents: read` only.
- Turn any finding into a one-click fix by having the model wrap replacements in a
  ` ```suggestion ` block inside a comment `body` — GitHub renders an "Apply
  suggestion" button.

## The workflow

```yaml
name: Cross-model PR review

on:
  pull_request:
    types: [opened, synchronize, reopened, ready_for_review]

# Only ever run one review per PR; cancel superseded runs.
concurrency:
  group: cross-model-review-${{ github.event.pull_request.number }}
  cancel-in-progress: true

permissions:
  contents: read
  pull-requests: write

jobs:
  review:
    if: ${{ !github.event.pull_request.draft }}
    runs-on: ubuntu-latest
    env:
      REVIEWER_MODEL: openai/gpt-5.2      # <- the model that REVIEWS (pick a family != the author)
      MAX_DIFF_CHARS: "60000"
    steps:
      - uses: actions/github-script@v7
        env:
          OPENROUTER_API_KEY: ${{ secrets.OPENROUTER_API_KEY }}
        with:
          script: |
            const { owner, repo } = context.repo;
            const pull_number = context.payload.pull_request.number;

            // 1. Fetch the unified diff for the PR.
            const diffRes = await github.request(
              'GET /repos/{owner}/{repo}/pulls/{pull_number}',
              { owner, repo, pull_number, mediaType: { format: 'diff' } }
            );
            let diff = String(diffRes.data);
            const cap = parseInt(process.env.MAX_DIFF_CHARS, 10);
            if (diff.length > cap) diff = diff.slice(0, cap) + '\n... [diff truncated] ...';

            // 2. Ask the reviewer model for structured findings.
            const sys = [
              'You are a senior code reviewer. Review the pull request diff.',
              'Return STRICT JSON only, no prose, matching:',
              '{ "summary": string, "comments": [ { "path": string, "line": number, "side": "RIGHT", "body": string } ] }',
              'Rules: comment ONLY on lines that are ADDED or MODIFIED in the diff (side "RIGHT").',
              '`line` is the line number in the NEW version of the file. Be specific and actionable.',
              'Prefer few high-signal comments over many trivial ones. Use ```suggestion blocks for concrete fixes.'
            ].join(' ');

            const resp = await fetch('https://openrouter.ai/api/v1/chat/completions', {
              method: 'POST',
              headers: {
                'Authorization': `Bearer ${process.env.OPENROUTER_API_KEY}`,
                'Content-Type': 'application/json'
              },
              body: JSON.stringify({
                model: process.env.REVIEWER_MODEL,
                response_format: { type: 'json_object' },
                messages: [
                  { role: 'system', content: sys },
                  { role: 'user', content: 'PR diff:\n\n' + diff }
                ]
              })
            });
            if (!resp.ok) {
              core.setFailed(`Reviewer model call failed: ${resp.status} ${await resp.text()}`);
              return;
            }
            const raw = (await resp.json()).choices?.[0]?.message?.content ?? '{}';

            // 3. Parse (defensively strip any code fences the model added).
            let review;
            try {
              review = JSON.parse(raw.replace(/^```(?:json)?/i, '').replace(/```$/,'').trim());
            } catch (e) {
              await github.rest.pulls.createReview({
                owner, repo, pull_number, event: 'COMMENT',
                body: `🤖 Cross-model review (${process.env.REVIEWER_MODEL}) — could not parse structured output:\n\n\`\`\`\n${raw.slice(0, 4000)}\n\`\`\``
              });
              return;
            }

            const comments = Array.isArray(review.comments) ? review.comments
              .filter(c => c && c.path && c.line && c.body)
              .map(c => ({ path: c.path, line: c.line, side: 'RIGHT', body: c.body })) : [];
            const header = `🤖 **Cross-model review** — reviewed by \`${process.env.REVIEWER_MODEL}\`\n\n${review.summary || ''}`;

            // 4. Post the review with inline comments; fall back to summary-only if
            //    line anchoring is rejected by the API.
            try {
              await github.rest.pulls.createReview({
                owner, repo, pull_number, event: 'COMMENT', body: header, comments
              });
            } catch (err) {
              core.warning(`Inline review rejected (${err.message}); posting summary-only.`);
              const inlined = comments.map(c => `- \`${c.path}:${c.line}\` — ${c.body}`).join('\n');
              await github.rest.pulls.createReview({
                owner, repo, pull_number, event: 'COMMENT',
                body: `${header}\n\n---\n${inlined}`
              });
            }
```

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:9b5d41">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-21-multi-model-dev-environment-and-cross-model-pr-review (2026-07-21)

2 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:9b5d41`]**  (co-feeds: `em:db4e6c`)

**Shape C — The code-review workflow (your fallback — and honestly the strongest near-term answer)**

Your instinct here is right, and **yes — a cross-model review looks exactly like you pictured.** When Codex (or GLM, or Kimi) reviews a PR that Fable authored, it shows up on the PR as:

- a **top-level summary review**, plus
- **inline comments anchored to specific diff lines**, and
- optionally **`suggestion` blocks** that GitHub renders with an "Apply suggestion" button.

That's the standard shape, and it's the *most* decoupled-from-provider pattern of everything here, because **GitHub is the shared surface** — the author and the reviewer never need to live in the same harness, they just need to touch the same PR. Off-the-shelf Actions already do this: [tag1consulting/ai-pr-review](https://github.com/tag1consulting/ai-pr-review) (multi-agent, posts summary + inline suggestion blocks), the multi-provider [LLM Code Reviewer](https://github.com/tusgino/llm-code-reviewer/) (GPT / Gemini / Claude selectable), and the [gh-pr-review](https://github.com/agynio/gh-pr-review) CLI extension built specifically to give automated agents full inline-comment support.

Two ways to wire it:

- **CI-driven (simplest):** Fable/Claude Code authors and pushes a PR. A GitHub Action triggered `on: pull_request` calls a *different* provider's API with the diff + a review prompt and posts the review back via the GitHub API. Fully cross-model, zero shared harness, and it survives whatever you change about your authoring tool.
- **Interactive:** OpenCode with a "reviewer" agent pinned to a different model family, or two terminals, handing off through the PR.

And note — **you're already half-way to this pattern.** The harness you're in right now subscribes to PR activity (`subscribe_pr_activity`) and drives reviews through the GitHub MCP tools (`add_comment_to_pending_review`, `pull_request_review_write`). Today the author and reviewer are both Anthropic (you *can* already split roles across Fable/Opus/Sonnet via subagents). Swapping the reviewer step to Codex or GLM is a **change of API endpoint in an Action, not a re-architecture.**

---

**[`em:9b5d41`]**

Done. Both are filed in the brain and pushed to `claude/multi-model-dev-environment-pbxdv7`.

**How the Action works, briefly** — on every PR open/update it fetches the diff, sends it to a reviewer model of a *different* family than the author (routed through OpenRouter so `openai/gpt-5.2` → `moonshotai/kimi-k2` → `z-ai/glm-4.6` is a one-line change), and posts a review with **inline comments anchored to diff lines** plus a summary. The one real failure mode — GitHub rejecting the whole review if a comment points at a line not in the diff — is handled with a summary-only fallback. To use it you just add an `OPENROUTER_API_KEY` secret and pick `REVIEWER_MODEL`.
