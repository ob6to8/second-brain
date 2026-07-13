---
id: sb:0b648f
type: concept
title: Glossary
description: Hub for the cross-domain glossary — one concept file per term under /beliefs/glossary/, accreted from threads, papers, and posts by /add-to-glossary.
provenance: "Agent-distilled definitions; each term's file cites the sources it was seen in"
verified: false
tags: [glossary, terminology, cross-domain]
timestamp: 2026-07-13
attribution:
  when: 2026-07-10T22:24:41+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
---

# Glossary

The hub for the brain's cross-domain glossary. **Each term is its own concept
file under [`/beliefs/glossary/`](/beliefs/glossary/index.md)** — with its own `sb:` id,
frontmatter, and *Seen in:* citations — so every definition is individually
linkable: cite a term anywhere (a response, another concept, a thread) as a
bundle-absolute link like `[route tag](/beliefs/glossary/route-tag.md)` and the link
lands on the definition.

Entries are accreted by
[`/add-to-glossary`](/.claude/skills/add-to-glossary/SKILL.md) from persisted
threads, papers, posts, and filed concepts — one file per term, listed
alphabetically in [`/beliefs/glossary/index.md`](/beliefs/glossary/index.md). A term whose
canonical definition lives in a filed concept (or in the operating contract)
gets a [pointer entry](/beliefs/glossary/pointer-entry.md), not a duplicate
definition; a term that outgrows the glossary
[graduates](/beliefs/glossary/graduation.md) into the domain taxonomy, its id
travelling with it.

Every term is classified by **where its usage lives** — a `sense` frontmatter
field, gated by `mix brain.verify`: `common` (portable — industry, field, or
ecosystem vocabulary that means the same thing outside this repo), `repo`
(this brain's own vocabulary — coined here or naming local machinery), or
`dual` (an established common sense *plus* a specific repo referent). Dual
entries define the common sense first, then the local one in an **In this
brain:** passage, so local jargon never silently displaces the portable
meaning. Querying the `repo` and `dual` subset answers "which terms here mean
something non-standard?" — the local-jargon primer. The convention is defined
in the [`/add-to-glossary` skill](/.claude/skills/add-to-glossary/SKILL.md); the
decision record is the
[glossary sense-disambiguation plan](/meta/plans/glossary-sense-disambiguation.md).

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="sb:0b648f">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-10-add-to-glossary-skill-and-pr-wiring (2026-07-10)

2 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`sb:0b648f`]**  (co-feeds: `.claude/skills/add-to-glossary/SKILL.md`)

Built and pushed. The `/add-to-glossary` skill now exists on `claude/add-to-glossary-skill-jz1ewh` (commit `f45940f`), with all verifiers green (`brain.verify`, `brain.route_tags`, contract check, 78 tests passing).

**What it does** (`.claude/skills/add-to-glossary/SKILL.md`): you point it at a persisted thread under `meta/threads/`, a paper or post (URL, pasted text, or PDF), or an already-filed concept. It extracts the technical terms the source actually uses — same selection bar as `/summarize-technical`'s key-terms section, so incidental nouns don't qualify — and merges one-to-three-sentence definitions into a single running glossary at the bundle root.

**Key design decisions**, since your proposal left a couple open:

- **`glossary.md`, not `glossary.json`.** The glossary is a bundle concept like any other (`type: concept`, id `sb:0b648f`), so it flows through `mix brain.verify`/`registry` and the site renderer. JSON would sit outside all of that; the entry structure (alphabetical `##` headings + a *Seen in:* citation line) is regular enough to parse mechanically if tooling ever wants it.
- **One glossary, cross-domain, at the bundle root** — listed under a new "Cross-domain" heading in the root `index.md`. A term seen in three threads and a paper gets one entry with four citations, which is the thing `/summarize-technical`'s per-document glossaries can't give you.
- **Pointer entries instead of duplicates.** A term already canonically defined by a filed concept (or by the operating contract itself, like *route tag*) gets a one-line gloss plus a link, honoring update-in-place/don't-fragment.
- **A graduation path.** When an entry outgrows a few sentences it gets filed as a proper concept via `/intake` and the glossary entry shrinks to a pointer — the glossary is a staging layer, not a terminal home.
- The whole doc stays `verified: false` (agent-authored definitions); individual claims can graduate and get grounded through the normal `verified_by` machinery.

