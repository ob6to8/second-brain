---
type: reference
title: 2026-07-13-council-round-suitability-evaluation
description: Evaluated the operator-supplied "council round" adversarial draft-PR review protocol for integration; filed the suitability analysis (verdict — integrate as /council after four ratified bindings), reconciled and merged PR #72, then ratified the verdict into a deferred-execution plan.
provenance: "Claude Code session (Claude Fable, then Claude Sonnet 5 after a mid-session /model switch), 2026-07-13; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped; earlier turns parsed from the host session log with one gap reinstated from live context, later turns (main-reconciliation, PR merge, plan authoring) rendered from live context"
tags: [meta, thread, council, review, adversarial, analysis, distillation]
timestamp: 2026-07-13
session: https://claude.ai/code/session_017LXaQmsBGVNofviVhtTLp9
pr: 72
---

# 2026-07-13-council-round-suitability-evaluation

Verbatim render. Retained operator messages and agent responses are reproduced
**verbatim** (the delivered text); only tool calls, tool results, reasoning, and
short pre-tool narration are stripped. Parsed from the host session log via
`/capture`'s parse-the-log path; one delivered block missing from the log was
reinstated verbatim from the live context.

## Where this landed

The operator pasted a protocol prompt — the **council round**, a structured,
adversarial, multi-agent review run as comments on a draft PR, gated on every
finding having a disposition and distilled into a curated target document — and
commissioned a suitability evaluation for integrating it into this repo. The
session filed
[council-round-suitability](/meta/analysis/council-round-suitability.md)
(`type: analysis`, evaluated prompt preserved verbatim in its appendix; commit
`ccb6a31` on `claude/council-review-secondbrain-oq5e8o`). Verdict: **integrate,
as a `/council` skill, after operator ratification of four bindings** — narrow
the protocol's no-transcripts rule to defer to the
[session-capture policy](/meta/policy/session-capture.md); bind its `<FILL IN>`
distillation target to `type: plan` docs under `meta/plans/`; reconcile its
draft-PR open motion with `/create-pull-request` and position it against
`/code-review`; and land it via a skills-registry policy edit +
`/render-contract`. A follow-up exchange disambiguated the three senses of
"distilled, not dumped": the council prompt's ground rule 2 (executed once, at
the close motion after the gate), the bundle's
[distill-dont-dump policy](/meta/policy/distill-dont-dump.md) (applies at every
filing), and the session-capture policy's deliberately inverted sense
(noise-stripped, kept text verbatim). The session closed with this capture;
during it, the analysis doc's dates were corrected from 2026-07-11 to
2026-07-13 (the actual session date). The operator then invoked
`/create-pull-request` — this doc was refreshed in place with the closing
exchange, glossaried, and shipped as PR #72. A follow-up session merged
`origin/main` into the branch to reconcile against a large intervening
restructure (root reorg into `knowledge/`/`beliefs/`, the `attribution` and
`sense` frontmatter properties, and hand-kept-log retirement): the five new
glossary terms moved to `beliefs/glossary/` with `sense` and `attribution`
added, the analysis doc gained its required `attribution.from` back-link to
this thread, this thread was stamped `pr: 72`, and the `log.md`/`meta/log.md`
entries this session had written were dropped (retired policy) rather than
merged — content untouched throughout, relocation and metadata backfill only.
The operator then said "Merge"; PR #72 was merged into `main` as a true merge
commit (`7b708a5`), CI green beforehand, head branch auto-deleted. Rather than
leave the verdict as a paused analysis strand awaiting ratification, the
operator asked for it to be authored as a plan for later: this session
restarted the designated branch from the new `main` tip (the prior branch was
merged and gone) and filed
[the /council skill plan](/meta/plans/council-skill.md) (`type: plan`,
`status: accepted`, execution explicitly deferred) — the four bindings
recast as concrete build decisions plus a build order, with a "Ratified"
pointer added atop the analysis and an entry in `meta/plans/index.md`. A
stop-hook then required the resulting uncommitted changes to be committed and
pushed, which this capture pass folds in.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Council-round protocol: suitability for integration | closed | [council-round-suitability](/meta/analysis/council-round-suitability.md) | - |
| "Distilled, not dumped" — where defined, when it applies, three senses | closed | `unrouted` | - |
| Reconcile PR #72 against main's intervening restructure and land it | closed | `unrouted` | - |
| Author the ratified verdict as a deferred-execution plan | closed | [council-skill plan](/meta/plans/council-skill.md) | - |

