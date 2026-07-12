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

**Lineage header.** A flow doc opens with a one-line `> **Lineage —**` blockquote
tracing the arc that produced the flow: the originating `analysis` (a problem or
idea identified against evidence), the `plan` that designed the change, and the PR
that implemented it — so the whole path *problem-identified → designed → built →
running system* reads at a glance, and the upstream analysis/plan gain the forward
pointer they otherwise lack (the citations run backward only). Each hop is a link to
the record that carries its reasoning. The chain is **heterogeneous**: omit hops a
flow doesn't have (some flows emerged directly as a plan, with no upstream analysis;
the genre itself came from the [flows-genre plan](/meta/plans/flows-genre-and-scenario-testing.md)
with none) and name the gap rather than forcing a link. The reference instance is
the [dedup recall probe flow](/meta/flows/dedup-recall-probe.md), whose full
`analysis → plan → PR → flow` chain is intact.

Distinct from the other meta genres: `policy` is the standing rules (compiled
into `/CLAUDE.md`); `tutorials` is the *why* behind a piece of tooling, read
start to finish; `plans` is the design/decision record for a change not yet
fully built; `threads` is verbatim session archives. A flow doc is none of these — it narrates how a
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
- [Site build & Pages deploy](/meta/flows/site-build-and-deploy.md) — from a
  push on `main` to the live GitHub Pages site: the four integrity gates, then
  `mix brain.site` renders every page (metadata panels, evidence edges +
  backlinks, search index) and the workflow deploys it. Fully unattended; no
  skill involved.
- [News — generate the daily inbox of candidates](/meta/flows/news-inbox.md) —
  `/news` derives a query profile from the taxonomy, searches, dedups twice,
  reason-tags, and writes a dated digest into the non-bundle `inbox/`
  namespace; hand-off to `/intake` crosses a candidate into the brain. Almost
  all judgment layer — the structural guarantee is the namespace boundary.
- [Add to glossary — accrete per-term definition concepts](/meta/flows/add-to-glossary.md) —
  `/add-to-glossary` extracts a source's technical terms, dedups
  (merge/pointer/new), and files one concept per term under `/glossary/`,
  riding the same id → registry → verify spine as intake (one pin, shared
  scenario).
- [Create pull request — capture, glossary, commit, push, open](/meta/flows/create-pull-request.md) —
  the composition flow that ships a session: run capture in full, glossary its
  thread doc, back-link this session's `meta/elaborations/` docs to the
  captured thread (`thread:` frontmatter), then commit/push/open the PR —
  invocation is the authorization; ordering (capture before commit) keeps the
  record in the same PR as the change.
- [Dedup recall probe — measuring and maintaining intake dedup recall](/meta/flows/dedup-recall-probe.md) —
  the dedup-recall eval loop: how `mix brain.dedup_probe` scores intake dedup
  against an id-keyed gold set, how the gold set and baseline grow automatically
  at intake, and — foregrounded — **how the operator audits, explores, and
  re-evaluates** a system that otherwise runs silently in the background.
