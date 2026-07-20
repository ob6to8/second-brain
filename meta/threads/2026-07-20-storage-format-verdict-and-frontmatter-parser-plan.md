---
type: reference
title: 2026-07-20-storage-format-verdict-and-frontmatter-parser-plan
description: Operator asked whether markdown is still the right storage format for the brain versus JSON or a database; the agent's verdict was keep markdown canonical and derive indexes, naming the hand-rolled frontmatter parser as the first casualty of growth — then designed its replacement (strict OKF-profile parser plus order-preserving serializer) and filed it as a plan on the operator's direction.
provenance: "Claude Code session (claude-fable-5), 2026-07-20; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, storage-format, markdown, frontmatter, parser, serializer, yaml, tooling, plan]
timestamp: 2026-07-20
---

# 2026-07-20-storage-format-verdict-and-frontmatter-parser-plan

## Where this landed

The session opened as a design question about the bundle's storage substrate: given
what the repo is becoming, is markdown still the ideal format for storing the
knowledge and manipulating it from Elixir, versus JSON, a database, or something
else? The agent's assessment: markdown-with-frontmatter stays canonical — the
readers/writers are agents and the operator, git is the provenance layer and needs
line-oriented text, the scale (586 docs, 3.7 MB) doesn't justify a database, and the
repo already uses the correct hybrid pattern (markdown canonical, compiled artifacts
derived) — with the real strain located in the structured layer, naming the
hand-rolled frontmatter parser as the most likely first casualty of growth and a
derived SQLite index as the future scaling move. The operator then asked what
replacing the frontmatter parser would look like; the agent designed it (reject full
YAML deliberately; rewrite as a strict "OKF frontmatter profile" recursive-descent
parser behind the unchanged `parse/1` API, paired with an order-preserving
`Frontmatter.dump/1` serializer so attribution stamping stops being regex surgery,
migrated via a differential harness over the live corpus and a byte-for-byte
round-trip check). On the operator's direction the design was filed as the
[frontmatter-parser-profile-rewrite plan](/meta/plans/frontmatter-parser-profile-rewrite.md)
(`status: proposed`) and the session closed with `/create-pull-request merge`.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Is markdown still the right storage format for the bundle vs JSON/database? | closed | [frontmatter-parser-profile-rewrite plan](/meta/plans/frontmatter-parser-profile-rewrite.md) | - |
| Design of the frontmatter parser replacement (profile parser + serializer) | closed | [frontmatter-parser-profile-rewrite plan](/meta/plans/frontmatter-parser-profile-rewrite.md) | - |
| Derived SQLite index (`mix brain.index`) as hardening move 2 of the format verdict | paused | `unrouted` | File as its own plan when structured-query cost grows — or ahead of it, to make the markdown-canonical/index-derived boundary explicit |

## User

Looking at what this repo is becoming, is md still the ideal format for storing this info and allowing for manipulation by elixir? Json, database, other?

## Assistant

<routes ref="/meta/plans/frontmatter-parser-profile-rewrite.md lib/elixir_mind/frontmatter.ex">
Short answer: yes — markdown-with-frontmatter is still the right canonical store for this system, and the pressure points that are emerging are better solved with derived indexes than by switching formats. Here's the reasoning, grounded in what the repo actually is today.

## Why markdown keeps winning here

**The primary readers and writers are LLM agents and you.** Every skill in this repo — `/intake`, `/capture`, `/elaborate`, the glossary — has an agent authoring or revising *prose*. Markdown is the format agents are natively best at reading and producing, and it's the format you can review in a PR diff, edit in any editor, and read on the Pages site. JSON would turn every document body into an escaped string blob; a database would put every read and write behind tooling instead of behind `Read`/`Edit`.

**Git is your provenance layer, and that's a hard constraint.** The merge-strategy and session-capture policies make the commit graph the single change-narrative layer: session trailers, SHAs cited in plans, `git blame` as "which session changed this". That architecture requires line-oriented text. A SQLite file committed to git kills diff, blame, and merge; JSON diffs badly for prose (a rewrapped paragraph is an opaque line change). Markdown is the format that keeps `git blame` meaningful per-sentence.

