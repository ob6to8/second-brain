# second-brain

A personal knowledge base stored as an
[Open Knowledge Format](/knowledge-management/open-knowledge-format.md)
(OKF v0.1) bundle — a directory of plain-markdown "concept" documents with YAML
frontmatter, designed to be read and extended by AI agents and humans alike.

## Layout

- **`index.md`** — bundle-root index; the entry point for navigation.
- **`log.md`** — chronological change history.
- **`CLAUDE.md`** — the operating contract every agent follows (OKF rules, filing
  conventions, `type` vocabulary, and the taxonomy-evolution protocol).
- **`.claude/skills/`** — skills. Start with **`/intake`** for capturing content.
- **`deprecated/`** — archived legacy content and tooling (read-only; not part of the
  knowledge bundle).

The knowledge taxonomy starts **blank** and grows **collaboratively**: the agent files
into existing directories on its own, but proposes any new directory for the operator
to ratify before creating it.

## Usage

From the Claude Code app, paste material after `/intake` to capture it into the brain.

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
push to `main`.

The workflow enables Pages automatically on its first run (via
`actions/configure-pages`) and gates the deploy on the same integrity checks CI
runs (`brain.verify` et al.), so only a valid, verified bundle is published. If
your organization restricts automatic enablement, set **Settings → Pages →
Source** to **GitHub Actions** once by hand.
