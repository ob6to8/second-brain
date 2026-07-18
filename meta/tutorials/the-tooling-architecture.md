---
type: tutorial
title: The tooling architecture — a grand tour of the mix brain.* pipeline
description: The spine that ties the toolchain together — how the elixir_mind modules form a parse → scan → generate → publish pipeline over the bundle's markdown, with a cross-cutting provenance layer and a thin mix brain.* CLI on top, and where each of the narrow tutorials and the generated code-map fit into that shape.
tags: [meta, tooling, elixir, architecture, pipeline, overview]
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T10:11:10Z
  channel: agent-authored
  agent: "Claude Code agent, code-tutorial-glossary session"
  why: "operator ratified a prose architecture tour of the tooling, complementing the generated code-map (code-tutorial-and-code-map plan)"
  from: [/meta/threads/2026-07-16-code-tutorial-and-generated-code-map.md]
---

# The tooling architecture — a grand tour of the `mix brain.*` pipeline

The `lib/` tree is a small (~6k-line), dependency-free Elixir toolchain that
sits **alongside** the knowledge bundle — it carries no `em:` id, the site
excludes it, and it exists to keep the bundle consistent as it grows. This
tutorial is the **spine**: it walks the whole toolchain end to end and places
every module, so the narrow tutorials (the three scanners, the gate suite, the
session-init digest, …) read as zoom-ins on one shape rather than nine
unrelated notes. For per-function and per-struct intent, the generated
[code map](/meta/code-map.md) is the reference; this is the story that connects
it.

## The shape: one pipeline, one data structure

Almost everything the toolchain does is a stage in a single pipeline over the
bundle's markdown:

```
   parse  ──▶  scan  ──▶  generate  ──▶  publish
   (read a       (enumerate    (compile        (render the
    doc into      + validate    checked-in      whole bundle
    frontmatter   the corpus)   artifacts)      to a site)
    + body)
```

and one data structure threads through all of it: a document parsed into
**`%{frontmatter: map, body: binary}`**. Get that shape in your head and the
rest is who consumes it and what they emit. A separate **provenance** layer
(attribution, lineage, dev-history) and a thin **CLI** wrap the pipeline; we
take those last.

## Stage 1 — Parse: two hand-rolled, offline parsers

Every stage downstream needs a document split into structured frontmatter plus
body text, and that split happens in exactly one place:
[`ElixirMind.Frontmatter.parse/1`](/lib/elixir_mind/frontmatter.ex). It splits a
raw document on the `---` delimiters and parses the frontmatter into a map,
returning `{:ok, %{frontmatter: map, body: binary}}`. Crucially it implements
only the **tiny YAML subset the bundle actually writes** — scalars, quoted
strings, inline `[a, b, c]` lists, and one level of nested block maps like
`attribution:` — rather than pulling in a YAML library.

Its sibling [`ElixirMind.Markdown`](/lib/elixir_mind/markdown.ex) is the same
bet on the render side: `to_html/2` turns a document body into an HTML fragment,
handling just the markdown vocabulary the bundle uses (ATX headings with
anchors, lists, fenced/inline code, tables, blockquotes, emphasis, links). Its
one clever job is **link rewriting** — bundle-absolute and relative `.md`
cross-links in a body become correct site-relative `.html` links at build time,
so authors write plain markdown and the site generator emits working links.

Both modules are deliberately dependency-free. That is not incidental: it is
what lets the whole toolchain run in any sandbox with no network — the subject
of [why the toolchain runs offline](/meta/tutorials/why-the-toolchain-runs-offline.md).

## Stage 2 — Scan: enumerate the corpus, then judge it

The scan stage answers *what are the bundle's concepts, and are they valid?*
There is **one** crawler —
[`ElixirMind.Registry.scan/1`](/lib/elixir_mind/registry.ex) (wildcard →
directory-exclusion → parse → `Entry` struct) — and the validators consume its
output rather than re-walking the tree. That trunk-and-consumers structure has
its own tutorial:
[the three bundle scanners](/meta/tutorials/the-three-bundle-scanners.md).

