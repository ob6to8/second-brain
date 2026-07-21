---
type: reference
title: 2026-07-13-glossary-sense-disambiguation
description: Ratified and executed the glossary sense-disambiguation proposal — every term classified common/repo/dual via a `sense` frontmatter field, dual entries restructured common-first, verifier rule 7 added, and the /add-to-glossary conventions updated.
provenance: "Claude Code session, 2026-07-13; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, glossary, terminology, verification]
timestamp: 2026-07-13
session: https://claude.ai/code/session_01CH4Z23tz1ThNy9fYYA3iBo
pr: 63
---

# 2026-07-13-glossary-sense-disambiguation

## Where this landed

The operator proposed disambiguating glossary usages between common and
repo-specific senses; the agent's assessment found the glossary already
half-doing it informally and proposed formalizing: one file per term stays, a
`sense` frontmatter field (`common` · `repo` · `dual`), a common-first body
convention for dual entries, and a verifier rule. Ratified with "Go" and
executed in the same session: all 148 terms classified (85 common / 53 repo /
10 dual), the 10 dual bodies restructured with an explicit **In this brain:**
pivot, `mix brain.verify` rule 7 added with red + green tests, the
[`/add-to-glossary`](/.claude/skills/add-to-glossary/SKILL.md) skill updated
with classification and sense-aware merge conventions, and the decision record
persisted as the
[glossary sense-disambiguation plan](/meta/plans/glossary-sense-disambiguation.md)
(`status: done`). Index badging and a registry sense column were deferred.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Glossary sense disambiguation: common vs repo-specific usage | closed | [glossary hub](/beliefs/glossary.md) | - |
| Surfacing `sense` in the index and registry views | paused | `unrouted` | Whether to badge `/beliefs/glossary/index.md` lines and add a registry column (deferred in the plan) |

## User

I would like to look at the glossary and look into disambiguating usages between common and repo specific. This may mean that some glossary entries have both common or repo specific meanings. What do you think of this idea?

## Assistant

<routes ref="em:0b648f .claude/skills/add-to-glossary/SKILL.md">
I read the glossary hub, the index (~115 terms), and a few entries that likely carry both senses (`materialize`, `deduplication`, `provenance`, `doctrine`). Here's my assessment.

## The idea is sound, and the glossary is already half-doing it informally

Reading the entries, a de facto pattern already exists: `materialize` opens with the general meaning ("compute derived content and write it to disk…") and then pivots with "In this bundle the term names `mix brain.route_tags --materialize`…". `deduplication` does the same ("Detecting whether a candidate item already exists in a corpus…" → "In this brain it is performed at intake time…"). So your idea isn't inventing a distinction — it's formalizing one that emerged organically but is applied inconsistently. Some dual-sense entries blend the two senses in one run-on paragraph, and nothing marks *which* sense a citing document meant.

The terms split into three real populations:

- **Purely common** (~half): `BM25`, `embeddings`, `CRLF`, `actor model`, `KV cache`, `XSS`, `webhook` — portable knowledge, no local sense.
- **Purely repo-specific**: `route tag`, `routing ledger`, `stable id`, `pointer entry`, `feeding pairs`, `session-init digest` — coined here or defined by policy.
- **Dual-sense** — the interesting set: `materialize`, `deduplication`, `sink`, `digest`, `strand`, `graduation`, `doctrine`, `recall`, `lineage`. These are common terms this brain has *narrowed*: e.g. "digest" generally vs. the `/research` daily digest; "sink" generally vs. a route-tag sink.

## Why disambiguating is worth doing

Three concrete payoffs beyond tidiness:

1. **It protects the common meaning from being silently overwritten.** The failure mode of a jargon-heavy repo is that "sink" comes to *only* mean route-tag sink, and the entry becomes useless for reading an external paper. Keeping the senses visibly separate keeps the glossary useful in both directions.
2. **It sharpens `/add-to-glossary` merge decisions.** When a new source uses `materialize` in the general database sense, the skill currently has no guidance on whether that citation belongs to the same entry or contaminates the repo-specific definition. An explicit two-sense structure gives merges a home for each.
3. **It's queryable metadata.** Knowing which entries are local jargon is exactly what a future reader (or an agent priming itself) wants: "which terms in this repo mean something non-standard?"

## How I'd shape it (and one refinement)

