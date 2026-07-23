---
type: policy
title: Elixir coding standards — the tooling holds the bundle's own bar
description: Coding conventions for the repo's Elixir tooling (lib/, test/, the mix brain.* tasks) and the admission rule for new guardrails — every standard with a mechanical oracle is a gate, the rest live here, and a recurring agent miss is fixed by updating this policy, never only the offending change.
section: tooling-standards
order: 1
status: active
tags: [meta, governance, elixir, coding-standards, guardrails, tooling, drift]
timestamp: 2026-07-23
attribution:
  when: 2026-07-23T00:00:00Z
  channel: agent-authored
  agent: "Claude Code agent, operator-directed session"
  why: "operator ratified absorbing the transferable coding standards and guardrails from the Zornek AI-drift/LocalCents intake into the contract"
  from: [/meta/threads/2026-07-23-ai-drift-intake-and-coding-standards-ratification.md]
---
**This contract is the coding-standards file.** The Elixir tooling (`lib/`,
`test/`, the `mix brain.*` tasks) is held to the same anti-drift bar as the
bundle it maintains: an agent reaches for whatever pattern it has already seen,
so yesterday's substandard addition becomes tomorrow's precedent unless a
standard announces the violation. The repo's answer is the one it applies to
knowledge: every standard with a **mechanical oracle** is a
[gate](/meta/tutorials/the-gate-suite-and-where-it-runs.md); standards without
one are written here. **A recurring agent miss is fixed by updating this policy
and recompiling the contract, never only in the offending change** — a miss
fixed only in-line is a miss re-fixed forever. (Absorbed from
[Guarding Against AI Drift](/knowledge/SWE/agentic/code-quality/guarding-against-ai-drift.md)
and the transferable half of
[Zornek's LocalCents standards](/knowledge/SWE/agentic/code-quality/elixir-coding-conventions-localcents.md).)

**The structural layer — build gates.** Warnings are non-negotiable in both
compilation and tests (`mix compile --warnings-as-errors`,
`mix test --warnings-as-errors`); source is canonically formatted
(`mix format --check-formatted`); and compile-time coupling between modules is
banned outright (`mix xref graph --label compile-connected --fail-above 0` —
the count is zero today and the gate keeps it there). CI additionally lints its
own workflow files with **actionlint**.

**Admission rule for new guardrails.** A check earns a gate when its **signal
beats its upkeep** *and* it runs offline as a plain `mix` task with no
dependencies (per
[why the toolchain runs offline](/meta/tutorials/why-the-toolchain-runs-offline.md)).
One carve-out: hygiene checks on CI's own configuration (actionlint) run
CI-only, since their subject exists only there. The **intentional gaps** are
deliberate, not oversights: no Credo, no Dialyzer, no Sobelow/mix_audit, no
CI-gated coverage — each would break the zero-dependency stance for signal the
small `lib/` doesn't yet warrant (and coverage stays exploratory, never a gate,
on the merits). Re-evaluate if the toolchain ever takes on dependencies or
`lib/` grows past what review holds.

**Conventions (editorial — no oracle, so hold the line in review):**

- **`@impl` names the behaviour; never `@impl true`.** Every `run/1` carries
  `@impl Mix.Task` (the codebase already conforms); a future behaviour callback
  names its behaviour the same way.
- **Name `@spec` arguments whose type doesn't reveal their role.** The test:
  can a reader tell what the argument is from its type alone? If not
  (`binary()`, `String.t()`, `integer()`, `map()`, `keyword()`, `term()`),
  write `name :: type`, matching the function's actual parameter name. Leave a
  self-describing domain type bare (`Policy.t()`, `DateTime.t()`) unless two of
  the same type sit side by side. When a spec wraps, stack one argument per
  line with the return type on its own line after `::`.
- **Moduledocs are load-bearing.** `mix brain.codemap` compiles
  [`meta/code-map.md`](/meta/code-map.md) from them, so a moduledoc is written
  summary-first and carries the *why*, not a restatement of the code; editing
  one means regenerating the code map (the freshness gate catches the miss).
- **Don't restate what a `@spec` already states.** `@doc` prose carries
  behavior and the *condition* under which each branch happens — named
  semantically ("a `:stale` result when the artifact lags its sources"), never
  a transcription of the return tuple.
- **Comments carry durable *why* and never restate the signature.** Future-work
  asides become `meta/todos/` or `meta/issues/` entries, not `TODO` comments.
- **Discard an ignored return with `_ = expr`** so the disinterest is explicit,
  never a bare dangling expression.
- **Test through the narrowest public surface** — a module's API or the mix
  task boundary — reaching into internals only for a guarantee the surface
  can't express; flows get scenario tests (see the
  [testing methodology](/knowledge/SWE/testing/elixir-mind-testing-methodology.md)).