The skill is registered in `meta/policy/skills-registry.md` with `CLAUDE.md` re-rendered via `mix brain.contract`, the empty glossary scaffold is seeded, and both `log.md` and `meta/log.md` carry dated entries. The glossary has no entries yet — a natural first run would be `/add-to-glossary` on the 2026-07-05 bootstrap thread. I didn't open a PR since you didn't ask for one; say the word (or `/create-pull-request`) and I will.

---

**[`sb:0b648f`]**  (co-feeds: `.claude/skills/add-to-glossary/SKILL.md`)

Done — restructured and pushed (commit `b61ee57`, now part of PR #35). Each glossary term is its own concept file under `/glossary/`, so I can now cite definitions exactly the way you described: a response can link [route tag](/glossary/route-tag.md), [pointer entry](/glossary/pointer-entry.md), or [verified_by](/glossary/verified-by.md), and clicking lands on the definition — on GitHub and on the Pages site alike.

How the pieces landed:

- **Seven term files** under `/glossary/`, each a full bundle concept with its own minted `sb:` id, frontmatter, definition, and *Seen in:* citations. `glossary/index.md` lists them alphabetically with one-line descriptions.
- **`/glossary.md` stayed, repurposed as the hub.** It couldn't simply be deleted: it's `sb:0b648f`, the route-tag sink for this session's thread, and it carries the generated excerpt log — ids are immutable and the verifier re-derives that log. So it now describes the system and points into the directory, and all existing links to it still resolve.
- **Graduation got more elegant.** Since every term is already a concept, an outgrown term no longer needs re-filing via `/intake` — the file just *moves* into the domain taxonomy, its id travels with it, and a pointer stub stays at `/glossary/<slug>.md` so old glossary links keep landing somewhere useful.
- **The `/add-to-glossary` skill** was updated to the per-term model (kebab-slug files, per-file merge rules, index upkeep) and gained a "Citing terms in responses" section: link a term's first use in a response, not every occurrence. The skills-registry policy, `CLAUDE.md`, `/create-pull-request`'s step 2, the root `index.md`, and the registry are all in sync, and every gate passes (verify, route tags, contract/registry checks, 78 tests).

One governance note: `glossary/` is a new top-level directory, which the taxonomy protocol normally has me propose rather than create — your message was the proposal and direction here, and the whole shape ships in PR #35 for you to ratify or push back on in review. From here on, just ask for "glossary links" in any answer and I'll cite terms inline; anything I define along the way can be `/add-to-glossary`'d into its own linkable file.

### 2026-07-11-doctrine-vs-policy-and-glossary-cross-linking (2026-07-11)

3 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`sb:0b648f`]**  (co-feeds: `.claude/skills/add-to-glossary/SKILL.md`)

**Cross-linking similarity between glossary terms**

**Yes — two mechanisms exist today, and I used both in the new entry:**

1. **Inline markdown links between term files.** Since every term is its own concept file, any entry can link related terms by bundle-absolute path — the new `policy (type)` entry links to `plan-type`, `issue-type`, `methodology-type`, and `operating-contract` right in its "distinct from…" sentence. These are untyped edges where the prose carries the meaning (per the cross-linking policy), and they render as clickable links on GitHub and the Pages site. Several entries already do this organically (e.g. `skill.md` → `session-capture.md`).
2. **Shared frontmatter tags.** Entries carry tags like `[glossary, types, governance]`, so related clusters are already greppable/queryable (`policy-type`, `plan-type`, `issue-type` all share `types, governance`).

**What doesn't exist yet:** a *structured* similarity edge — e.g. a `related:` frontmatter field holding `sb:` ids, analogous to `verified_by`, that tooling could traverse to render a "See also" block per entry. That would be a new typed edge, which under the stable-identity policy is a change to the brain's shape — so I'm proposing it rather than building it. If you like it, the design would be: `related: [sb:bf0524, sb:e9a82b]` on each term file, symmetric-checked by `mix brain.verify`, rendered as a *See also:* line. A lighter alternative is a plain *See also:* prose line convention added to the `/add-to-glossary` skill — no tooling change at all. Say the word on either and I'll build it.

---

**[`sb:0b648f`]**  (co-feeds: `.claude/skills/add-to-glossary/SKILL.md`)

**My recommendation: *See also* — not `related:`, not neither**

**A prose *See also:* line, added as a convention in the `/add-to-glossary` skill, used sparingly.** Reasoning:

