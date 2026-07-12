---
type: reference
title: 2026-07-12-docs-audit-wiki-verdict-and-freshness-warnings
description: A full docs-surface audit filed as an analysis (verdict — no wiki, the Pages site already is one), Tier-1 staleness fixes, then the ratified Tier-2 list (session-init tutorial, news + create-pull-request flow docs, the SecondBrain.Links warn pass), eight glossary terms, and surfacing docs-freshness warnings in the session-init digest for an app-only operator.
provenance: "Claude Code session (Claude Fable), 2026-07-12; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, documentation, wiki, drift, enforcement, warn-pass, glossary, session-init]
timestamp: 2026-07-12
pr: 49
---

# 2026-07-12-docs-audit-wiki-verdict-and-freshness-warnings

## Where this landed

The operator asked for a full evaluation of the repo and its docs, a verdict on
creating a wiki, and an analysis before any work. The audit (all gates green,
mechanical scans for index drift and broken links) was filed as
[the docs-surface analysis](/meta/analysis/docs-surface-evaluation-and-wiki-question.md):
**no wiki** — a second content store would sit outside the enforcement stack,
and the Pages site already fills the role — plus tiered findings. Tier-1
staleness fixes shipped immediately (README rewrite, two `meta/index.md`
omissions, a broken policy-example link recompiled out of `CLAUDE.md`,
`specs`→`plans` in the flows index). The operator then ratified the full
Tier-2 list: the [session-init digest tutorial](/meta/tutorials/the-session-init-digest.md),
flow docs for [news](/meta/flows/news.md) and
[create-pull-request](/meta/flows/create-pull-request.md), and the warn-only
docs-freshness pass (`SecondBrain.Links`, printed by `mix brain.verify`) —
which caught its first real case in this very session's analysis doc. The
operator's question about the field-comparison prediction produced eight
glossary terms, and their question about how an app-only operator would ever
see bash/CI warnings led to appending the warnings to the session-init digest.
The dedup-recall-probe plan stays with the operator for another session. The
session closed via `/create-pull-request`.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Docs-surface audit + the wiki question (verdict: no wiki; Pages site is one) | closed | [docs-surface analysis](/meta/analysis/docs-surface-evaluation-and-wiki-question.md) | - |
| Tier-1 staleness fixes (README, meta index, policy link, flows genre name) | closed | unrouted | - |
| Session-init digest tutorial | closed | [tutorial](/meta/tutorials/the-session-init-digest.md) | - |
| Flow docs for /news and /create-pull-request | closed | [news flow](/meta/flows/news.md) | - |
| Docs-freshness warn pass (SecondBrain.Links in brain.verify) | closed | [gate-suite tutorial](/meta/tutorials/the-gate-suite-and-where-it-runs.md) | - |
| Field-comparison drift question → 8 glossary terms | closed | [glossary hub](/glossary.md) | - |
| Operator visibility of warnings (app-only) → digest surfacing | closed | [session-init tutorial](/meta/tutorials/the-session-init-digest.md) | - |
| Dedup recall probe | paused | [plan](/meta/plans/dedup-recall-probe.md) | Operator will run it in another session |

## User

Evaluate this repo and all of its docs. Consider whether we should create a wiki. Evaluate how we could improve the docs and make them more comprehensive, and updated where needed. Evaluate and levy an analysis before beginning work
Continue from where you left off.

## User

Proceed

## Assistant

The remote branch ref was stale — the local branch sits at `main` with no prior work, so I'm starting the evaluation fresh. Quick priority note: the heuristic top-3 stands (the /news Routine issue, the `deprecated/` triage strand, and the epistemic-overlay execution path), but your request — a docs/wiki evaluation — is itself an `analysis`-genre task that touches the same doc infrastructure, so I'm treating it as this session's priority.

Let me survey the repo and its documentation surface first.

<routes ref="meta/analysis/docs-surface-evaluation-and-wiki-question.md">
Done — the analysis is filed and the immediate fixes are applied, committed, and pushed to `claude/repo-docs-evaluation-svp0tf` (no PR opened, per instructions).

## The verdict on the wiki: don't create one

The analysis is at `meta/analysis/docs-surface-evaluation-and-wiki-question.md`. The core reasoning: a GitHub wiki lives in a separate `*.wiki.git` repo with no frontmatter, no `sb:` ids, no CI gates, and no session-trailer provenance — it would be a second content store that the entire enforcement stack can't reach, exactly the "separate map that drifts" your tree-is-the-taxonomy policy forbids. And the wiki role is already filled: `mix brain.site` publishes the whole bundle to GitHub Pages with a taxonomy sidebar, metadata panels, evidence backlinks, and search, deploy-gated on a verified bundle. If you want more wiki-ness, the analysis suggests site features (prose-link backlinks, a recently-changed page, per-tag pages) rather than a second store.

## Docs health: strong where enforced, stale where not

All eight CI gates were green before I touched anything, and index coverage was effectively total. Every staleness hit was on a hand-maintained surface — which is the drift pattern your own field-comparison analysis predicted. Fixed in this push (Tier 1):

- **README.md** still listed the retired `log.md` and predated `meta/`, the glossary, the inbox, the gate suite, and `session_init` — rewritten to match the current repo.
- **meta/index.md** was missing `mix brain.session_init` from the tooling list and had no entry for `future-beliefs.md` (the only two index-drift hits in the bundle).
- **The filenames-and-cross-linking policy** used a broken example link (`/references/open-knowledge-format.md`, a path that never existed) — fixed to the real path and `CLAUDE.md` recompiled.
- **meta/flows/index.md** referred to the retired genre name `specs` instead of `plans`.

