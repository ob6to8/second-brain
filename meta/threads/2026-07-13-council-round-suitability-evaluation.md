---
type: reference
title: 2026-07-13-council-round-suitability-evaluation
description: Evaluated the operator-supplied "council round" adversarial draft-PR review protocol for integration; filed the suitability analysis (verdict — integrate as /council after four ratified bindings) and clarified the three senses of "distilled, not dumped" across the council prompt and the bundle's policies.
provenance: "Claude Code session (Claude Fable), 2026-07-13; verbatim retained messages parsed from the host session log — tool calls, tool results, reasoning, and short pre-tool narration stripped; one delivered ≥300-char assistant block absent from the host log was reinstated verbatim from the live context"
tags: [meta, thread, council, review, adversarial, analysis, distillation]
timestamp: 2026-07-13
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

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Council-round protocol: suitability for integration | paused | [council-round-suitability](/meta/analysis/council-round-suitability.md) | Operator to ratify the four bindings and commission the `/council` skill |
| "Distilled, not dumped" — where defined, when it applies, three senses | closed | `unrouted` | - |

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
