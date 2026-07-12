---
type: note
title: Dedup recall probe — measuring and maintaining intake dedup recall
description: The end-to-end flow of the dedup-recall eval loop — how intake dedup recall is measured (mix brain.dedup_probe over an id-keyed gold set), how the gold set and baseline are grown automatically at intake, and — the point of this doc — exactly how the operator audits, explores, and re-evaluates a system that otherwise runs silently in the background.
tags: [meta, governance, evals, dedup, recall, intake, flow, workflow, auditability]
timestamp: 2026-07-12
---

# Dedup recall probe — measuring and maintaining intake dedup recall

The connective doc for the brain's first **eval loop**: the machinery that measures
whether [intake](/meta/flows/intake.md) [deduplication](/glossary/deduplication.md)
actually finds the existing concept a new item should merge into, and that keeps that
measurement honest as the corpus grows. It narrates the whole loop end to end and
points at the artifacts that make it work — and, because the loop is **designed to
run silently unless something regresses**, it deliberately foregrounds *how you
audit, explore, and re-evaluate it by hand* (§4). It does not restate the rules or
the procedure; those have homes.

> **The artifacts (sources of truth — point, don't restate):**
> - **Design + decisions** → the [dedup-recall-probe plan](/meta/plans/dedup-recall-probe.md)
>   (`status: done`; motivation, the banded gold-set design, the resolved open questions).
> - **The gold set** → [`meta/evals/dedup-probe.md`](/meta/evals/dedup-probe.md) —
>   the id-keyed queries, bands, variants, adjudication notes, and generated `## Baseline`.
> - **Procedure (harvest step)** → the [`/intake` skill](/.claude/skills/intake/SKILL.md), step 8.
> - **Mechanism + proof** → [`SecondBrain.DedupProbe`](/lib/second_brain/dedup_probe.ex)
>   and the `mix brain.dedup_probe` task, pinned by
>   [`test/second_brain/dedup_probe_test.exs`](/test/second_brain/dedup_probe_test.exs).

---

## 1. The problem

Two problems, one loop.

**The measured problem.** Intake dedup is guarded by lexical (word-matching) search
plus the agent's own reasoning. Lexical search misses on *vocabulary mismatch* — a
note titled "poisoning" is invisible to a search for "pollution" — and the agent's
compensating reasoning is a subsidy that shrinks as the corpus outgrows what one
context can hold. Nobody was re-measuring the loss, so there was no signal for when
to invest in heavier machinery. This loop supplies the instrument.

**The meta-problem — the one this doc is really for.** An automated system that only
speaks up on failure tends to **recede into the background**: it works, it's quiet,
and quiet slowly reads as "not there." A silent guardrail you never open is a
guardrail you can't trust, because you can no longer tell a healthy silence from a
broken one. The antidote isn't more notifications — it's **legibility**: every part
named and openable, a handful of commands that show you the current state on demand,
and an explicit account of how the thing could drift out of your awareness and what
holds it back (§8). Auditing this should never require re-deriving it from the code.

---

## 2. The pipeline

```
   ┌───────────────────────────── at intake time (per /intake run) ─────────────────────────────┐
   │                                                                                             │
   │   operator's own phrasing ──▶ (step 8a) harvest a gold row ──▶ meta/evals/dedup-probe.md    │
   │   for the filed concept          (skip if none; never synthesize)      (## Gold set table)  │
   │                                                                             │               │
   │   mix brain.dedup_probe --update-baseline  ◀────────────────────────────────┘ (step 8b)     │
   │        │  regenerate the ## Baseline table from a fresh run                                  │
   │        ▼                                                                                     │
   │   plain recall dropped vs the prior baseline?  ──yes──▶ flag it to the operator (step 8c)    │
   │        │no                                                    (the ONE thing that's yours)   │
   │        ▼  commit gold-row + baseline with the concept                                        │
   └─────────────────────────────────────────────────────────────────────────────────────────────┘

   ┌──────────────────────── any time / in CI (standalone, read-only) ───────────────────────────┐
   │   mix brain.dedup_probe [--expanded]  ──▶ per-row hit/miss table + aggregate + baseline delta │
   │   CI runs it non-gating on every push (a report line, never a failure)                        │
   │   git log -p -- meta/evals/dedup-probe.md  ──▶ the recall trend over time                     │
   └───────────────────────────────────────────────────────────────────────────────────────────────┘
```

The **backend under test** is deliberately dumb: case-insensitive substring match
over each concept's title, description, tags, and body (what intake actually has, no
LLM, no embeddings). `--expanded` re-scores using each gold row's recorded synonym
variants — approximating the tier-1 [synonym-expansion](/glossary/synonym-expansion.md)
fix offline. The gap between the two numbers is the whole signal.