## User

Consider the following prompt, Evaluate it for suitability to be integrated into the SecondBrain repo.

# Council: an adversarial review round on a draft PR

You are running a **council round**: a structured, adversarial, multi-agent
review of drafted work, driven to convergence and distilled into a plan.
The round runs at the gate between *work drafted* (committed to a branch,
not yet merged) and *work merged*.

**Distillation target:** <FILL IN — the document that receives the round's
settled outcome: a design doc, ADR, issue, or plan file. The target is a
curated document, not a transcript.>

## Ground rules (load-bearing — do not weaken these)

1. **The medium is a draft PR; reviews are comments, never committed files.**
   All findings, responses, and dispositions live as PR review comments.
   The only artifacts that ever land in the tree are the distilled plan and
   the code itself. Never run a round against main, and never replay a round
   that already happened elsewhere.
2. **The durable record is distilled, not dumped.** Settled decisions are
   written into the distillation target; rejected alternatives fold into a
   dated "rejected: X because Y" block in that same document; the raw
   exchange stays referenced by commit SHA / PR link and is never copied
   into the document.
3. **Close is a gate, not a dump.** The round cannot converge while any
   finding lacks a disposition. Silent omission is the failure mode the
   review exists to catch — never commit it yourself.

## The four motions

Run these in order (or resume at whichever motion the round has reached —
the PR itself is the shared state, so independent sessions can take turns).

### 1. open
- Ensure a **draft PR** exists for the branch under review; create one if
  needed. This PR is the chamber for the whole round.
- Dispatch one or more reviewer subagents. Each receives: the full diff,
  and this fixed adversarial brief:
  > You are an adversarial reviewer. Your job is to find what is wrong,
  > missing, unjustified, or fragile in this change — correctness bugs,
  > unstated assumptions, design flaws, gaps between the stated intent and
  > the code. Do not praise. Do not soften. Return a structured findings
  > report: each finding gets an ID (F1, F2, ...), a severity, the file/line
  > it anchors to, and a concrete failure scenario or reasoned objection.
- Post each reviewer's findings as PR review comments (line-anchored where
  possible, top-level otherwise), prefixed with their finding IDs.

### 2. review
- A fresh reviewer (new subagent, no context from motion 1) makes one
  independent pass over the diff with the same adversarial brief, and posts
  its findings the same way, continuing the finding-ID sequence.

### 3. respond
- Acting as the author, read every open finding and reply to each — in the
  finding's own comment thread — with exactly one disposition:
  - **agree** — the finding stands; state what will change.
  - **refute** — the finding is wrong; give evidence (code, tests, docs),
    not assertion.
  - **defer** — real but out of scope for this round; state where it goes
    (issue, follow-up plan) and file it there.
- Nothing is silently dropped. Every finding gets a reply.

### 4. close
- **The gate:** enumerate every finding from motions 1–2 and verify each
  has a disposition (agree / refute-with-evidence / defer-with-destination).
  If any finding is undispositioned, **refuse to close** — report which
  findings are open and stop. Do not summarize around them.
- Once the gate passes, distill:
  - Settled decisions (agreed findings and their resolutions) become
    concrete items in the distillation target.
  - Rejected alternatives become a dated "rejected: X because Y" block in
    the same document.
  - Cite the raw exchange by PR link and commit SHA only. Do not paste the
    transcript.
- Post a closing PR comment: the disposition tally (N agreed / N refuted /
  N deferred), a link to the updated distillation target, and the statement
  that the round is converged.
- Hand off: the distilled plan — not this conversation — is what the
  implementer receives.

## Provenance
- A council round is a dev-dev exchange: it leaves no artifact in the tree
  beyond the distilled plan and the code. Session notes, transcripts, and
  review dumps do not get committed.
- If this round is being run by hand (no tooling support yet), label it as
  hand-run in the closing comment. A hand-run round is a legitimate founding
  example only when labelled as such — do not manufacture receipts for
  machinery that was not in force.

## Assistant

