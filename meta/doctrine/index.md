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
- [The operator must be able to reconstruct a mental model of code they did not write](/meta/doctrine/comprehension-of-generated-code.md) — the comprehension precondition of the orchestrator's evaluation domain: hand-coding forced a mental model into existence as a side effect of building, but agent generation severs that coupling — code ships with zero operator comprehension unless the process deliberately produces it. The standing intention the capture/routing/tagging apparatus instrumentally serves (spatial *and* causal model, for two readers: the operator and the next stateless agent); scored against by the [localized-conversation analysis](/meta/analysis/localized-code-conversation-vs-linear-thread.md).
- [Intent is the source; artifacts are derived — and opacity is earned by the oracle](/meta/doctrine/intent-is-the-source.md) — the artifact-layer application of the orchestrator direction: the human-ratified layer is intent (policies, invariants, specs, tests), everything downstream — code included — is a derived, machine-checked artifact, and an artifact may become invisible to the operator only to the degree a mechanical oracle covers its behavior; generated code is held as a regenerable cache kept inspectable until the oracle earns its opacity. Judged against the dark-factory evidence in [what the dark-factory wave prices about intent-as-source](/meta/analysis/dark-factory-oracle-pricing-intent-as-source.md).
- [Regenerate the change, not the system](/meta/doctrine/regenerate-the-change-not-the-system.md) — the temporal companion to [intent-is-the-source](/meta/doctrine/intent-is-the-source.md): where that names the artifact's *status* and the oracle-opacity boundary, this names the *unit and dynamics* of regeneration over a living system's life — a specification selects an equivalence class of programs, not one program, so the unit of legitimate regeneration is the *change* and the existing artifact is a first-class input to it (never just its disposable output); pinning properties is choosing what may vary, and stability is itself load-bearing. Derived by the [natural-language compilation-target analysis](/meta/analysis/code-as-natural-language-compilation-target.md).