---

## 3. Where everything lives

Open any of these directly — that is the point of listing them.

| Artifact | What it is | Read it / run it |
|---|---|---|
| [`meta/evals/dedup-probe.md`](/meta/evals/dedup-probe.md) | The gold set: queries → acceptable concept ids, bands, synonym variants, adjudication notes, and the generated baseline. **The human-readable heart of the system.** | open the file |
| [`lib/second_brain/dedup_probe.ex`](/lib/second_brain/dedup_probe.ex) | The engine: parse the gold doc, build the search index, score, render, regenerate the baseline. | open the file |
| [`lib/mix/tasks/brain.dedup_probe.ex`](/lib/mix/tasks/brain.dedup_probe.ex) | The command wrapper. | `mix brain.dedup_probe` |
| [`test/second_brain/dedup_probe_test.exs`](/test/second_brain/dedup_probe_test.exs) | The scenario: a fixture corpus + gold set pinning every rule (parsing, hit/miss, bands, expanded recovery, baseline regen). | `mix test test/second_brain/dedup_probe_test.exs` |
| [`/intake` SKILL.md](/.claude/skills/intake/SKILL.md), steps 3 & 8 | Where the loop touches your workflow: synonym-expanded dedup search, then the automatic harvest/baseline step. | open the file |
| CI report step (`.github/workflows/ci.yml`) | Prints the current numbers on every push; **non-gating** — it never blocks a merge. | the PR's checks |

---

## 4. How to audit this yourself

The loop runs without you. These are the handles to look in on it whenever you want —
no ceremony, all read-only unless noted.

- **See the current state, right now:**
  `mix brain.dedup_probe` — the per-query hit/miss table, the aggregate recall, each
  query's match-set size (the noise signal), and the delta from the committed baseline.
  Add `--expanded` to see what synonym expansion recovers.
- **Read the gold set like a document:** open
  [`meta/evals/dedup-probe.md`](/meta/evals/dedup-probe.md). Every row carries a *note*
  explaining why that query maps to that concept and why it's in its band. If a row
  looks wrong to you, it is wrong — the adjudication is editorial, and yours overrides.
- **See the trend over time:** `git log -p -- meta/evals/dedup-probe.md`. The
  `## Baseline` table's history *is* the recall trajectory — every intake that changed
  it left a commit. (This is deliberate: the brain keeps no hand-written logs; git is
  the provenance layer.)
- **Spot-check that it isn't fooling itself:** the queries are meant to be *natural
  phrasings you didn't copy from the note's title*. Skim the `target` rows — if they've
  drifted toward parroting the concepts' own words, the score is inflated and the note
  in the gold doc's *Upkeep* section tells the agent (and you) to re-adjudicate.
- **Re-evaluate the whole design:** the [plan](/meta/plans/dedup-recall-probe.md) holds
  the reasoning and the resolved open questions; the
  [vector-DB recall analysis](/meta/analysis/vector-db-recall-for-the-scaling-bundle.md)
  holds the evidence that started it. Both are yours to reopen.
- **Change how it behaves:** it's all editable text. Flip the baseline cadence, make
  the harvest opt-in, or add a hard CI floor — the plan's *scope boundaries* section
  says what was deliberately deferred and why.

---

## 5. The touch-sequence

Two entry points. **Checked by** is `scenario` (the CI test over the engine), `tool`
(a `mix` gate), or `editorial` (a judgment with no mechanical oracle).

**A — automatic, inside a `/intake` run** (the part that would otherwise be invisible):

| # | Actor | Action | Files touched | Checked by |
|---|-------|--------|---------------|------------|
| 8a | agent | Harvest a `target` gold row from the operator's own phrasing for the filed/merged concept; **skip silently** if the intake had no natural phrasing (never synthesize a query) | `meta/evals/dedup-probe.md` | editorial |
| 8b | tool | `mix brain.dedup_probe --update-baseline` — regenerate the `## Baseline` table from a fresh run | `meta/evals/dedup-probe.md` | tool |
| 8c | agent | If **plain** recall dropped below the prior baseline, surface it in the intake report — the tier-2 embedding-dedup trigger; else say nothing | — | editorial |
| — | agent | Commit the gold-row + baseline change together with the concept | — | tool (CI report) |

**B — standalone, any time or in CI** (read-only):

| # | Actor | Action | Files touched | Checked by |
|---|-------|--------|---------------|------------|
| 1 | anyone | `mix brain.dedup_probe [--expanded]` — score and report | — (reads bundle) | tool |
| 2 | CI | Non-gating report step on every push | — | tool |

