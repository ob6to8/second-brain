# elixir-mind

A personal knowledge base stored as an
[Open Knowledge Format](/knowledge/knowledge-management/open-knowledge-format.md)
(OKF v0.1) bundle — a directory of plain-markdown "concept" documents with YAML
frontmatter, designed to be read and extended by AI agents and humans alike.

## Layout

- **`index.md`** — bundle-root index; the entry point for navigation. Every
  directory carries its own `index.md` (progressive disclosure) — the tree *is*
  the taxonomy.
- **`CLAUDE.md`** — the operating contract every agent follows (OKF rules, filing
  conventions, `type` vocabulary, and the taxonomy-evolution protocol). A
  **generated artifact**, compiled from `meta/policy/` by `mix brain.contract`.
- **`meta/`** — governance namespace: the source policies, plans, issues, todos,
  analyses, tutorials, flow docs, archived session threads, and the generated
  stable-id registry. See [`meta/index.md`](/meta/index.md).
- **`glossary/`** — one concept file per technical term used across the brain,
  with citations; accreted by `/add-to-glossary` (hub: [`glossary.md`](/beliefs/glossary.md)).
- **`inbox/`** — the daily candidate feed written by `/research` (a non-bundle
  namespace: candidates awaiting `/intake`, not concepts).
- **`.claude/skills/`** — skills. Start with **`/intake`** for capturing content.
- **`deprecated/`** — archived legacy content and tooling (read-only; not part of
  the knowledge bundle).

There are no `log.md` files: git's commit history is the change record, and every
merge is a true merge so cited commits stay reachable.

The knowledge taxonomy starts **blank** and grows **collaboratively**: the agent files
into existing directories on its own, but proposes any new directory for the operator
to ratify before creating it.

## Usage

From the Claude Code app, paste material after `/intake` to capture it into the brain.
Run `/priorities` for an open-work appraisal — `mix brain.session_init` compiles a
digest of open issues, todos, active plans, and dangling thread strands, ending in a
heuristic top-3 the agent refines. The `/issue`, `/plan`, and `/todo` skills list the
open artifacts of each type.

## Integrity gates

CI runs the full gate suite on every push and PR: compile, format, tests, contract
freshness (`mix brain.contract --check`), registry freshness (`mix brain.registry
--check`), bundle verification (`mix brain.verify` — ids, evidence edges,
grounding), route-tag verification (`mix brain.route_tags`), and a site build.
A local mirror is available as an opt-in pre-commit hook
(`git config core.hooksPath .githooks`).

## Website

The bundle is published as a navigable knowledge base at **GitHub Pages**. A
dependency-free Elixir generator renders every concept into a static HTML site — a
sidebar mirroring the directory taxonomy, per-concept metadata panels (type, tags,
verification status, evidence edges and their reverse backlinks), and client-side
search — with all links relative so it works at any base path.

```sh
mix brain.site            # build into _site/
mix brain.site --out DIR  # build into a custom directory
```

Open `_site/index.html` (serve over HTTP — e.g. `python3 -m http.server -d _site`
— so client-side search can load its index). The site is not committed; it is built
and deployed by [`.github/workflows/pages.yml`](.github/workflows/pages.yml) on every
push to `main`, gated on the same integrity checks CI runs, so only a valid,
verified bundle is published.

The workflow enables Pages automatically on its first run (via
`actions/configure-pages`). If your organization restricts automatic enablement,
set **Settings → Pages → Source** to **GitHub Actions** once by hand.