**The scale doesn't justify a database.** The bundle is 586 documents and the whole `.git` is 3.7 MB. Every `mix brain.*` task can slurp and parse the entire tree in well under a second — Elixir streams files and holds the whole corpus in memory trivially. Databases solve concurrent writers, transactional integrity, and indexed queries over data too big to scan. You have one writer at a time (a session branch), atomicity via commits, and a corpus that fits in L2 cache. You'd be taking on operational complexity to solve problems you don't have.

**The repo already uses the right hybrid pattern.** Notice what `CLAUDE.md`, `meta/registry.md`, and the route-tag excerpt logs have in common: markdown is canonical, and *structured views are compiled from it* (`mix brain.contract`, `brain.registry`, `brain.route_tags --materialize`), with CI checking they haven't drifted. That's the static-site-generator architecture, and it's the correct one — the source of truth stays human/agent/git-native, and anything that needs to be queryable gets derived.

## Where the strain actually is

The real tension isn't markdown vs. JSON — it's that the *structured layer* (ids, `verified_by` edges, `attribution` maps, route tags) is growing inside a prose format. Concretely:

- `lib/elixir_mind/frontmatter.ex` is a hand-rolled YAML-subset parser: scalars, inline lists, and exactly one level of nested block map. Every new frontmatter shape (attribution was the recent one) risks bumping into its ceiling. This is the most likely first casualty of growth — and the fix is adopting a real YAML library (or extending the subset), not changing the storage format.
- Typed edges (`verified_by`, route-tag refs) are relational data queried by full-tree scan. Fine at 586 docs; at ~10,000+ docs with richer edge types, `mix brain.evidence`-style traversals would want an index.

If/when that day comes, the move is a **derived SQLite index** — a `mix brain.index` that compiles frontmatter and edges into a gitignored `.db` used by the query tasks, rebuilt from the markdown at will. Cache, never source of truth. That gets you SQL over the graph without giving up anything above. (In-process, ETS already serves this role within a single task run.)

## When the answer would change

Markdown-as-canonical would stop being right if: the bundle reached a scale where full-tree scans hurt even at build time (think 50k+ docs), you needed multiple concurrent writers without git's branch/merge mediation, or the dominant workload became structured queries rather than reading and writing prose. None of those are on the visible horizon, and even then the migration path runs *through* the derived-index pattern, not around it.

So my recommendation: no format change. If you want to invest ahead of growth, the two worthwhile hardening moves are (1) replacing or extending the frontmatter parser before frontmatter complexity outgrows it, and (2) sketching the derived-index task now so the "markdown canonical, SQLite derived" boundary is explicit in a plan doc. Happy to file either as a `plan` under `meta/plans/` if you'd like this reasoning persisted.
</routes>

## User

What would it look like to replace the frontmatter parser

## Assistant

<routes ref="/meta/plans/frontmatter-parser-profile-rewrite.md lib/elixir_mind/frontmatter.ex lib/elixir_mind/attribution/backfill.ex">
Now I have the full picture. The key facts that shape the answer: there are 16 call sites across 10 modules, all *reads* through the same `parse/1` API; the project is deliberately zero-dependency (`deps: []`, and both `frontmatter.ex` and `markdown.ex` document that as a design goal — the tooling must run offline in any sandbox); and the one place that *writes* frontmatter back (`attribution/backfill.ex`) does it with regex surgery on the raw text, not through the parser at all. That last point matters as much as the parser itself.

## Two viable shapes, and which I'd pick

**Option A — adopt a real YAML library** (`yaml_elixir`/`yamerl`, pure Erlang, no NIFs). This is the obvious move but I'd argue against it here. It breaks the zero-dependency property that lets the tooling compile in any fresh sandbox without a hex fetch. And full YAML is a *liability* for this bundle, not a feature: YAML 1.1 coercions (`no` → false, dates → tuples, octals) would silently change parsed values, and full-YAML permissiveness means agents could write anchors, flow maps, and folded scalars that parse fine but wreck the bundle's uniformity. The whole contract philosophy is "controlled vocabulary, machine-enforced shape" — a parser that accepts everything works against that.

