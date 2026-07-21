---
type: reference
title: 2026-07-16-render-contract-invocation-and-auto-render
description: Operator questioned whether /render-contract is a failure-prone operator-invoked step and whether CLAUDE.md should auto-render on detected policy change; the agent showed the render is already a mix task and the staleness check already an unconditional CI + pre-commit gate that fails-don't-fix by design, then filed the judgment as an analysis doc.
provenance: "Claude Code session (claude-opus-4-8), 2026-07-16; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, contract, compiled-artifact, render-contract, ci, pre-commit, automation, analysis]
timestamp: 2026-07-16
session: https://claude.ai/code/session_018SKrCF2rgKpTiP87h3onAC
pr: 102
---

# 2026-07-16-render-contract-invocation-and-auto-render

## Where this landed

The session opened as a design question about the `/render-contract` skill: is it
meant to be operator-invoked, does that make it failure-prone, and would it be better
to auto-render `CLAUDE.md` as a mix task when an audit step detects a policy change?
The agent researched the wiring and answered that the premise conflates the skill with
the mechanism: the render is already the deterministic `mix brain.contract` task, its
staleness detection is already the unconditional `--check` gate in CI and pre-commit
(a stale `CLAUDE.md` cannot merge), and the gate deliberately fails-don't-fix to keep
CI a verifier and preserve the reviewable one-commit diff — so the manual step is not
failure-prone, the safety net being the gate, not the skill. The only sound automation
identified was an opt-in local pre-commit that renders-and-stages. On the operator's
request the judgment was filed as
[the render-contract-invocation analysis](/meta/analysis/render-contract-invocation-and-auto-render.md)
and the session closed with `/create-pull-request`.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Is /render-contract operator-invoked, is it failure-prone, and should CLAUDE.md auto-render on detected policy change? | closed | [render-contract-invocation-and-auto-render](/meta/analysis/render-contract-invocation-and-auto-render.md) | - |
| Opt-in local pre-commit that renders-and-stages CLAUDE.md (the one sound automation) | paused | [render-contract-invocation-and-auto-render](/meta/analysis/render-contract-invocation-and-auto-render.md) | File as issue/todo if the manual round-trip friction actually recurs |

## User

See the /render-contract skill. Is this meant to be invoked by the operator? Seems failure-prone. Possibly better to be invoked automatically as a mix task when the test suite/CI/or wherever the audit step is determines that a policy was modified?

## Assistant

<routes ref="/meta/analysis/render-contract-invocation-and-auto-render.md">
Good question, and I think the premise is slightly off in a way worth untangling — because most of what you're proposing already exists.

## The rendering is already a mix task

The skill isn't the compiler. `mix brain.contract` is — a pure, deterministic mix task in `lib/mix/tasks/brain.contract.ex` with two modes:

- `mix brain.contract` → re-render and write `CLAUDE.md`
- `mix brain.contract --check` → re-render and byte-diff, non-zero exit on drift

`/render-contract` is a thin **procedural wrapper** around that task. It exists to tell the agent *when* to run it and to bundle the governance around it (update `meta/policy/index.md`, commit source + artifact in one commit, flag shape-changes for operator ratification). It's not where the work happens.

## It's agent-executed, not operator-invoked

The flow doc is explicit ([`meta/flows/render-contract.md:119`](meta/flows/render-contract.md)): the flow is **agent-executed**; the operator's only parts are *ratify shape-changing rules* and *review the rendered diff*. So the normal path is already: same session edits a policy → same agent runs the task. The operator typing `/render-contract` is the exception (e.g., recovering after `--check` reports staleness), not the design.

## The detection is already automated — and it fails on purpose

Your "when the audit step determines a policy was modified" is `mix brain.contract --check`, and it's already wired into both gates, unconditionally:

- `.github/workflows/ci.yml:32` — "CLAUDE.md is compiled and current"
- `.githooks/pre-commit:14` — same check

It doesn't even need to *detect* a policy edit — it always re-renders from source and byte-compares. So a stale `CLAUDE.md` **cannot merge**: CI and pre-commit both fail. The "agent edits a policy, forgets to recompile" failure you're worried about is exactly the case the scenario test pins as `{:stale, _}` ([`contract_scenario_test.exs`](test/elixir_mind/contract_scenario_test.exs)).

## So the real question is: should the gate auto-fix instead of fail?

That's the substantive design choice, and the repo deliberately chose fail-don't-fix. Three reasons, all from the invariants in the flow doc:

1. **CI must stay a verifier, not a writer.** An auto-render step in CI would have to commit `CLAUDE.md` back to the branch — mutating history mid-review. That breaks the "source and artifact ship together in one commit" invariant and removes the diff the operator is supposed to review in the PR.
2. **The operator reviews the rendered diff.** That's a named actor boundary. Silent regeneration erases the thing being reviewed.
3. **Drift is structural, not procedural** — the whole point of the byte-diff is to be a complete oracle. A gate that fixes what it finds can't also prove nothing was wrong.

## Where your instinct *does* land

The one place auto-render fits cleanly is an **opt-in local pre-commit that renders-and-`git add`s** instead of failing. That's a convenience win — you'd never hand-commit a stale artifact. But it's local-only (pre-commit runs only if you set `core.hooksPath .githooks`), so it changes ergonomics, not the safety guarantee, and it trades away the "review `git diff CLAUDE.md` before committing" habit. CI still has to stay check-only.

**My take:** the current split is sound and not failure-prone — render is a mix task, detection is automated and unconditional, and the fail-don't-fix gate is a deliberate consequence of the generated-artifact discipline. If the manual round-trip annoys you in practice, the right-sized change is a local auto-render pre-commit, not moving rendering into CI. Want me to file that as a `type: issue` (or `todo`) so it's tracked rather than lost in chat?
</routes>

## User

Create an analysis doc and persist

Commit and push

/create-pull-request

## User

Continue from where you left off.

Proceed

*The session closed here: the operator invoked `/create-pull-request`, whose `/capture` step produced this thread doc.*
