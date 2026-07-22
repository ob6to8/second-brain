---
type: analysis
title: "Harness and ledger as eval infrastructure: conflict of interest, observation media, and the continuous-eval landscape"
description: Finds the bundle's eval potential splits cleanly along a harness/ledger axis — the deterministic mix-task harness pattern generalizes but is replaceable, while the ledger machinery (id-keyed labels, adjudication-bearing gold docs, write-once attribution, the routing ledger as a completion oracle) is the genuinely underserved layer of eval infrastructure — and derives the trust conditions: self-run evals are conflict-free as internal regression instruments but carry three conflict-of-interest patterns (task-selection bias, scorer-encodes-policy, answer-key-in-repo contamination) the moment results make comparative claims, resolved by authoring gold sets with the ledger while executing under a neutral runner (Inspect); grounds the ledger's three layers (run/label/lineage records) in the pencil-and-paper observer tradition and its dictation variant (raw-vs-derived two-layer records), evaluates the Eve-style continuous-eval model as all-harness-no-ledger with four hazards (contamination, unattended judge drift, flaky gates, continuous Goodhart pressure) against which the bundle's warn-don't-gate posture looks correct, and predicts an Elixir ledger library would be ignored by the Python eval monoculture but could travel as a format with a reference verifier.
provenance: "Claude Code session (Claude Fable), 2026-07-20 — operator asked whether the repo's beginnings could apply to evals via its harness or ledger, then probed conflict of interest vs. neutral runners, the ledger's exact function, observation-record media (pencil-and-paper, dictation), and the Eve continuous-eval model; Eve facts fetched same day from vercel.com and coverage"
tags: [meta, analysis, evals, ledger, harness, provenance, adjudication, conflict-of-interest, inspect, contamination, goodhart, continuous-evals, eve, elixir]
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T00:00:00Z
  channel: agent-authored
  agent: "Claude Code agent, operator-commissioned analysis of the session's eval-infrastructure findings"
  why: "the operator asked to commit the session's layered reasoning — harness/ledger applicability, conflict-of-interest conditions, observation-media grounding, and the continuous-eval comparison — so the judgment persists beyond the session"
  from: [/meta/threads/2026-07-20-evals-harness-ledger-and-observation-records.md]
---

# Harness and ledger as eval infrastructure

**Question.** Do the beginnings of this repo contain something applicable to
evals — specifically the harness (the `mix brain.*` toolchain) or the ledger
(the routing/provenance machinery)? And if so, under what conditions can
self-run evals be trusted, versus requiring a neutral standard such as
[Inspect](https://inspect.aisi.org.uk/) (the UK AI Security Institute's
open-source eval framework)?