- **[`Registry`](/lib/elixir_mind/registry.ex)** is the stable-identity layer.
  Its `Entry` struct — `{id, concept_id, path, type, title, verified, resource,
  sense, attribution, verified_by}` — is the normalized in-memory view of one
  document that every other scanner reads.
- **[`Verifier.run/2`](/lib/elixir_mind/verifier.ex)** layers the bundle's
  semantic rules (OKF conformance, id well-formedness, `verified_by` resolution,
  verification grounding, glossary `sense`, attribution shape) over that corpus,
  returning `:ok | {:error, [messages]}`. It adds no new files — only judgments.
- **[`RouteTags`](/lib/elixir_mind/route_tags.ex)** opens a *second* surface
  (`meta/threads/`, which the registry excludes) and rejoins it to the identity
  layer by stable id — the mechanism behind the route-tagging convention.
- **[`Links`](/lib/elixir_mind/links.ex)** is the advisory scanner: it walks the
  raw tree (governance namespaces included) checking that internal links resolve
  and directories have an `index.md`, emitting **warnings that never fail** — per
  OKF's tolerant-consumer rule, link and index drift is surfaced, not gated.

## Stage 3 — Generate: compiled artifacts, checked for drift

This is the largest family, and it follows one discipline: **a file in the repo
is compiled from a source of truth, and a `--check` mode fails CI if the
checked-in copy drifts.** `CLAUDE.md` is the flagship — you are reading a
generated artifact — but the pattern repeats:

| Generated artifact | Compiled from | By |
|--------------------|---------------|-----|
| `CLAUDE.md` | `meta/preamble.md` + `meta/policy/*.md` | [`Contract`](/lib/elixir_mind/contract.ex) + [`Policy`](/lib/elixir_mind/policy.ex) |
| `meta/registry.md` | each concept's `id:` frontmatter | [`Registry`](/lib/elixir_mind/registry.ex) |
| `meta/code-map.md` | each `lib/` module's docstrings | [`CodeMap`](/lib/elixir_mind/code_map.ex) |
| per-concept excerpt logs | the current `<routes>` tags | [`RouteTags.materialize/1`](/lib/elixir_mind/route_tags.ex) |
| `meta/flows/*` lineage | each flow doc's `attribution.from` | [`Lineage`](/lib/elixir_mind/lineage.ex) |
| `meta/dev-history.md` | the first-parent merge graph | [`DevHistory`](/lib/elixir_mind/dev_history.ex) |

