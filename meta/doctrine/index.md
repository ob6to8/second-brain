# Doctrine

Standing **intention statements** — guiding principles and directions that shape how
the brain and its agents are designed and prioritized. Doctrine is the *why* that
informs judgment; a [`policy`](/meta/policy/index.md) implements doctrine as a
concrete, enforceable rule, and plans, analyses, and priority rankings may cite a
doctrine as the direction they serve. A separate namespace from `policy` (enforceable
*rules*) and `analysis` (reasoned judgments on questions): a doctrine is a *standing
direction*.

Each doctrine is a `type: doctrine` doc (governance namespace — no `em:` id).

## Contents

- [The engineer as orchestrator, not implementer](/meta/doctrine/engineer-as-orchestrator.md) — the brain's founding direction, quoted from Anthropic's 2026 coding-trends report: the human's value has shifted to system architecture design, agent coordination, quality evaluation, and strategic problem decomposition; scored against by the [orchestrator-role alignment analysis](/meta/analysis/alignment-with-the-orchestrator-role.md).
- [Capability-matched model selection](/meta/doctrine/capability-matched-model-selection.md) — the model-layer application of the orchestrator direction: concentrate the strongest models where output becomes canonical, a judgment is rendered, or errors are silent; delegate derivational, oracle-checked, and high-volume motions to cheaper tiers. Selection is a runtime act enforceable only through its attribution shadow (provenance naming the producing model — a possible future policy).
- [Intent is the source; artifacts are derived — and opacity is earned by the oracle](/meta/doctrine/intent-is-the-source.md) — the artifact-layer application of the orchestrator direction: the human-ratified layer is intent (policies, invariants, specs, tests), everything downstream — code included — is a derived, machine-checked artifact, and an artifact may become invisible to the operator only to the degree a mechanical oracle covers its behavior; generated code is held as a regenerable cache kept inspectable until the oracle earns its opacity. Judged against the dark-factory evidence in [what the dark-factory wave prices about intent-as-source](/meta/analysis/dark-factory-oracle-pricing-intent-as-source.md).
