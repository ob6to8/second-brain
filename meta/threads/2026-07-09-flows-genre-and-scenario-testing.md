---
type: reference
title: 2026-07-09-flows-genre-and-scenario-testing
description: Designed and built the meta/flows/ genre (per-flow touch-sequence docs backed by ExUnit scenario tests over each flow's deterministic spine), proving it on /capture and /intake; ran a harness research spike, intook its sources, added the three-scanners tutorial, and unified the spec genre into main's plan genre. Landed as PR #23.
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-09; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped (parse-the-log render)"
tags: [meta, thread, flows, scenario-testing, plans, intake, testing, elixir]
timestamp: 2026-07-09
---

# 2026-07-09-flows-genre-and-scenario-testing

## Where this landed

The session began from an agent comment about the `/capture` docs and turned into
a design-and-build effort: it established a **`meta/flows/` genre** — per-flow
"touch-sequence" docs, each backed by an **ExUnit scenario test** over that flow's
*deterministic spine* — and proved it on two flows. `/capture` came first (a
3→1 collapse of `meta/session-workflow.md` + `meta/verification-flows/` into one
flow doc), then `/intake`. A commissioned **research spike** corrected the testing
approach mid-design (in-code fixtures + structured/targeted assertions, not
on-disk whole-tree golden), and its sources were intook as two `SWE/testing`
references. Along the way: a **three-bundle-scanners tutorial**, a
**`persist-plans` policy** for design records, and — after `main` shipped a
parallel `plan` type/namespace — a **`spec`→`plan` genre collapse** unifying on
`meta/plans/`. It all landed as **PR #23 (merged)**.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| The `flows` genre — from idea to a built `meta/flows/` + collapse of `session-workflow.md`/`verification-flows/` | closed | `unrouted` | - |
| Formal scenario testing + the harness research spike (an "adjust" verdict) | closed | `unrouted` | - |
| Dependency-free ExUnit testing — the spike's findings, intook as references | closed | [ExUnit dependency-free fixtures and diffs](/SWE/testing/exunit-dependency-free-fixtures-and-diffs.md) | - |
| Persisting design records — the `persist-plans` policy + `spec`→`plan` genre collapse | closed | `unrouted` | - |
| The three bundle scanners tutorial | closed | `unrouted` | - |
| The `/intake` flow (second flow) | closed | `unrouted` | - |
| Generalizing the genre to other tool pipelines (contract-render, site-build) | paused | `unrouted` | whether to add a `future-beliefs` note generalizing the flows genre |
| Syncing with `main` (repeated merges) and landing PR #23 | closed | `unrouted` | - |

## User

I was implementing a change and received an agent comment:

"Corrected the session-capture policy, the /capture skill, meta/session-workflow.md, and the verification-flow so the rule is unambiguous: everything kept is reproduced verbatim — the delivered text of each operator message and agent response, never summarized. I also made parse-the-log the preferred render path (it’s mechanically exact, vs. reproducing from memory), and recompiled CLAUDE.md."

This made me think, what if we were to create a "flows" or "paths" section of meta akin to tutorials which traces an action or intention (in the above case, running /capture to capture/persist a thread) across a canonical run, referencing every file that gets touched, and describing exactly what happens at each point. This could be useful for:

1 - operator comprehension of processes
2 - (possibly) agent comprehension of workflows without needing to derive from source. To this end there could be abbreviated tour at top and a more detailed operator centric response below
3 - testing - these would basically be scenarios

Thoughts

## Assistant

Good instinct — and the useful news is that this repo has already grown most of the machinery you're describing, which sharpens what's actually new in your proposal (and where it would just duplicate).

## What already exists in this genre space

`meta/` already runs a four-way split of "non-policy explanatory doc":

| Genre | Answers | Example |
|-------|---------|---------|
| `meta/policy/` | the **rules** (compiles into `CLAUDE.md`) | `session-capture.md` |
| `meta/tutorials/` | the **why**, read start-to-finish | `why-the-toolchain-runs-offline.md` |
| `meta/session-workflow.md` | the **connective runbook** for one subsystem (pipeline, data model, invariants) | (capture) |
| `meta/verification-flows/` | **did it work?** — who does what, the gate suite, a pass/fail table | `session-capture-routing-route-tags.md` |
| skill `SKILL.md` | the agent's **step-by-step procedure** | `.claude/skills/capture/` |

So for the `/capture` example you picked, there are already *three* docs tracing that exact flow (session-workflow + verification-flow + the skill). A "flows" doc there would be the fourth — and this repo's single strongest value is allergy to parallel maps that drift ("do not maintain a separate map that drifts"; "generated, not hand-kept; the verifier owns it").

## What's genuinely new in your proposal

Two things none of the above delivers:

1. **A file-by-file execution trace** — "references every file that gets touched, describes exactly what happens at each point." `session-workflow.md` explains *why* and points at sources rather than restating them; the verification-flow lists *gates*, not the touch-sequence. A linear "control/data-flow trace naming each file as it's hit" is a distinct artifact. This is the real gap.
2. **The scenario/testing framing** — nothing currently frames a flow as an executable scenario.

## The trap, and how I'd avoid it

**Don't add a flows doc for subsystems that already have the session-workflow + verification-flow pair** (i.e. capture). That's pure drift. Where the genre *earns its keep* is the subsystems that have **no** connective doc yet — each would get exactly one trace doc instead of sprouting the same three-doc sprawl:

- `/intake` (paste → distilled concept → index/log upkeep)
- the contract render pipeline (`meta/policy/*` → `mix brain.contract` → `CLAUDE.md`)
- verification/grounding (`claim` + `verified_by` → `mix brain.verify` → `mix brain.evidence`)
- id minting + registry (`mix brain.id` → `mix brain.registry`)
- the site build

**On the testing angle — be honest about it or mechanize it, don't split the difference.** A prose "scenario" that claims to be a test but isn't machine-run is exactly the hand-kept shadow this repo refuses to tolerate; it'll drift the moment code changes and quietly lie. Two clean options:
- **(a)** Ship it as an operator/agent *comprehension* doc and don't oversell the testing claim — its correctness gets spot-checked, like the tutorials.
- **(b)** Anchor each trace to the existing green **reference instance** (the verification-flow already names one: thread `2026-07-08-…` ↔ `sb:d479e3`) so the trace narrates a *real, checked* run rather than an idealized one. That keeps it honest without needing new tooling.

Your two-tier format (abbreviated tour on top, detailed operator trace below) is good and mirrors `summarize-technical`'s layered structure — no objection there.

## My recommendation

Add `meta/flows/` as its own genre, define it crisply against the four above (the **touch-sequence** of a canonical run — every file, in order, what happens at each), and **seed it with one subsystem that currently lacks a connective doc** (I'd pick `/intake` — highest operator/agent value, zero overlap). Wire it into `meta/index.md`, give it an `index.md`, and follow option (b): narrate a real reference run, not an idealized one. Prove the genre on one before templating it across the rest.

One genuine fork for you before I draft anything:

## Assistant

The interactive question tool isn't working in this session, so I'll just put the two forks inline with my recommended defaults — tell me if you'd steer differently and I'll draft accordingly.

**Fork 1 — scope.** My recommendation: **new `meta/flows/` genre, seeded on a subsystem that has no connective doc yet** (I'd pick `/intake`). Rationale: capture already has three tracing docs, so a flows doc there is pure drift; the genre proves its worth exactly where there's currently *nothing*. I'd explicitly define `flows/` against the other four genres as "the **touch-sequence** of a canonical run — every file, in order, what happens at each point," so it doesn't bleed into the "why" (tutorials/session-workflow) or "did-it-work" (verification-flows) lanes.

**Fork 2 — testing.** My recommendation: **anchor each trace to a real green run** rather than an idealized one, and don't over-claim the testing angle in prose. Mechanized fixtures are the "right" end-state by this repo's ethos (generated, verifier-owned, fails-on-divergence), but that's a much bigger lift and I'd only reach for it once the prose genre has earned its place. Anchoring to a real instance gets you 80% of the honesty for none of the tooling.

Two things worth flagging before you decide:

- **Genre proliferation is itself a cost.** You'd be going from four explanatory genres to five, each needing an `index.md` and a crisp boundary definition so agents/operators know which to write and which to read. If the boundary between `flows/` and `verification-flows/` can't be stated in one sentence each, that's a signal to fold rather than split (fork 1, option 3).
- **This is a `meta/` shape change.** Adding a top-level `meta/` genre is governance-namespace, not knowledge-taxonomy, so it doesn't strictly need the taxonomy-evolution ratification — but it's the same *kind* of decision, and you're the operator proposing it, so consider this your ratification point.

If you're happy with both defaults, say go and I'll draft `meta/flows/` + its `index.md` + a first `/intake` flow anchored to a real thread, wire it into `meta/index.md`, and run the gate suite before committing to `claude/flows-paths-documentation-b6mzee`. Or point me at a different seed subsystem.

## User

I would argue that session workflow is essentially a prototype of what we're describing here. Verification flows was also an early attempt to get at what would be covered by this new document type, so I would push back and say that both of these could be collapsed into a single document type that covers everything we're discussing. The scale could be collapsed down to whatever is essential for the agent to read. Um, it could be written in conjunction with this new flow document, uh, to avoid duplication. across them.
I would actually like to address the the testing question now. Are we basically creating informal scenario tests? If so, I'd like to explore formalizing it and actually going the distance. Uh, I don't wanna go eighty percent of the way and ignore the last twenty percent, which may have, if addressed, changed the way that the first eighty percent was done. So start with specking out the hard thing. Is this something that we could benefit from if we were to look at this as scenario testing? and then build any pros around that test so you have something formal, and then you have informal context surrounding that formal testing. Let's spec that out and discuss before moving forward with implementing anything.

## User

There is a typo in the last message, I meant to say the skill could be collapsed down to whatever is essential for the agent to read. So in a way, I guess I'm imagining three documents, which is the skill, The formal scenario testing, if we decide to go that way, and the prose document, which would be the flow document slash verification flows slash session overview thing that is there currently, those collapse into a single prose document, which provides context and everything that is not directly covered in the skill and testing.

## Assistant

This is the right instinct — design the formal layer first, because if it's real it reshapes the prose and the skill around it. Before I spec, I need to see what the toolchain actually gives me to build on: whether the `mix brain.*` tasks can run against a fixture bundle or hardcode the repo root, and what the test suite looks like today. Let me look.

## Assistant

This changes the picture in a good way. The repo already contains proto-scenario-tests — I just want to reflect them back to you before speccing, because they answer your "are we basically creating informal scenario tests?" question concretely.

## Direct answer: you already have both halves, unmerged

- **The formal half exists but is hidden in code.** `route_tags_test.exs` builds a `green_fixture` — a real mini-bundle (a thread + a concept with a materialized log) — then runs `RouteTags.run_checks/1` and asserts each check's status, with one red test per failure mode (unresolved ref, missing block, divergent fidelity, orphan, uncovered row). That *is* a scenario test. It's just written as Elixir heredocs, scoped to one module, and invisible to the prose.
- **The informal half is the "reference instance."** The verification-flow doc points at a *live* thread↔concept pair (`2026-07-08…` ↔ `sb:d479e3`) as "the green worked example to diff against." That's a narrated scenario with no executable teeth, and it can drift when either file is edited.

So your proposal, precisely stated: **promote the hidden fixture to a first-class, named artifact, and make the prose narrate that same artifact instead of a drift-prone live pair.** One scenario, executed by CI and narrated by prose.

## The load-bearing reason to go the full distance (not 80%)

There's a specific hole that only formal golden fixtures close, and it's exactly the 20% you don't want to skip:

The live checks are **self-consistency** checks. `log fidelity` asserts each concept's excerpt log *matches its own re-derivation from the current tags*. If someone changes the transform itself — say header-demotion or how multi-ref paragraphs are lifted — **both sides move together and the check stays green.** The whole bundle passes CI while the transform silently does the wrong thing. A **golden fixture** (input → expected exact bytes, pinned in the repo) is the *only* thing that catches a wrong-but-internally-consistent transform. That's not a nice-to-have; it's the class of bug your current suite is structurally blind to. That single argument is what justifies formalizing rather than narrating.

## The honest boundary of what can be formal

A flow has two layers, and only one is deterministically testable:

| Layer | Example (capture) | Formalizable? |
|-------|-------------------|---------------|
| **Deterministic spine** — the `mix brain.*` transforms + checks | `--materialize` writes the log; the 5 checks; registry/verify chaining | **Fully.** Golden fixture + assertions. This is the formal test. |
| **Agent judgment** — LLM-driven distillation & selection | "distill don't dump"; which paragraphs to tag; routing target choice | **No** — non-deterministic, needs an LLM+judge eval, not a unit test. |

Trying to force the judgment layer into a deterministic test is the trap. The clean design **routes each layer to the artifact that can actually hold it**: spine → scenario test; judgment → skill (procedure) + prose (narrated boundary); and phase-2 optionally an *eval* over the judgment layer (separate harness, graded not asserted). I'd spec the eval as explicitly deferred, not skipped — so the door your "last 20%" worry wants open stays open, but v1 doesn't block on it.

## Proposed artifact shape

**Scenario = on-disk golden fixture, run by the existing ExUnit harness.** Concretely, per flow:

```
test/scenarios/<flow>/
  before/     ← a real mini-bundle: input files as they'd exist pre-action
  expected/   ← the exact bundle state after the deterministic steps run
  steps.md    ← ordered step list: actor {operator|agent|tool}, action, files touched
```

An ExUnit case copies `before/` to a tmp dir, runs the tool step(s) named in `steps.md`, and diffs the result against `expected/` (golden), plus asserts check statuses. This **reuses the proven tmp-dir harness** — no bespoke DSL, no new runner to maintain — but lifts the fixture out of Elixir heredocs into readable files the prose can point at. `steps.md` is the single authoritative touch-sequence; the prose flow doc narrates *that*, so the two can't independently drift (and a cheap check can warn if the prose references a file the steps don't touch).

Critical constraint to resolve: **fixtures must live outside the scanned bundle** (a fixture concept carrying a fake `sb:` id would collide in registry/verify). The scanners already exclude some dirs; we must confirm `test/` is excluded (or exclude it) before putting `.md` fixtures on disk there. Flagging as an open question, not an assumption.

## The three-doc model, concretely

Your collapse is right. Per flow, three artifacts, zero overlap:

| Doc | Audience | Holds | Must NOT hold |
|-----|----------|-------|---------------|
| **Skill** (`.claude/skills/<f>/SKILL.md`) | agent, at run time | terse imperative procedure incl. judgment steps | the why; verification detail; narrative |
| **Scenario** (`test/scenarios/<f>/`) | CI | golden fixture + assertions over the deterministic spine | prose; anything non-deterministic |
| **Flow doc** (`meta/flows/<f>.md`) | operator + agent (comprehension) | the touch-sequence narrative, the why, actor boundaries, and *pointers* to skill + scenario | restating skill steps or scenario bytes |

This **supersedes `meta/verification-flows/` and `meta/session-workflow.md`** — both fold into the flow doc, with their "did-it-work" checklist becoming "here's the scenario CI runs + the editorial spot-checks the machine can't judge."

## Recommended first target: capture (a collapse, not an addition)

I flip my earlier `/intake` suggestion. Capture is the ideal proof precisely *because* it already has three overlapping docs and a rich deterministic spine (route_tags is your most-tested tool). Doing capture first **demonstrates the 3→1 collapse directly** rather than greenfielding, and reuses the existing `green_fixture` as the seed of `test/scenarios/capture/`. `/intake` becomes the second target once the genre's shape is proven.

## Open questions to settle before I write anything

1. **Golden-diff granularity** — assert exact `expected/` bytes (strictest, catches the transform-drift bug, but noisier to update), or assert check-statuses + a few key golden files? I lean **exact bytes**, since that's the whole justification.
2. **`steps.md` authority** — is it authoritative and the prose generated/checked against it, or is it just documentation with a soft warn? I lean **authoritative + warn-level cross-check** (matches the route-tags ethos, avoids over-engineering a generator in v1).
3. **Eval layer** — spec it now as an explicit phase 2, or leave it entirely out of scope? I lean **spec-as-deferred** so the design doesn't paint it out.
4. **Fixture location** — confirm/extend scanner exclusions so `test/scenarios/**.md` isn't ingested as bundle concepts. (Mechanical; I'll verify the exclusion list when we proceed.)

My recommended path is: capture-first collapse, exact-byte golden fixtures, `steps.md` authoritative with a warn cross-check, eval deferred. If that reads right, I'll turn this into a written spec doc (probably `meta/flows/README`-style genre definition + the capture flow's three artifacts sketched) for one more review pass before any code. Where do you want to push back?