`Contract` depends on `Policy` (which turns each `meta/policy/*.md` into a
validated `%Policy{}` struct, failing fast on a malformed policy) for its parse
step, exactly as the scan validators depend on `Registry`. Each generator
exposes the same `render` / `write` / `check` trio, so wiring a new one into the
gates is mechanical — which is precisely how
[`CodeMap`](/lib/elixir_mind/code_map.ex), the newest member, was added: it
extracts module/function/type docs via `Code.fetch_docs/1` (standard library, so
it stays offline) and emits [the code map](/meta/code-map.md) this tutorial
points at. ([`DedupProbe`](/lib/elixir_mind/dedup_probe.ex) is a near relative —
it scores the intake search backend against a gold set and rewrites only that
doc's baseline table; it reports rather than gates.)

Every `--check` here is one of the CI gates catalogued in
[the gate suite](/meta/tutorials/the-gate-suite-and-where-it-runs.md).

## Stage 4 — Publish: render the whole bundle to a site

[`ElixirMind.Site.build/2`](/lib/elixir_mind/site.ex) is the terminal stage: it
loads every non-excluded `.md` as a `page` (via `Frontmatter` and `Markdown`),
builds an id index, reverse `verified_by` backlinks, and the directory nav tree,
then writes one HTML page per document plus a client-side search index and the
`.nojekyll` marker. It leans on two helpers:
[`Site.Assets`](/lib/elixir_mind/site/assets.ex) holds the CSS/JS as string
constants (so the site needs no build step or CDN), and
[`SiteConfig`](/lib/elixir_mind/site_config.ex) is the single source of truth for
the deploy — the base URL, the excluded directories, and the
bundle-path → live-URL mapping (`live_url/1`) that the response-resource-links
policy relies on.

The deploy is gated on the same integrity checks CI runs, for a reason that has
its own tutorial:
[gating the Pages deploy on a verified bundle](/meta/tutorials/gating-the-pages-deploy-on-a-verified-bundle.md).

## The cross-cutting layer — provenance and open work

Three modules don't sit *in* the pipeline so much as record facts *about* the
bundle and its history:

- **[`Attribution`](/lib/elixir_mind/attribution.ex)** defines and enforces the
  `attribution` ingestion-event record (the who/when/how/why a doc entered the
  brain), and exposes `list/2` as a query surface.
  **[`Attribution.Backfill`](/lib/elixir_mind/attribution/backfill.ex)** is the
  one-shot migration that reconstructed those records for pre-policy docs from
  git history — never inventing data.
- **[`Lineage`](/lib/elixir_mind/lineage.ex)** and
  **[`DevHistory`](/lib/elixir_mind/dev_history.ex)** are pure derivations: the
  first turns `attribution.from` edges into per-flow provenance views, the second
  turns the first-parent merge graph into a per-PR changelog. Both are
  generated-and-`--check`ed like the Stage 3 artifacts, but their *source of
  truth is history*, not the corpus.
- **[`SessionInit`](/lib/elixir_mind/session_init.ex)** is the read-only
  aggregator behind `/priorities`: it scans open issues, todos, active plans, and
  dangling routing-ledger strands into a ranked digest — detailed in
  [the session-init digest](/meta/tutorials/the-session-init-digest.md).

## The CLI surface — thin wrappers, one convention

The `mix brain.*` tasks under [`lib/mix/tasks/`](/lib/mix/tasks/) are the entry
points, and they are deliberately **thin**: each parses its flags and delegates
into the `ElixirMind.*` module that holds the logic. The convention is uniform —
a generator task is `mix brain.<thing>` to write and `mix brain.<thing> --check`
to verify — so the whole surface is learnable from one example. The handful with
real logic of their own (`brain.evidence` renders a verification narrative,
`brain.id` does collision-safe id minting with LF/CRLF-tolerant file surgery,
`brain.dev_history` guards against shallow clones) are the exceptions that prove
the rule. The [code map](/meta/code-map.md) lists every task and the module it
drives.

## How it composes

```
              Frontmatter.parse/1  ·  Markdown.to_html/2        ── Stage 1: parse
                            │
                    Registry.scan/1  ◄──────────────── the one crawler
                     /        │        \                          ── Stage 2: scan
            Verifier      RouteTags     Links (advisory)
                            │
   Contract/Policy · Registry view · CodeMap · RouteTags.materialize
        · Lineage · DevHistory · (DedupProbe baseline)            ── Stage 3: generate
                            │
                    Site.build/2  ·  Site.Assets  ·  SiteConfig   ── Stage 4: publish

   cross-cutting:  Attribution (+Backfill) · Lineage · DevHistory · SessionInit
   on top of all:  mix brain.*  — thin CLI wrappers, `[--check]` convention
```

## In one sentence

The toolchain is a four-stage pipeline — parse a document into frontmatter and
body, scan the corpus and validate it, compile drift-checked artifacts from
their sources of truth, and render the whole bundle to a static site — wrapped by
a provenance layer that records how each doc and commit got here and a thin
`mix brain.*` CLI, every module of which the [code map](/meta/code-map.md)
inventories and this spine places.
