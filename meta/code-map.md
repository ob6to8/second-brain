<!--
  GENERATED FILE — do not edit by hand.
  Source of truth: the @moduledoc/@doc/@typedoc in each lib/ module.
  Regenerate:      mix brain.codemap
  Verify (CI):     mix brain.codemap --check
-->

# Code map — module, function & type intent

A generated glossary of the `elixir_mind` tooling: every module compiled into
the application, its purpose (`@moduledoc`), its public functions, and its
declared types. The tooling is not part of the knowledge bundle — it has no
`em:` id and no site page — so this map is where its intent is browsable.

Source of truth is the docstrings in `lib/`; this file is compiled from them
(`mix brain.codemap`) and checked for drift in CI (`mix brain.codemap --check`),
on the same generated-artifact discipline as `CLAUDE.md` and
[`meta/registry.md`](/meta/registry.md). To change an entry, edit the module's
`@moduledoc`/`@doc`/`@typedoc` and regenerate — never edit this file by hand.

## Library — `ElixirMind.*`

### `ElixirMind.Attribution`

`lib/elixir_mind/attribution.ex`

The attribution layer: machine checks and helpers for the `attribution`
frontmatter map — the record of the **ingestion event** on every bundle
concept and governance doc (see `meta/policy/resource-attribution.md` and the
attribution plan).

    attribution:
      when: 2026-07-13T14:02:00Z
      channel: auto-intake
      agent: "Claude Code agent, /research daily Routine"
      why: "featured in the 2026-07-13 digest under agents/orchestration"
      from: [/meta/threads/2026-07-13-example.md]   # governance docs only

Rules (surfaced through `ElixirMind.Verifier`):

  * **Shape** — `attribution` is a map; `when` parses as ISO 8601 (date or
    datetime); `channel` is from the controlled vocabulary; `agent` is a
    non-empty string; `why` is a non-empty string except under
    `channel: backfill`, where a reconstructed event may honestly lack one.
  * **`from` placement** — `from` belongs to governance docs only; on a
    bundle concept it is an error.
  * **`from` resolution** — every ref resolves: `em:` ids to a bundle
    concept, bundle-absolute paths to an existing file.
  * **Exemption placement** — exempt files (thread docs, `inbox/` digests,
    `index.md` listings, generated artifacts) must NOT carry `attribution`.
  * **Presence** — once the backfill lands (`presence_enforced?/0` flips to
    `true`), every bundle concept and every governance doc carries
    `attribution`. `from`-presence on ratification-flow docs is advisory
    (a warning) while `/create-pull-request` stamping beds in.

The event sub-keys are immutable once written; governance `from` is
append-only. Immutability is a contract obligation on agents (the verifier
sees one snapshot, not a diff) — git review is the safety net.

**Functions**

- `bundle_errors/4` — Attribution errors for one bundle concept (a `Registry.Entry`). Pass `presence: true` to require the field (the post-backfill regime).
- `channels/0`
- `governance_errors/3` — All attribution errors for the governance namespace, given the bundle's id index (for `from` ref resolution). Pass `presence: true` to also require `attribution` on every governance doc (the post-backfill regime).
- `governance_paths/1` — All governance-side `.md` paths (relative), partitioned into `%{governance: [...], exempt: [...]}`. Governance docs live under `meta/`; exempt files are thread docs, `inbox/` digests, `index.md` listings, and generated artifacts (`meta/registry.md`, `meta/preamble.md`, `meta/flows/lineage.md`, `meta/dev-history.md`).
- `list/2` — List every attributed doc as a row map (`path`/`id`/`when`/`channel`/ `agent`/`why`/`from`), newest first. Options:
- `presence_enforced?/0`
- `warnings/1` — Advisory warnings (never fail the gate): ratification-flow governance docs (plan/analysis/elaboration/issue) whose `attribution` lacks a `from` back-link to the thread or doc they were extracted from.


### `ElixirMind.Attribution.Backfill`

`lib/elixir_mind/attribution/backfill.ex`

One-shot reconstruction of `attribution` for docs that predate the
resource-attribution policy (`mix brain.attribution --backfill`).