---

## 6. The moving parts

Condensed; the mechanics live in the engine and the plan.

- **Id-keyed, banded gold set.** Rows map a query to acceptable concept **`sb:` ids**
  (surviving renames), banded `target` (scored), `negative` (a non-duplicate pair, not
  scored in v1), or `quarantine` (answer undefined until supersession exists; reported,
  never scored). Concept **merges** are the one case needing your eyes — a merge can
  change which id a row should point at, so affected rows are flagged for
  re-adjudication rather than rewritten.
- **The baseline is generated, not hand-kept.** `--update-baseline` rewrites only the
  table's data rows, preserving surrounding prose, and is idempotent. Same
  generated-not-maintained discipline as [`CLAUDE.md`](/meta/flows/render-contract.md)
  and [`meta/registry.md`](/meta/registry.md); the trend lives in git history.
- **Recall is a trend, not an invariant.** So CI **warns and reports**, never fails —
  the same call the route-tags ledger cross-check makes. A hard floor gate was
  deliberately deferred until a baseline history exists to set one honestly.
- **Offline and deterministic.** `deps: []`, no LLM at probe time — it runs in any
  sandbox and in CI, and two runs on the same corpus give the same number.

---

## 7. Actor boundaries — who does what

The loop is **agent-executed and near-silent by design**. What stays with the operator
is small but real — and it is where auditability lives.

| Actor | Does |
|-------|------|
| **Agent** | expands dedup queries with synonyms at intake; harvests the gold row; regenerates the baseline; runs the probe; surfaces a regression when (and only when) one occurs |
| **Operator** | **decides the one thing that's a decision** — whether a sustained recall drop warrants tier-2 embedding dedup; and holds the editorial oversight the machine can't: is the gold set honest, are the adjudications right, should the design change (§4) |

The division to keep in view: the agent guarantees the *measurement runs*; only you
can judge whether *the measurement means what it claims*. That judgment doesn't happen
on a schedule — it happens whenever you open §4's handles.

---

## 8. How it could recede — and what holds it back

Named honestly, because the operator raised it.

- **Risk: silence reads as absence.** *Held back by* §4 — the state is one command away
  and the gold set reads as prose, so looking in costs nothing; and by CI printing the
  number on every push, so it's in front of you at each PR even when nothing's wrong.
- **Risk: the gold set rots toward easy queries.** Harvesting from *your actual
  phrasing* (never synthetic paraphrases) is the structural defense; the *Upkeep*
  section makes re-adjudication an explicit, flaggable step rather than a hope.
- **Risk: the baseline auto-updates so drift hides.** *Held back by* the trend living in
  **git history** — each baseline change is a commit you can diff — rather than a single
  mutable number that erases its own past.
- **Residual risk this doc does not fully solve:** a slow decline that never trips the
  "dropped since last time" check because each intake re-baselines. That's the honest
  limitation; the real defense is periodically reading the git trend (§4), and the
  deferred **hard CI floor** (plan, scope boundaries) is the mechanical backstop to add
  once there's enough history to set the floor fairly. If you want that floor sooner,
  say so — it's a small change.

---

## 9. Verify — the scenario and the gates

**The scenario test pins the engine.**
[`test/second_brain/dedup_probe_test.exs`](/test/second_brain/dedup_probe_test.exs)
builds an in-code fixture corpus and gold set and asserts the whole contract: gold-row
parsing (bands, id sets, variants); plain-mode hit/miss; `--expanded` recovery via a
recorded variant (with the phrasing that recovered it); band handling (negatives and
quarantine parsed but never scored); baseline-delta rendering; and that
`--update-baseline` regenerates the table while preserving surrounding prose and stays
idempotent. A missing gold doc raises.

**The gate suite** (or just `./.githooks/pre-commit`, which mirrors CI):

```
mix format --check-formatted
mix compile --warnings-as-errors
mix brain.dedup_probe           # non-gating recall report (informational)
mix brain.verify
mix brain.route_tags
mix test                        # includes the dedup-probe scenario
```

**The editorial spot-checks the machine can't judge** — the axes with no mechanical
oracle, and the ones §4 hands to you: is each gold row's query a genuinely *natural*
phrasing (not a copy of the concept's title); is the id it points at still the right
one after a merge; and is a flagged recall regression a real degradation or gold-set
noise.

**Reference instance.** The seed gold set and its first baseline — **plain 3/10,
expanded 10/10** at 39 concepts, 2026-07-12 — is the canonical worked measurement: 7 of
10 natural-phrasing queries miss under plain lexical search and are recovered by the
recorded synonym variants.
