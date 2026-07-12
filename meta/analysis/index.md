# Analysis

Point-in-time evaluations and decision-support write-ups — a question investigated
against evidence (often the live bundle itself), yielding findings and a
recommendation, filed so the reasoning and its conclusion persist. A separate
namespace from `plans` (intended *work* to execute) and `issues` (problems to
track): an analysis is a *reasoned judgment on a question*.

Each analysis is a `type: analysis` doc.

## Contents

- [Should the brain add a wiki, and where do its docs fall short?](/meta/analysis/docs-surface-evaluation-and-wiki-question.md) — a full-surface docs audit (all gates green) recommending against a GitHub wiki — a second content store outside the enforcement stack, whose role the verified Pages site already fills — and locating the real gaps: a stale README, two index omissions, one broken policy-example link, and tutorial/flow coverage holes, tiered by action.
- [Would CB's four-typed DAG, as an overlay, stabilize this knowledge base against the failure chain?](/meta/analysis/cb-epistemic-overlay-as-failure-chain-stabilizer.md) — yes for cross-reference drift and trust collapse (both through supersession + staleness propagation), no for the dedup entry gate, conditional elsewhere; portable as a format, but enforcement and edge-authoring must stay host-native. Includes a source-staleness check that corrected two claims traced to CB's outdated thesis doc — itself a live demonstration of the drift failure mode.
- [Is the corpus-maintenance failure space rich content for evals?](/meta/analysis/eval-suitability-of-the-corpus-maintenance-failure-space.md) — yes: ground truth is constructible because the operator owns the corpus; maps each failure-chain stage to a measurable eval (dedup recall, fan-out completeness, filing consistency, capacity curves, longitudinal corpus-health) and decomposes the seven sources of fuzziness in "is this a duplicate" ground truth, each dictating a gold-set property.
- [How does this bundle compare to the 2026 second-brain field?](/meta/analysis/comparison-with-the-2026-second-brain-field.md) — a landscape survey (Obsidian/PARA influencer systems, Karpathy-pattern Claude Code vaults, PKM products) finds no public system combining this bundle's enforcement stack; models the five-stage failure chain that kills advisory systems past ~500 concepts, and names intake dedup recall as the one semantic gate this bundle's CI can't cover.
- [Would a vector DB improve recall as this bundle scales?](/meta/analysis/vector-db-recall-for-the-scaling-bundle.md) — a dedup-recall probe over the live corpus finds grep already misses existing concepts on natural-phrasing (semantic, not typographic) queries; recommends synonym-expanded intake dedup + a repeatable recall probe over any standalone vector DB.