Derivation rules — facts recovered from history, never invented:

  * `when` — the file's first-add instant from `git log --follow
    --diff-filter=A` (the ingestion commit).
  * Bundle concepts tagged `auto-intake` — their true channel is known:
    `channel: auto-intake`, `why` derived from the digest date in
    `provenance`, and the retired tag removed (its job moves to
    `attribution.channel`).
  * Glossary term files — their pathway is structural:
    `channel: glossary` (every term file is accreted by `/add-to-glossary`
    from scanned sources; the *Seen in:* line carries the citations).
  * Everything else — `channel: backfill` with the reconstruction named in
    `agent` and `why` omitted (the reason is unrecoverable; the backfill
    rule allows its absence rather than a guessed sentence).
  * Governance `from` — recovered from the explicit sources that already
    exist: an elaboration's `thread:` field (migrated, the field removed)
    and a flow doc's `lineage:` block (analysis/plan/thread paths; the
    block itself is retired separately by lineage derivation).

Files already carrying `attribution` are left untouched — the event is
write-once, and hand-written blocks beat reconstruction.

**Functions**

- `run/1` — Backfill the whole corpus under `root`. Returns `{written, skipped}` — paths rewritten and paths that already carried attribution. Runs two idempotent passes: reconstruct missing `attribution` blocks, then derive missing governance `from` back-links (the thread of the PR that introduced the doc, resolved through the thread docs' `pr:` anchors).


### `ElixirMind.CodeMap`

`lib/elixir_mind/code_map.ex`

Compiles `meta/code-map.md` — the code glossary of module, function, and type
intent for the `elixir_mind` tooling.

The tooling (`lib/`, the `mix brain.*` tasks) sits *alongside* the knowledge
bundle, not inside it: it carries no `em:` id and the site excludes `lib/`, so
the code has no page and no registry entry. This module gives it the one thing
the bundle documents get for free — a browsable statement of intent — by
compiling it from the docstrings already in the source.

Like `CLAUDE.md` (via `ElixirMind.Contract`) and `meta/registry.md` (via
`ElixirMind.Registry`), the output is a **generated artifact**: the `@moduledoc`
/ `@doc` / `@typedoc` in each module are the source of truth, `render/0` compiles
them, and `mix brain.codemap --check` fails in CI if the checked-in file drifts.
Extraction uses `Code.fetch_docs/1` (standard library), so the whole thing stays
dependency-free and runs offline — no ExDoc, no second doc site.

Scope: every module compiled into the `:elixir_mind` application that carries a
*visible* `@moduledoc`. Modules marked `@moduledoc false` (internal structs like
`ElixirMind.Registry.Entry`, the Mix project) are intentionally omitted, exactly
as they are from ExDoc — documenting them is a docstring-enrichment decision, not
a code-map one.

**Functions**

- `check/1` — Check the on-disk code map matches a fresh render.
- `modules/0` — The documented modules, split into `{library, tasks}` — `ElixirMind.*` modules and the `mix brain.*` task modules respectively — each sorted by name, each carrying a visible `@moduledoc`.
- `output_path/0` — Path of the compiled code map, relative to repo root.
- `render/0` — Render the compiled code map markdown.
- `write/1` — Render and write the code map. Returns the output path.


### `ElixirMind.Contract`

`lib/elixir_mind/contract.ex`

Compiles `CLAUDE.md` — the operating contract every agent reads — from its source
documents:

  * `meta/preamble.md`  — the fixed framing/intro (plain markdown, no frontmatter)
  * `meta/policy/*.md`  — the rules, as `type: policy` OKF docs (see `ElixirMind.Policy`)

Each policy is grouped under its declared `section` and rendered in `order`, with a
visible trace link back to its source document. `CLAUDE.md` is therefore a generated
artifact: never hand-edited, always reproducible via `mix brain.contract`.

**Functions**

- `check/1` — Check whether the on-disk `CLAUDE.md` matches a fresh render. Returns `:ok` or `{:stale, diff_summary}`.
- `output_path/0` — Path of the generated contract, relative to repo root.
- `render/1` — Render the full `CLAUDE.md` contents as a string.
- `write/1` — Render and write `CLAUDE.md`. Returns the output path.


### `ElixirMind.DedupProbe`

`lib/elixir_mind/dedup_probe.ex`

The intake dedup-recall probe: score the bundle's mechanical search layer
against a gold set of natural-phrasing dedup queries.

Intake dedup — finding the existing concept a new item should merge into — is
the entry gate of the corpus-maintenance failure chain, and it is the one gate
CI can't otherwise cover. Today it leans on lossy lexical search plus an
LLM-in-context subsidy that expires as the corpus outgrows agent context. This
probe measures the *mechanical* layer in isolation, so the loss is re-measured
as the corpus grows (see the
[dedup-recall-probe plan](/meta/plans/dedup-recall-probe.md)).

Deliberately zero-dependency, fully offline, deterministic — it must run in CI
and any sandbox, so it makes **no LLM calls** at probe time.

## The gold set

`meta/evals/dedup-probe.md` — a prose-bearing doc whose `## Gold set` table this
module parses. Each row is a `query`, its `acceptable ids` (one or more `em:`
ids), a `band`, `;`-separated `variants`, and an adjudication `note`.

  * **`target`** — a scored row: the query should surface at least one acceptable
    id from the mechanical backend.
  * **`negative`** — a non-duplicate pair (shares vocabulary, must not merge).
    Not scored in v1 (lexical search has no duplicate judgment to test); seeded
    so the later embedding/judge tiers inherit them.
  * **`quarantine`** — gold answer undefined until supersession exists
    (time-relativity). Parsed, reported, never scored.

## The backend under test

Case-insensitive substring match over each bundle concept's title, description,
tags, and body. A row **hits** if any of its acceptable ids is in the query's
match set. Scoring is surfaced-or-not, not ranked — intake has no ranked backend
yet — and the report also carries each query's match-set size (the noise /
cluster-saturation signal). In `--expanded` mode a target row hits if the query
**or any recorded variant** hits, approximating synonym-expanded intake dedup
deterministically; the plain-vs-expanded gap measures how much recall the tier-1
`/intake` synonym-expansion change is expected to recover, offline.

Tolerant consumer per OKF conformance: unparseable concepts are skipped, never
fatal; a missing gold doc raises (the probe has nothing to measure).

**Functions**

- `gold_path/0` — Path of the gold-set doc, relative to repo root.
- `parse_baseline/1` — The committed `## Baseline` figures as `%{"plain" => {hits, targets}, ...}`, or `nil` if no baseline table is present.
- `parse_gold!/1` — Parse the `## Gold set` table into `Row` structs (doc order).
- `report/2` — Run the probe and render its report as text.
- `run/2` — Run the probe. Options: `expanded: true` scores in synonym-expanded mode. Returns a report map: `%{expanded:, results:, aggregate:, baseline:}` where `results` is one entry per gold row (in doc order) and `aggregate` covers the `target` rows only.
- `search_index/1` — Map of `id => searchable blob` for every bundle concept carrying an `em:` id. The blob is the lowercased concatenation of title, description, tags, and body — the text the mechanical backend matches against.
- `update_baseline/1` — Rewrite the gold doc's `## Baseline` table from a fresh plain + expanded run, preserving all surrounding prose. The committed baseline is a *generated* figure — refreshed by this command (typically at intake time), never hand-kept — so the recall trend lives in the doc's git history. Returns the gold path.


### `ElixirMind.DedupProbe.Row`

`lib/elixir_mind/dedup_probe.ex`

One parsed gold-set row.



### `ElixirMind.DevHistory`

`lib/elixir_mind/dev_history.ex`

The derived dev-history view: per-PR features and progress, compiled from
the default branch's **first-parent git history** into
`meta/dev-history.md`.

There is no hand-kept log (see the reserved-filenames policy and the
retire-hand-kept-logs plan): the true-merge commit graph *is* the
provenance layer, and this module renders a readable overview of it on the
same generated-artifact discipline as `CLAUDE.md`, `meta/registry.md`, and
`meta/flows/lineage.md`. `git log --first-parent` yields one commit per PR;
each entry's bullets are the merged branch's commit subjects (already
atomic and deliberately messaged per the merge-strategy policy).

Three eras of history are handled:

  * **true merges** — `Merge pull request #N …`; bullets from the branch
    commits (`merge^1..merge^2`), title from the merge subject or body.
  * **the pre-policy squash era** — `Title (#N)` commits directly on main;
    bullets from the squash body's `* ` lines.
  * **the pre-PR era** — direct commits predating the PR workflow, listed
    as a closing section of dated subjects.

The checked-in file inherently lags by the PR that ships it (a PR cannot
contain its own merge commit), so `check/1` is **lag-tolerant**: a fresh
derivation may have newer sections the file lacks, but everything the file
does contain must match. The Pages build regenerates the doc at deploy
time, so the live site's copy is always fully current.

**Functions**

- `check/1` — Check the on-disk view against a fresh derivation. Lag-tolerant: the fresh render may carry newer PR sections the file lacks (the file cannot contain the merge that ships it), but the shared preamble and every section the file does contain must match. Returns `:ok`, `{:stale, path}`, or `{:error, reason}`.
- `classify/1` — Classify a first-parent commit subject into its era: `{:merge_from, pr, branch}` / `{:merge_titled, pr, title}` (true merges), `{:squash, pr, title}` (pre-policy squash commits), or `:direct`.
- `default_ref/1` — Resolve the ref the history is derived from: the first of `origin/main` / `main` that exists. Returns `{:ok, ref}` or `{:error, :no_default_branch}`.
- `entries/1` — Derive the entry list (newest first) from the first-parent history of the default branch. Returns `{:ok, entries}` or `{:error, reason}`.
- `humanize_branch/1` — A readable fallback title from a head-branch name when the merge body is empty: strip the owner and `claude/` prefixes and the trailing session id, and space out the slug (`ob6to8/claude/foo-bar-ab12cd` → `foo bar`).
- `lagging_but_consistent?/2` — True when `disk` is `fresh` minus some newest sections (pure).
- `output_path/0` — Path of the generated dev-history view, relative to repo root.
- `render/1` — Derive and render the full generated document.
- `render_entries/2` — Render a document from an entry list (pure; newest first).
- `shallow?/1` — True when the repository is a shallow clone (derivation would truncate).
- `squash_bullets/1` — Bullets from a squash-commit body: the first line of each `* `-led block (GitHub's default squash body lists the branch's commit subjects that way).
- `write/1` — Derive, render, and write the view. Returns `{:ok, path}` or `{:error, reason}`.


### `ElixirMind.Frontmatter`

`lib/elixir_mind/frontmatter.ex`

Parser for the small YAML-frontmatter subset used by OKF concept documents in
this bundle. Deliberately dependency-free: it handles scalars (string, integer,
boolean), quoted strings, inline `[a, b, c]` lists, and **one level of nested
block maps** (a `key:` with no value whose children are indented `k: v` pairs —
the shape of `attribution:` and `lineage:` blocks) — which is everything the
bundle's frontmatter uses. It is a tolerant *consumer* per OKF §5: unknown keys
are preserved as strings.

A document is `---\n<yaml>\n---\n<body>`. `parse/1` returns
`{:ok, %{frontmatter: map, body: string}}` or `{:error, reason}`.

**Functions**

- `parse/1` — Parse a full document (frontmatter + body).
- `parse!/1` — Like `parse/1` but raises on malformed input.


### `ElixirMind.Glossary`

`lib/elixir_mind/glossary.ex`

Machine checks over the glossary's single-overview convention (see the
[glossary plan](/meta/plans/glossary-single-overview-and-dedup-check.md)).

Each term file under `beliefs/glossary/` carries one canonical overview: its
`description` frontmatter, rendered as the entry page's lede and shown
verbatim as the term's gloss in the index `## Terms` section. The body below
the lede is expansion-only — it must not restate what the description
already says.

Enforcement splits by what has a mechanical oracle, mirroring
`ElixirMind.RouteTags`:

  * **fail** — a term file missing a non-empty `description`; the index
    `## Terms` section diverging from its re-derivation (`materialize/1`
    regenerates it: one bullet per term, title-sorted case-insensitively,
    gloss = description verbatim).
  * **fail** — a body sentence that near-restates the description:
    normalized content-word containment (lowercase, punctuation stripped,
    stopwords dropped, naive plural stemming; sentences under
    8 content words skipped) at or above the fail threshold.
  * **warn** — moderate containment. Semantic redundancy has no exact
    oracle, so the middle band reports without failing, like the
    routing-ledger coverage warning.

Generated `## Thread excerpts — route-tagged log` sections, *Seen in:* and
*See also:* lines are excluded from the repetition check — they are
citations and route-tag materializations, not definition prose.

**Functions**

- `index_path/0` — Repo-relative path of the glossary index.
- `materialize/1` — Regenerate the index's `## Terms` section from the term files (title-sorted case-insensitively, gloss = `description` verbatim), preserving the prose above the heading. Returns `{:written, path}` or `:unchanged`.
- `run_checks/1` — Run all glossary checks. Returns a list of `{name, :ok | :warn | :fail, detail}` tuples, like `ElixirMind.RouteTags.run_checks/1`.


### `ElixirMind.Lineage`

`lib/elixir_mind/lineage.ex`

Flow-doc provenance: the `analysis → plan → thread → PR → flow` chain that
produced each `meta/flows/*.md` doc.

The **canonical source** is the flow doc's `attribution.from` back-links
(see the resource-attribution policy) — there is no hand-kept lineage data.
Each ref is classified by its governance path (`/meta/analysis/` →
analysis, `/meta/plans/` → plan, `/meta/threads/` → thread), and the PR hop
is resolved through each thread doc's `pr:` anchor — the same anchors the
session-capture policy already maintains. A flow built across several
sessions simply carries several thread refs (appended by
`/create-pull-request`'s stamping step, `from` being append-only).

From those edges this module derives two never-hand-kept views, on the same
generated-artifact discipline as `CLAUDE.md` and `meta/registry.md`:

  * a per-doc **blockquote** materialized between `lineage:start`/`lineage:end`
    markers at the top of each flow doc (`materialize/1`), and
  * a cross-flow **flowchart index** at `meta/flows/lineage.md` (Mermaid graph +
    a dependency-free table), written by `write_index/1`.

`check/1` re-derives both and reports staleness for the `--check` CI gate.

(`parse_lineage_block/1` remains only as the migration reader the
attribution backfill used to convert the retired hand-kept `lineage:`
blocks into `attribution.from` refs.)

**Functions**

- `blockquote/1` — Render the generated lineage blockquote for a flow, or `nil` when the flow has no lineage recorded.
- `check/1` — Check the on-disk views match a fresh derivation. Returns `:ok` or `{:stale, [paths]}`.
- `flow_paths/1` — Relative paths of every flow doc (excluding the generated index/lineage files).
- `index_output_path/0` — Path of the generated flowchart index, relative to repo root.
- `materialize/2` — Return `content` with its lineage blockquote materialized: replace the region between the markers if present, else insert a fresh marker block right after the doc's first `# ` H1. A flow with no lineage is returned unchanged.
- `render_index/1` — Render the full generated `meta/flows/lineage.md` document.
- `scan/1` — Scan every flow doc and return a list of `%Flow{}`, sorted by path.
- `write/1` — Materialize every flow doc's blockquote and (re)write the flowchart index. Returns the list of paths written.


### `ElixirMind.Links`

`lib/elixir_mind/links.ex`

Advisory docs-freshness checks: internal-link resolution and index coverage.

Two warning families (never errors — `mix brain.verify` prints them but
stays green; per OKF conformance broken links are tolerated, and index
coverage is ultimately editorial):

  1. **Link resolution** — every internal markdown link (`](/abs/path)` or
     `](relative/path)`) in a live doc resolves to a file on disk.
  2. **Index coverage** — every directory holding `.md` docs has an
     `index.md`, and every non-reserved doc (and immediate subdirectory)
     is mentioned in it.

Deliberately exempt, because their content is frozen or placeholder:

  * `meta/threads/` bodies (frozen verbatim by the capture policy — a broken
    link quoted there is history, not drift);
  * `## Thread excerpts — route-tagged log` sections anywhere (they quote
    frozen thread regions verbatim);
  * link targets containing `…` (ellipsis placeholders in examples) and
    external targets (`scheme://`, `mailto:`, pure `#anchor`s);
  * code spans and fenced code blocks (literal text, not rendered links);
  * reserved files (`index.md`, `log.md`, `README.md`, `CLAUDE.md`) from the
    must-be-listed requirement.

Unlike `Registry.scan/1` this walks the governance namespaces too (`meta/`,
`inbox/`) — index drift lives exactly where the id gates don't look.

**Functions**

- `check/1` — Run both warning families over the tree rooted at `root`.
- `doc_paths/1` — All `.md` docs in scope (relative paths), sorted.
- `internal_targets/1` — Internal markdown link targets in `body`, minus code spans/blocks and external/mailto/anchor/placeholder targets — the same set the resolution check walks. Raw targets (a `#fragment` may still be attached); normalize with `resolve_target/2`.
- `resolve_target/2` — Normalize an internal link `target` found in `from_path` to a repo-relative path (leading `#fragment` dropped): bundle-absolute targets lose their leading `/`, relative ones resolve against the source doc's directory.


### `ElixirMind.Markdown`

`lib/elixir_mind/markdown.ex`

A small, dependency-free Markdown → HTML converter, scoped to the constructs the
elixir-mind bundle actually uses: ATX headings (with GitHub-style slug anchors),
bulleted and numbered lists (nested by indentation), fenced code blocks, inline
code, GitHub-style tables, blockquotes, horizontal rules, paragraphs, and inline
emphasis / links / autolinks.

Staying dependency-free keeps the site generator in step with the rest of the
tooling (`mix brain.*`), which parses the bundle with the standard library only
so it runs offline in any sandbox.

## Link rewriting

Bundle cross-links point at markdown files (`[x](/SWE/index.md)`,
`[y](../foo.md)`). `to_html/2` rewrites those to the generated `.html` pages,
resolving relative paths against the source file's directory and prefixing the
result so the link works from the page's depth in the output tree. External URLs,
`mailto:`, and pure `#anchor` links pass through untouched.

**Functions**

- `slug/1` — Slugify a heading the way GitHub does: downcase, drop punctuation other than spaces and hyphens, then turn spaces into hyphens. Used for in-page `#anchor` targets so bundle links like `[x](#grounding)` resolve.
- `to_html/2` — Render a markdown `body` to an HTML fragment.


### `ElixirMind.Orphans`

`lib/elixir_mind/orphans.ex`

Find docs with **no inbound internal link** — filed but never referenced from
another doc's prose.

An *inbound link* is an internal markdown link in some other doc that resolves
to the candidate (extraction and normalization are reused from
`ElixirMind.Links`, so this can't drift from the link-resolution check).

Two scoping decisions make the default output meaningful rather than noisy:

  * **`index.md` links don't count** by default. Every filed doc is listed in
    its directory's `index.md`, so counting those listings as inbound links
    would mask every real orphan. Pass `include_index: true` to count them.
  * **Anchored-by-design namespaces are not candidates** by default:
    `meta/threads/` (anchored by `pr:`) and `inbox/` (dated digests) are
    unreferenced on purpose, not orphaned. Pass `all: true` to include them.

A doc that links *out* but has nothing linking *in* is still an orphan — only
inbound edges matter here.

**Functions**

- `find/2` — Repo-relative paths (sorted) of candidate docs with no inbound link.


### `ElixirMind.Policy`

`lib/elixir_mind/policy.ex`

A governance policy: a `type: policy` OKF document under `meta/policy/`. Policies
are the *source of truth* for the operating contract; `CLAUDE.md` is compiled from
them (see `ElixirMind.Contract`).

Each policy declares which contract `section` it renders into and its `order`
within that section.

**Functions**

- `dir/0` — Directory (relative to repo root) holding policy documents.
- `load!/1` — Load and validate a single policy document.
- `load_all/1` — Load every active policy document, sorted by `(section, order, id)`. Raises if a document is missing a required field.

**Types**

- `t/0`


### `ElixirMind.Registry`

`lib/elixir_mind/registry.ex`

The stable-identity layer for the knowledge bundle.

Every bundle concept carries an opaque, immutable `id` in its frontmatter
(format `em:` + 6 lowercase hex chars). The per-file `id` is the **canonical**
data; `meta/registry.md` is a *compiled* id → path view (like `CLAUDE.md`),
regenerated via `mix brain.registry`. References between concepts — e.g.
`verified_by` — point at stable ids, so moving or renaming a file never
breaks an edge: only the registry view changes.

Scope: knowledge-bundle concepts only. Governance (`meta/`), skills
(`.claude/`), tooling (`lib/`, `test/`), the archive (`deprecated/`), and
reserved/root files (`index.md`, `log.md`, `README.md`, `CLAUDE.md`) are
outside the registry.

**Functions**

- `check/1` — Check the on-disk registry view matches a fresh render.
- `concept_paths/1` — All `.md` concept files in the bundle (relative paths), sorted.
- `id_format/0` — Regex a valid stable id must match.
- `index!/1` — Return a map of id => Entry. Raises if the bundle has scan errors.
- `mint/1` — Mint a fresh stable id, guaranteed not to collide with `taken` (a MapSet).
- `output_path/0` — Path of the compiled registry view, relative to repo root.
- `render/1` — Render the compiled id → path registry view.
- `scan/1` — Scan the bundle and return `{entries, errors}`. Entries are concepts that parsed cleanly (with or without an id); errors are human-readable strings for unparseable files and duplicate ids.
- `write/1` — Render and write the registry view. Returns the output path.


### `ElixirMind.RouteTags`

`lib/elixir_mind/route_tags.ex`

Verify route tags and the excerpt logs they materialize (the route-tagging
convention; see `meta/policy/route-tagging.md`).

A finalized thread body (under `meta/threads/`) carries `<routes ref="...">`
regions — per-paragraph, multi-ref, keyed on canonical ids. A **`em:` id** is
an aggregating sink: the concept it names carries the region in an append-only,
per-thread, date-stamped excerpt log (`## Thread excerpts — route-tagged log`).
A **path** ref (anything with a `/`) is a non-aggregating back-link and
accretes no log.

The log is a write-once materialization of the tags, so its freshness is
structural only if something re-derives it: this module re-derives each sink's
per-thread block from the current tags and reports divergence, converting the
guarantee from procedural (remember to append, remember to propagate a tag
correction) to structural. Tag *coverage* — whether every paragraph that feeds
a matter was tagged — has no mechanical oracle and stays editorial; a
routing-ledger cross-check lifts it to row granularity and reports (never
fails) at warn level.

Checks, in order:

- **tag wellformedness** — regions are line-anchored and outside fenced code,
  balanced, never nested, never crossing a `## User`/`## Assistant` turn
  boundary, and carry a non-empty ref set.
- **ref resolution** — every ref resolves: `em:` ids to a bundle concept (via
  the stable-id registry), path refs to files in the repository.
- **sink logs** — every concept sink referenced by a tagged thread carries a
  dated block for that thread in its route-tagged log section.
- **log fidelity** — each block matches its re-derivation from the current
  tags (count line, region order, full ref-sets, whole-region content with
  ATX headers demoted to bold); blocks naming threads that no longer tag the
  sink are orphans and fail.
- **ledger cross-check** (warn) — each tagged thread's routing-ledger rows
  that route to a concept sink are covered by at least one tag; threads with
  routing rows but no tags at all are reported once.

`materialize/1` projects the current tags into the sinks in both directions
— writing each fed sink's log section and removing the section from any sink
no longer fed — so the log is generated, not hand-kept; `run_checks/1` is
then the structural backstop that fails if the two ever diverge.

**Functions**

- `classify_ref/1` — Classify a ref. A `em:` id is an aggregating concept sink; anything else is treated as a path back-link (it must resolve to a file, and it accretes no log). There are deliberately only two kinds in this bundle — belief ids do not exist here.
- `demote_headers/1` — Demote ATX headers to bold, outside fenced code.
- `derive_block/3` — Re-derive sink `sink`'s dated block for a thread from its tagged regions: the `###` header, the count line, and each region lifted whole (ATX headers demoted to bold) under its full ref-set, in document order.
- `doc_refs/1` — Concept sinks (aggregating refs) of a region, in ref order.
- `ledger_doc_sinks/3` — Concept sinks a thread's routing ledger routes to, as `em:` ids: markdown links in the `Routed to` column that resolve to a bundle concept (via its stable id). Only the `## Routing` section's table rows count — a thread body may quote other pipe tables, and those are not the ledger. Bundle-absolute links (`/SWE/…`) and thread-relative links both resolve; links to non-concepts (`unrouted`, `index.md`, tooling) drop out because they carry no id.
- `materialize/1` — Project the current tags into the sinks, in both directions: regenerate every fed sink's route-tagged log section, and **remove** the section from any sink that carries one but is no longer fed by any thread (its tags vanished — the orphaned section goes with them, unconditionally; the PR diff is the review point). Returns the sorted list of concept paths (relative to `root`) that were rewritten. Run this after (re)placing tags so the log is generated rather than hand-kept; `run_checks/1` then guards it structurally.
- `parse_log_section/1` — Extract the route-tagged log section's per-thread blocks from a document. Returns `nil` when the document carries no log section, else a map of `thread_slug => block_lines` (from the `###` header to the section's end).
- `parse_regions/1` — Parse `<routes ref="...">` regions out of a markdown body.
- `run_checks/1` — Run all checks against the bundle at `root`. Returns results in check order; a check that cannot fully run because an earlier one failed is still reported, on whatever it could see.
- `scan_sinks/2` — All concept documents carrying a route-tagged log section, mapped `sb_id => %{path: rel, blocks: %{thread_slug => block_lines}}`.
- `scan_threads/1` — All finalized threads under `meta/threads/` (excluding `index.md`), parsed.

**Types**

- `result/0`
- `status/0`


### `ElixirMind.SessionInit`

`lib/elixir_mind/session_init.ex`

The session-init digest: a point-in-time scan of the brain's open work,
rendered as markdown for the operator's priority appraisal. Produced on
demand by the `/priorities` skill, which runs `mix brain.session_init` and
relays the output (it is no longer auto-injected at session start — the
SessionStart hook now only provisions the toolchain).

Four sources, all already maintained by existing policy:

  * **Open issues** — `meta/issues/*.md` with `status: open`.
  * **Open todos** — `meta/todos/*.md` with `status: open`.
  * **Active plans** — `meta/plans/*.md` with `status` in
    `proposed` / `accepted` / `in-progress`.
  * **Dangling strands** — routing-ledger rows in `meta/threads/*.md` whose
    state is `open`/`paused`, or whose Dangling column carries a question
    (a `closed` row can still leave deferred work dangling).

Plus, when any exist, the **docs-freshness warnings** from
`ElixirMind.Links` (unresolved internal links, index-coverage gaps) — the
digest is the surface an app-based operator actually sees, so advisory
warnings that would otherwise live only in gate output and CI logs are
repeated here. The section is omitted entirely when the tree is clean.

The digest ends with a heuristic top-3 priority ranking (issues, then
in-flight plans, then open todos, then accepted plans, then open strands,
then paused strands and leftover dangling questions, then proposed plans;
newer first within a class) and an
agent note asking the agent to state its own top-3 appraisal, using the
heuristic as a starting point — the script ranks, the agent judges.

An issue/todo/plan may carry an explicit `priority: <integer>` frontmatter
key (1 = most urgent). Flagged items rank above every heuristic class,
ordered among themselves by the integer — the operator's escape hatch when
the class weights get it wrong. Strands come from ledger rows, which have
no frontmatter, so they cannot be flagged.

Tolerant consumer per OKF conformance: unparseable files and malformed
ledger rows are skipped, never fatal.

**Functions**

- `active_plans/1` — Plans under meta/plans that are proposed/accepted/in-progress, newest first.
- `dangling_strands/1` — Routing-ledger rows across meta/threads that still carry work: state `open`/`paused`, or a non-`-` Dangling cell. Newest thread first.
- `open_issues/1` — Open issues under meta/issues, newest first.
- `open_todos/1` — Open todos under meta/todos, newest first.
- `report/1` — Render the full session-init digest for the bundle rooted at `root`.


### `ElixirMind.Site`

`lib/elixir_mind/site.ex`

Static-site generator for the knowledge bundle.

Renders the OKF bundle into a self-contained, navigable HTML site suitable for
GitHub Pages: one page per concept (and per `index.md`/`log.md`/doc), a sidebar
that mirrors the directory taxonomy, per-concept metadata panels (type, tags,
verification, evidence edges and their reverse), and a client-side search index.

Like the other `mix brain.*` tools it is **dependency-free** — it reuses
`ElixirMind.Frontmatter` and `ElixirMind.Markdown` and the standard library
only, so `mix brain.site` runs offline in CI and any sandbox.

All internal links are **relative** (each page carries a `root_prefix` computed
from its depth), so the site works both at a domain root and under a project
subpath like `/elixir-mind/` without configuration.

**Functions**

- `build/2` — Build the site from `root` into `out_dir`. Removes and recreates `out_dir`, then writes every page plus `assets/` and `search-index.json`. Returns the number of pages written.
- `default_out/0` — Default output directory (relative to repo root).

**Types**

- `page/0`


### `ElixirMind.Site.Assets`

`lib/elixir_mind/site/assets.ex`

Static assets (CSS + JS) for the generated site, kept as string constants so the
generator stays dependency-free and produces a fully self-contained bundle.

**Functions**

- `css/0` — The site stylesheet.
- `js/0` — The site client script (search, theme toggle, mobile nav, tag filter).


### `ElixirMind.SiteConfig`

`lib/elixir_mind/site_config.ex`

Deploy-time configuration for the published site: the canonical **base URL** the
bundle is served from, and the bundle-path → live-URL mapping derived from it.

This is the single source of truth for *where the bundle is published*. The base
URL is read from application config (`config/config.exs`), falling back to the
GitHub Pages default so the tooling still runs in a bare checkout:

    config :elixir_mind, site_base_url: "https://ob6to8.github.io/elixir-mind/"

Consumers:

  * `ElixirMind.Contract` expands the `{{site_base_url}}` token in policy bodies
    when compiling `CLAUDE.md`, so the contract states one config-driven URL.
  * `ElixirMind.Site` expands the same token when rendering pages, and reuses
    `excluded_dirs/0` so "not rendered → no live URL" stays consistent.
  * `mix brain.url` prints `live_url/1` for a bundle path.

Change the deploy location (e.g. a custom domain) in one place — the config — then
re-run `mix brain.contract` and `mix brain.site`.

**Functions**

- `base_url/0` — The canonical base URL the site is published under, normalized to a single trailing slash. Reads `:elixir_mind, :site_base_url`, defaulting to the GitHub Pages URL.
- `excluded_dirs/0` — Top-level directories the site excludes (no page, no live URL).
- `expand_tokens/1` — Expand deploy tokens in a markdown body. Currently `{{site_base_url}}` → `base_url/0`. Applied by both the contract compiler and the site renderer so the one config value reaches every rendered surface.
- `live_url/1` — Map a bundle path to its page on the deployed site.
- `repo_url/0` — The repository's home on GitHub (no trailing slash), for PR/commit links in generated views. Reads `:elixir_mind, :repo_url`; `nil` when unconfigured (consumers then render plain `PR #N` text instead of links).


### `ElixirMind.Verifier`

`lib/elixir_mind/verifier.ex`

Machine checks over the knowledge bundle's identity and verification layer.

Rules enforced (each violation is a human-readable error string):

  1. Every bundle concept has parseable frontmatter and a non-empty `type`
     (OKF conformance) — surfaced via `ElixirMind.Registry.scan/1`.
  2. Every bundle concept carries a stable `id` matching `em:[0-9a-f]{6}`;
     ids are unique.
  3. Every `verified_by` reference resolves to an existing id. (Targets are
     typically `source` captures, which are not themselves `verified` — they
     are trusted evidence, not verified statements.)
  4. Verification is only for agent-authored statements. A concept that stores
     a link (has a `resource`) is a capture and cannot be `verified: true`.
  5. `verified: true` requires evidence: a non-empty `verified_by`. A statement
     is never "grounded" by a `resource` of its own — storing a link proves
     nothing.
  6. The `verified` field (either value) may only appear on statement types
     (`claim`/`note`/`concept`) — captures, sources, and every other type
     omit it entirely.
  7. Every glossary term file (a bundle concept under `beliefs/glossary/`)
     carries a `sense` field classifying where the term's usage lives:
     `common` (portable — the wider world uses it this way), `repo` (this
     brain's own vocabulary), or `dual` (both senses, defined common-first).
     The field is not policed outside the glossary.
  8. `attribution` (see `ElixirMind.Attribution`) is well-formed wherever
     it appears — valid `when`/`channel`, non-empty `agent`, `why` per the
     backfill rule — `from` appears on governance docs only and every ref
     resolves, exempt files carry no attribution, and (once the backfill
     lands) every bundle concept and governance doc carries the field.

**Functions**

- `run/2`


## Mix tasks — `mix brain.*`

### `Mix.Tasks.Brain.Attribution`

`lib/mix/tasks/brain.attribution.ex`

The attribution layer's command surface (see `ElixirMind.Attribution` and
`meta/policy/resource-attribution.md`).

    mix brain.attribution [--channel CHANNEL] [--since YYYY-MM-DD]

List attributed docs, newest first: ingestion instant, channel, id/path,
and the recorded why. The operator's post-auto-intake editorial pass is
`mix brain.attribution --channel auto-intake --since <last-review-date>`.

    mix brain.attribution --backfill

One-shot reconstruction of `attribution` for docs that predate the policy
(see `ElixirMind.Attribution.Backfill` for the derivation rules). Files
already carrying the field are skipped; review the diff before committing.



### `Mix.Tasks.Brain.Codemap`

`lib/mix/tasks/brain.codemap.ex`

Compile the code map from the `@moduledoc`/`@doc`/`@typedoc` in each `lib/`
module — the code glossary of the tooling that sits alongside the bundle.

    mix brain.codemap          # render and write meta/code-map.md
    mix brain.codemap --check  # verify the map is current (non-zero exit if stale)

Docstrings are the source of truth; this file is generated, on the same
`--check`-gated discipline as `mix brain.contract` and `mix brain.registry`.
Never hand-edit `meta/code-map.md` — edit the module's docstrings and regenerate.



### `Mix.Tasks.Brain.Contract`

`lib/mix/tasks/brain.contract.ex`

Compile the operating contract (`CLAUDE.md`) from its source documents.

    mix brain.contract          # render and write CLAUDE.md
    mix brain.contract --check  # verify CLAUDE.md is up to date (non-zero exit if stale)

`CLAUDE.md` is a generated artifact — never hand-edit it. Edit the source policy
documents under `meta/policy/` (or `meta/preamble.md`) and re-run this task.



### `Mix.Tasks.Brain.DedupProbe`

`lib/mix/tasks/brain.dedup_probe.ex`

Measure how well the bundle's mechanical search layer finds the concept a new
item should merge into, scored against the gold set in
`meta/evals/dedup-probe.md`.

    mix brain.dedup_probe                    # plain lexical recall
    mix brain.dedup_probe --expanded         # synonym-expanded recall (query + variants)
    mix brain.dedup_probe --update-baseline  # rewrite the committed ## Baseline, then report

Zero-dependency, fully offline, deterministic — makes no LLM calls. Prints a
per-row table over the `target` rows, the aggregate recall, the reported-not-
scored `negative`/`quarantine` rows, and the delta from the committed
`## Baseline`. Non-gating: recall is an editorial trend metric (like the
route-tags cross-check), so the task always exits 0 — read the trend, don't
block on it.

`--update-baseline` regenerates the gold doc's `## Baseline` table from a fresh
run (the baseline is generated, not hand-kept); the `/intake` skill runs it so
the recall figure and its git-history trend stay current with zero manual
upkeep.

See the [dedup-recall-probe plan](/meta/plans/dedup-recall-probe.md) and
`ElixirMind.DedupProbe`.



### `Mix.Tasks.Brain.DevHistory`

`lib/mix/tasks/brain.dev_history.ex`

Compile the dev-history view from the default branch's first-parent git
history — one section per merged PR, bulleted with the branch's commit
subjects. There is no hand-kept source: the commit graph is the data.

    mix brain.dev_history          # derive and write meta/dev-history.md
    mix brain.dev_history --check  # verify the view is consistent (lag-tolerant;
                                   # non-zero exit if hand-edited or diverged)

On a shallow clone the derivation would silently truncate, so `--check`
passes with a note and a plain run refuses to write.



### `Mix.Tasks.Brain.Evidence`

`lib/mix/tasks/brain.evidence.ex`

Render the evidence chain for a concept, derived live from frontmatter — the
bundle commits only the `verified_by` edges; the prose is generated on demand.

    mix brain.evidence em:4c9e1f
    mix brain.evidence SWE/version-control/git/some-concept



### `Mix.Tasks.Brain.Glossary`

`lib/mix/tasks/brain.glossary.ex`

Verify the glossary layer (see `ElixirMind.Glossary` and the
[glossary plan](/meta/plans/glossary-single-overview-and-dedup-check.md)): that
every term carries a non-empty `description` (its one canonical overview), that
the index `## Terms` section matches its re-derivation from the term files
(title-sorted, gloss = description verbatim), and — with a fail/warn split —
that no body sentence near-restates its entry's description.

    mix brain.glossary                # verify; exits non-zero on any failure
    mix brain.glossary --materialize  # regenerate the index `## Terms`
                                      # section, then verify

Warnings never fail the task; only `:fail` results do.



### `Mix.Tasks.Brain.Id`

`lib/mix/tasks/brain.id.ex`

Insert a freshly minted `id: em:xxxxxx` as the first frontmatter line of every
bundle concept that does not already carry one. Existing ids are never touched —
ids are immutable for the life of a concept.

    mix brain.id



### `Mix.Tasks.Brain.Lineage`

`lib/mix/tasks/brain.lineage.ex`

Derive the flow-lineage views from each `meta/flows/*.md` `lineage:` frontmatter
block: a per-doc blockquote (between `lineage:start`/`lineage:end` markers) and
the cross-flow flowchart index at `meta/flows/lineage.md`.

    mix brain.lineage                # materialize blockquotes + write the index
    mix brain.lineage --materialize  # same (explicit)
    mix brain.lineage --check        # verify the views are current (non-zero exit if stale)



### `Mix.Tasks.Brain.Orphans`

`lib/mix/tasks/brain.orphans.ex`

Report docs that nothing else links to — filed but never cross-referenced.

    mix brain.orphans                 # knowledge + governance docs, index listings ignored
    mix brain.orphans --include-index # also count links inside index.md listings
    mix brain.orphans --all           # include meta/threads/ and inbox/ (anchored by design)

By default `index.md` listings don't count as inbound links (every filed doc is
listed in one, which would hide every real orphan), and the anchored-by-design
namespaces `meta/threads/` and `inbox/` are excluded from candidates. See
`ElixirMind.Orphans` for the scoping rules. Read-only.



### `Mix.Tasks.Brain.Registry`

`lib/mix/tasks/brain.registry.ex`

Compile the registry view from the canonical per-file `id:` frontmatter.

    mix brain.registry          # render and write meta/registry.md
    mix brain.registry --check  # verify the view is current (non-zero exit if stale)



### `Mix.Tasks.Brain.RouteTags`

`lib/mix/tasks/brain.route_tags.ex`

Verify the route-tagging layer (see `ElixirMind.RouteTags` and
`meta/policy/route-tagging.md`): `<routes ref="...">` tag wellformedness, ref
resolution, that every tagged concept sink carries its dated block, that each
block matches its re-derivation from the current tags, and — at warn level —
that every concept-routed routing-ledger row is covered by a tag.

    mix brain.route_tags              # verify; exits non-zero on any failure
    mix brain.route_tags --materialize  # project tags into sinks (write fed
                                        # sections, remove unfed ones), then verify

Warnings never fail the task; only `:fail` results do.



### `Mix.Tasks.Brain.SessionInit`

`lib/mix/tasks/brain.session_init.ex`

Render the open-work digest a fresh session should start from.

    mix brain.session_init

Scans `meta/issues/` (status `open`), `meta/todos/` (status `open`),
`meta/plans/` (status `proposed` / `accepted` / `in-progress`), and the
`## Routing` ledgers under `meta/threads/` (rows in state `open`/`paused`,
or with a dangling question), then prints a markdown digest ending in a heuristic top-3
priority ranking. The SessionStart hook echoes this output into the
session's context so every thread opens against the same picture of the
brain's open work.



### `Mix.Tasks.Brain.Site`

`lib/mix/tasks/brain.site.ex`

Render the OKF bundle into a self-contained, navigable static site.

    mix brain.site              # build into _site/
    mix brain.site --out DIR    # build into a custom output directory

The output is dependency-free HTML/CSS/JS: a sidebar mirroring the directory
taxonomy, per-concept metadata panels (type, tags, verification, evidence edges),
and a client-side search index. All links are relative, so the site works at a
domain root or under a project subpath (e.g. `/elixir-mind/`). Deployed to
GitHub Pages by `.github/workflows/pages.yml`.



### `Mix.Tasks.Brain.Url`

`lib/mix/tasks/brain.url.ex`

Map a bundle path to its page on the deployed Pages site.

    mix brain.url knowledge/knowledge-management/open-knowledge-format.md
    mix brain.url /meta/policy/response-resource-links.md

The mechanical form of the response-resource-links policy: use it to cite a brain
resource by its live URL instead of hand-constructing one. The base URL comes from
config (`ElixirMind.SiteConfig.base_url/0`). Paths under non-rendered directories
(`deprecated/`, `.claude/`, `lib/`, `test/`, …) have no page and print a notice —
cite those by repo path.



### `Mix.Tasks.Brain.Verify`

`lib/mix/tasks/brain.verify.ex`

Run the machine checks over the knowledge bundle (see `ElixirMind.Verifier`):
OKF conformance, stable-id presence/uniqueness/format, `verified_by` edge
resolution, and grounding of every `verified: true`.

On a green bundle, also prints advisory docs-freshness warnings (see
`ElixirMind.Links`): internal links that don't resolve and index-coverage
gaps. Warnings never fail the task — broken links are tolerated per OKF
conformance, and index coverage is ultimately editorial.

    mix brain.verify



