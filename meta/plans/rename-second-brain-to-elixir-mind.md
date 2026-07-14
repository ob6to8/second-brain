---
type: plan
title: "Rename the brain: second-brain → elixir-mind (including sb: → em: id migration)"
description: Spec for renaming the repository and all associated naming from "second-brain" to "elixir-mind" — the GitHub repo, the Elixir app/module namespace, hooks, docs, prose, and (operator-directed rescope) the stable-id prefix sb: → em: as a bundle-wide namespace re-key that preserves every id's hex tail.
status: proposed
provenance: "Claude Code session, 2026-07-13 — operator asked to spec out the second-brain rename lift (initially targeting elixir-brain, later retargeted to elixir-mind); same session rescoped the plan to also migrate the id prefix sb: → em:, explicitly accepting the increased scope"
attribution:
  when: 2026-07-13T00:00:00Z
  channel: agent-authored
  agent: "Claude Code agent, elixir-mind rename-plan session"
  why: "persists the second-brain → elixir-mind rename spec (with the sb: → em: id migration) per the persist-plans policy"
  from: [/meta/threads/2026-07-13-elixir-mind-rename-plan-and-model-orchestration.md]
tags: [meta, plan, rename, identity, migration, tooling, governance]
timestamp: 2026-07-13
---

# Rename the brain: second-brain → elixir-mind

## The ask

The operator wants the repository and all associated naming moved from
**second-brain** to **elixir-mind** — including, per an explicit rescope, the
stable-id prefix: every `sb:` id becomes an `em:` id. (The target name was first
scoped as `elixir-brain`, then retargeted to `elixir-mind`; this plan reflects
the current target and supersedes the earlier one. The id prefix mirrors the
display name — **em:** for **e**lixir-**m**ind — at the operator's direction.
Because the migration rewrites every token in one deterministic pass, the
replacement string is free to choose: `em:` costs exactly what `eb:` would have,
so a mnemonic prefix is worth taking.) The original spec recommended keeping
`sb:` (opaque, immutable
per the stable-identity policy); the operator considered that and directed the
migration anyway, accepting the larger scope. The operator authors and ratifies
the policies, so this is a policy amendment plus a one-time migration, not a
violation — but the plan must carry both explicitly.

The lift is two workstreams:

- **Workstream A — the name rename** (repo, Elixir app, hooks, docs, prose):
  one mechanical in-repo PR plus minutes of operator action on GitHub.
- **Workstream B — the id namespace migration** (`sb:` → `em:`): a
  deterministic, bundle-wide token rewrite plus code/policy updates, in its own
  atomic PR.

Measured surface: `grep -ri 'second[-_ ]?brain'` finds **459 occurrences across
128 files** (workstream A; most frozen, generated, or category-term prose —
see below). For workstream B: **200 minted `id:` fields**, **~940 `sb:xxxxxx`
tokens** across the markdown corpus (beliefs 228, knowledge 242, meta 418,
inbox 43, `.claude` 3, `CLAUDE.md` 2, `deprecated/` 1), and **65 `"sb:"`
string sites** in `lib/` + `test/`.

## Inventory — where the names live

### Workstream A: "second-brain"

