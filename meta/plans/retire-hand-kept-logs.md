---
type: plan
title: "Retire the hand-kept chronological logs (log.md) in favor of git history"
description: Remove root log.md, meta/log.md, and inbox/log.md and every policy/skill mandate to maintain them — git's true-merge commit graph is the single provenance layer — while explicitly keeping the generated, CI-verified route-tagged excerpt logs.
status: done
provenance: "Claude Code session, 2026-07-11 — operator-ratified after the stale-log incident in the deprecated-triage/glossary session; this conversation is the design review"
tags: [meta, plan, logs, provenance, dry, governance]
timestamp: 2026-07-11
---

# Retire the hand-kept chronological logs

## Status & provenance

**Done** — executed 2026-07-11, the same day it was filed (operator: "Can we
delete the log then as well?"). Ratified and flagged `priority: 1` earlier that
day. The design review is the ratifying conversation itself: an
agent cited a `log.md` entry as the source for the session-init priority
ranking and the entry was stale (it predated the todos extension), prompting
the operator's challenge — *"the only true guarantee is one source of truth…
why is git history not enough? If we can't define \[the log's unique value]
discretely, better to remove the liability."* The enumeration below failed to
find a discrete, irreplaceable use case; removal follows.

## Problem

The hand-kept chronological logs (root `log.md`, `meta/log.md`,
`inbox/log.md`) are a second, manually maintained provenance layer beside git:

- **DRY violation.** A single event is recorded in up to four places — commit
  message, `log.md`, the captured thread doc, and the threads index. The
  [merge-strategy policy](/meta/policy/merge-strategy.md) already designates
  the commit graph as *the* provenance layer (true merges, session trailers,
  SHA citations).
- **Demonstrated failure avenue.** Stale-but-greppable prose gets retrieved
  and trusted as current state (the ranking incident above). A "never cite
  logs as current state" rule is behavioral, not structural — it cannot be
  guaranteed.
- **Merge-conflict overhead.** Every parallel-session merge conflicts on the
  append-point of `log.md` and `meta/log.md` (observed on PR #43 and its
  predecessors); resolving them is pure toil.

## The enumeration (why git history is enough)

Every claimed log benefit, scored against an existing surface:

| Claimed benefit | Covered by |
|---|---|
| What changed, when, why | git history — true merges + session trailers + semantic commit messages; `git log --first-parent main` gives the curated one-line-per-PR read |
| Catch-up on open/parallel work | the session-init digest (compiled from *current* structured sources — cannot be stale) |
| Decision context and intent | plans, analyses, issues, thread docs — the intention-documentation layer |
| OKF conformance | not required: the spec defines `log.md`'s structure *when present*; absence is conformant |
| History readable on the rendered site | the one real gap — fillable later by a *generated* changelog (see Deferred), never by hand |

## Decision

1. Delete the three hand-kept logs: `/log.md`, `/meta/log.md`,
   `/inbox/log.md`. Their content stays recoverable in git history, whose
   reachability the merge-strategy policy already protects.
2. Remove every mandate to write log entries from policy and skills; recompile
   the contract.
3. Commit messages become the sole change narrative — they were already
   written at the semantic level; keep that bar.

## Scope boundary — what this does NOT touch

- **Route-tagged excerpt logs stay.** The `## Thread excerpts — route-tagged
  log` sections inside concepts are *generated* from route tags and
  CI-verified for fidelity (`mix brain.route_tags`) — one-source-of-truth
  artifacts, not hand-kept prose. Same for every other compiled artifact
  (`CLAUDE.md`, `meta/registry.md`).
- **Thread docs, ledgers, indexes stay.** `index.md` files are current-state
  listings, not history; they remain reserved and maintained.
- The **reserved filename** `log.md` remains reserved in the OKF sense (a
  consumer must still tolerate one); this bundle simply stops keeping them.

## Execution checklist

Grep first — `grep -rln 'log\.md' meta/ .claude/ lib/ test/` — the known
touch-set as of filing:

1. **Policies** (then `mix brain.contract` / `/render-contract`):
   [reserved-filenames](/meta/policy/reserved-filenames.md) (drop the `log.md`
   stanza or mark it not-kept-here),
   [maintain-reserved-files](/meta/policy/maintain-reserved-files.md) (index
   upkeep only),
   [taxonomy-evolution-protocol](/meta/policy/taxonomy-evolution-protocol.md)
   ("record it in the nearest `log.md`"),
   [persist-plans](/meta/policy/persist-plans.md) (log-entry step),
   [update-in-place](/meta/policy/update-in-place.md) ("note the update in
   `log.md`"), [skills-registry](/meta/policy/skills-registry.md) and
   [okf-conformance](/meta/policy/okf-conformance.md) (verify wording; the
   tolerant-consumer clause can stay).
2. **Skills**: `/intake` (step 7), `/capture` (After-writing step 2),
   `/add-to-glossary` (step 5), `/todo`, `/research`, `/summarize-technical`,
   `/create-pull-request` — drop the log-entry instructions.
3. **Flows + tests**: `meta/flows/intake.md` (and session-capture flow);
   update any scenario test asserting log upkeep; `docs_in/2` in
   `lib/second_brain/session_init.ex` already skips `log.md` — remove the
   special-case once the files are gone (harmless either way).
4. **Delete** the three log files; run the full gate suite; commit with a
   message that carries this plan's rationale pointer.
5. **Flip this plan to `done`** and move it in
   [meta/plans/index.md](/meta/plans/index.md).

## Deferred

- **Generated changelog for the rendered site** — if browsing history on the
  Pages site ever matters, add a site-build step rendering
  `git log --first-parent main` into a changelog page (compiled-artifact
  pattern; zero hand-maintenance). Not built now; no known reader.
