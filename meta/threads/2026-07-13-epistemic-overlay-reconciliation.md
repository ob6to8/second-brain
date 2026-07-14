---
type: reference
title: 2026-07-13-epistemic-overlay-reconciliation
description: A session that verified the 2026-07-10 evaluation thread's output survived on main (the dedup-recall-probe plan shipped; the epistemic-overlay plan is still proposed), discovered a sibling belief-decomposition-analysis-mode plan had emerged in the interim, and reconciled the epistemic-overlay plan's execution-path addendum against repo drift (a corrected external-repo path corruption, a moved capture-manifest target) and the sibling plan (a shared graph-algorithm core).
provenance: "Claude Code session (Claude Sonnet 5), 2026-07-13; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, epistemic-overlay, composable-beliefs, belief-decomposition, drift, reconciliation]
timestamp: 2026-07-13
pr: 78
---

# 2026-07-13-epistemic-overlay-reconciliation

## Where this landed

Picking up the 2026-07-10 evaluation thread days later (after PR #34 merged and
`main` moved on substantially), the operator asked whether everything from that
thread survived. It had — three analyses, the thread capture, and both addenda
on the [epistemic-overlay plan](/meta/plans/epistemic-overlay.md) were intact —
with one plan already better than expected (the
[dedup-recall-probe plan](/meta/plans/dedup-recall-probe.md) had shipped in
full) and one still pending (the epistemic-overlay execution path had not been
run). A new complication had also landed: an independently-proposed sibling,
[`belief-decomposition-analysis-mode`](/meta/plans/belief-decomposition-analysis-mode.md)
and its [commissioning analysis](/meta/analysis/belief-decomposition-derived-vs-authored.md),
addressing a related but distinct layer (a derived, never-authored belief graph
vs. this plan's committed frontmatter storage).

The operator then asked whether to consolidate the session's findings by
pasting a plan into a fresh session, or whether a different approach was
better. The recommendation was to file a proper reconciliation as a committed
plan addendum instead — persist-plans doctrine treats a pasted chat blob as
still-chat, fragile to transcription, and unlinkable, whereas a filed addendum
survives, is indexed, and needs no paste. The operator said to proceed. The
session synced to latest `main` on a fresh branch, read the current contract's
gate suite and the sibling plan/analysis in full, and reconciled the
epistemic-overlay plan in place: fixed a live drift artifact (a mechanical
glossary-restructuring rewrite had silently corrupted two references to the
*external* CB repo's own `docs/glossary.md` path into `docs/beliefs/glossary.md`
— a concrete instance of the exact cross-reference drift this plan exists to
fight), corrected the stale internal capture-manifest path after the root
reorg (`knowledge-management/` → `knowledge/knowledge-management/`), and
appended a new addendum amending Thread B's charter to read the sibling plan
before deciding Q1/Q4 and to factor `mix brain.graph`'s core as shared,
reusable graph algorithms. A stale index placement (the shipped
dedup-recall-probe plan still listed under "Proposed") was corrected in
passing. Full expanded gate suite green (compile, format, 156 tests, contract,
registry, verify, route tags, lineage, dev-history, dedup-probe, site build).
Session closed with `/create-pull-request`.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Verifying the 2026-07-10 thread's output survived on `main` | closed | [epistemic-overlay plan](/meta/plans/epistemic-overlay.md) | - |
| Paste-into-a-new-session vs. file a proper reconciliation artifact | closed | [epistemic-overlay plan](/meta/plans/epistemic-overlay.md) | - |
| Reconciliation: drift fixes + sibling-plan amendment to Thread B's charter | open | [epistemic-overlay plan](/meta/plans/epistemic-overlay.md) | Thread A (CB asset import) and Thread B (architecture sketch, now reading the sibling plan first) still need to execute |

## User

See main - is everything that was covered in this thread there at this point?

## Assistant

<routes ref="/meta/plans/epistemic-overlay.md">
Yes — everything from this thread survived on `main` intact, but the picture has moved on since, and there's a new complication worth flagging before you launch Thread A/B.

**What's confirmed present and unchanged:**
- All three analyses (`comparison-with-the-2026-second-brain-field`, `eval-suitability-of-the-corpus-maintenance-failure-space`, `cb-epistemic-overlay-as-failure-chain-stabilizer`) — filed, indexed.
- The session capture thread doc — filed, indexed.
- `epistemic-overlay.md` — both addenda (stabilization reframing, execution path) are still intact, word for word.

**Better than expected — Prompt 1 already ran and shipped:** the dedup-recall-probe plan is now `status: done`. `mix brain.dedup_probe` exists with tests, the gold set, the CI report, a committed baseline, *and* the tier-1 `/intake` synonym-expansion plus automated gold-harvest — the full build order from the plan, all landed (see `meta/threads/2026-07-12-dedup-recall-probe-and-synonym-intake.md`).

**Not yet run — the epistemic-overlay execution path:** `epistemic-overlay.md` is still `status: proposed`. Neither Thread A (CB asset import) nor Thread B (architecture sketch) has executed — no `knowledge-management/composable-beliefs/` captures exist, and no frontmatter design decisions have been made.

**The complication:** in the meantime a substantial, separate line of work landed on the same subject:
- A **root reorganization** — new `knowledge/` and `beliefs/` top-levels replaced part of the old taxonomy, with a large `beliefs/glossary/` (200+ terms, including its own `composable-beliefs.md`, `attestation.md`, `epistemic-overlay.md`, `supersession.md`, `staleness-propagation.md` entries).
- A **rival/complementary plan**, [`belief-decomposition-analysis-mode`](main:/meta/plans/belief-decomposition-analysis-mode.md) (`proposed`, 2026-07-11): a *read-only, derived, regenerable* belief graph over artifacts — explicitly the opposite storage philosophy from `epistemic-overlay`'s committed frontmatter edges — backed by its own analysis, [`belief-decomposition-derived-vs-authored`](main:/meta/analysis/belief-decomposition-derived-vs-authored.md), which evaluates the atomic-belief-DAG idea against CB's own failure lineage and argues for "derive the graph, never author it." The plans index already annotates it as complementing (not competing with) the overlay's no-atomization line — but that's a claim from the newer plan's own framing, not something reconciled from the overlay side.

So before running Prompts 2/3 as originally written, it's worth having a fresh agent read `belief-decomposition-analysis-mode` and its analysis first — the epistemic-overlay execution path was written before that design existed, and Thread B's job (deciding Q1/Q4, drawing the frontmatter surface) shouldn't proceed blind to a sibling plan that's already staked out a competing answer to "should belief structure be committed or derived." Want me to draft a short reconciliation note for the epistemic-overlay plan pointing at the newer plan, so Thread A/B picks it up automatically — or would you rather review the belief-decomposition line yourself first?
</routes>

## User

Would it be possible to consolidate anything from this thread to be persisted into a plan and i paste that into a new session to be persisted? Could that be the best approach?

## Assistant

<routes ref="/meta/policy/persist-plans.md /meta/plans/epistemic-overlay.md">
Possible, yes — but it's working against the grain of this repo's own doctrine, and there's a better path that gets you the same outcome more reliably.

The persist-plans policy exists precisely to prevent this pattern: "chat scrolls off... a plan that lives only there is lost the moment the session ends." Pasting a consolidated blob into a fresh session's opening message is still chat — it's just chat in a different window. It also has to survive a copy-paste round-trip (easy to truncate or garble a long doc), and it can't be linked to, indexed, or gated by CI the way a filed `meta/plans/` doc can.

The more reliable move: let me sync *this* session to the current `main` (it's stale — behind by the reorg, the glossary, and the belief-decomposition plan), read the new belief-decomposition material properly, and author a proper reconciliation as a committed artifact — either a new `meta/plans/` doc or a further addendum on `epistemic-overlay.md` — that records what this thread found (dedup probe done, epistemic-overlay still proposed, the sibling plan that emerged) and updates Thread B's charter to require reading `belief-decomposition-analysis-mode` + its analysis before deciding Q1/Q4. Commit, push, PR it. Then the handoff to a fresh session stays exactly the pattern you already established: point at the plan and say "go" — no paste required, and the new session gets a vetted document instead of a transcript fragment.

Want me to do that now?
</routes>

## User

Proceed

## Assistant

<routes ref="/meta/plans/epistemic-overlay.md /meta/plans/belief-decomposition-analysis-mode.md">
Confirmed: root reorg moved `SWE/` and `knowledge-management/` under a new `knowledge/` top-level. So the execution-path addendum's reference to filing captures under `knowledge-management/composable-beliefs/` is now stale — should be `knowledge/knowledge-management/composable-beliefs/`. And the "worked example" path is now `knowledge/SWE/testing/elixir-second-brain-testing-methodology.md`.

*(The remainder of this turn was mechanical: reading `belief-decomposition-analysis-mode.md` and its commissioning analysis in full, discovering and fixing a live drift artifact — two references to CB's own `docs/glossary.md` had been silently rewritten to `docs/beliefs/glossary.md` by this bundle's own glossary-restructuring tooling — correcting the stale capture-manifest path, appending the reconciliation addendum to `epistemic-overlay.md` (drift fixes, the sibling-plan amendment to Thread B's charter, housekeeping notes on retired `log.md` files and mandatory `attribution`), moving the shipped dedup-recall-probe plan's index entry out of "Proposed," and running the full expanded gate suite — each step narrated briefly inline but under the drop threshold for a captured thread; the substantive outcome is the addendum itself, in [epistemic-overlay.md](/meta/plans/epistemic-overlay.md).)*
</routes>
