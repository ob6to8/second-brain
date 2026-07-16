---
type: analysis
title: "Should /render-contract be operator-invoked, or auto-rendered when a policy changes?"
description: An examination of how CLAUDE.md compilation is wired finds the render is already a deterministic mix task, its staleness detection is already automated and unconditional as the CI + pre-commit --check gate, and the gate deliberately fails-don't-fix to keep source and artifact in one reviewable commit; the skill is a procedural wrapper, not the safety mechanism, and the only sound automation is an opt-in local pre-commit that renders-and-stages — CI must stay a verifier, never a writer.
provenance: "Claude Code session (2026-07-16) — operator questioned whether /render-contract is failure-prone as an operator-invoked step and whether it should auto-render on detected policy change"
tags: [meta, analysis, contract, compiled-artifact, render-contract, ci, pre-commit, automation]
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T10:33:35Z
  channel: agent-authored
  agent: "Claude Code agent, operator dialogue on the render-contract-invocation branch"
  why: "operator asked whether /render-contract is meant to be operator-invoked and whether auto-rendering on policy change would be less failure-prone"
  from: [/meta/threads/2026-07-16-render-contract-invocation-and-auto-render.md]
---

# Should /render-contract be operator-invoked, or auto-rendered when a policy changes?

**Question.** The operator observed that `/render-contract` — invoked to recompile
`CLAUDE.md` after a policy edit — "seems failure-prone" as a manual step, and asked
whether it would be better invoked **automatically as a mix task** when the test
suite / CI / audit step determines a policy was modified. Does the manual invocation
carry a real drift risk, and is auto-rendering the right fix?

## Evidence: what is already automated

The premise conflates the skill with the mechanism. Three facts from the current
wiring:

1. **The render is already a mix task.** `/render-contract` is not the compiler —
   [`mix brain.contract`](/lib/mix/tasks/brain.contract.ex) is, a pure deterministic
   task with two modes: bare (`write` → recompile `CLAUDE.md`) and `--check`
   (re-render + byte-diff, non-zero exit on drift). The
   [skill](/.claude/skills/render-contract/SKILL.md) is a thin **procedural wrapper**:
   it tells the agent *when* to run the task and bundles the governance around it
   (update [`meta/policy/index.md`](/meta/policy/index.md), commit source + artifact
   in one commit, flag shape-changes for operator ratification).

2. **It is agent-executed, not operator-invoked.** The
   [flow doc](/meta/flows/render-contract.md) is explicit: the flow is
   *agent-executed*; the operator's only parts are *ratify shape-changing rules* and
   *review the rendered diff*. The normal path is already "same session that edits a
   policy runs the task." An operator typing `/render-contract` is the recovery
   exception, not the design.

3. **The detection is already automated — and unconditional.** The proposed "audit
   step that determines a policy was modified" is `mix brain.contract --check`, wired
   into **both** gates: [`.github/workflows/ci.yml`](/.github/workflows/ci.yml) and
   the [`.githooks/pre-commit`](/.githooks/pre-commit) hook. It does not need to
   *detect* an edit — it always re-renders from source and byte-compares. A stale
   `CLAUDE.md` therefore **cannot merge**: CI and pre-commit both fail. The
   forgotten-recompile case is exactly the `{:stale, _}` guardrail pinned by
   [`contract_scenario_test.exs`](/test/elixir_mind/contract_scenario_test.exs).

## Findings

1. **The drift risk the question worries about is already closed structurally.** The
   safety net is the `--check` gate, not the skill. "Agent edits a policy, forgets to
   recompile" fails CI and pre-commit; it is un-mergeable. The skill reduces the
   friction of the round-trip but is not what makes drift safe — the gate is. So the
   manual step is *not* failure-prone in the sense of letting bad state land.

2. **The real design question is fail-don't-fix vs. auto-fix**, and the bundle chose
   fail-don't-fix deliberately, for three reasons drawn from the flow's invariants:
   - **CI must stay a verifier, not a writer.** Auto-rendering in CI would have to
     commit `CLAUDE.md` back to the branch — mutating history mid-review and breaking
     the "source and artifact ship together in one commit" invariant.
   - **The operator reviews the rendered diff.** That is a named actor boundary
     (operator "reviews the rendered `CLAUDE.md` diff in the PR"). Silent
     regeneration erases the artifact being reviewed.
   - **Drift is structural, not procedural.** The byte-diff is meant to be a
     *complete oracle*; a gate that repairs what it finds can no longer prove nothing
     was wrong.

3. **The instinct does land in exactly one place: an opt-in local pre-commit that
   renders-and-`git add`s** instead of failing. That removes the "hand-commit a stale
   artifact" friction without changing any safety guarantee — pre-commit is local-only
   (runs only when `core.hooksPath .githooks` is set), so it is ergonomics, not
   enforcement. But it trades away the "review `git diff CLAUDE.md` before committing"
   habit, and it cannot replace the CI check, which must stay check-only.

## Recommendation

Keep the render an explicit mix task and keep the `--check` gate as the automated,
unconditional, fail-don't-fix detector — the current split is sound and not
failure-prone. Do **not** move rendering into CI (it would make CI a writer and
destroy the reviewable one-commit diff). If the manual round-trip proves annoying in
practice, the right-sized change is an **opt-in local pre-commit auto-render + stage**,
tracked as an `issue`/`todo` rather than a redesign of the gate. This analysis is that
tracking record until such friction actually recurs.
