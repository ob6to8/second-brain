---
type: tutorial
title: The three bundle scanners — Registry, Verifier, and RouteTags
description: How the toolchain walks the repository — one base scanner (Registry.scan) that enumerates knowledge-bundle concepts through a directory-exclusion filter, and two consumers (the Verifier and RouteTags) that build on it, with RouteTags adding a second scan surface over meta/threads and bridging the governance and knowledge namespaces by stable id.
tags: [meta, tooling, elixir, registry, verifier, route-tags, scanning, architecture]
timestamp: 2026-07-09
---

# The three bundle scanners — Registry, Verifier, and RouteTags

Three of the `mix brain.*` tasks work by **walking the repository and reading
files**: the registry (`mix brain.registry`), the verifier (`mix brain.verify`),
and the route-tag checker (`mix brain.route_tags`). It is tempting to think of
them as three independent crawlers. They are not. There is **one** scanner —
[`SecondBrain.Registry.scan/1`](/lib/second_brain/registry.ex) — and the other
two are *consumers* of it. Understanding that hierarchy explains what each tool
sees, what it deliberately ignores, and why fixtures placed under `test/` are
invisible to all three.

## The shared foundation: `Registry.scan/1`

Everything starts here. `scan/1` answers one question — *what are the bundle's
concepts?* — and answers it the same way for every caller:

```elixir
def concept_paths(root \\ File.cwd!()) do
  root
  |> Path.join("**/*.md")
  |> Path.wildcard()          # every markdown file under root
  |> Enum.map(&Path.relative_to(&1, root))
  |> Enum.reject(&excluded?/1) # drop non-bundle paths
  |> Enum.sort()
end
```

Each surviving path is read, its YAML frontmatter parsed, and folded into an
`Entry` struct — `{id, concept_id, path, type, title, verified, resource,
verified_by}`. `scan/1` returns `{entries, errors}`, where `errors` collects two
failure classes: files whose frontmatter won't parse, and **duplicate ids**
(two concepts claiming the same `sb:` id). That is the whole scan: *wildcard →
exclude → parse → struct*, with duplicate-id detection folded in.

The scoping is the interesting part. The registry is the **stable-identity
layer**, and identity is a property of *knowledge-bundle concepts only* — not
governance, not tooling, not the archive. So `excluded?/1` drops any path whose
top-level directory or basename is on a fixed list:

| Excluded | Why it isn't a bundle concept |
|----------|-------------------------------|
| `.git` `.github` `.githooks` `_build` `deps` `tmp` | machinery, not knowledge |
| `.claude` | skills — agent behavior, not concepts |
| `lib` `test` | the Elixir toolchain (and its fixtures) |
| `meta` | governance namespace — policies, threads, tutorials, this file |
| `inbox` | the daily candidate feed — a non-bundle namespace with no `sb:` ids |
| `deprecated` | the read-only archive of legacy content |
| `index.md` `log.md` `README.md` `CLAUDE.md` | reserved/generated files, any level |

A path survives only if it is a real concept living at the root or in a
knowledge subdirectory. This single filter is what keeps the identity layer
scoped, and it is why a `type: plan` doc under `meta/plans/` or a fixture concept
under `test/scenarios/` never receives an `sb:` id or shows up in the registry —
they are structurally outside the scan.

`Registry` then adds the *compiled view* on top of the scan: `render/1` sorts the
id-bearing entries and emits `meta/registry.md`; `check/1` compares that render to
what's on disk and reports staleness. But the crawl underneath is `scan/1`.

## Scanner 2: the Verifier — same corpus, plus rules

[`SecondBrain.Verifier.run/1`](/lib/second_brain/verifier.ex) does **not** walk
the tree itself. Its first line delegates:

```elixir
{entries, scan_errors} = Registry.scan(root)
```

It inherits exactly the registry's corpus and exclusions, then layers rule checks
over each entry, accumulating human-readable error strings:

| Rule | What it enforces |
|------|------------------|
| **type** | every concept has a non-empty `type` (OKF conformance) |
| **id** | every concept carries an `id` matching `sb:[0-9a-f]{6}` |
| **edges** | every `verified_by` reference resolves to an existing id in the corpus |
| **grounding — capture** | a concept with a `resource` (a capture) may not be `verified: true` |
| **grounding — evidence** | `verified: true` requires a non-empty `verified_by` |

`run/1` returns `:ok` or `{:error, errors}` (the scan errors prepended). The
takeaway: the verifier is the registry's scan **plus a validation pass**. It adds
no new files to look at — it adds *judgments* about the files the registry
already found. This is why `mix brain.verify` never trips over a policy, a
thread, or a test fixture: none of them were ever in the corpus.

## Scanner 3: RouteTags — a second surface, bridged by id

[`SecondBrain.RouteTags.run_checks/1`](/lib/second_brain/route_tags.ex) is the
one that adds something genuinely new, because the route-tagging convention spans
**two namespaces the registry keeps apart**:

```elixir
threads  = scan_threads(root)              # NEW surface: meta/threads/*.md
concepts = bundle_concepts(root)           # reuses Registry.scan
id_index = Map.new(concepts, &{&1.id, &1.path})
sinks    = scan_sinks(root, concepts)      # excerpt logs inside concepts
```

- **`scan_threads/1`** globs `meta/threads/*.md` (minus `index.md`) and runs
  `parse_regions/1` over each to extract the `<routes ref="…">` tag regions.
  Note the directory: `meta/threads` is *excluded from the registry* — threads
  are governance records with no `sb:` id. The registry's own scan would never
  surface them, so RouteTags reaches into that namespace directly.
- **`bundle_concepts/1`** is just `Registry.scan(root)` keeping the id-bearing
  entries — the same base scanner again.
- **`scan_sinks/2`** reads each concept and pulls its
  `## Thread excerpts — route-tagged log` blocks via `parse_log_section/1`.

The bridge is the **stable id**. A tag in a governance-namespace thread
(`<routes ref="sb:d479e3">`) points at a knowledge-namespace concept via its
registry id. So RouteTags is the one scanner that joins the two namespaces — it
reads tags from files the registry excludes, and resolves them against the
identity layer the registry compiles. Its five checks (wellformedness, ref
resolution, sink logs, log fidelity, and the warn-level ledger cross-check) all
run off those three reads, and `materialize/1` writes each sink's log back from
the current tags so the log stays a derivation, never a hand-kept copy.

## How they compose

```
              Path.wildcard + exclusion filter + frontmatter parse
                              │
                    Registry.scan/1  ◄─────────────── the one crawler
                     /            \
            Verifier.run/1     RouteTags.run_checks/1
         (rules over the       (adds meta/threads as a
          same corpus)          second surface; joins the
                                two namespaces by id)
```

`Registry.scan/1` is the trunk; the verifier is a rule layer with no new inputs;
RouteTags is the only tool that opens a second door (into `meta/threads`) and
then walks back through the registry to resolve what it found.

## A practical consequence

Because all three ultimately gate on the same exclusion filter, **anything under
an excluded directory is invisible to the whole toolchain.** Put a markdown file
with a fabricated `sb:` id under `test/`, and `mix brain.registry`,
`mix brain.verify`, and `mix brain.route_tags` all sail past it: `test` is on the
exclusion list, the verifier scans through the registry, and RouteTags only reads
threads from `meta/threads`. That is precisely what makes on-disk scenario
fixtures safe — they can carry whatever frontmatter a realistic input needs
without colliding with the live identity layer.

## In one sentence

There is one bundle scanner — `Registry.scan/1`, a wildcard-plus-exclusion crawl
that enumerates knowledge concepts — and the verifier layers rules over its
output while RouteTags adds a second read over `meta/threads` and rejoins the two
namespaces by stable id; everything an excluded directory holds is, by
construction, beneath all three.
