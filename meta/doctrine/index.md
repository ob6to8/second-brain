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
- [Regenerate the change, not the system](/meta/doctrine/regenerate-the-change-not-the-system.md) — how agents should treat any rebuild of code or generated artifacts: a specification selects an equivalence class of programs, not one program, so the unit of legitimate regeneration is the *change* and the existing artifact is a first-class input to it (never just its disposable output); pinning properties is choosing what may vary, and stability is itself load-bearing. Derived by the [natural-language compilation-target analysis](/meta/analysis/code-as-natural-language-compilation-target.md).
