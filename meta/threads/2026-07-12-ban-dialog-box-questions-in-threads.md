---
type: reference
title: 2026-07-12-ban-dialog-box-questions-in-threads
description: Added a session-capture policy rule banning the AskUserQuestion dialog UI within threads (its Q&A never enters the captured stream) and re-rendered CLAUDE.md §8.
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-12; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, session-capture, policy, contract, dialog-ui]
timestamp: 2026-07-12
---

# 2026-07-12-ban-dialog-box-questions-in-threads

## Where this landed

The operator reported that questions posed through the dialog-box UI
(`AskUserQuestion`) don't survive into thread docs — the UI has been erroring
out, and neither the question nor the selected answer is persisted. Diagnosed
the mechanism: `/capture` renders a thread doc purely from the delivered
`## User`/`## Assistant` message stream, and a dialog-box exchange lives outside
that stream, so it's lost from the thread doc and everything routed from it. The
fix landed as a new bullet in the **session-capture policy**
(`meta/policy/session-capture.md`) — *"Ask the operator in the chat, not the
dialog box"* — and `CLAUDE.md` §8 was recompiled from it via `mix brain.contract`.
The operator confirmed the compiled-artifact model (the rule lives in the policy
source; `CLAUDE.md` is its generated projection, kept in sync by the `--check`
drift gate). All bundle gates pass; committed and pushed to the feature branch.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Ban the `AskUserQuestion` dialog UI within threads so Q&A survives into thread docs | closed | [session-capture policy](/meta/policy/session-capture.md) | - |
| Confirm the compiled-contract model (CLAUDE.md projected from the policy source) | closed | [session-capture policy](/meta/policy/session-capture.md) | - |

## User

Update claude.md to NOT use the dialog box's presentation of questions via UI within threads. It's airing out for some reason, and answers are not persisted within the thread. And subsequently, the thread documents.

## Assistant

I'll start by giving you a quick priority appraisal (per the session-init note), then dig into your request.

**Top-3 appraisal:** I'd keep the heuristic ranking roughly as-is — the skills-compile plan (`priority: 1`) stays pinned, and the two open operational issues (orphaned branches, `/news` Routine not landing) follow. But your request here is a fresh, concrete contract change that I'll treat as top priority for this session since it's actionable now and affects agent behavior directly.

Let me investigate how questions/dialogs are currently handled in the contract and where the source policy lives.

## Assistant

<routes ref="meta/policy/session-capture.md">
The contract doesn't currently mention the dialog/`AskUserQuestion` UI at all — so this is a new rule to add. Since `CLAUDE.md` is generated, I need to edit the source policy and re-render. The rationale you gave (answers not persisted in the thread doc) ties directly to session capture. Let me read that policy and the capture skill.
</routes>

## Assistant

<routes ref="meta/policy/session-capture.md">
Now I understand the mechanism precisely: `/capture` renders the thread doc from the delivered `## User`/`## Assistant` message stream. A question posed through the dialog-box UI (`AskUserQuestion`) — and the answer selected in it — never enters that text stream, so both vanish from the thread doc. Plus you're seeing the dialog UI error out.

The right home for this rule is the **session-capture policy** (the source `CLAUDE.md` §8 is compiled from), since the rationale is thread-doc persistence. Let me add a bullet there, then re-render.
</routes>

## Assistant

Done. Here's what I changed and why.

**The problem, precisely:** `/capture` builds the thread doc purely from the delivered `## User`/`## Assistant` message stream. A question asked through the `AskUserQuestion` dialog box — and the answer the operator picks in it — lives *outside* that stream, so it never lands in the thread doc, and by extension never reaches the routing ledger, route tags, or any concept routed from the session. Combined with the dialog UI erroring out ("airing out") in these sessions, it's a clear net negative.

**The fix:** Since `CLAUDE.md` is a generated artifact, I edited the source policy rather than the contract directly:

- Added a bullet to `meta/policy/session-capture.md` (§8's source): *"Ask the operator in the chat, not the dialog box"* — pose every question as ordinary `## Assistant` text, never via `AskUserQuestion`, so capture retains the question and its answer verbatim.
- Re-rendered `CLAUDE.md` via `mix brain.contract` so §8 reflects it.

**Verification:** `mix brain.contract --check`, `brain.registry --check`, `brain.verify`, and `brain.route_tags` all pass. Committed to `claude/claude-md-dialog-threading-opvyb6` and pushed.

Two notes:
- I placed this in the **session-capture** policy because the rationale is thread-doc persistence. If you'd rather it read as a general interaction rule (e.g., its own policy or in the preamble), I can move it — but capture is where the "why" is airtight.
- I did **not** open a PR (none requested). Say the word — or run `/create-pull-request` — and I'll capture this session and open one.

## User

That makes sense, as long as it surfaced. The Claude MD is compiled, correct, so  this aspect would be compiled from the session capture policy?

## Assistant

<routes ref="meta/policy/session-capture.md">
Correct — exactly that. The flow is:

`meta/policy/session-capture.md` (the rule's source) → `mix brain.contract` → `CLAUDE.md` §8 "Session capture, routing & route tags."

And it *did* surface — the render diff I ran earlier shows the new bullet landing in `CLAUDE.md` §8, and `mix brain.contract --check` reports "up to date," which is the drift gate confirming the compiled contract matches the source. So the committed `CLAUDE.md` already carries the rule verbatim; the policy edit is the single source of truth and the contract is its generated projection.

Both files went in the same commit, so they can never drift apart in history:
- `meta/policy/session-capture.md` — the authored rule
- `CLAUDE.md` — the recompiled artifact

If you ever edit the policy again, the same `mix brain.contract` step re-projects it (and CI / the pre-commit hook fail loudly via `--check` if someone edits the policy but forgets to re-render).
</routes>