The repo grounding is clear now. Quick priority note per the session-init digest: the heuristic top-3 stands (the `/news` Routine issue first, `deprecated/` triage second, epistemic-overlay execution path third) — but this session's task is an operator-commissioned evaluation, which takes precedence over all three; none of them are touched by this work.

The task is a question ("evaluate for suitability"), and this repo's own contract says a reasoned judgment on a question gets filed as a `type: analysis` doc so the reasoning persists — so I'll write the evaluation, file it under `meta/analysis/`, and push it to the designated branch. Let me check git state and the remaining policy I need (session-capture vs. council's no-transcripts rule is the deepest tension).

<routes ref="meta/analysis/council-round-suitability.md">
**Verdict: suitable — integrate it, as a `/council` skill, but only after four bindings are ratified.** The full evaluation is filed as [`meta/analysis/council-round-suitability.md`](meta/analysis/council-round-suitability.md) (with the evaluated prompt preserved verbatim in an appendix), committed with index/log upkeep, all verifiers green, and pushed to `claude/council-review-secondbrain-oq5e8o` (`ccb6a31`). No PR opened, per the default.

The short version of the assessment:

**Why it fits unusually well.** The protocol isn't just compatible with this bundle — it composes with machinery already in place. Its "distilled, not dumped" ground rule is a restatement of the distill-don't-dump policy applied to review exchanges; its hand-off artifact ("the distilled plan, not the conversation") is exactly what persist-plans mandates; and its cite-by-PR-link-and-SHA provenance rule *depends on* the true-merge policy — the council round would be the first workflow that consumes the SHA-reachability guarantee rather than merely preserving it. Its disposition gate matches the repo's advisory→structural conversion pattern, and unlike route-tag coverage it actually has a mechanical oracle (finding IDs are enumerable), so a future `mix brain.council` verifier is a natural extension. It also fills a genuine gap: there is currently no defined gate between drafted and merged. And its PR-as-shared-state resumability suits these ephemeral remote sessions well.

**The four bindings it needs before adoption:**

1. **The real conflict — its no-transcripts rule vs. session-capture.** "Session notes, transcripts, and review dumps do not get committed" collides with the capture policy, and `/create-pull-request` runs `/capture` unconditionally. Resolution: narrow the council rule (its target is *review dumps as pseudo-plans*), not the capture policy — thread docs are noise-stripped distilled records, and subagent findings arrive as tool results that `/capture` drops anyway.
2. **Bind the `<FILL IN>` distillation target** to a `type: plan` doc under `meta/plans/`, with deferrals filed as `issue`/`todo`. No new type is needed — a point in its favor.
3. **Reconcile with the PR machinery**: the draft-PR "open" motion needs the same invocation-is-authorization clause as `/create-pull-request`, and `/council` should be positioned as the heavy gate for shape-of-brain changes so it doesn't sprawl over `/code-review`.
4. **Ratification path**: skill + skills-registry policy edit + `/render-contract` — a contract change, so operator ratifies first. This analysis is the proposal's evidence base, not its ratification.

If you ratify, the suggested build order is in the doc: SKILL.md with bindings baked in → registry edit + contract recompile → one labelled hand-run founding round → only then the mechanical gate checker.

One priority note from session init: the heuristic top-3 (the `/news` Routine issue, `deprecated/` triage, epistemic-overlay execution path) still stands and none were affected by this work — this commissioned evaluation simply took precedence for the session.
</routes>

## User

When it is distilled, not dumped, and where is it defined?

## Assistant

<routes ref="meta/policy/distill-dont-dump.md meta/policy/session-capture.md">
There are two definitions — one in the council prompt, one in this repo — plus a deliberately different third sense worth distinguishing.

**In the council prompt**, it's ground rule 2: "The durable record is distilled, not dumped." It's *defined* in the ground-rules section and *executed* at exactly one moment: the **close motion, after the disposition gate passes**. Nothing is distilled while the round is live — findings, replies, and dispositions accumulate as raw PR comments. Only once every finding has a disposition does distillation happen, and it takes a precise form: agreed findings become concrete items in the distillation target, rejected alternatives become a dated "rejected: X because Y" block in that same document, and the raw exchange is cited by PR link and commit SHA only — never pasted. So "when" = at convergence, and the gate is what makes the distillation trustworthy: you can't summarize around an undispositioned finding because the round refuses to close with one open.

**In this repo**, the counterpart is the policy at `meta/policy/distill-dont-dump.md` (section 3 of the compiled `CLAUDE.md`, filing section, order 1): "Capture the *knowledge*, not the raw noise. A concept has a clear title, a one-sentence `description`, and a clean body. Keep the original material as a `resource` URI and/or under a `# Citations` section — not as the whole document." Its "when" is broader: it applies **every time content is filed into the bundle** — intake, reference capture, any concept creation — not just at a review gate. The council rule is effectively this policy specialized to review exchanges, which is why I scored the alignment as near-restatement in the analysis.

**The third sense is the trap.** The session-capture policy (`meta/policy/session-capture.md`) also uses "distilled," but defines it in the opposite direction: there it means *only the noise is stripped* (tool calls, reasoning, short pre-tool narration) while **everything kept is reproduced verbatim, never condensed**. A thread doc is "distilled" in the noise-removal sense, not the summarization sense. That's precisely why the council prompt's "transcripts do not get committed" rule reads as a conflict at first glance but isn't fatal — a thread doc is not the "dump" either rule is warning against, which is the reconciliation Binding 1 in the filed analysis proposes.
</routes>

## User

Anything left to persist before closing thread?

*(The short pre-capture reply and the capture-run narration are stripped per
the drop rule; the capture ran here, and the closing report below followed
it. The session then shipped via `/create-pull-request` — this doc's second,
update-in-place close.)*

## Assistant

Nothing is left unpersisted now — the session is captured and everything is pushed. What this last pass did:

**Thread doc**: `meta/threads/2026-07-13-council-round-suitability-evaluation.md` — rendered via the parse-the-log path from the host session log, with one caveat recorded in its provenance: the host log was missing one delivered ≥300-char assistant block (the priority-appraisal/filing-decision message), which I reinstated verbatim from the live context rather than losing it. Routing ledger has two rows: the evaluation strand is **paused** (dangling: you ratifying the four bindings and commissioning `/council`), and the distilled-vs-dumped clarification is **closed**. The route tags are all path back-links (to the analysis doc and the two policies) — the session fed no `sb:` concept sinks, so no excerpt logs were materialized.

**A date correction I caught during capture**: I had stamped the analysis doc's `timestamp`/provenance as 2026-07-11 and filed its `meta/log.md` entry under that heading, but today is 2026-07-13. Both are fixed in this commit, with the fix noted in the log entry.

All gates green (`brain.contract --check`, `brain.registry --check`, `brain.verify`, `brain.route_tags`, 81 tests), committed as `09c6826` and pushed to `claude/council-review-secondbrain-oq5e8o` (two commits total on the branch: the analysis `ccb6a31`, the capture `09c6826`).

The only open items are yours, and both are recorded in the tree: ratifying the four bindings if you want `/council` built, and whether to open a PR for this branch — say the word or run `/create-pull-request` (its capture step will just update this thread doc in place).

## User

Pull main again and reconcile pr

## Assistant

<routes ref="meta/policy/merge-strategy.md">
PR #72 is reconciled and pushed. What the merge involved, since main had moved substantially since this branch was cut (a root reorg into `knowledge/`/`beliefs/`, new `attribution`/`sense` frontmatter properties, and retirement of the hand-kept logs, plus 20+ other PRs):

- True-merged `origin/main` into the branch (per the merge-strategy policy — no rebase, so this thread's own cited commit SHAs stay reachable).
- Relocated the 5 new glossary terms to `beliefs/glossary/`, added `sense` (repo/dual/common per term) and the required `attribution` block to each, and fixed their internal cross-links to the new paths.
- Added the required `attribution.from` block to the analysis doc, pointing back at the thread.
- Stamped the thread doc with `pr: 72` (now known) and added a short note documenting this reconciliation pass.
- Merged the two additive index conflicts (`meta/analysis/index.md`, `meta/threads/index.md`) — kept both sides.
- Dropped this session's `log.md`/`meta/log.md` entries entirely — those files are deleted on `main` under the retired-logs policy; the commit graph is now the sole change-narrative layer.
- Regenerated `meta/registry.md` rather than hand-merging it.

Content itself is untouched — this was pure relocation and metadata backfill. Full gate suite is green: format, `brain.contract --check`, `brain.registry --check`, `brain.verify`, `brain.route_tags`, `brain.lineage --check`, and 156 tests (dev-history check skipped — shallow clone, as designed). Pushed as `9fde6d8`; PR #72 should now be mergeable against current `main`.
</routes>

## User

Merge

## Assistant

<routes ref="meta/policy/merge-strategy.md meta/policy/git-branch-deletion.md">
Good — `claude/council-review-secondbrain-oq5e8o` is already gone (auto-delete handled it), and `main` is now at `7b708a5`, the merge commit. Nothing further to clean up.

**PR #72 is merged.** Summary:
- Merge commit: `7b708a5` (true merge, per policy — the PR's four commits, including the council-round-suitability analysis and the main-reconciliation merge, stay reachable from `main`'s history).
- CI (`verify`) was green on the head commit before merging.
- Head branch auto-deleted.

The suitability verdict is now durably on `main`: **integrate the council-round protocol as a `/council` skill, after you ratify the four bindings** (narrow the no-transcripts rule, bind the distillation target to `meta/plans/`, reconcile with `/create-pull-request`, land via a skills-registry policy edit). That's recorded in `meta/analysis/council-round-suitability.md`, with the full session in `meta/threads/2026-07-13-council-round-suitability-evaluation.md` — routing ledger still shows the evaluation strand `paused` on your ratification.
</routes>

## User

I would rather author this as a plan to do later

## Assistant

<routes ref="meta/plans/council-skill.md meta/policy/persist-plans.md">
I've filed the ratified decision as a plan rather than leaving it as a paused analysis strand. What I did:

**[`meta/plans/council-skill.md`](meta/plans/council-skill.md)** — `type: plan`, `status: accepted`, execution deferred. It carries:
- The problem (no defined drafted→merged gate) and the decision to build `.claude/skills/council/SKILL.md`.
- The four bindings from the analysis, now written as concrete build decisions rather than open caveats.
- A build order (write the skill → registry edit + `/render-contract` → one labelled hand-run founding round → only then consider a mechanical gate checker).
- Explicit scope boundaries (not replacing `/code-review`; not building the verifier yet).
- `attribution.from` pointing back at both the analysis and the thread, per the resource-attribution policy.

**Housekeeping to keep the two docs coherent:**
- Added the plan to `meta/plans/index.md` under Accepted / In progress.
- Added a short "Ratified" pointer note at the top of the analysis doc, directing future readers to the plan for the build spec — the analysis stays the historical judgment, the plan is where work resumes.

I deliberately left the thread doc's routing ledger untouched — that row (`paused`, dangling: "operator to ratify...") gets updated by `/capture` at the next close, not hand-edited mid-session, per how this repo's ledger upkeep works.

Everything's local on the restarted `claude/council-review-secondbrain-oq5e8o` branch (PR #72 merged, so I rebuilt the branch from current `main` first) — not yet committed or shipped. Want me to run `/create-pull-request` now, or keep going?
</routes>

## User

Stop hook feedback:
[~/.claude/stop-hook-git-check.sh]: There are uncommitted changes in the repository. Please commit and push these changes to the remote branch.

## Assistant

The hook wants uncommitted work saved — that's a mechanical safety check, not a request to open a PR. I'll persist the session properly first (capture the new exchange, since a ratified plan is exactly the kind of decision this repo's policy says must survive the session), then commit and push to the branch, without opening a PR since that wasn't asked for.

Committed (`2aabfee`) and pushed to `claude/council-review-secondbrain-oq5e8o` — no PR opened, since only the commit was requested.

What shipped: the plan (`meta/plans/council-skill.md`, `status: accepted`, execution deferred), the analysis's "Ratified" pointer, the plans index entry, and a capture of everything since PR #72 merged — the main-reconciliation, the merge itself, and this plan-authoring turn, folded into the thread doc's routing ledger (evaluation strand now `closed`, routed to the plan) and threads index. All gates green (contract, registry, verify, route_tags, lineage, 156 tests).

The branch is pushed but has no open PR — say the word (or run `/create-pull-request`) whenever you want this shipped to `main`.