## User

No pushback, agree, proceed

## Assistant

Resolved: `test` is in the registry's `@excluded_dirs`, the verifier scans through `Registry.scan`, and `route_tags` only reads threads from `meta/threads/` + sinks from the registry. So fixtures under `test/scenarios/**` are invisible to all three scanners already — **open question #4 needs no code**. Writing the spec now.

## Assistant

Spec written. Here's the shape of it for the review pass; full doc attached below.

**What it locks in**
- **Three artifacts per flow, one concern each:** skill (agent procedure) · scenario (`test/scenarios/<f>/` golden fixture, CI-run) · flow doc (`meta/flows/<f>.md`, the narrated touch-sequence). The flow doc **supersedes and collapses** `meta/session-workflow.md` + `meta/verification-flows/`.
- **Why formal, not narrated:** the live checks are self-consistency checks (`log fidelity` re-derives from the same tags), so a *wrong-but-consistent transform change passes CI green*. Only a golden fixture (pinned expected bytes) catches that class — it's the exact 20% you didn't want to skip.
- **Honest boundary:** deterministic spine → golden scenario; agent judgment (distillation, tag coverage) → skill + narrated boundary, with an **eval layer spec'd but deferred** to phase 2 so the design doesn't wall it out.
- **Harness reuses what exists:** the `tmp_dir` ExUnit pattern already drives `green_fixture` through `run_checks`; we lift the fixture onto disk as readable `before/`, `expected/`, `steps.md`. ~40 lines of runner, no new DSL, picked up by the existing `mix test`.
- **`steps.md` is the authoritative touch-sequence**; the flow doc narrates it, with a warn-level cross-check (route-tags ethos) so the two can't silently drift.