| Surface | What's there | Rename action |
|---------|--------------|---------------|
| **GitHub repo** | `ob6to8/second-brain` | Operator renames in repo Settings → `ob6to8/elixir-mind` (Phase 2) |
| **Elixir app** | `mix.exs` `app: :second_brain`; module namespace `SecondBrain` (~78 occurrences across `lib/` + `test/`); dirs `lib/second_brain/`, `test/second_brain/` | `:elixir_mind` / `ElixirMind` / `lib/elixir_mind/` / `test/elixir_mind/` — fully mechanical |
| **Mix tasks** | `mix brain.contract`, `brain.verify`, `brain.route_tags`, … | **Unchanged** — the task namespace is `brain.*`, not `second_brain.*`; skills and CI keep working. (Note: `brain.*` is domain-neutral and survives the brain→mind retarget too.) |
| **Session hook** | `.claude/hooks/session-start.sh`: log path `/tmp/second-brain-session-start.log`, two `second-brain:` message prefixes | Rename strings |
| **CI workflows** | `.github/workflows/ci.yml`, `pages.yml` | **No occurrences** — nothing to change |
| **Generated artifacts** | `CLAUDE.md` (title "Operating Contract — Second Brain (OKF)"), `meta/registry.md`, route-tag excerpt logs, `meta/flows/lineage.md` | Never hand-edited — edit sources (`meta/preamble.md`, policies), then regenerate (`mix brain.contract`, `brain.registry`, `brain.route_tags --materialize`, `brain.lineage --materialize`) |
| **Maintained docs (name-prose + code refs)** | `README.md`, root `index.md` (`# Second Brain`), `meta/preamble.md`, skill `SKILL.md`s, `meta/flows/*`, `meta/tutorials/*`, policy examples (e.g. route-tagging's `lib/second_brain/route_tags.ex` sample ref) | Update names and code paths |
| **Live code-identifier refs across *all* doc surfaces** | `SecondBrain.` module refs, `lib/second_brain/…` & `test/second_brain/…` paths, and `:second_brain` — appearing in **37 doc files** beyond the maintained-docs list above: `beliefs/glossary/*` (7) + `beliefs/glossary.md` + `beliefs/future-beliefs.md`, `knowledge/**` concept bodies, `meta/analysis/*` (3), `meta/issues/*`, `meta/evals/*`, `meta/elaborations/*`, `meta/plans/*` | **Grep is the worklist, not a file list** — update every live code-identifier occurrence (see Decision 6). These are pointers into moving code, distinct from name-prose |
| **Route-tag path refs in frozen threads** | `<routes ref="… lib/second_brain/….ex">` attributes inside `meta/threads/` docs; `mix brain.route_tags` **fails CI** if a path ref doesn't resolve to a file on disk | Update the `ref` attributes when `lib/` moves — see Decision 3 |
| **Filed concept slug + body** | `knowledge/SWE/testing/elixir-second-brain-testing-methodology.md` (`sb:d58da3`): the slug, the in-body `SecondBrain.Frontmatter`/`SecondBrain.Policy` module refs, and the "Second Brain testing methodology" display text in its 3 inbound links | Rename file, update body module refs and inbound display text; id survives — see Decision 4 |
| **GitHub Pages** | Site served at `ob6to8.github.io/second-brain/`; the site build uses relative URLs throughout (only doc comments mention the subpath) | No code change; URL moves to `…/elixir-mind/` on repo rename, **old Pages URL will 404** (Pages does not redirect) |
| **Environment / sessions** | Claude Code remote environment source and session repo scope pinned to `ob6to8/second-brain`; local clone dir `/home/user/second-brain` | Operator updates the environment source after the repo rename; git-level redirects cover existing clones/Routines in the interim |
| **Frozen / archival prose** | `meta/threads/` bodies, `deprecated/` (read-only), `inbox/` dated digests, `meta/analysis/` **name-prose** | Name-prose **not renamed** (workstream A) — but analysis's *live code pointers* are (see Decision 6 and scope boundaries) |

### Workstream B: the `sb:` id namespace

| Surface | What's there | Migration action |
|---------|--------------|------------------|
| **Minted ids** | 200 `id: sb:xxxxxx` frontmatter fields across the bundle | Rewrite prefix, **preserve the 6-hex tail**: `sb:4c9e1f` → `em:4c9e1f` |
| **Evidence edges** | `verified_by:` inline lists of `sb:` ids | Same prefix rewrite — edges stay internally consistent because tails are preserved |
| **Route tags** | `<routes ref="sb:…">` in thread docs (including frozen bodies); `SecondBrain.RouteTags.classify_ref/1` pattern-matches the `"sb:" <>` prefix at `lib/second_brain/route_tags.ex:222` | Rewrite tag refs; update the code clause to `"em:" <>` |
| **Id-format code** | `registry.ex` `@id_format ~r/^sb:[0-9a-f]{6}$/` + minting `"sb:" <> …`; `verifier.ex` format check + error message; `dedup_probe.ex` `~r/sb:[0-9a-f]{6}/`; `mix brain.id` / `brain.evidence` docs; ~65 `"sb:"` string sites in `lib/` + `test/` (fixtures, assertions) | Flip to `em:` in the same PR — the verifiers make a mixed state unrepresentable |
| **Dedup-probe gold set** | `meta/evals/dedup-probe.md` rows keyed on `sb:` acceptable-ids | Prefix rewrite; probe re-run as the check |
| **Policies & contract** | `stable-identity.md`, `verification-grounding.md`, `route-tagging.md`, `session-capture.md`, and every policy/skill doc describing "`sb:` + 6 hex chars" or "no `sb:` id" (governance namespaces) | Edit policy sources (see Decision 1's amendment), recompile `CLAUDE.md` |
| **Prose id mentions** | `sb:xxxxxx` tokens quoted in thread bodies, glossary *Seen in*/co-feeds lines, tutorials, flows, analyses, inbox digests, `deprecated/README.md` (1 token) | Global token rewrite per Decision 2; `deprecated/` excluded |
| **Git history & commit messages** | Old commits reference `sb:` ids | **Untouched** (history is never rewritten); the deterministic tail-preserving mapping means any historical `sb:X` reads as today's `em:X` |

## Decisions for ratification

**Decision 1 — migrate `sb:` → `em:` as a prefix swap, with a stable-identity
policy amendment (operator-directed).**
The original recommendation was to keep `sb:` — the stable-identity policy
makes ids opaque and immutable, and the prefix is a namespace token, not a
display name. The operator weighed that and directed the migration; that
ruling stands and this plan executes it. Two design choices make it safe:

- **Prefix swap, never re-mint.** Every id keeps its 6-hex tail:
  `sb:4c9e1f` → `em:4c9e1f`. The mapping is total, deterministic, collision-free
  (tails are already unique), and mechanically reversible. Cross-references
  (`verified_by`, route tags, gold set, prose citations) all stay consistent
  under one regex: `\bsb:([0-9a-f]{6})\b` → `em:$1`.
- **Amend the policy, don't silently break it.** `stable-identity.md` is
  reworded so the *tail* is the immutable identity and the *prefix* is the
  bundle's id namespace, changeable only by an operator-ratified, bundle-wide
  migration — and it records this 2026-07 migration as the instance. Ratifying
  this plan ratifies the amendment; the policy edit and recompiled `CLAUDE.md`
  ship in the migration PR.

The prefix is `em:` — chosen to mirror the display name (**e**lixir-**m**ind) at
the operator's direction. Nothing in the identity model requires this: the
prefix is opaque, and edges (`verified_by`) and route tags key on the full
token, not its meaning. But a mnemonic prefix is free here — the migration is
one tail-preserving regex regardless of the target string, so `em:` costs
exactly what an arbitrary two letters would. The amended policy still treats the
prefix as opaque; `em:` is a mnemonic convenience, not a semantic dependency
anything may rely on.

**Decision 2 — the token rewrite is global, including frozen thread bodies
and dated records (recommended: yes, with `deprecated/` excluded).**
`sb:` ids appear in *retained verbatim text* (e.g. the worked example quoting
`sb:d479e3` in the 2026-07-08 thread) and in dated `inbox/` digests, not just
in machinery. Leaving them would strand ~hundreds of permanently dangling
identifiers that no longer resolve to anything. Because the mapping is 1:1,
tail-preserving, and recorded in a single commit, rewriting the token inside
frozen prose is a namespace re-key, not a falsification of the record — the
freeze exists so the *content* of what was said survives, and `em:4c9e1f`
denotes exactly what `sb:4c9e1f` denoted. Ratifying this plan ratifies this
one-time freeze exception, scoped to the exact regex above and nothing else.
The alternative (machinery-only rewrite, prose keeps `sb:`) preserves
byte-level freeze purity at the cost of a permanently split id space; not
recommended. **`deprecated/` stays untouched** (read-only archive; its single
token remains a legible fossil given the deterministic mapping).

**Decision 3 — update `<routes>` path refs inside frozen thread docs
(recommended: yes).**
Moving `lib/second_brain/` breaks path back-links like
`<routes ref="lib/second_brain/session_init.ex">` in `meta/threads/`, and
`mix brain.route_tags` fails CI on unresolved refs. Route tags are machinery
applied *over* the frozen body, not part of it — updating a tag's `ref`
attribute (and re-running `--materialize`) is maintenance of the routing
layer. (With Decision 2 ratified, the sink-id side of these refs is being
rewritten anyway.) The alternative — an alias map in the verifier — adds
permanent complexity to serve one rename. **Update the ref attributes.**

**Decision 4 — rename the one filed concept whose slug carries the name, and
fix its body and inbound links (recommended: yes).**
`knowledge/SWE/testing/elixir-second-brain-testing-methodology.md` names *this
project*. Per the identity policy, identity survives refactors: rename to
`elixir-mind-testing-methodology.md`, keep the id (tail `d58da3`), and
regenerate the registry. Beyond the slug, this file also needs its **body** and
its **inbound links** updated — the concept body references `SecondBrain.Frontmatter`
and `SecondBrain.Policy` (code identifiers that move in Workstream A), and three
sibling docs (`unit-vs-integration-purity-and-extent.md`,
`how-to-test-features-not-code.md`, `knowledge/SWE/testing/index.md`) link it
with the display text "Second Brain testing methodology" (proper-noun → "Elixir
Mind testing methodology") plus the old slug in the path. By contrast,
`meta/analysis/comparison-with-the-2026-second-brain-field.md` keeps its **name**
— there "second brain" is the product category being compared against, not this
repo — but its live code pointers still move under Decision 6.

**Decision 5 — prose policy: proper noun vs. category term.**
Where "Second Brain" names *this repo* (README title, root `index.md` heading,
`meta/preamble.md` title, hook messages), it becomes **Elixir Mind** /
**elixir-mind**. Where "second brain" is the *category* ("a personal second
brain stored as an OKF bundle", the field-comparison analysis, glossary
definitions of the concept), the recommendation is to keep the category term —
the repo is still *a* second brain; it is just no longer *named* that. The
retarget to "mind" makes this cleaner than "brain" would have: "mind" is not
the category word at all, so there is zero collision between the new proper
noun and the standing "second brain" category term. The preamble's opening
line can carry both: "…a personal second brain … named **elixir-mind**."
Operator may instead direct a full prose sweep; that widens the diff into
policy/tutorial prose but changes nothing structural.

**Decision 6 — sweep live code identifiers everywhere, separately from
name-prose (recommended: yes).**
The rename has *two* targets that must not be conflated: the **display name**
("Second Brain" → "Elixir Mind"), governed by Decision 5's proper-noun/category
split; and the **code identifiers** — `SecondBrain.` module refs,
`lib/second_brain/…` & `test/second_brain/…` paths, and the `:second_brain` app
atom — which are *live pointers into the code Workstream A moves*. A stale code
pointer is a dangling reference, not preserved history, so it must move wherever
it is live. An audit finds these identifiers in **37 doc files**, well beyond the
maintained-docs list: `beliefs/glossary/*` and the glossary hub/index,
`beliefs/future-beliefs.md`, `knowledge/**` concept bodies (including the
Decision 4 file), `meta/analysis/*`, `meta/issues/*`, `meta/evals/*`,
`meta/elaborations/*`, and `meta/plans/*`.

- **The sweep is grep-defined, not file-list-defined.** The 1a docs step targets
  every live occurrence of the three identifier forms across all non-frozen,
  non-`deprecated/` surfaces; the residue grep (1a.8) is the completeness oracle.
- **Name-prose vs. code-pointer, per surface.** In `meta/analysis/` and other
  point-in-time docs, the *prose* ("the second-brain field") stays under
  Decision 5, but the *code links* (`lib/second_brain/contract.ex`, `SecondBrain.*`)
  are updated. This resolves the otherwise-contradictory "analysis is frozen"
  boundary: analysis name-prose is frozen, its code pointers are not.
- **Frozen thread bodies are the one exception.** Prose code mentions inside the
  verbatim `## User`/`## Assistant` render of `meta/threads/` bodies stay as
  historical record (the path was accurate when said); only the `<routes>` ref
  attributes are repointed (Decision 3). A tolerated stale mention in frozen
  conversation is not the same as a live pointer in a maintained doc.

## Scope boundaries — what does not change

- **Id tails.** All 200 six-hex tails survive verbatim; no id is re-minted,
  retired, or reused. Only the two-character namespace prefix changes
  (`sb:` → `em:`); the identity that must not change is the tail.
- **`mix brain.*` task names** — already repo-name-agnostic and domain-neutral.
- **Frozen retained text** in `meta/threads/` bodies, beyond the two ratified
  exceptions: the Decision 2 id-token regex and the Decision 3 `<routes>` ref
  attributes. Prose mentions of "second brain", old URLs, quoted commit
  messages, and **prose code mentions** (`lib/second_brain/…`, `SecondBrain.*`
  in the verbatim render) stay verbatim — a stale pointer in frozen conversation
  is tolerated (Decision 6), unlike a live pointer in a maintained doc.
- **Name-prose** ("second brain" the category, per Decision 5) across all
  surfaces — only *code identifiers* move in maintained/analysis docs
  (Decision 6), not the category term.
- **`deprecated/`** — read-only archive; not part of the bundle; excluded from
  both workstreams (its one `sb:` token and its prose stay).
- **Git history, cited SHAs, PR numbers** — untouched; GitHub repo renames
  preserve issues/PRs and redirect `github.com/ob6to8/second-brain/…` web URLs
  and git remotes, so `pr:` anchors in thread frontmatter keep resolving.
  Historical commit messages keep `sb:` tokens; the migration commit message
  states the mapping rule so they stay interpretable.
- **CI workflow files** — contain no repo-name references.

## Build order

**Phase 0 — ratify.** Operator approves this plan; ratification covers the
stable-identity amendment (Decision 1), the frozen-body exceptions
(Decisions 2–3), and the name-prose/code-identifier split (Decisions 5–6). Plan
`status` → `accepted`.

**Phase 1a — name rename PR (workstream A, one session).**

1. `mix.exs`: `SecondBrain.MixProject` → `ElixirMind.MixProject`,
   `app: :second_brain` → `app: :elixir_mind`.
2. `git mv lib/second_brain lib/elixir_mind`,
   `git mv test/second_brain test/elixir_mind`; sweep
   `SecondBrain` → `ElixirMind` and `second_brain` → `elixir_mind` across
   `lib/` and `test/` (~78 module references plus path strings in moduledocs).
3. `.claude/hooks/session-start.sh`: log path and message prefixes.
4. **Name-prose sweep** (Decision 5): rename proper-noun uses of "Second Brain"
   in `README.md`, root `index.md`, `meta/preamble.md`, `.claude/skills/*/SKILL.md`,
   `meta/flows/*.md`, `meta/tutorials/*.md`, `meta/policy/*` — leaving the
   "second brain" category term.
5. **Code-identifier sweep** (Decision 6): update every live occurrence of
   `SecondBrain.`, `lib/second_brain/…`, `test/second_brain/…`, and `:second_brain`
   across **all** non-frozen, non-`deprecated/` surfaces — the maintained docs
   above *plus* `beliefs/glossary/*`, the glossary hub/index, `beliefs/future-beliefs.md`,
   `knowledge/**` bodies, `meta/analysis/*` (code pointers only; name-prose stays),
   `meta/issues/*`, `meta/evals/*`, `meta/elaborations/*`, `meta/plans/*`. The grep
   (`SecondBrain\.|lib/second_brain|test/second_brain|:second_brain`) is the
   worklist (~37 doc files today), not a fixed file list.
6. Decision 4: rename the testing-methodology file, fix its body module refs and
   the three inbound links' display text + paths.
7. Frozen-thread `<routes>` path-ref sweep (Decision 3).
8. Regenerate: `mix brain.contract`, `brain.registry`,
   `brain.route_tags --materialize`, `brain.lineage --materialize`. Hand-edit
   none of them; if a materialized surface still shows an old path, fix the
   *tag*, not the log.
9. Full gate suite (see below); **two residue checks**:
   (a) code identifiers must be gone —
   `grep -rIn -E 'SecondBrain\.|lib/second_brain|test/second_brain|:second_brain'
   --include='*.md' . | grep -vE 'meta/threads/|deprecated/'` expects **zero**
   (frozen-thread prose code mentions are the only tolerated live-tree residue);
   (b) `grep -ri 'second[-_ ]?brain' --exclude-dir=deprecated --exclude-dir=_build .`
   — every remaining hit must be an intentional keep (frozen prose, category-term
   prose, dated records, this plan).
10. PR, true merge, delete the head branch.

**Phase 1b — id migration PR (workstream B, one session, after 1a merges).**
Atomic by construction: the verifiers reject any mixed `sb:`/`em:` state, so
every step lands in one PR.

1. Code flip: `registry.ex` (`@id_format`, minting), `verifier.ex` (format
   check + message), `dedup_probe.ex` (extraction regex), `route_tags.ex`
   (`classify_ref` clause + docs), `mix brain.id`/`brain.evidence` task docs,
   and the ~65 `"sb:"` sites in `lib/` + `test/` (fixtures and assertions
   included). (These live under `lib/elixir_mind/` once 1a has merged.)
2. Policy amendment: reword `stable-identity.md` (tail = immutable identity;
   prefix = ratified-migration-only namespace; record this migration); update
   `sb:`-prefix mentions across `meta/policy/*` and `.claude/skills/*/SKILL.md`.
3. Global token rewrite, one deterministic pass:
   `\bsb:([0-9a-f]{6})\b` → `em:$1` over all `*.md` excluding `deprecated/`
   and `_build/` — covers the 200 `id:` fields, `verified_by` lists, route-tag
   refs, gold set, glossary citation lines, and prose mentions (Decision 2).
4. Non-hex prose forms by hand: "`sb:` + 6 hex chars"-style descriptions in
   policies/docs the regex deliberately doesn't match.
5. Regenerate: `mix brain.contract`, `brain.registry`,
   `brain.route_tags --materialize`, `brain.lineage --materialize`.
6. Full gate suite; `mix brain.dedup_probe` re-run (report-only) to confirm
   the gold set survived; residue checks
   `grep -rEn 'sb:[0-9a-f]{6}' --exclude-dir=deprecated --exclude-dir=_build .`
   (expected: zero) and a `` `sb:` `` prose grep (expected: only historical
   references *about* the migration, e.g. this plan).
7. PR, true merge, delete the head branch. The migration commit message states
   the mapping rule (`sb:X → em:X`, tails preserved) for readers of old
   commits.

**Phase 2 — GitHub rename (operator, after Phase 1a merges; 1b need not
wait for it).**

1. Repo Settings → rename to `elixir-mind`. Git remotes and web URLs
   redirect; Actions, branch protection, and Pages settings carry over.
2. The Pages site redeploys on the next push at
   `ob6to8.github.io/elixir-mind/`; the **old Pages URL 404s** (no redirect
   at the Pages layer) — update any external bookmarks. Old-URL mentions
   inside frozen threads stay as historical record.
3. Update the Claude Code environment source / session repo scope to
   `ob6to8/elixir-mind`; existing Routines keep working through git
   redirects in the interim but should be re-pointed when convenient.
4. Optionally re-point local clones: `git remote set-url origin
   git@github.com:ob6to8/elixir-mind.git` (redirects make this non-urgent).

**Phase 3 — post-rename verification (first session in the renamed repo).**
Confirm: session hook provisions and prints the new name; CI and the Pages
deploy are green; the site serves at the new URL; `mix brain.verify`,
`brain.route_tags`, and `brain.dedup_probe` pass; `mix brain.id` mints `em:`
ids for a scratch concept. File an `issue` for anything that slipped.

**Gate suite (both PRs):** `mix compile --warnings-as-errors`,
`mix format --check-formatted`, `mix test`, `brain.contract --check`,
`brain.registry --check`, `brain.verify`, `brain.route_tags`,
`brain.lineage --check`, `brain.site`.

## Risks & notes

- **Atomicity is load-bearing in both PRs.** In 1a the route-tags verifier
  fails on unresolved path refs; in 1b the id-format verifiers fail on any
  surviving `sb:` id. This is a feature: a partial migration cannot merge
  green.
- **The rewrite regex is the safety boundary.** `\bsb:([0-9a-f]{6})\b`
  matches only prefixed six-hex tokens — it cannot touch prose words, code
  identifiers, or the bare letters "sb". Step 1b.4 handles the descriptive
  prose forms by hand precisely so the mechanical pass can stay narrow.
- **New-id minting must flip in the same PR as the corpus** (`registry.ex`),
  or a concurrent session could mint a stale `sb:` id. Freeze other filing
  sessions while 1b is open, or rebase them across it.
- **Old Pages URL breakage is permanent** — the only non-redirected surface.
- **A future re-clone under the old name** (stale environment config) works
  via GitHub's redirect but yields a dir named `second-brain`; harmless —
  nothing depends on the directory basename.
- **Sweep discipline:** workstream A's name appears in four casings
  (`second-brain`, `second_brain`, `SecondBrain`, `Second Brain`); the
  residue greps in 1a.9 and 1b.6 are the completeness oracles, with the scope
  boundaries above as the keep-list. Note the keep-list distinguishes
  *name-prose* (kept) from *code identifiers* (moved) — see Decision 6.

## Estimate

Two focused sessions for Phase 1 (one per PR): 1a hand-edits roughly the
Elixir tree (mechanical), one hook, a name-prose sweep of the maintained docs,
a code-identifier sweep across **~37 doc files** (Decision 6 — mostly
mechanical `SecondBrain`/`lib/second_brain` substitutions), the Decision 4 file
rename, and ~10 thread-doc `<routes>` ref sweeps; 1b is one code flip
(~10 files), one policy amendment pass, one deterministic corpus rewrite
(~940 tokens), and regeneration. Phases 2–3 are minutes of operator action plus
one verification session.