**Against `related:` (the typed edge):** the brain's own identity policy reserves typed frontmatter edges for relations tooling actually traverses with semantics — `verified_by` earns that because verification is machine-checked and evidential. Term similarity is editorial and fuzzy: there's no oracle for whether `embeddings` is "related enough" to `recall@k`, so a verifier could only check that ids resolve and edges are symmetric — enforcement overhead without enforcing the thing that matters. It would also be the first typed edge added for human navigation rather than machine meaning, which dilutes the distinction the contract draws between typed edges (ids, tooling) and prose links (untyped, meaning in the prose).

**Against neither:** inline links inside definitions are the *best* form of cross-linking — "distinct from a [plan](/glossary/plan-type.md)…" tells you *why* they're related — but they only work when the relationship fits a natural sentence. Genuinely adjacent clusters (`recall` / `recall probe` / `recall@k`, or `doctrine` / `policy` / `operating contract`) sometimes have members with no prose-worthy sentence connecting them, and those associations currently just get dropped.

**So: *See also*, with a preference order.** The convention I'd codify in the skill: weave a link into the definition prose when you can state the relationship (first choice); fall back to a `*See also:*` line after the *Seen in:* line only for real adjacency that prose can't carry; never list more than 3–4 terms. Zero tooling change, follows the existing cross-linking policy (untyped markdown links, broken links tolerated), renders fine on GitHub and the Pages site, and it can always be upgraded to a `related:` typed edge later if tooling ever wants to traverse it — the reverse migration is much more annoying.

Adding that convention is a one-paragraph edit to the `/add-to-glossary` skill (a shape change, so this reply is the proposal). Say the word and I'll codify it and push to the same branch.

---

**[`sb:0b648f`]**  (co-feeds: `.claude/skills/add-to-glossary/SKILL.md`)

Done — the convention is codified and pushed (`1f13ffc`, all verifiers and 78 tests green).

What landed:

- **The `/add-to-glossary` skill** now carries the cross-linking rule in its merge step: link related terms **in the definition prose** whenever the relationship can be stated ("distinct from a [plan](…)…"); fall back to a `*See also:*` line — placed after *Seen in:*, capped at 3–4 term links — only for genuine adjacency that no sentence connects. These stay ordinary untyped prose links per the cross-linking policy; deliberately not a `related:` frontmatter field, which stays reserved for machine-traversed edges like `verified_by`.
- **First application, on the recall cluster:** `recall probe` and `recall@k` already named each other in prose, so those mentions became inline links; `recall` got the glossary's first *See also:* line (recall probe, recall@k, semantic search) plus an inline link to `deduplication`, which its prose already referenced.
- The root `log.md` records the ratified convention, and the touched entries' timestamps are bumped.

The branch now holds three commits: the `policy (type)` entry, the `doctrine` entry, and this convention. Say the word if you want a PR opened (`/create-pull-request` will also capture this session and glossary it in the same PR).

### 2026-07-11-glossary-backfill-from-thread-docs (2026-07-11)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`sb:0b648f`]**  (co-feeds: `.claude/skills/add-to-glossary/SKILL.md`)

**Approach:** four parallel Explore subagents read the 12 threads and extracted candidate terms (source-independent definitions + pointer targets), so I could dedup across threads before writing — a term seen in three threads gets **one** file with three citations, not three files. I then generated all entries from a single controlled script to keep the format byte-identical to the existing entries.

**Result — glossary grew from 7 → 68 terms:**
- **46 new term files** across scheduling/automation (Routine, cron expression, fresh-session-per-fire, approval gate), the news inbox (query profile, candidate feed, digest), flows & testing (flow/touch-sequence, scenario test, deterministic spine, golden test, ExUnit, property-based testing), the site generator (static-site generator, dependency-free, markdown renderer, GitHub Pages, deploy gating, HTML escaping, XSS, GFM), retrieval (recall, dedup, recall probe, recall@k, vector database, embeddings, semantic search, ANN), Composable Beliefs/epistemics (typed edge, epistemic overlay, supersession, proto-belief document, route-tag sink), and skills (namespacing, delegation, plugin).
- **15 pointer entries** that defer to the canonical policy/skill docs (routing ledger, session capture, provenance, verification grounding, reason tags, featuring, the `issue`/`analysis`/`methodology`/`plan`/`tutorial` types, etc.) instead of duplicating definitions.
- **6 existing entries** got *Seen in:* citations appended for the threads that also used them.

### 2026-07-12-code-review-flows-hardening-and-elaborations (2026-07-12)