**Two things resolved during speccing (were open questions)**
- **Fixture location needs no code:** `test/` is already in the registry's `@excluded_dirs`, the verifier scans via the registry, and route_tags only reads `meta/threads/` — so `test/scenarios/**.md` is invisible to all scanners, fake `sb:` ids and all.
- **First target flipped to capture, not `/intake`** — because capture already carries the three overlapping docs, so it *demonstrates the 3→1 collapse* instead of greenfielding, and `green_fixture` seeds the scenario directly. `/intake` becomes the second target.

**Build order** (spine first, per your "spec the hard thing first"): scenario fixture + runner green against current `RouteTags` → flow doc narrating it → collapse the two old docs + repoint links → optional `mix brain.flows` warn-check → gate suite + push.

Three non-blocking mechanical choices I'll settle at implementation (golden-update ergonomics, whether the cross-check is its own `mix brain.flows` task, runner file layout) — none change the artifact shape.

## Assistant

That's the spec. Nothing is committed yet — this is the review gate I promised before any code. Read §9 (build order) and §4 (scenario harness) most closely, since those are where I'd want a green light or a redirect. Say go and I'll build it in that order, starting with the golden fixture + runner against the current `RouteTags`.

## User

Create a tutorial describing the functionality and implementation of the 3 "scanners" referred to above
Where is the specced eval layer doc persisted to?
Re: harness reusing what exists - do a research spike reaffirming that this architecture represents the best balance of elixir best practices and the resources saved here re: testing 
Spec approved. We should persist this, set policy to persist all spec/plans, determine where to save this policy, and where to save the plan/spec artifacts

