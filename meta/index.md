# meta

Governance and tooling for the brain itself — a separate namespace from the knowledge
taxonomy. This is where the rules that compile into the operating contract live.

## Contents

- [analysis](/meta/analysis/index.md) — point-in-time evaluations and decision-support write-ups on questions about the brain (`type: analysis`)
- [flows](/meta/flows/index.md) — per-flow connective docs: the file-by-file touch-sequence of a canonical run, tying together the skill, the CI-checked scenario, and the why (supersedes the old `session-workflow.md` guide + `verification-flows/`)
- [issues](/meta/issues/index.md) — tracked operational problems and open concerns about the brain's tooling/automation (`type: issue`, each with a `status`)
- [plans](/meta/plans/index.md) — design/decision records for proposed changes to the brain or its tooling (`type: plan`, each with a `status`)
- [policy](/meta/policy/index.md) — the `type: policy` rules that compile into `/CLAUDE.md`
- [preamble.md](/meta/preamble.md) — fixed framing text prepended to the compiled contract
- [future-beliefs.md](/meta/future-beliefs.md) — a running scratch list of small, true observations about the tooling/governance worth formalizing later
- [registry.md](/meta/registry.md) — **generated** stable-id → concept view (`mix brain.registry`)
- [threads](/meta/threads/index.md) — archived operator–agent conversations (exchanges only)
- [todos](/meta/todos/index.md) — lightweight actionable task items (`type: todo`, each with a `status`)
- [tutorials](/meta/tutorials/index.md) — long-form explanatory notes on how the tooling and governance work

## Related tooling (not part of the knowledge bundle)

- `mix.exs`, `lib/`, `test/` — the Elixir toolchain:
  - `mix brain.contract [--check]` — compile `/CLAUDE.md` from preamble + policies.
  - `mix brain.id` — mint stable ids for bundle concepts that lack one.
  - `mix brain.registry [--check]` — compile `/meta/registry.md` (id → concept).
  - `mix brain.verify` — enforce conformance, id uniqueness/format, `verified_by`
    edge resolution, and grounding of every `verified: true`; on a green bundle,
    also print advisory docs-freshness warnings (unresolved internal links,
    index-coverage gaps) that never fail the gate.
  - `mix brain.evidence <sb:id|path>` — derive a concept's verification narrative
    (the prose is never committed; only the edges are).
  - `mix brain.route_tags [--materialize]` — verify `<routes ref="sb:…">` tags on
    threads and the excerpt logs they materialize into concepts (re-derives each
    log from the current tags and fails on divergence); `--materialize` writes the
    log sections from the tags.
  - `mix brain.session_init` — compile the session-start digest: open issues and
    todos, active plans, dangling ledger strands, and a heuristic top-3 priority
    ranking.
  - `mix brain.site [--out DIR]` — render the bundle into a static, navigable site
    (deployed to GitHub Pages); see the [tutorials](/meta/tutorials/index.md).
- `.github/workflows/ci.yml` — CI enforcement on every push/PR: compile, format check,
  tests, `mix brain.contract --check`, `mix brain.registry --check`, `mix brain.verify`,
  `mix brain.route_tags`, and a `mix brain.site` build (blocks a stale contract/registry
  or a broken build).
- `.github/workflows/pages.yml` — builds `mix brain.site` and deploys to GitHub Pages
  on every push to `main`.
- `.githooks/pre-commit` — optional fast local mirror of CI. Enable once with
  `git config core.hooksPath .githooks`.
- `.claude/hooks/session-start.sh` — installs Elixir in Claude-on-web sandboxes so the
  above works there too.