2 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`sb:0b648f`]**

Done — three terms filed, all gates green, pushed as `9178648`. The glossary went 68 → 71: **materialize** (`sb:15fe73`) — defined source-independently (write derived content to disk vs. recompute on demand, paired with a freshness check), noting `CLAUDE.md` and the registry as materializations in the same sense; **excerpt log (route-tagged log)** (`sb:3101ef`) — definition plus a pointer to the route-tagging policy that canonically defines it, per the pointer-entry rule; and **orphan block** (`sb:3ee2d2`) — the general idea (generated output whose source vanished) grounded in this bundle's specific case, citing the issue and the hardening plan. Each carries its minted `sb:` id, *Seen in:* citations, and cross-links to the already-filed `route tag` / `sink` terms. The index stayed alphabetical, the registry was recompiled, and — per link-don't-duplicate — the elaboration doc's three inline definitions now link their new canonical homes rather than standing alone.

---

**[`sb:0b648f`]**

**Glossary report** (93 → 101 terms): *Added (7):* **feeding pairs** — the (thread, sink) pairs the current tags induce; the domain of materialization in both directions; **stale block** — a block diverged from its re-derivation (source *changed*), defined against **orphan block** (source *vanished*); **red test** — proves the detector fires, not just that good input passes; **pipe table** — GFM's `|` table syntax, with the scoping lesson attached; **spurious (warning)** — the false positive that teaches readers to ignore the channel; **section terminator** — where a parsed section ends; reader and rewriter must agree; **CRLF** — normalize on read or honor the file's ending on write. *Pointer (1):* **ratification** — one-line gloss deferring to the taxonomy-evolution protocol and persist-plans policies that canonically define it. *Merged (2):* **sink** and **materialize** already existed — each gained the two-directional-projection nuance from this session (an unfed sink loses its section) plus a citation, rather than a duplicate file.

### 2026-07-12-docs-audit-wiki-verdict-and-freshness-warnings (2026-07-12)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`sb:0b648f`]**  (co-feeds: `meta/tutorials/the-session-init-digest.md lib/second_brain/session_init.ex`)

Glossary done — 7 terms added, `deduplication` extended. Now the answer to your visibility question implies a concrete gap worth closing before the PR: the warnings currently live in terminal output you never see. The fix is to surface them in the session-init digest, which *is* injected into every session you open. Implementing that now.

### 2026-07-13-glossary-sense-disambiguation (2026-07-13)

2 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`sb:0b648f`]**  (co-feeds: `.claude/skills/add-to-glossary/SKILL.md`)

I read the glossary hub, the index (~115 terms), and a few entries that likely carry both senses (`materialize`, `deduplication`, `provenance`, `doctrine`). Here's my assessment.

**The idea is sound, and the glossary is already half-doing it informally**

Reading the entries, a de facto pattern already exists: `materialize` opens with the general meaning ("compute derived content and write it to disk…") and then pivots with "In this bundle the term names `mix brain.route_tags --materialize`…". `deduplication` does the same ("Detecting whether a candidate item already exists in a corpus…" → "In this brain it is performed at intake time…"). So your idea isn't inventing a distinction — it's formalizing one that emerged organically but is applied inconsistently. Some dual-sense entries blend the two senses in one run-on paragraph, and nothing marks *which* sense a citing document meant.

The terms split into three real populations:

- **Purely common** (~half): `BM25`, `embeddings`, `CRLF`, `actor model`, `KV cache`, `XSS`, `webhook` — portable knowledge, no local sense.
- **Purely repo-specific**: `route tag`, `routing ledger`, `stable id`, `pointer entry`, `feeding pairs`, `session-init digest` — coined here or defined by policy.
- **Dual-sense** — the interesting set: `materialize`, `deduplication`, `sink`, `digest`, `strand`, `graduation`, `doctrine`, `recall`, `lineage`. These are common terms this brain has *narrowed*: e.g. "digest" generally vs. the `/research` daily digest; "sink" generally vs. a route-tag sink.

**Why disambiguating is worth doing**

Three concrete payoffs beyond tidiness:

1. **It protects the common meaning from being silently overwritten.** The failure mode of a jargon-heavy repo is that "sink" comes to *only* mean route-tag sink, and the entry becomes useless for reading an external paper. Keeping the senses visibly separate keeps the glossary useful in both directions.
2. **It sharpens `/add-to-glossary` merge decisions.** When a new source uses `materialize` in the general database sense, the skill currently has no guidance on whether that citation belongs to the same entry or contaminates the repo-specific definition. An explicit two-sense structure gives merges a home for each.
3. **It's queryable metadata.** Knowing which entries are local jargon is exactly what a future reader (or an agent priming itself) wants: "which terms in this repo mean something non-standard?"

**How I'd shape it (and one refinement)**

I'd recommend **not** splitting dual-sense terms into two files — that fragments (against update-in-place), mints two ids for one string, and makes `[materialize](…)` links ambiguous. Instead, keep one file per term with:

- **A body convention**: common definition first, then a clearly marked repo-specific paragraph (e.g. a bolded **In this brain:** lead-in — essentially blessing what `materialize` already does), with *Seen in:* citations optionally noting which sense a source used.
- **A frontmatter marker**, e.g. `sense: common | repo | dual`, so the index can badge entries and tooling can list the local-jargon subset. Extra frontmatter keys are already allowed by the schema, and `mix brain.verify` could cheaply check the value is in-vocabulary.

One refinement worth deciding up front: "common vs. repo-specific" is really a three-point spectrum. Terms like `skill`, `plugin`, `SessionStart hook`, `mix task`, `OTP` aren't universal *or* this-repo-specific — they're **ecosystem-specific** (Claude Code, Elixir, OKF). I'd fold ecosystem terms into "common" (they're portable outside this repo, which is the distinction that matters) rather than adding a third value, but it's your call.

Cost is modest: a one-time classification pass over ~115 entries (most are trivially one-sided; maybe 10–15 are genuinely dual and need their bodies restructured), plus a paragraph in the `/add-to-glossary` skill codifying the convention.

Since this changes the glossary's shape and the skill's rules, it's a ratification item under the contract — treat this reply as the proposal. If you say go, I'd: add the convention to `/add-to-glossary`, classify all entries, restructure the dual-sense bodies, and add the `sense:` field with a verify check.

---

**[`sb:0b648f`]**  (co-feeds: `lib/second_brain/verifier.ex .claude/skills/add-to-glossary/SKILL.md`)

Done — built, gated, and pushed as `543e0c5` on `claude/glossary-common-repo-specific-cj76kw` (156 files, all verifiers and 118 tests green).

What landed:

- **Every one of the 148 glossary terms now carries a `sense` frontmatter field**: `common` (85 — portable industry/field/ecosystem vocabulary like `BM25`, `git worktree`, `Routine`), `repo` (53 — this brain's own vocabulary like `route tag`, `feeding pairs`, `cognitive debt`), or `dual` (10 — both senses).
- **The 10 dual entries were restructured common-first** with an explicit **In this brain:** pivot: `deduplication`, `digest`, `doctrine`, `lineage`, `materialize`, `orphaned branch`, `provenance`, `sink (route-tag sink)`, `run (canonical run)`, and `typed edge`. Entries like `digest` and `typed edge` that previously defined *only* the local sense gained a proper common definition; `orphaned branch` now leads with git's own `--orphan` sense before the session-branch one.
- **Verifier rule 7** in `mix brain.verify`: any bundle concept under `beliefs/glossary/` must carry a valid `sense`; missing or invalid values fail the gate (so every future entry gets classified at write time). Shipped with red + green tests in `test/second_brain/registry_test.exs`.
- **The `/add-to-glossary` skill** now owns the convention: how to classify, the dual body shape, and sense-aware merging — a common-sense citation extends the common paragraph, a repo-sense one extends the *In this brain* paragraph, and reclassification to `dual` happens when a `common` term acquires a real local referent.
- **The decision record** is persisted at `meta/plans/glossary-sense-disambiguation.md` (status: done), including the classification principles I applied — notably: ecosystem terms fold into `common` as you left to my call; coined-here-but-portable terms (`deterministic spine`, `drift class`) are `repo` because the classification tracks where the *usage* lives; and an everyday-English second meaning (e.g. `graduation`) doesn't make a term `dual` — only a technical common sense does. The hub `beliefs/glossary.md` and the glossary index describe the scheme.

Deferred (noted in the plan): badging the index lines with sense markers, and a sense column in the compiled registry — both derivable from the field whenever wanted.

I didn't open a PR since you didn't ask; `/create-pull-request` will also capture this session and glossary it in the same PR. If any individual classification looks wrong to you, it's a one-line frontmatter edit — the mapping is deliberately easy to overrule.