## Assistant

Done — all four items landed on `claude/flows-paths-documentation-b6mzee` (commit `2332f60`, pushed; no PR since you didn't ask for one). Full gate suite green: `mix format`, `brain.contract --check`, `brain.registry --check`, `brain.verify`, `brain.route_tags`, and 69 tests, 0 failures.

**1 — Scanners tutorial** → `meta/tutorials/the-three-bundle-scanners.md`. Covers `Registry.scan/1` as the *one* crawler (wildcard → exclusion filter → frontmatter→`Entry`, with duplicate-id detection), the Verifier as a rule layer with no new inputs (it delegates to `Registry.scan`), and RouteTags as the only scanner that opens a second surface (`meta/threads`) and rejoins the governance/knowledge namespaces by stable id. Closes with why anything under an excluded dir (e.g. `test/` fixtures) is invisible to all three — the fact that made the scenario-fixture location safe.

**2 — Where the eval-layer doc is persisted:** it lives as **§7 ("Deferred: the eval layer") of the flows spec**, now at `meta/specs/flows-genre-and-scenario-testing.md`. Per the new policy, a deferred phase stays inside its parent spec under an explicit "deferred" heading until it's actually built, at which point it graduates into its own `meta/specs/` doc. So today: one file, §7. Before this change it existed nowhere durable — only in the scratchpad — which is exactly the gap the persist-specs policy closes.

<routes ref="sb:f6e843 sb:b1ba4b">

**3 — Research spike — important, and I want to be straight with you: it did *not* cleanly reaffirm. Verdict was "adjust (mostly reaffirm)."** What it upheld: plain ExUnit + `@tag :tmp_dir`, no external dep, no DSL, no custom mix runner — that half was correct. What it corrected, and which I folded into the persisted spec before saving it:
- **Drop whole-tree byte-exact golden as the primary oracle** — brittle, invites blind-approval of golden diffs, and for RouteTags re-encodes logic the tool already self-checks.
- **Keep fixtures in-code** (heredocs), not on-disk `before/expected/` trees.
- **Primary oracle = structured + targeted assertions** (matching the existing tests), with the transform-pinning need met by a *targeted* in-code expected-output assertion rather than a whole-tree snapshot. Reserve golden narrowly for large opaque renders (the Site HTML), dep-free, behind `UPDATE_GOLDEN`, normalized.
- **`steps.md` becomes a human-readable table in the flow doc, not a machine-parsed artifact** — which also deletes the warn-check task from the earlier plan.

My original "only golden catches a wrong-but-consistent transform" justification survived in *substance* (self-consistency checks genuinely can't pin the transform) but was over-built in *mechanism*; the spec's §1 now states the corrected version, and §8 records the spike's verdict + sources as provenance.

</routes>

**4 — Persistence set as policy:**
- New `spec` type ratified in `controlled-type-vocabulary`.
- New **`meta/policy/persist-specs.md`** (filing section, order 6) → compiled into `CLAUDE.md`: approved specs/plans persist as `type: spec` under `meta/specs/`, never left in chat/scratchpad; superseded specs are kept, not deleted.
- New **`meta/specs/`** genre with its `index.md`, seeded with the approved flows spec.
- Indexes (`meta/index.md`, `meta/policy/index.md`, `meta/tutorials/index.md`) and `meta/log.md` all updated; `CLAUDE.md` recompiled.

Note the spec's `status: approved` refers to the *design*; the build itself (creating `meta/flows/`, the capture scenario test, collapsing `session-workflow.md` + `verification-flows/`) is **not started** — that's build order §9, awaiting your go.

## User

Commit
Create a doc called "future-beliefs.md" in meta and add the following: policies derive id from filename
Commit
Were the results from the research spike incorporated into the spec? Also - persist via /intake every outside reference that informed the design changes, and include some way of tracing their influence on the design decision. Inassume this would be bu cross-linkjng the resources with the spec doc, correct me if wrong

## Assistant

All four items are done and pushed to `claude/flows-paths-documentation-b6mzee` (three commits: `2332f60` was last turn's, then `b63f8db`, `fbe44d5`). Gate suite green throughout — 69 tests, `contract`/`registry`/`verify`/`route_tags` all clean.

**Commits** — the working tree was already clean from last turn, so the first "Commit" was a no-op. `meta/future-beliefs.md` created (a holding-pen note; first entry: *policies derive their `id` from filename via `Policy.load!/1`*) and committed on its own.

**Were the spike results incorporated into the spec? Yes — before it was persisted, deliberately.** Concretely:
- **§1** — rewrote the "load-bearing justification." The original "only a whole-tree golden catches a wrong-but-consistent transform" was corrected: the *need* survives (self-consistency checks can't pin the transform), but the *mechanism* is now a targeted in-code expected-output assertion, not an on-disk whole-tree snapshot.
- **§4** — rewrote the scenario mechanics: in-code heredoc fixtures (not `before/expected/` trees), structured + targeted assertions as the primary oracle, golden reserved narrowly for large opaque renders behind `UPDATE_GOLDEN`, and `steps.md` demoted to a human-readable table in the flow doc (killing the warn-check task).
- **§8** — a new "Design review — harness research spike" section records the *adjust (mostly reaffirm)* verdict, what it upheld vs. corrected, and the sources.

So the persisted spec reflects the corrected design, not the pre-spike one.

**Intake + traceability** — filed two distilled `reference` captures under `SWE/testing/` (autonomous — existing domain):
- `exunit-dependency-free-fixtures-and-diffs` (`sb:f6e843`) — `:tmp_dir` + built-in `assert ==` diff.
- `elixir-snapshot-libraries-require-a-dependency` (`sb:b1ba4b`) — mneme/snapshy/assert_value are hex deps.

I grouped the six source URLs into two genuinely-reusable concepts (distill-don't-dump) rather than six thin bookmarks; each holds its full URL set under `# Citations`. Ids minted, `meta/registry.md` regenerated, index + root log updated.

**On your cross-linking assumption — you're right, with one refinement.** Cross-linking is the correct mechanism, and I made it **bidirectional**: each capture carries an `# Influence` section back-linking the spec, and the spec's §8 links *forward* to each capture, tying a specific design change to the resource that drove it (drop-the-snapshot-library → `sb:b1ba4b`; built-ins-are-enough → `sb:f6e843`). The refinement: I deliberately did *not* use the repo's typed `verified_by` edges for this. Those are reserved for verification-grounding of agent-authored *claims* — a spec isn't a verified claim, and these references *inform a decision* rather than *prove a statement*, so a typed edge would be a semantic misuse (and specs live in the governance namespace with no `sb:` id, so they can't be an edge endpoint anyway). Untyped bundle-absolute markdown links — the repo's standard for related concepts — are exactly the right tool here.

Nothing from the flows *build* has started — that remains spec'd and awaiting your go.

## User

Pull main and merge to branch

## Assistant

Merged and pushed. The branch is now `0` behind main / `4` ahead (my three commits + the merge), and the whole tree passes the full gate suite (contract, registry, verify, route_tags, 69 tests).

**What the merge pulled in from main** (12 commits — the `/news` inbox arc): the new top-level `inbox/` namespace + `/news` skill, a `meta/issues/` namespace with the `issue` type, three captured threads, `inbox` added to `Registry`'s `@excluded_dirs`, and a tutorial.

**Conflicts — all additive, resolved as unions** (kept both sides, no work lost):
- `meta/policy/controlled-type-vocabulary.md` — kept **both** new types (`spec` from this branch, `issue` from main).
- `meta/tutorials/index.md`, `meta/log.md`, `log.md` — kept both sides' entries.
- `CLAUDE.md` — not hand-resolved; regenerated from the merged policy sources via `mix brain.contract` (it now carries both `spec` and `issue`). `meta/registry.md` regenerated too.

I also made one accuracy fix while resolving: main added `inbox` to the exclusion list, so I added an `inbox` row to my three-scanners tutorial's excluded-dirs table.

**One thing to flag** (not acted on): main's merge added a tutorial, `meta/tutorials/bundle-scope-and-non-bundle-namespaces.md`, that **overlaps** conceptually with the `the-three-bundle-scanners.md` tutorial I wrote this session — both explain the registry's exclusion list and how the verifier/route-tags inherit scope. They're framed differently (mine: the three scanners as one crawler + two consumers; main's: four scanners and why the site renders what the registry ignores), so they're not duplicates, but there's real redundancy. Both are live in the tree right now. Want me to reconcile them — merge into one, or cross-link and scope each to its distinct angle?

## User

Keep

## Assistant

Understood — both tutorials stay as-is. Nothing further to do: the merge is committed and pushed (`7f5bab2`), the branch is level with main plus your four commits, and the full gate suite is green.

## User

Proceed with specced dev

## Assistant

All gates green and the site builds (106 pages). One broken *link* remains at `log.md:50` — but that's a frozen 2026-07-08 historical log entry (accurate at the time it was written); per the repo's "historical mentions are left as-is" convention I'm leaving it rather than rewriting past history. Committing and pushing:

## Assistant

The specced dev is built and pushed (`27895ef`). All three artifacts of the capture flow now exist per the spec's three-artifact model, and the collapse is done.

**What landed (build order §9):**

1. **Scenario (the spine, first)** — `test/second_brain/capture_scenario_test.exs`. Plain ExUnit over a `:tmp_dir` fixture (in-code, per the spike — no on-disk golden tree). Two threads (one with a multi-ref, ATX-header-bearing region) feed one concept sink; it drives `RouteTags.materialize/1` and asserts three ways:
   - **structured** — only the fed sink is rewritten; `run_checks/1` all `:ok`;
   - **targeted/byte-exact** — the materialized log section matches expected exactly (co-feed line, ATX→bold demotion, count line, alpha-before-beta ordering). This is the transform-pin: the assertion the `log fidelity` self-check structurally can't provide, since it re-derives both sides from the same tags.
   - Plus an idempotency test. 71 tests green (was 69).

2. **Flow doc** — `meta/flows/session-capture.md` + `meta/flows/index.md` (the genre definition). The flow doc carries the distinctive contribution — a **§3 touch-sequence table**: every file a `/capture` run touches, in order, each row tagged actor (`operator`/`agent`/`tool`) and "checked by" (`scenario`/`tool`/`editorial`) — plus the pipeline, data model, actor boundaries, the 5-check tooling table, invariants, provenance, and a Verify section pointing at the scenario as the canonical green example.

3. **Skill** — unchanged procedure, with a new "See also" pointer to the flow doc.

**Collapse (§9.3):** removed `meta/session-workflow.md` and all of `meta/verification-flows/` (folded into the flow doc), repointed `meta/index.md` (dropped both rows, added a `flows` row), updated the spec's status to "capture flow built" and delinked its now-removed-doc references, and logged it.

**Verification:** full gate suite green — format, `compile --warnings-as-errors`, `contract --check`, `registry --check`, `verify`, `route_tags`, 71 tests, and `mix brain.site` (106 pages). Flow docs are governance-namespace (`type: note`, no `sb:` id), so no registry/contract churn.

**Two things to flag:**
- One tolerated broken *link* remains at `log.md:50` — a frozen 2026-07-08 history entry that linked to `session-workflow.md`. It was accurate when written; per the repo's "leave historical mentions as-is" convention I didn't rewrite past history. Say the word if you'd rather I delink it.
- **`/intake` is the next target** in the spec (second flow), deliberately not built this pass — the genre shape is now proven on capture. Want me to proceed to the `/intake` flow, or stop here?

## User

Commit, then oroceed with /intake

## Assistant

The `/intake` flow is built and pushed (`b0e89bb`) — the "Commit" was a no-op (last push held), then I proceeded with `/intake` as the second flow, completing the spec's planned scope.

**All three artifacts now exist for `/intake`, matching the capture flow's pattern:**

1. **Scenario** — `test/second_brain/intake_scenario_test.exs` (3 tests). In-code `:tmp_dir` fixture of a real intake output (a `source` capture + a `claim` grounded against it via `verified_by`). It drives the identity spine — compile the registry, then:
   - **structured** — `Registry.check/1` round-trips; `Verifier.run/1` clean;
   - **targeted/byte-exact** — both registry rows render exactly (id, path, type, and the `verified` column: `true` for the grounded claim, empty for the capture);
   - **two red guardrails** encoding intake's mechanical handoffs — a concept written *without an id* gets flagged (the cue to run `mix brain.id`), and a *capture marked `verified: true`* is rejected. Id minting is random, so deliberately not pinned.

2. **Flow doc** — `meta/flows/intake.md` (+ flows index entry): the file-by-file touch-sequence of an `/intake` run (paste → distill+dedup → file by taxonomy → mint id → compile registry → verify → reserved files), with the judgment/spine split, actor boundaries, the identity gate suite, and invariants.

3. **Skill** — unchanged procedure, now with a See-also to the flow doc.

**Design note worth surfacing:** intake's spine is genuinely different from capture's, which is why the scenario isn't a rerun of the existing registry/verifier tests. Capture had a *deterministic transform* to pin byte-exact (the materialized log). Intake's core mechanical step — id minting — is *random*, so the scenario pins what's deterministic (the registry render + verifier's green/red judgments) and honestly leaves the RNG unpinned. That's the spike's principle applied: byte-exact only where a deterministic transform needs it, structured assertions everywhere else.

**Verification:** full gate suite green — format, `compile --warnings-as-errors`, `contract --check`, `registry --check`, `verify`, `route_tags`, 74 tests (71 + 3), and `mix brain.site` (107 pages).

**Spec status:** now marked approved-and-built — both planned flows (`session-capture`, `intake`) landed with scenario tests. The genre's planned scope is complete; further flows (contract-render or site-build pipelines) would be additive follow-ups, not part of this spec. Nothing pending unless you want one of those.

## User

Are those follow ups documented in the repo?

## Assistant

No — not as tracked follow-ups. They appear in exactly one place: a single illustrative aside in the flows spec's status line (`meta/specs/flows-genre-and-scenario-testing.md:15-16`, "further flows (e.g. the contract-render or site-build pipelines) are additive follow-ups"). That's a passing example to bound the spec's scope, not a durable, actionable record.

What *is* properly documented as deferred is the **eval layer** — it has its own §7 heading in the spec, per the persist-specs policy's "deferred phases stay under an explicit heading" rule. The two candidate flows don't get that treatment because they aren't spec'd — they're just named as things that *could* be flows, with no design behind them.

Worth noting there's no dedicated "backlog / future work" home in the repo right now:
- `meta/issues/` is for *problems/defects* (`status: open/resolved/wontfix`) — a planned enhancement isn't a defect.
- `meta/future-beliefs.md` is a holding pen for *facts/observations* worth formalizing — not work items.
- `meta/specs/` holds *designed* plans — these two aren't designed yet.

So if you want them tracked rather than left as an aside, the honest options are:
1. **Leave as-is** — they're genuinely just "the genre generalizes; obvious next candidates exist." Low value in over-formalizing undesigned work.
2. **A `future-beliefs` entry** — a one-liner noting the flows genre generalizes to any tool pipeline, with contract-render and site-build as the obvious next candidates. Lightweight, matches that file's holding-pen purpose.
3. **A real backlog genre** — if you expect a recurring stream of "planned but not yet designed" items, that'd argue for a dedicated genre (e.g. `meta/backlog/`), which is a shape change I'd propose and you'd ratify.

My recommendation is (2) — it's the smallest honest record that keeps the idea from evaporating without pretending it's a designed plan. Want me to add it?

## User

Pull and merge origin/main

## Assistant

Merged and pushed (`5c920d9`). Branch is now level with main (0 behind) and 7 ahead.

**Pulled in from main** (4 commits, PR #16): the Pages-deploy hardening — `pages.yml` now repeats the integrity checks so the deploy is gated on a verified bundle, plus `markdown.ex` link-href escaping and a new tutorial explaining the gate.

**Conflicts — both additive, resolved as unions:**
- `meta/tutorials/index.md` — this one was genuinely tangled: "What makes a commit…" had drifted to different positions on each side and appeared **twice** after the naive merge. I resolved to a clean, **deduplicated** list of all five tutorials (offline, verified-commit, bundle-scope, three-scanners, pages-gate).
- `meta/log.md` — kept both sides' 2026-07-09 entries (my flows/intake work + main's Pages-gate tutorial entry).

Everything else from main (`pages.yml`, `markdown.ex`, its test, `README.md`) auto-merged cleanly.

**Verification:** full gate suite green — format, `compile --warnings-as-errors`, `contract --check`, `registry --check`, `verify`, `route_tags`, 78 tests (74 + main's 4 new markdown tests), and `mix brain.site` (108 pages).

Still outstanding from before, if you want it: the one-line `future-beliefs` note recording that the flows genre generalizes to other tool pipelines (contract-render, site-build) — I left that pending your call.

## User

Do you see meta/plans?

## Assistant

No — there is no `meta/plans/`. The directories under `meta/` are: `flows`, `issues`, `policy`, `specs`, `threads`, `tutorials`.

Two things that might be behind the question:

- **The spec/plan genre I created is `meta/specs/`**, not `meta/plans/`. When you said "persist all spec/plans," I named the genre `specs` (the `persist-specs` policy and the `spec` type both use that word), and its scope is explicitly *both* — "design specs **and** implementation plans." So plans do have a home; it's just called `meta/specs/`. If you'd rather it be `meta/plans/` (or the type be `plan`), that's a rename I can do — say the word.
- **There is a `deprecated/plans/`** — nine archived legacy plan docs (`001`–`009`) under the read-only `deprecated/` archive. That's not part of the knowledge bundle and I don't touch it, but it's the only `plans` path in the repo.

Which did you mean — should the genre be renamed to `meta/plans/`, or were you pointing at the deprecated archive?

## User

Pull origin/main

## Assistant

Merged and pushed (`a3b05e6`); branch is level with main, 8 ahead. Conflicts were `log.md` (additive union) and the generated `meta/registry.md` (regenerated via `mix brain.registry` rather than hand-merged). Gates green — 78 tests, 111 site pages, and `contract --check` confirms the auto-merged `CLAUDE.md` matches the merged vocabulary.

**This is what your "Do you see meta/plans?" question was pointing at** — and it now creates a real collision I should flag rather than leave buried:

Main (PR #22) added a **`plan` type + `meta/plans/`** namespace. My branch earlier added a **`spec` type + `meta/specs/`**. After this merge, both coexist, and their definitions overlap heavily:

| | `spec` → `meta/specs/` (mine) | `plan` → `meta/plans/` (main) |
|---|---|---|
| Definition | "design spec or implementation plan… decisions, rationale, build order for a change to the brain's shape or tooling" | "intended work on the brain or its tooling: a design/decision record for a proposed change… motivation, shape, scope, open questions" |
| Status field | `draft/approved/superseded` | `proposed/accepted/in-progress/done/superseded` |
| Home | `meta/specs/` | `meta/plans/` |

Both are "a design/decision record for a proposed change to the brain/tooling." That's exactly the kind of near-duplicate genre the repo's own `update-in-place` / "don't fragment" ethos warns against — and now the controlled vocabulary carries two types for one concept. (Also note main added a third adjacent type this cycle, `methodology`, but that one is genuinely distinct — a repeatable how-to, not a one-off change record.)

I don't want to unilaterally collapse two operator-ratified genres, so this is a decision for you. Options:

1. **Merge into one** — pick `plan` **or** `spec` as the survivor, migrate the other's docs into it, retire the loser type, and reconcile the status vocab. (My flows spec would move, or the epistemic-overlay plan would.)
2. **Differentiate them sharply** — e.g. `spec` = *approved & designed, ready to build* vs `plan` = *proposed, not yet designed* — and rewrite both vocabulary entries so the boundary is one crisp sentence each. Only worth it if that distinction is real to you.
3. **Leave both** — accept the overlap.

My recommendation is **(1)**, collapsing to a single genre, since I can't state a boundary between them that isn't hair-splitting. Which survivor do you want — `plan`/`meta/plans/` or `spec`/`meta/specs/`?

## User

Agree, 1. Plans

## Assistant

The collapse is done and pushed (`1fb13ad`). `spec`/`meta/specs/` is fully retired; everything lives under `plan`/`meta/plans/` now.

**What changed:**
- **Doc moved** — `meta/specs/flows-genre-and-scenario-testing.md` → `meta/plans/flows-genre-and-scenario-testing.md`, retyped `spec`→`plan`, `status: approved`→`done` (it's built), title `Spec —`→`Plan —`, self-references reconciled. Git tracked it as a rename.
- **Type retired** — `spec` removed from the controlled vocabulary; `plan`, `issue`, `methodology` remain.
- **Policy renamed** — `persist-specs` → `persist-plans`, retargeted to `type: plan` / `meta/plans/` with the plan status vocab (`proposed/accepted/in-progress/done/superseded`).
- **Namespace removed** — `meta/specs/` (its `index.md`) deleted; `meta/index.md` specs row dropped (plans row from main stays).
- **Indexed** — the flows plan now sits under `meta/plans/index.md` → "Done / Superseded".
- **All references repointed** — flow docs, the two `SWE/testing/` `# Influence` back-links, the scanners tutorial's example, both scenario-test header comments, and the policy index. `CLAUDE.md` recompiled. Zero markdown links to `/meta/specs` remain anywhere.

**One deliberate call:** the earlier 2026-07-09 log entries that *narrate* creating `meta/specs/` are left as frozen history — their prose still says "spec," but I repointed the actual doc link in them to `/meta/plans/` so nothing 404s. I added a new log entry documenting the collapse itself.

**Verification:** full gate suite green — format, `contract --check`, `registry --check`, `verify`, `route_tags`, 78 tests, and `mix brain.site` (110 pages, down 1 from removing the `meta/specs/` index page).

The result: one design-record genre (`plan`), holding both the epistemic-overlay plan (`proposed`, from main) and the flows plan (`done`, mine).

## User

Commit and push

## Assistant

Nothing to commit or push — the working tree is clean and the branch is already in sync with the remote. The last commit, `1fb13ad` ("Collapse the spec genre into plan"), was committed and pushed in the previous turn (`0	0` = no divergence between local `HEAD` and `origin/claude/flows-paths-documentation-b6mzee`).

So you're fully up to date: everything through the spec→plan collapse is on the branch. Nothing pending.

## User

Anything to create a pr for?

## Assistant

No existing PR for this branch, and yes — there's a clean, self-contained feature set worth one. The branch is 9 commits ahead of `main` and 0 behind, all gates green.

**What a PR would contain** (net diff vs `main`, +1468/−382 across 25 files):

- **New `meta/flows/` genre** — per-flow "touch-sequence" docs: `session-capture.md` and `intake.md`, plus the genre `index.md`.
- **Two scenario tests** — `capture_scenario_test.exs` and `intake_scenario_test.exs`, pinning each flow's deterministic spine.
- **Collapsed** `meta/session-workflow.md` + `meta/verification-flows/` into the flow docs (both removed).
- **The flows plan** — `meta/plans/flows-genre-and-scenario-testing.md` (`status: done`), with the harness research spike folded in.
- **`persist-plans` policy** (the spec→plan genre-collapse landed here too) + `CLAUDE.md` recompiled.
- **Scanners tutorial** (`the-three-bundle-scanners.md`), **two `SWE/testing/` references** (the spike's sources, cross-linked to the plan), and the **`future-beliefs.md`** holding-pen note.

It's cohesive — essentially "add the flows genre + scenario testing, and reconcile the plan/spec genres."

I haven't opened it, since creating a PR needs your explicit go. Want me to create it against `main`? If so I'll check for a PR template and fill it in. Suggested title: **"Add the flows genre with scenario testing; unify plan/spec genres."** Any change to the title or base branch before I do?

## User

Merged

## Assistant

Confirmed — PR #23 is merged into `main` (`06b17ce`), and `git log origin/main..HEAD` is empty, so every commit from this branch is now on `main`. The flows genre, scenario tests, the docs collapse, and the plan/spec unification all landed.

Since the PR for `claude/flows-paths-documentation-b6mzee` is now merged, that branch is finished — I won't stack new commits on it. If you have follow-up work, I'll restart the branch fresh from the updated `main` (`git checkout -B claude/flows-paths-documentation-b6mzee origin/main`) and any new PR will be a genuinely new one.

Nothing outstanding on my end. The one still-open idea from earlier, if you ever want it: the `future-beliefs`/plans note about the flows genre generalizing to other tool pipelines (contract-render, site-build) — otherwise we're done here.

## Assistant

Session captured and pushed (`42044ef`).

**The thread** — `meta/threads/2026-07-09-flows-genre-and-scenario-testing.md`:
- **Parse-the-log render** from the host `.jsonl` (818 lines), so the retained text is mechanically exact — all **18 operator messages** and **22 agent turns** verbatim, with tool calls/results, reasoning, and `<300`-char pre-tool narration dropped, and the `/capture` slash-command wrapper stripped.
- **Eight-row routing ledger**, mostly `unrouted` — honestly reflecting that the session was overwhelmingly governance/tooling homed in `meta/` (matching the bootstrap-thread precedent). The one knowledge feed — the dependency-free-testing strand — routes to the ExUnit reference.
- **One route-tag region** (the research-spike verdict paragraph) feeding both `SWE/testing` captures `sb:f6e843` and `sb:b1ba4b`; their excerpt logs were materialized, giving a real tag→log round-trip.

**Reserved files** — threads index, `meta/log.md` (capture entry), and root `log.md` (the two references' excerpt logs changed) all updated.

**Verification** — `mix brain.route_tags` green (10 regions across 6 threads, 4 sink appends, fidelity clean), full gate suite green (78 tests, 111 site pages).

**Procedure notes:**
- Per the merged-PR rule, I **restarted the branch from `main`** before capturing (PR #23 was merged), so this capture sits on fresh history atop the merge — not stacked on the finished branch. Any PR opened for it would be a new PR.
- I pushed (not just committed) since this remote environment reclaims containers and the whole session's cadence has been commit+push. If you'd rather keep captures local until you say so, tell me and I'll hold the push next time.

## Assistant

Extended in place and pushed (`81b3f2b`).

This was an **extend-in-place**, not a new capture: the session already had its thread doc, so per the update-in-place rule I regenerated the same file (`meta/threads/2026-07-09-flows-genre-and-scenario-testing.md`) rather than forking a second one.

- **What changed:** re-parsed the now-longer host log (881 lines) → the render picked up **one new agent turn** (the previous `/capture`'s summary), which the drop rule keeps as a closing reply. Both `/capture` slash-commands stayed dropped. 18 operator messages, 23 agent turns, all verbatim.
- **What didn't:** same routing ledger, same single route-tag region (the research-spike verdict → `sb:f6e843`/`sb:b1ba4b`). The excerpt logs re-materialized **identically**, so the two `SWE/testing` references are untouched — the only file in the diff is the thread doc. No log/index changes were warranted (the existing capture entry still holds).
- **Verification:** `mix brain.route_tags` green, full gate suite green (78 tests).

The inherent tail limitation still applies — this capture can't include its own closing summary (not yet in the log); a future `/capture` would fold it in if you run one. Nothing else outstanding.
