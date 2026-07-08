# meta

Governance and tooling for the brain itself — a separate namespace from the knowledge
taxonomy. This is where the rules that compile into the operating contract live.

## Contents

- [policy](/meta/policy/index.md) — the `type: policy` rules that compile into `/CLAUDE.md`
- [preamble.md](/meta/preamble.md) — fixed framing text prepended to the compiled contract
- [registry.md](/meta/registry.md) — **generated** stable-id → concept view (`mix brain.registry`)
- [threads](/meta/threads/index.md) — archived operator–agent conversations (exchanges only)

## Related tooling (not part of the knowledge bundle)

- `mix.exs`, `lib/`, `test/` — the Elixir toolchain:
  - `mix brain.contract [--check]` — compile `/CLAUDE.md` from preamble + policies.
  - `mix brain.id` — mint stable ids for bundle concepts that lack one.
  - `mix brain.registry [--check]` — compile `/meta/registry.md` (id → concept).
  - `mix brain.verify` — enforce conformance, id uniqueness/format, `verified_by`
    edge resolution, and grounding of every `verified: true`.
  - `mix brain.evidence <sb:id|path>` — derive a concept's verification narrative
    (the prose is never committed; only the edges are).
  - `mix brain.route_tags [--materialize]` — verify `<routes ref="sb:…">` tags on
    threads and the excerpt logs they materialize into concepts (re-derives each
    log from the current tags and fails on divergence); `--materialize` writes the
    log sections from the tags.
- `.github/workflows/ci.yml` — CI enforcement on every push/PR: compile, format check,
  tests, `mix brain.contract --check` (blocks a stale or hand-edited `CLAUDE.md`),
  `mix brain.verify`, and `mix brain.route_tags`.
- `.githooks/pre-commit` — optional fast local mirror of CI. Enable once with
  `git config core.hooksPath .githooks`.
- `.claude/hooks/session-start.sh` — installs Elixir in Claude-on-web sandboxes so the
  above works there too.