I'd recommend **not** splitting dual-sense terms into two files — that fragments (against update-in-place), mints two ids for one string, and makes `[materialize](…)` links ambiguous. Instead, keep one file per term with:

- **A body convention**: common definition first, then a clearly marked repo-specific paragraph (e.g. a bolded **In this brain:** lead-in — essentially blessing what `materialize` already does), with *Seen in:* citations optionally noting which sense a source used.
- **A frontmatter marker**, e.g. `sense: common | repo | dual`, so the index can badge entries and tooling can list the local-jargon subset. Extra frontmatter keys are already allowed by the schema, and `mix brain.verify` could cheaply check the value is in-vocabulary.

One refinement worth deciding up front: "common vs. repo-specific" is really a three-point spectrum. Terms like `skill`, `plugin`, `SessionStart hook`, `mix task`, `OTP` aren't universal *or* this-repo-specific — they're **ecosystem-specific** (Claude Code, Elixir, OKF). I'd fold ecosystem terms into "common" (they're portable outside this repo, which is the distinction that matters) rather than adding a third value, but it's your call.

Cost is modest: a one-time classification pass over ~115 entries (most are trivially one-sided; maybe 10–15 are genuinely dual and need their bodies restructured), plus a paragraph in the `/add-to-glossary` skill codifying the convention.

Since this changes the glossary's shape and the skill's rules, it's a ratification item under the contract — treat this reply as the proposal. If you say go, I'd: add the convention to `/add-to-glossary`, classify all entries, restructure the dual-sense bodies, and add the `sense:` field with a verify check.
</routes>

## User

Go

## Assistant

Ratified — I'll build it. Plan of attack: persist the plan doc (per the persist-plans policy), add the `sense:` convention to the `/add-to-glossary` skill, classify all entries, restructure the dual-sense bodies, add the verify check, then run the gates and push.

First, branch setup and reconnaissance of the pieces I'll touch.

<routes ref="em:0b648f lib/elixir_mind/verifier.ex .claude/skills/add-to-glossary/SKILL.md">
Done — built, gated, and pushed as `543e0c5` on `claude/glossary-common-repo-specific-cj76kw` (156 files, all verifiers and 118 tests green).

What landed:

- **Every one of the 148 glossary terms now carries a `sense` frontmatter field**: `common` (85 — portable industry/field/ecosystem vocabulary like `BM25`, `git worktree`, `Routine`), `repo` (53 — this brain's own vocabulary like `route tag`, `feeding pairs`, `cognitive debt`), or `dual` (10 — both senses).
- **The 10 dual entries were restructured common-first** with an explicit **In this brain:** pivot: `deduplication`, `digest`, `doctrine`, `lineage`, `materialize`, `orphaned branch`, `provenance`, `sink (route-tag sink)`, `run (canonical run)`, and `typed edge`. Entries like `digest` and `typed edge` that previously defined *only* the local sense gained a proper common definition; `orphaned branch` now leads with git's own `--orphan` sense before the session-branch one.
- **Verifier rule 7** in `mix brain.verify`: any bundle concept under `beliefs/glossary/` must carry a valid `sense`; missing or invalid values fail the gate (so every future entry gets classified at write time). Shipped with red + green tests in `test/second_brain/registry_test.exs`.
- **The `/add-to-glossary` skill** now owns the convention: how to classify, the dual body shape, and sense-aware merging — a common-sense citation extends the common paragraph, a repo-sense one extends the *In this brain* paragraph, and reclassification to `dual` happens when a `common` term acquires a real local referent.
- **The decision record** is persisted at `meta/plans/glossary-sense-disambiguation.md` (status: done), including the classification principles I applied — notably: ecosystem terms fold into `common` as you left to my call; coined-here-but-portable terms (`deterministic spine`, `drift class`) are `repo` because the classification tracks where the *usage* lives; and an everyday-English second meaning (e.g. `graduation`) doesn't make a term `dual` — only a technical common sense does. The hub `beliefs/glossary.md` and the glossary index describe the scheme.

Deferred (noted in the plan): badging the index lines with sense markers, and a sense column in the compiled registry — both derivable from the field whenever wanted.

I didn't open a PR since you didn't ask; `/create-pull-request` will also capture this session and glossary it in the same PR. If any individual classification looks wrong to you, it's a one-line frontmatter edit — the mapping is deliberately easy to overrule.
</routes>
