# Flows

Per-flow connective docs. For one multi-step action of the brain (running
`/capture`, `/intake`, …), a flow doc is the **touch-sequence of a canonical
run** — every file touched, in order, and what happens at each point — tying
together the three artifacts that make the flow work:

- the **skill** — the agent's terse imperative procedure;
- the **scenario** — a CI-checked ExUnit test over the flow's *deterministic
  spine* (`test/second_brain/<flow>_scenario_test.exs`);
- **this doc** — the *why*, the actor boundaries, the touch-sequence, and the
  did-it-work checklist.

One flow doc per flow. This genre **supersedes** the old
`meta/session-workflow.md` guide and the `meta/verification-flows/` checklist,
folding both in.

Distinct from the other meta genres: `policy` is the standing rules (compiled
into `/CLAUDE.md`); `tutorials` is the *why* behind a piece of tooling, read
start to finish; `specs` is the plan for a change not yet fully built; `threads`
is verbatim session archives. A flow doc is none of these — it narrates how a
*whole action* runs end to end, naming the files and pointing at the scenario
that proves it. The genre itself was designed in
[The flows genre + formal scenario testing](/meta/plans/flows-genre-and-scenario-testing.md).

## Contents

- [Session capture, routing & route tags](/meta/flows/session-capture.md) —
  driving a session through `/capture` → routing ledger → route tags →
  materialized excerpt log: the pipeline, data model, invariants, the
  touch-sequence, actor boundaries, the gate suite, and the scenario test that
  pins the spine.
- [Intake — capture pasted material into a filed concept](/meta/flows/intake.md) —
  driving pasted material through `/intake` → distill + dedup → file by the
  taxonomy → mint id → compile registry → verify: the touch-sequence, the
  judgment/spine split, actor boundaries, the identity gate suite, and the
  scenario test that pins the spine.
- [Render-contract — compile the operating contract from its policy sources](/meta/flows/render-contract.md) —
  driving a rule change through edit-the-policy → `mix brain.contract` →
  `--check` drift gate → one commit for source + artifact: the touch-sequence
  (including the sections-are-code step), actor boundaries, and the scenario
  test that pins the spine.
- [Dedup recall probe — measuring and maintaining intake dedup recall](/meta/flows/dedup-recall-probe.md) —
  the dedup-recall eval loop: how `mix brain.dedup_probe` scores intake dedup
  against an id-keyed gold set, how the gold set and baseline grow automatically
  at intake, and — foregrounded — **how the operator audits, explores, and
  re-evaluates** a system that otherwise runs silently in the background.