**Bottom line.** Yes — and the bundle has already crossed the threshold once
(the [dedup recall probe](/meta/plans/dedup-recall-probe.md) is a shipped
eval; the [eval-suitability analysis](/meta/analysis/eval-suitability-of-the-corpus-maintenance-failure-space.md)
is its design rationale). The sharper finding is that the potential splits
cleanly along the harness/ledger axis. The **harness pattern** (deterministic,
zero-dependency, offline scorers; gold sets as prose-bearing versioned docs;
generated baselines; warn-don't-gate CI) generalizes to eval infrastructure —
but harness code is replaceable, and neutrality demands it be replaced for any
public claim. The **ledger machinery** is the durable export: adjudication and
lineage as first-class, machine-checked records are the layer the entire eval
ecosystem — including the new continuous-eval frameworks — has not built.
Conflict of interest attaches to being sole examiner *and* star pupil, not to
having authored the exam: author gold sets with the ledger, execute under a
neutral runner, and keep the answer key out of the examinee's reach.

## 1. The ledger, decomposed: three layers of record

A ledger is a tamper-resistant record of who did what, when, and on what
basis — appended, never erased, every entry traceable to a receipt. In eval
terms the records worth keeping split into three layers, and mainstream
tooling only builds the first:

| Layer | Answers | Eval-world state | This bundle's mechanism |
|-------|---------|------------------|-------------------------|
| **Run record** (trace/transcript) | what happened? | Inspect logs this well | Frozen verbatim [thread docs](/meta/policy/session-capture.md); commit graph with session trailers |
| **Label record** (adjudication) | why is this the right answer? | Usually a bare data file — the reasoning evaporates | Gold docs with per-row bands (`target`/`negative`/`quarantine`) and written adjudication notes ([dedup-probe gold set](/meta/evals/dedup-probe.md)) |
| **Lineage record** (provenance) | where did this come from; can I trust it? | Usually nothing | Stable `em:` ids, write-once `attribution`, `verified_by` evidence edges, the routing ledger |

The payoff is dispute resolution: when a score looks wrong — and eval scores
look wrong constantly — layers two and three are what let the investigation
trace backward instead of shrugging. Without them, trust in a benchmark
decays unrecoverably.

Several bundle mechanisms translate into eval opportunities almost verbatim:

- **The routing ledger as a completion oracle.** Its per-strand bookkeeping —
  resolved or dangling, routed where — is structurally the grading rubric for
  multi-step agent work: *did the agent finish everything it started, and can
  it account for where each piece went?* Work silently dropped mid-task is
  among the most common real agent failures, and no public eval grades it.
- **Harvest-at-the-moment gold collection.** `/intake`'s gold-harvest step
  (append a test row from the operator's actual phrasing at filing time)
  generalizes: the operational log and the eval dataset accrete in the same
  writing motion, at zero synthetic cost — and it counters overfitting by
  refreshing the suite from live traffic (see §4).
- **Write-once discipline as anti-tampering.** Immutable `attribution`,
  applied to gold sets in git, yields the property benchmark audits care
  about: the answer key provably predates the run, and backdating is visible.
- **The `claim` → `verified` → `concept` graduation path** is the formalized
  version of what judge-graded labels need: provisional until linked to
  recorded evidence.

## 2. Conflict of interest: when self-run evals are trustworthy

The verdict is use-dependent, with a bright line between two uses.

**Internal regression instrumentation: no conflict.** The dedup probe is a
bathroom scale — even a biased instrument, run consistently on the same
subject, yields a real trend. Deeper: the probe's notion of correctness
("these two notes should have merged") is *policy-relative* by construction
(the eval-suitability analysis's central finding), so the coupling of metric
to policy is the design, not a bias. A neutral harness could not even express
the question.

**Comparative or published claims: three real conflict patterns.**

1. **Task-selection bias.** A benchmark authored by a system that has stable
   ids and a ledger by construction will naturally reward having them.
   "Author's system tops author's benchmark" is the oldest credibility
   failure in the field.
2. **Scorer-encodes-policy.** The scoring oracle *is* this bundle's merge
   policy; a system with a different (legitimate) taxonomy altitude scores as
   failing for an editorial difference. Fine internally, misleading
   comparatively unless the relativity is front and center.
3. **Contamination — concrete, not hypothetical.** The gold set lives *in the
   repo the agent under test operates on*: an intake agent can open
   [`meta/evals/dedup-probe.md`](/meta/evals/dedup-probe.md) and read the
   answer key. Harmless while the measured backend is a lexical search
   function; invalidating the moment an agent (or model) under test can read
   or has trained on the answers.

**The mitigation is a role split, not abandonment.** The credibility-bearing
artifact is the *dataset with its adjudication trail*, not the runner:

- Keep OKF gold docs as the source of truth; compile them mechanically into
  Inspect's dataset format (the rows already have the input/target shape).
- Port scorers as Inspect scorers — they are pure, dependency-free functions
  by design, which is exactly what makes them cheap to reimplement. Anyone
  can then rerun the eval on machinery this bundle does not control.
- Benchmark runs use a **held-out** corpus + gold split that never ships in
  any repo the examinee reads; the constructible-ground-truth affordance
  (synthesize corpora at any scale) is the generator.
- Report against a naive **baseline** and at least one third-party system;
  **preregister** the metrics before running.

Inspect supplies a neutral runner and log format, but its logs are a weaker
ledger than this bundle's — trajectories without adjudication provenance or
id-keyed label lineage. The honest division of labor: **this ledger authors
and audits; Inspect executes and reports.**

## 3. Observation media as ledger instances

The pencil-and-paper observer tradition (lab notebooks, clinical source data,
usability studies, humans watching agent runs) is the physical original of
the ledger, and each of its reasons maps to a digital design requirement:

- **Independence / out-of-band recording.** The measurement channel must not
  share failure modes with — or be readable by — the subject. Paper shares
  nothing with any software; notes-in-the-system-under-test rebuild the
  answer-key-in-repo problem and go down with the system's crashes.
- **Contemporaneity.** A record made at the moment, in a medium where
  backdating is awkward (bound pages; git), outranks reconstruction —
  memory rewrites itself within minutes. This is the physical ancestor of
  write-once `attribution`.
- **Schema-freedom.** Structured capture forces premature classification;
  full-bandwidth capture defers coding until the phenomenon is understood.
- **Distillation pressure.** Handwriting's slowness forces selection — the
  first pass of analysis. The bundle's
  [distill-don't-dump](/meta/policy/capture-knowledge-cite-the-source.md) policy is the same
  principle as prose.

**Dictation into transcription software** trades along these axes: it wins
gaze-continuity, speech-rate contemporaneity, and free timestamps, but the
channel acquires its own word-error rate (worst on jargon and negations, and
modern transcribers *smooth* — silent editorializing by the instrument),
independence and tamper-evidence drop unless deliberately rebuilt, and the
distillation pressure disappears. The repair is the bundle's own
raw-vs-derived idiom: audio as the primary artifact (the frozen thread),
transcript as a derived, correctable artifact (the generated registry),
committed promptly so contemporaneity becomes provable. The medium is not
the trust; the properties are, and each must be arranged deliberately.

## 4. The continuous-eval model (Eve): all harness, no ledger

[Eve](https://vercel.com/eve) (Vercel's open-source agent framework,
June 2026) represents the opposite corner from the human observer: evals as
files in the agent's directory, scored rubric suites run locally,
[in CI as a deploy gate, and on a schedule](https://vercel.com/blog/introducing-eve)
against the deployed agent — regression testing transplanted onto agents.

**What it buys:** it institutionalizes the internal-use case from §2. A probe
run once measures a moment; run on every commit it measures a *curve*, and
attributes any bend to the commit that caused it. This is the strongest form
of the conflict-free internal eval — and this bundle already practices it in
miniature (verifier, route-tags check, dedup probe on every commit; scores
trended through git history).

**What the removal of the observer costs — four hazards:**

1. **Contamination, again.** Eve's evals live in the agent's own project
   directory; an agent with file access can read its test suite. Tolerable
   for self-versus-yesterday trending, corrosive as evidence of quality.
2. **Unattended judge drift.** Scored rubrics are typically LLM-as-judge, and
   in a continuous setup the instrument changes *mid-trend-line* — a bend
   becomes unattributable between subject regression and judge shift.
   Continuous evals need a pinned judge recalibrated against a
   human-adjudicated subset; almost nobody wires that up.
3. **Gates plus noise equals rot.** Stochastic agent behavior makes scores
   flaky; a flaky deploy gate trains teams to rerun until green, then to
   ignore red. The dedup probe's **warn-don't-gate-until-a-baseline-history-
   justifies-a-floor** posture is the more disciplined default.
4. **Continuous Goodhart pressure.** A score that blocks deploys is maximally
   a target; the suite drifts from independent check to description of what
   was optimized. The countermeasure is refreshing cases from live traffic
   faster than the system overfits — structurally, the harvest-at-intake
   mechanism; a static checked-in suite has no equivalent.

Continuous frameworks produce mountains of layer-one run records and nothing
of layers two and three: the trend line without the receipts. The
complementarity is exact — **Eve-style frameworks automate the running; the
ledger governs what the runs mean.** The question they raise is not "should
evals run continuously" (yes; already built here) but "when the number moves,
does a record exist that the investigation can stand on."

## 5. Reception of an Elixir ledger: ignored as a library, viable as a format

Three audiences, three predictions:

- **The mainstream eval/ML community — as Elixir code: ignored.** That world
  is monolingually Python (Inspect, model SDKs, training stacks, notebooks);
  the barrier is friction, not hostility, and excellent non-Python tooling
  historically goes unused until wrapped or reimplemented in Python.
- **The same community — as a format: a real chance.** Nothing load-bearing
  in the ledger is Elixir; it is markdown, YAML, and rules. What spreads in
  this ecosystem is specifications, not implementations (JSONL, the
  OpenAI-compatible API shape, model cards). A published eval-ledger spec —
  how to record adjudication and lineage for a benchmark — with the Elixir
  toolchain as *reference verifier* is adoptable by people who never install
  the runtime. Reference implementation is a respected role, not an ignored
  one.
- **The Elixir community: warmly received, little used.** Genuine hunger for
  credible AI-adjacent projects (the Nx/Livebook ecosystem exists because of
  it), but few members run evals professionally — appreciation as craft, not
  adoption as infrastructure.

The realistic path if this ever goes public: the ledger's rules and file
formats are the artifact; gold docs compile to Inspect datasets so Python
users consume the ledger without touching Elixir; the Elixir verifier keeps
*this* ledger honest rather than being the thing others must install. The
idea is then judged on its merits instead of its runtime — and the idea
(adjudication and lineage as first-class, machine-checked records) is the
genuinely underserved part.

## Disposition

No new work is commissioned by this analysis; it is the decision record for
the trust conditions any future eval effort here must satisfy. The standing
recommendations, should one be commissioned: (i) internal evals continue
exactly as built — continuous, warn-don't-gate, ledger-backed; (ii) any
comparative or published claim triggers the §2 split (ledger authors, Inspect
executes, held-out sets, baseline + preregistration); (iii) the export
candidate worth a plan of its own is the eval-ledger *format* — adjudication
and lineage schemas with the existing toolchain as reference verifier — not
an Elixir eval library. The natural next eval rungs remain the ones prior
work named: fan-out completeness and filing consistency, on the dedup probe's
gold-set substrate; the routing-ledger-as-completion-oracle idea (§1) is this
session's addition to that list.

## Citations

- [Inspect — UK AI Security Institute](https://inspect.aisi.org.uk/)
- [Eve — The Agent Framework, Vercel](https://vercel.com/eve)
- [Introducing eve — Vercel blog](https://vercel.com/blog/introducing-eve) (2026-06)
- [Vercel Introduces Eve — InfoQ](https://www.infoq.com/news/2026/06/vercel-eve-agents/)
- [Vercel eve: Open-Source Agent Framework for Production — Honra](https://www.honra.io/insights/vercel-eve-open-source-agent-framework)
