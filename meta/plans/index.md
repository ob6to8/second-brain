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
- [Epistemic overlay: the four operations as a frontmatter-native graph over concepts](/meta/plans/epistemic-overlay.md) — promote the latent attestation/aggregation/inference/prescription structure to a first-class, queryable layer over existing concepts, with an integrity-checking `mix brain.graph`; explicitly bounds out atomization and strength-as-count. `status: proposed`.

## Accepted / In progress

- [Auto-intake featured /news items: move the human from the intake gate to the editorial surface](/meta/plans/auto-intake-featured-news.md) — automatically run `/intake` on the items `/news` already featured, relocating the operator's role from a pre-intake gate (judged artificial — you can't assess filing/dup until a thing is in the system) to post-intake editorial work; bounded to the known tree, preferring update-in-place on `relates to sb:` hints, tagged `auto-intake`. Sequenced **Fork A** (gated behind the dedup-recall-probe's tier-1 `/intake` fix). `status: accepted`.

## Done / Superseded

- [Code review toolchain hardening](/meta/plans/code-review-toolchain-hardening.md) — the 2026-07-11 top-down review + staleness audit (findings kept as background) and its executed hardening: two-directional `materialize` (orphan removal; issue resolved), verifier rule 6 gating `verified` to statement types, and the five-item hygiene batch — with an explicit out-of-scope list. `status: done`.
- [Retire the hand-kept chronological logs (log.md) in favor of git history](/meta/plans/retire-hand-kept-logs.md) — removed root `log.md`, `meta/log.md`, and `inbox/log.md` and every policy/skill mandate to maintain them; git's true-merge commit graph is the single provenance layer. The generated route-tagged excerpt logs stay. Filed, ratified, and executed same day. `status: done`.
- [The daily read: a cross-domain synthesis lede for /news digests](/meta/plans/news-daily-read-synthesis.md) — add a `## The read` section at the top of each digest: a short, `sb:`-id-grounded perspective reading the day's selections as a set against the brain's standing concerns, connecting threads across domains. Proposed, ratified, and implemented same session. `status: done`.
- [The flows genre + formal scenario testing](/meta/plans/flows-genre-and-scenario-testing.md) — establish a `meta/flows/` genre (per-flow touch-sequence docs) backed by ExUnit scenario tests over each flow's deterministic spine; collapse the capture docs and build the `session-capture` + `intake` flows. `status: done`.