**Option B — rewrite the in-house parser as an explicit, strict "OKF frontmatter profile" parser** (recommended). Same module, same `parse/1`/`parse!/1` API so all 16 call sites are untouched, but internally a small indentation-based recursive-descent parser with a *defined grammar* instead of accreted special cases:

- scalars (string, integer, boolean), single/double-quoted strings
- inline lists that respect quoting (today `["a, b"]` splits on the comma — wrong)
- **arbitrarily nested block maps** (today: exactly one level, hardcoded to the shape of `attribution:`)
- **block lists** (`- item` lines — today unsupported, which is why `attribution.from` must stay inline; long thread paths make those lines unwieldy)
- everything else → a **loud error with line number**, not silent tolerance

That last point fixes a real class of latent bugs in the current code. Two concrete ones I can see in `frontmatter.ex`: a title like `title: [Draft] some idea` coerces into a *list* because anything starting with `[` is treated as one (`frontmatter.ex:110`); and an unparseable line inside a nested block is silently dropped (`frontmatter.ex:102`) — data loss with no signal, in a bundle whose verifier exists to catch exactly this kind of drift. Strictness at the parser is what makes `mix brain.verify`'s guarantees real.

## The half people forget: a serializer

The rewrite should ship with `Frontmatter.dump/1` (or `update/2`) — and this is arguably the bigger win. Right now `backfill.ex:152` appends `from:` to attribution blocks with a regex that assumes the block is exactly "lines indented by two spaces" — it breaks the moment attribution contains anything nested deeper. The `/create-pull-request` from-stamping motion has the same problem shape. With a parse → modify-map → dump pipeline, frontmatter writes become structural instead of textual.

The design constraint is **order-preserving round-trip**: parse should keep key order (keyword-list or ordered map internally) so that `parse |> dump` on an unmodified doc reproduces the file byte-for-byte. That gives you a free canonical-form check (`mix brain.verify` can assert every doc's frontmatter round-trips cleanly), keeps diffs minimal when tooling rewrites a doc, and means agents and the serializer converge on one canonical formatting.

## Migration plan

The corpus is the test suite — 586 documents sitting right there:

1. Build the new parser alongside the old (`Frontmatter.V2` internally), identical return shape.
2. **Differential harness**: a test that parses every doc in the bundle with both parsers and asserts identical maps. Any divergence is either a new-parser bug or a latent old-parser bug surfacing — triage each.
3. Extend `test/elixir_mind/frontmatter_test.exs` with golden cases for the profile grammar, including inputs that must *fail* (that's the spec of the profile).
4. Round-trip test: `parse |> dump == original` across the whole bundle. Docs that don't round-trip get normalized once, in the same PR, so the canonical form starts true.
5. Swap the implementation, delete the old code paths, then refactor `backfill.ex`'s regex writes onto `dump`.
6. Optionally, a short policy note (or an update to the frontmatter-schema policy) naming the profile as the enforced grammar, since "what YAML subset is legal" graduates from implementation detail to contract.

Rough size: the parser+serializer is maybe 300–400 lines replacing the current 130, plus tests. A focused session's worth of work, very low risk given the differential harness — the API boundary means nothing else in `lib/` changes.

Per the persist-plans policy this is exactly a plan-worthy change. Want me to file it as a `type: plan` doc under `meta/plans/` (status `proposed`), or go ahead and implement it on this branch?
</routes>

## User

File as plan, then /create-pull-request merge

*(The remainder of the session was tool activity — filing the
[frontmatter-parser-profile-rewrite plan](/meta/plans/frontmatter-parser-profile-rewrite.md),
updating the plans index, and running the capture/PR flow — with no further
delivered prose at capture time.)*
