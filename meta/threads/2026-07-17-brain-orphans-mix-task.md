---
type: reference
title: 2026-07-17-brain-orphans-mix-task
description: Started as a walkthrough of iex/mix commands for exploring the bundle (Registry.scan, Frontmatter.parse!, the brain.* tasks), corrected two shape errors live, then built and registered a new mix brain.orphans task that lists docs with no inbound internal link.
provenance: "Claude Code session (claude-opus-4-8), 2026-07-17; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, tooling, mix-task, links, iex, elixir]
timestamp: 2026-07-17
pr: 106
---

# 2026-07-17-brain-orphans-mix-task

## Where this landed

The operator opened by asking what iex/mix commands are useful for exploring
this repo. That produced a tour of the `mix brain.*` tasks and the
`ElixirMind.*` modules callable from `iex -S mix` — with two live corrections
when the first aggregation examples were wrong: `Registry.scan/0` returns a
`{entries, errors}` **tuple** (not a list), and each `Entry` carries **flattened
atom fields** (`.type`, `.title`, `.verified`, …), not a `.frontmatter` map
(that map comes from `Frontmatter.parse!/1`, string-keyed). A short Elixir-
semantics aside clarified underscore-prefixed pattern bindings (`_errors` is
bound and readable, the underscore only suppresses the unused-variable warning).

The operator then asked for a query finding docs with no inbound links, which
graduated into a request to make it a real task. The result: **`mix
brain.orphans`** — a read-only advisory task listing docs nothing else links to.
The logic lives in `ElixirMind.Orphans` (`find/2`), reusing `Links.internal_targets/1`
and a newly-extracted `Links.resolve_target/2` so the orphan finder and the
link-resolution check share one extraction/normalization path and can't drift.
Two deliberate scoping defaults keep the output meaningful: `index.md` listings
don't count as inbound links (every filed doc is listed in one), and the
anchored-by-design namespaces `meta/threads/` and `inbox/` are excluded from
candidates (`--include-index` and `--all` widen each). On the real bundle the
default reports **zero orphans**; `--all` surfaces the ten expected thread/inbox
docs. Registered in `meta/index.md`'s grouped tooling listing (sibling to
`brain.evidence`) and discoverable via `mix help brain.orphans`. Five tmp_dir
tests added; full suite green (177), all local CI gates pass.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| iex/mix commands for exploring the bundle | closed | [meta/index.md](/meta/index.md) | - |
| `Registry.scan/0` returns a tuple of structs, not a list of frontmatter maps | closed | [lib/elixir_mind/registry.ex](/lib/elixir_mind/registry.ex) | - |
| Underscore-prefixed pattern bindings are bound-but-warn, not discarded | closed | `unrouted` | - |
| `mix brain.orphans` — orphan-doc query task | closed | [lib/elixir_mind/orphans.ex](/lib/elixir_mind/orphans.ex) | - |
| Reusing `Links` extraction/normalization to avoid drift | closed | [lib/elixir_mind/links.ex](/lib/elixir_mind/links.ex) | - |

## User

what are some commands i could run in iex related to this repo, ie. mix tasks, maybe viewing meta-data of an entry, or aggregating entries or something?

## Assistant

Here's a solid toolkit. There are two layers: **`mix brain.*` tasks** (CLI, run from the shell) and **the `ElixirMind.*` modules** (call directly from `iex -S mix`).

### Mix tasks (run in the shell)

These are the maintained entrypoints — most are also wired into CI/pre-commit:

| Command | What it does |
|---|---|
| `mix brain.verify` | Full bundle check: OKF conformance, stable ids, `verified_by` edges |
| `mix brain.session_init` | Digest of open issues, todos, active plans, dangling strands, top-3 (this is what `/priorities` runs) |
| `mix brain.registry` | Recompile `meta/registry.md` (id → path); `--check` to verify it's fresh |
| `mix brain.evidence <em:id>` | Print the verification narrative for a concept from its `verified_by` edges |
| `mix brain.attribution` | Query the attribution layer; `--backfill` reconstructs missing events from git |
| `mix brain.lineage` | Flow-doc lineage (analysis → plan → thread → PR) + flowchart index |
| `mix brain.url <path>` | Map a bundle path to its live Pages URL |
| `mix brain.route_tags` | Verify route tags + per-doc excerpt logs; `--materialize` rewrites them |
| `mix brain.glossary` | Check glossary single-overview convention |
| `mix brain.id` | Mint `em:` ids for docs missing one |
| `mix brain.codemap` / `mix brain.dev_history` | Compile `meta/code-map.md` / `meta/dev-history.md` |
| `mix brain.dedup_probe` | Score intake dedup recall against a gold set |
| `mix brain.contract` | Recompile `CLAUDE.md` from policies (`--check` for staleness) |

Run `mix help brain.verify` etc. for flags on any of them.

### iex (`iex -S mix`) — interactive exploration

The mix tasks are thin wrappers over these modules, so you can call them directly and inspect the returned data structures — this is where your "view metadata / aggregate entries" ideas live.

