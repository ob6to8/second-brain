# meta

Governance and tooling for the brain itself — a separate namespace from the knowledge
taxonomy. This is where the rules that compile into the operating contract live.

## Contents

- [analysis](/meta/analysis/index.md) — point-in-time evaluations and decision-support write-ups on questions about the brain (`type: analysis`)
- [dev-history.md](/meta/dev-history.md) — **generated** per-PR overview of development progress, derived from the merge graph (`mix brain.dev_history`)
- [doctrine](/meta/doctrine/index.md) — standing intention statements: guiding principles and directions the brain's design serves, which policies implement (`type: doctrine`)
- [elaborations](/meta/elaborations/index.md) — persisted expansions of technical phrases (`type: elaboration`, written by `/elaborate`; each back-links its originating thread via a `thread` field set by `/create-pull-request`)
- [evals](/meta/evals/index.md) — repeatable eval gold sets and their baselines: the fixtures a `mix brain.*` task re-scores on every run (distinct from a point-in-time `analysis`)
- [flows](/meta/flows/index.md) — per-flow connective docs: the file-by-file touch-sequence of a canonical run, tying together the skill, the CI-checked scenario, and the why (supersedes the old `session-workflow.md` guide + `verification-flows/`)
- [issues](/meta/issues/index.md) — tracked operational problems and open concerns about the brain's tooling/automation (`type: issue`, each with a `status`)
- [plans](/meta/plans/index.md) — design/decision records for proposed changes to the brain or its tooling (`type: plan`, each with a `status`)
- [policy](/meta/policy/index.md) — the `type: policy` rules that compile into `/CLAUDE.md`
- [preamble.md](/meta/preamble.md) — fixed framing text prepended to the compiled contract
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
  - `mix brain.dedup_probe [--expanded]` — score intake dedup recall: the lexical
    search backend vs the natural-phrasing gold set in `/meta/evals/dedup-probe.md`
    (`--expanded` scores synonym-expanded recall). Offline, deterministic, and
    non-gating (a report step in CI) — recall is an editorial trend metric.
  - `mix brain.session_init` — compile the session-start digest: open issues and
    todos, active plans, dangling ledger strands, and a heuristic top-3 priority
    ranking.
  - `mix brain.dev_history [--check]` — derive `/meta/dev-history.md` (per-PR
    features and progress) from the default branch's first-parent merge graph;
    `--check` is lag-tolerant (the checked-in copy cannot contain the merge that
    ships it) and the Pages build re-derives the page at deploy time.
  - `mix brain.site [--out DIR]` — render the bundle into a static, navigable site
    (deployed to GitHub Pages); see the [tutorials](/meta/tutorials/index.md).
- `.github/workflows/ci.yml` — CI enforcement on every push/PR: compile, format check,
  tests, `mix brain.contract --check`, `mix brain.registry --check`, `mix brain.verify`,
  `mix brain.route_tags`, `mix brain.lineage --check`, `mix brain.dev_history --check`,
  a non-gating `mix brain.dedup_probe` report, and a `mix brain.site` build (blocks a
  stale contract/registry or a broken build).
- `.github/workflows/pages.yml` — re-derives the dev history from the merge graph,
  builds `mix brain.site`, and deploys to GitHub Pages on every push to `main`.
- `.githooks/pre-commit` — optional fast local mirror of CI. Enable once with
  `git config core.hooksPath .githooks`.
- `.claude/hooks/session-start.sh` — installs Elixir in Claude-on-web sandboxes so the
  above works there too.
