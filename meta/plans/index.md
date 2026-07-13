# Plans

Intended work on the brain or its tooling — design/decision records for proposed
changes, each capturing motivation, the shape of the change, scope boundaries, and
open questions so a future session can execute against something concrete. A separate
namespace from `issues` (problems to track) and `policy` (the rules that compile into
the contract).

Each plan is a `type: plan` doc carrying a `status` (`proposed` · `accepted` ·
`in-progress` · `done` · `superseded`). Superseded and done plans stay filed as a
record of what was decided and why.

## Proposed

- [Compile the contract's Skills section from SKILL.md frontmatter](/meta/plans/compile-skills-registry-from-skill-frontmatter.md) — **operator-designated top priority** (`priority: 1`, ranked by the session-init override PR #45 built). Invert the skills-registry drift: each `SKILL.md`'s frontmatter becomes the source of truth for contract §7, rendered by the compiler with the existing `--check` gate; the hand-kept skills-registry policy shrinks to a wrapper or retires. `status: proposed`.
- [Dedup recall probe: gold set + `mix brain.dedup_probe`](/meta/plans/dedup-recall-probe.md) — a zero-dependency, offline eval scoring the lexical search layer against an id-keyed gold set of natural-phrasing dedup queries (bands for negatives and quarantined cases, gold pairs harvested at intake, non-gating CI report); the quantified trigger for tier-2 embedding dedup and the substrate for later corpus-maintenance evals. `status: done` — instrument (gold set, task, tests, CI report, baseline) **and** the tier-1 `/intake` synonym-expansion + automated gold-harvest all shipped.
- [The belief layer: a `belief` type and a real /beliefs/ namespace](/meta/plans/belief-type-and-beliefs-namespace.md) — introduce a `belief` type for operator-held, value-laden decision priors (outside the verification ladder, citable like doctrine, parallel to it rather than beneath it) and make `/beliefs/` its actual home; adds the epistemic/teleological filing test to the vocabulary and explicitly bounds out a values type, confidence scores, and doctrine-widening. Actionable residue of the [second-mind taxonomy analysis](/meta/analysis/second-mind-taxonomy-and-the-belief-gap.md). `status: proposed`.
- [Epistemic overlay: the four operations as a frontmatter-native graph over concepts](/meta/plans/epistemic-overlay.md) — promote the latent attestation/aggregation/inference/prescription structure to a first-class, queryable layer over existing concepts, with an integrity-checking `mix brain.graph`; explicitly bounds out atomization and strength-as-count. `status: proposed`.

## Accepted / In progress

_(none yet)_

## Done / Superseded

- [Flow lineage: frontmatter provenance + a derived flowchart](/meta/plans/flow-lineage-index.md) — every flow doc carries a canonical `lineage:` frontmatter block (`analysis → plan → thread → PR`); `mix brain.lineage` materializes a per-doc blockquote and derives the cross-flow flowchart index [`meta/flows/lineage.md`](/meta/flows/lineage.md) (Mermaid + table), `--check`-gated in CI and the pre-commit hook. All eight flow docs retrofitted (feature lineage, not doc-authorship). The flow-scoped precursor of the epistemic-overlay's typed lineage edges. `status: done`.
- [Auto-intake featured /research items: move the human from the intake gate to the editorial surface](/meta/plans/auto-intake-featured-research.md) — auto-run `/intake` on the items `/research` featured, relocating the operator's role from a pre-intake gate (judged artificial — you can't assess filing/dup until a thing is in the system) to post-intake editorial work; bounded to the known tree, preferring update-in-place on `relates to sb:` hints, tagged `auto-intake`, deferring new-top-level-domain items. **Fork A** (gated behind PR #50's tier-1 `/intake` fix); shipped as the `/research` §6 step with flow-doc + policy mirror. `status: done`.
- [Code review toolchain hardening](/meta/plans/code-review-toolchain-hardening.md) — the 2026-07-11 top-down review + staleness audit (findings kept as background) and its executed hardening: two-directional `materialize` (orphan removal; issue resolved), verifier rule 6 gating `verified` to statement types, and the five-item hygiene batch — with an explicit out-of-scope list. `status: done`.
- [Retire the hand-kept chronological logs (log.md) in favor of git history](/meta/plans/retire-hand-kept-logs.md) — removed root `log.md`, `meta/log.md`, and `inbox/log.md` and every policy/skill mandate to maintain them; git's true-merge commit graph is the single provenance layer. The generated route-tagged excerpt logs stay. Filed, ratified, and executed same day. `status: done`.
- [The daily read: a cross-domain synthesis lede for /research digests](/meta/plans/research-daily-read-synthesis.md) — add a `## The read` section at the top of each digest: a short, `sb:`-id-grounded perspective reading the day's selections as a set against the brain's standing concerns, connecting threads across domains. Proposed, ratified, and implemented same session. `status: done`.
- [The flows genre + formal scenario testing](/meta/plans/flows-genre-and-scenario-testing.md) — establish a `meta/flows/` genre (per-flow touch-sequence docs) backed by ExUnit scenario tests over each flow's deterministic spine; collapse the capture docs and build the `session-capture` + `intake` flows. `status: done`.