**Parse one doc's frontmatter + body:**
```elixir
{fm, body} = ElixirMind.Frontmatter.parse!(File.read!("areas/health.md"))
fm["type"]      # => "area"
fm["id"]        # => "em:..."
```

**Scan the whole bundle (the aggregation workhorse):**
```elixir
entries = ElixirMind.Registry.scan()   # every bundle doc w/ id + path + frontmatter

# aggregate: count documents by type
entries |> Enum.frequencies_by(& &1.frontmatter["type"])

# find every unverified claim
entries
|> Enum.filter(&(&1.frontmatter["type"] == "claim" and &1.frontmatter["verified"] != true))
|> Enum.map(& &1.path)

# id -> path map
ElixirMind.Registry.index!()
```

**Run the verifier and inspect results as data (not just exit code):**
```elixir
ElixirMind.Verifier.run()
ElixirMind.Links.check()          # broken cross-links
ElixirMind.Glossary.run_checks()
ElixirMind.RouteTags.run_checks()
```

**Attribution / provenance queries:**
```elixir
ElixirMind.Attribution.list()                     # every ingestion event
ElixirMind.Attribution.list(File.cwd!(), channel: "auto-intake")
```

**Site URL mapping:**
```elixir
ElixirMind.SiteConfig.live_url("areas/health.md")
```

One caveat on exact return shapes (map keys vs struct fields): I read the function signatures, not every return value — if a field name doesn't match, `i result` or `IO.inspect(result, structs: false)` in iex will show you the real shape. Want me to verify the shape of `Registry.scan/0` specifically, or write a small aggregation you have in mind (e.g. "all docs by directory" or "orphaned docs with no inbound links")?

## User

iex(7)> entries |> Enum.frequencies_by(& &1.frontmatter["type"])
** (Protocol.UndefinedError) protocol Enumerable not implemented for type Tuple. This protocol is implemented for the following type(s): Date.Range, File.Stream, Function, GenEvent.Stream, HashDict, HashSet, IO.Stream, List, Map, MapSet, Range, Stream

## Assistant

That explains both errors — `scan/0` returns a `{entries, errors}` tuple, and each `Entry` has flattened fields (`.type`, `.title`, `.verified`…), **not** a `.frontmatter` map. My earlier example was wrong on both counts. Corrected:

```elixir
{entries, _errors} = ElixirMind.Registry.scan()

# count documents by type
entries |> Enum.frequencies_by(& &1.type)

# every unverified claim
entries
|> Enum.filter(&(&1.type == "claim" and &1.verified != true))
|> Enum.map(& &1.path)

# peek at one entry's full shape
entries |> hd() |> IO.inspect()
```

`Entry` fields available: `:id` (em:id), `:concept_id`, `:path`, `:type`, `:title`, `:verified`, `:resource`, `:sense`, `:attribution`, `:verified_by`.

If you want the **raw frontmatter map** for a doc (all keys, including arbitrary extras), that's `Frontmatter.parse!/1`, which does return `{map, body}`:

```elixir
{fm, _body} = ElixirMind.Frontmatter.parse!(File.read!("areas/health.md"))
fm["type"]   # string-keyed map here
```

So: `Registry.scan/0` → structs with atom fields; `Frontmatter.parse!/1` → string-keyed map. Handy combined aggregation — group doc paths by directory:

```elixir
{entries, _} = ElixirMind.Registry.scan()
entries
|> Enum.group_by(&(&1.path |> Path.dirname()))
|> Enum.map(fn {dir, es} -> {dir, length(es)} end)
|> Enum.sort()
```

## User

after
{entries, _errors} = ElixirMind.Registry.scan()
is this destructuring {entries, _errors}? is that a tuple? does ElixirMind.Registry.scan return a tuple? should i be able to access _errors in iex or is that only if errors are returned?

## Assistant

Yes to all three, with one gotcha on the last.

**Is `{entries, _errors}` destructuring?** Yes. This is pattern matching. The left side `{entries, _errors}` is a tuple *pattern*; Elixir matches it against the value on the right, binding `entries` to the first element and `_errors` to the second.

**Is that a tuple?** Yes — `{...}` with a comma is Elixir's two-element tuple syntax. `{1, 2}` is a tuple; `{1, 2, 3}` is a three-tuple. (Contrast `[1, 2]` which is a list.)

**Does `scan` return a tuple?** Yes. From `registry.ex`:
```elixir
{entries, errors ++ duplicate_id_errors(entries)}
```
The last expression is the return value, and it's a 2-tuple: `{list_of_entries, list_of_errors}`. The match only succeeds *because* the shapes line up (2-tuple pattern ↔ 2-tuple value). If `scan` returned a bare list, `{entries, _errors} = ...` would raise `MatchError`.

**Can you access `_errors` in iex?** This is the gotcha. The leading underscore doesn't stop the variable from being *bound* — `_errors` still holds the errors list and you *can* reference it. What the underscore does is **suppress the "unused variable" compiler warning**. So:

```elixir
{entries, _errors} = ElixirMind.Registry.scan()
_errors   # works, returns the list — BUT emits a warning
```

Referencing an underscore-prefixed variable warns *"the underscored variable "_errors" is used after being set"* — because the underscore signals intent to discard, and then you used it anyway. If you actually want to look at the errors, drop the underscore:

```elixir
{entries, errors} = ElixirMind.Registry.scan()
errors    # no warning
```

The fully-anonymous `_` (bare underscore) is different again: it matches but binds *nothing*, so you can't reference it at all — `_` is not readable.

So the underscore is purely a convention about *use intent*, not a gate on returned data. `scan` always returns both elements; whether you name the second one with or without a leading underscore only changes whether the compiler nags you for reading it later.

## User

show me a query that finds docs with no inbound links

## Assistant

The `Links` module extracts targets but keeps that private, so I'll build the query in iex. One conceptual note first: **every properly-filed doc is listed in its directory's `index.md`**, so if you count index links, almost nothing is orphaned. The interesting query is **docs with no inbound link from _prose_ (excluding `index.md` listings)** — i.e. filed but never cross-referenced. Here's that, and I'll verify it runs:

## Assistant

It runs. The query works, but notice the result is **all threads/inbox docs** — those live in the governance namespace and are anchored by `pr:`/date, not cross-links, so they're orphans by design. Zero actual *bundle* knowledge docs came up orphaned, which is a good sign for the brain's link hygiene.

Here's the copy-pasteable iex version, and a scoped variant that only considers real bundle documents (`em:` ids):

```elixir
alias ElixirMind.{Links, Registry}
root = File.cwd!()

normalize = fn target, from ->
  target = target |> String.split("#") |> hd()
  case target do
    "/" <> rest -> rest
    _ -> Path.join(Path.dirname(from), target) |> Path.expand("/") |> String.slice(1..-1//1)
  end
end

# every inbound target, excluding links that sit inside index.md listings
linked =
  Links.doc_paths(root)
  |> Enum.reject(&(Path.basename(&1) == "index.md"))
  |> Enum.flat_map(fn from ->
    File.read!(Path.join(root, from))
    |> then(&Regex.scan(~r/\]\(([^)\s]+)\)/, &1))
    |> Enum.map(fn [_, t] -> t end)
    |> Enum.reject(&(String.contains?(&1, "://") or String.starts_with?(&1, "#")))
    |> Enum.map(fn t -> normalize.(t, from) end)
  end)
  |> MapSet.new()

# scope to bundle docs only (skip governance threads/inbox noise)
{entries, _} = Registry.scan(root)
entries
|> Enum.reject(&MapSet.member?(linked, &1.path))
|> Enum.map(& &1.path)
|> Enum.sort()
```

Two knobs to adjust depending on what "orphan" means to you:

- **Include `index.md` links** → drop the `Enum.reject(&(Path.basename(&1) == "index.md"))`. Then only genuinely-unfiled docs surface (most docs are listed in an index, so this is a much stricter test).
- **All docs vs. bundle-only** → use `Links.doc_paths/1` as the universe (walks `meta/`, `inbox/` too — what the first run showed) or `Registry.scan/1` (bundle docs with `em:` ids only, the version just above).

The scratchpad script is at `.../scratchpad/orphans.exs` if you'd rather `mix run` it than paste into iex. Want me to turn this into a `mix brain.orphans` task, or add a `--strict` mode that counts index links?

## User

make it a mix brain.orphans task

## Assistant

Done. `mix brain.orphans` is live, full suite green (177 tests).

### What I built

- **`lib/elixir_mind/orphans.ex`** — `ElixirMind.Orphans.find/2`, the logic. Reuses `Links.internal_targets/1` + `Links.resolve_target/2` so the orphan finder and the link-resolution check share one extraction/normalization path and can't drift.
- **`lib/mix/tasks/brain.orphans.ex`** — thin task wrapper (matches the `brain.url`/`brain.evidence` shape).
- **`test/elixir_mind/orphans_test.exs`** — 5 tmp_dir tests (index-listing exclusion, relative vs bundle-absolute inbound links, anchored-namespace scoping, reserved-file exclusion).
- **`lib/elixir_mind/links.ex`** — promoted `internal_targets/1` to public + extracted `resolve_target/2` out of `resolves?/3` (pure refactor; existing links tests still pass).
- **`meta/code-map.md`** — regenerated (it's compiled from `lib/` docstrings).

### Usage

```
mix brain.orphans                 # knowledge + governance docs; index.md listings ignored
mix brain.orphans --include-index # count links inside index.md listings too
mix brain.orphans --all           # include meta/threads/ and inbox/ (anchored by design)
```

Two deliberate scoping choices baked in: `index.md` listings don't count as inbound links by default (else every filed doc looks referenced), and `meta/threads/`+`inbox/` are excluded from candidates by default (they're anchored by `pr:`/date, unreferenced on purpose). Right now the default reports **zero orphans** — good link hygiene across the real bundle.

I haven't committed — changes are in the working tree. Want me to `/create-pull-request` this? Note the task isn't wired into `mix brain.verify`/CI (it's an on-demand advisory tool like `brain.evidence`), and it's not yet listed in the skills/policy docs — say the word if you'd like it registered or added to `mix help` groupings.

## User

register, add to mix help groupings, then /create-pull-request