All gates and the 82 tests pass after the changes.

## Recommended follow-ups (Tier 2, awaiting your call)

These are in the analysis but not acted on, since they're new work rather than fixes: a tutorial for the session-init digest (the only `mix brain.*` task with no tutorial/flow coverage), flow docs for `news` and `create-pull-request`, and a warn-only link-freshness check in the gate suite (the scan that caught the policy break is deterministic and cheap). Say the word and I'll pick any of them up — or run `/create-pull-request` if you want this branch shipped.
</routes>

## User

Commit
Proceed with all those, commiting as you go
Re "Every staleness hit was on a hand-maintained surface — which is the drift pattern your own field-comparison analysis predicted" - what field-comparison is this? What can be done to prevent this drift/increase coverage?

## Assistant

Three Tier-2 deliverables approved: the session-init tutorial, the `news` + `create-pull-request` flow docs, and the warn-only link check. I'll also answer the field-comparison question at the end. First, reading the source material — the field-comparison analysis itself, the genre exemplars, and the code I'll be documenting/extending.

All three Tier-2 items are shipped and pushed — three commits on `claude/repo-docs-evaluation-svp0tf`, full gate suite and 91 tests green.

**What landed:**
- `d7ca025` — **Session-init digest tutorial** (`meta/tutorials/the-session-init-digest.md`): the four policy-maintained sources, the class-weight ranking with recency tiebreak, the strand↔doc dedup, the `priority:` escape hatch, and the rank-vs-judge split.
- `bc96c00` — **Flow docs for `/news` and `/create-pull-request`** (coverage now 4 of 8 skills). Each is honest about its spine: news's is write conventions with no tooling (scenario deferred, reasons recorded); create-pull-request's is borrowed — pinned by the capture scenario, the id gates, and CI-on-the-branch, with the git/GitHub half held by guardrails and the merge-strategy policy.
- `8473447` — **The docs-freshness checker** (`SecondBrain.Links`): `mix brain.verify` now prints advisory warnings for unresolved internal links and index-coverage gaps (unlisted files, unlisted subdirectories, missing indexes). It never turns the gate red, scans `meta/` and `inbox/` (where the id gates don't look), and exempts frozen thread bodies, materialized excerpt logs, code spans, and `…` placeholders. Nine fixture tests; the live tree is warning-clean. Satisfying detail: during its own build-out it caught its first real case — a broken path quoted in my analysis doc — which is how it learned code spans are literal text.

<routes ref="sb:e8c1a9 sb:e08db0 sb:1c53dc sb:0da4a3 meta/analysis/comparison-with-the-2026-second-brain-field.md">
**Your question — what field-comparison, and what prevents the drift:**

It's `/meta/analysis/comparison-with-the-2026-second-brain-field.md`, filed 2026-07-10 when you asked how this repo stacks up against the second-brain landscape (Obsidian/PARA systems, Karpathy-pattern Claude Code vaults, PKM products). Its central finding was that the whole field runs on *advisory* integrity — an LLM promising to follow CLAUDE.md prose — while this bundle converts rules into *structural* CI checks. It then modeled why advisory systems die past ~500 concepts, and two of its root causes are the prediction I was citing: **probabilistic enforcement** (rules living in prose have a roughly constant per-operation violation rate, and with no detector there's no repair signal, so errors compound) and **invisible degradation** (nothing distinguishes a healthy corpus from a rotting one until it visibly fails). Stage 3 of its failure chain — cross-reference drift — is exactly what the audit found in miniature: the enforced surfaces (contract, registry, route-tag logs) had *zero* drift, while every staleness hit sat on a surface no verifier watches — the README, two index entries, one example link.

**What can be done** is the same move the repo has made repeatedly: shrink the set of surfaces that rely on discipline by giving each one a detector. That's what the new warn pass does for the two drift classes the audit caught by hand — a stale link or an unlisted file now announces itself in every `mix brain.verify` run and in CI logs, instead of waiting for someone to notice. After this change, the remaining detector-less surfaces are, deliberately: README *prose accuracy* (no mechanical oracle exists; the mitigation was making it a thin pointer into enforced surfaces rather than a parallel description that can rot), frozen thread quotes (history, not drift, by design), and the one big semantic gap both analyses converge on — **intake dedup recall**, which no syntactic check can cover. That's the still-`proposed` dedup-recall-probe plan, and it remains the highest-leverage unshipped work in the repo.
</routes>

Want me to run `/create-pull-request` to ship the branch, or take a look at accepting the dedup-recall-probe plan next?

## User

"The docs-freshness checker (SecondBrain.Links): mix brain.verify now prints advisory warnings for unresolved internal links and index-coverage gaps" - i am operating Entirely in the Claude app, how will these bash logs be shown to me? Also, how are CI oogs surfaced?

/add-to-glossary probablistic enforcement, invisible degradation, cross-reference drift, deterctor, drift class, warn pass, run, dedup

I'll run dedup-recall-probe in another session

Then, /create-pull-request

## Assistant

<routes ref="sb:0b648f meta/tutorials/the-session-init-digest.md lib/second_brain/session_init.ex">
Glossary done — 7 terms added, `deduplication` extended. Now the answer to your visibility question implies a concrete gap worth closing before the PR: the warnings currently live in terminal output you never see. The fix is to surface them in the session-init digest, which *is* injected into every session you open. Implementing that now.
</routes>

*(The session closed with `/create-pull-request`: this capture, the glossary pass over it, and the PR were produced after the last retained exchange.)*
