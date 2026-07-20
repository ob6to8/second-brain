---
type: reference
title: 2026-07-11-doctrine-vs-policy-and-glossary-cross-linking
description: Answered the doctrine-vs-policy question by filling the glossary's missing policy (type) entry, added doctrine at the operator's direction, and ratified a prose-first cross-linking convention (See also fallback) for glossary terms.
provenance: "Claude Code session, 2026-07-11; verbatim retained messages parsed from the host session log — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, glossary, governance, terminology, cross-linking]
timestamp: 2026-07-11
session: https://claude.ai/code/session_01GCK2qwM7CGEkANUW3r32Bi
pr: 40
---

# 2026-07-11-doctrine-vs-policy-and-glossary-cross-linking

Verbatim render. Retained operator messages and agent responses are reproduced
**verbatim** (the delivered text); only tool calls, tool results, reasoning, and
short pre-tool narration are stripped, and in-message ATX headers are demoted to
bold so they don't collide with the render's section structure. Parsed from the
host session log via `/capture`'s parse-the-log path.

## Where this landed

The operator asked whether *doctrine* and *policy* were both defined and how
glossary terms could cross-link similarity. Investigation found *doctrine* used
nowhere in the bundle and *policy* canonically defined in the
[controlled-type vocabulary](/meta/policy/controlled-type-vocabulary.md) but
missing the glossary pointer entry every sibling type already had — so
[policy (type)](/glossary/policy-type.md) (`em:fa15e7`) was added. The operator
then directed a [doctrine](/glossary/doctrine.md) entry (`em:6a9e78`), the term
having entered the brain's working vocabulary through the question itself. On
cross-linking, the agent recommended — and the operator ratified — a
**prose-first convention** codified in
[`/add-to-glossary`](/.claude/skills/add-to-glossary/SKILL.md): weave links into
definition prose when the relationship can be stated, fall back to a `*See
also:*` line (max 3–4 links) for genuine adjacency no sentence connects, and
deliberately no `related:` typed-edge field (typed edges stay reserved for
machine-traversed relations). First applied to the recall cluster. All three
changes shipped on `claude/glossary-doctrine-policy-lkabog`.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Is *policy* defined? — the missing policy (type) glossary entry | closed | [policy (type)](/glossary/policy-type.md) | - |
| Is *doctrine* defined? — doctrine vs. policy, entry added on direction | closed | [doctrine](/glossary/doctrine.md) | - |
| Cross-linking similarity between glossary terms — prose-first / See also convention | closed | [Glossary](/glossary.md) | - |

## User

Question for glossay - whats the difference between doctrine and policy, and are both defined? Plus - is there a way to cross link similarity between glossary terms?

## Assistant

You've hit your session limit · resets 11:20am (UTC)

## User

Continue from where you left off.

## Assistant

Pushed to `claude/glossary-doctrine-policy-lkabog` (commit `2a1b2dc`, all verifiers and 78 tests green). Here are the answers to your three questions:

<routes ref="em:fa15e7 em:6a9e78">
**Are "doctrine" and "policy" both defined?**

**No — only "policy" is, and until this session it had no glossary entry either.**

- **Doctrine** appears *nowhere* in the repo — not in the glossary, not in the contract, not in any policy doc, thread, or concept. It isn't part of this brain's vocabulary at all. I did **not** add a glossary entry for it, because the glossary's own guardrail is to define terms that sources actually use — an entry for a term nothing cites would be an orphan. If you want to introduce "doctrine" as a real concept in the brain, that's a quick `/add-to-glossary` or `/intake` away once something actually uses it.
- **Policy** is canonically defined in the [controlled-type vocabulary](meta/policy/controlled-type-vocabulary.md): *"a governance rule for how the brain operates; the source from which `CLAUDE.md` is compiled."* But I found a gap: every other governance type (`plan`, `issue`, `methodology`, `tutorial`, `analysis`) had a glossary pointer entry, and `policy` didn't. I've added [`/glossary/policy-type.md`](glossary/policy-type.md) (`em:fa15e7`) to fill it, cross-linked to its sibling types and cited to the bootstrap thread where the genre originated.

**The conceptual difference**

In ordinary governance usage, **doctrine** is the layer of *beliefs and principles* — the "why," a body of accepted tenets that guides judgment but doesn't prescribe specific action. **Policy** is the layer of *enforceable rules* — the "what you must do," specific and operational. Doctrine shapes policies; policies implement doctrine. In this brain's terms, the closest thing to "doctrine" is arguably the *preamble + the compiled operating contract as a whole* (the worldview: "the tree is the taxonomy," "distill, don't dump"), while each `type: policy` file is a concrete, enforceable rule — several of them literally machine-enforced by `mix brain.verify`.
</routes>

<routes ref="em:0b648f .claude/skills/add-to-glossary/SKILL.md">
**Cross-linking similarity between glossary terms**

**Yes — two mechanisms exist today, and I used both in the new entry:**

1. **Inline markdown links between term files.** Since every term is its own concept file, any entry can link related terms by bundle-absolute path — the new `policy (type)` entry links to `plan-type`, `issue-type`, `methodology-type`, and `operating-contract` right in its "distinct from…" sentence. These are untyped edges where the prose carries the meaning (per the cross-linking policy), and they render as clickable links on GitHub and the Pages site. Several entries already do this organically (e.g. `skill.md` → `session-capture.md`).
2. **Shared frontmatter tags.** Entries carry tags like `[glossary, types, governance]`, so related clusters are already greppable/queryable (`policy-type`, `plan-type`, `issue-type` all share `types, governance`).

**What doesn't exist yet:** a *structured* similarity edge — e.g. a `related:` frontmatter field holding `sb:` ids, analogous to `verified_by`, that tooling could traverse to render a "See also" block per entry. That would be a new typed edge, which under the stable-identity policy is a change to the brain's shape — so I'm proposing it rather than building it. If you like it, the design would be: `related: [em:bf0524, em:e9a82b]` on each term file, symmetric-checked by `mix brain.verify`, rendered as a *See also:* line. A lighter alternative is a plain *See also:* prose line convention added to the `/add-to-glossary` skill — no tooling change at all. Say the word on either and I'll build it.
</routes>

## User

Commit doctrine to glossary (used here)

Which do you recommend: related, see also, or neither?

## Assistant

<routes ref="em:6a9e78">
Done — [`doctrine`](glossary/doctrine.md) is committed and pushed (`5a57194`, `em:6a9e78`, all verifiers and 78 tests green). It defines doctrine as the principles layer ("the why") versus policy's enforceable rules, cross-links to `policy-type` and `operating-contract`, and notes that this brain has no `doctrine` type — the closest analogue being the preamble plus compiled contract read as a whole. The glossary is now 71 terms.
</routes>

<routes ref="em:0b648f .claude/skills/add-to-glossary/SKILL.md">
**My recommendation: *See also* — not `related:`, not neither**

**A prose *See also:* line, added as a convention in the `/add-to-glossary` skill, used sparingly.** Reasoning:

**Against `related:` (the typed edge):** the brain's own identity policy reserves typed frontmatter edges for relations tooling actually traverses with semantics — `verified_by` earns that because verification is machine-checked and evidential. Term similarity is editorial and fuzzy: there's no oracle for whether `embeddings` is "related enough" to `recall@k`, so a verifier could only check that ids resolve and edges are symmetric — enforcement overhead without enforcing the thing that matters. It would also be the first typed edge added for human navigation rather than machine meaning, which dilutes the distinction the contract draws between typed edges (ids, tooling) and prose links (untyped, meaning in the prose).

**Against neither:** inline links inside definitions are the *best* form of cross-linking — "distinct from a [plan](/glossary/plan-type.md)…" tells you *why* they're related — but they only work when the relationship fits a natural sentence. Genuinely adjacent clusters (`recall` / `recall probe` / `recall@k`, or `doctrine` / `policy` / `operating contract`) sometimes have members with no prose-worthy sentence connecting them, and those associations currently just get dropped.

**So: *See also*, with a preference order.** The convention I'd codify in the skill: weave a link into the definition prose when you can state the relationship (first choice); fall back to a `*See also:*` line after the *Seen in:* line only for real adjacency that prose can't carry; never list more than 3–4 terms. Zero tooling change, follows the existing cross-linking policy (untyped markdown links, broken links tolerated), renders fine on GitHub and the Pages site, and it can always be upgraded to a `related:` typed edge later if tooling ever wants to traverse it — the reverse migration is much more annoying.

Adding that convention is a one-paragraph edit to the `/add-to-glossary` skill (a shape change, so this reply is the proposal). Say the word and I'll codify it and push to the same branch.
</routes>

## User

Proceed

## Assistant

<routes ref="em:0b648f .claude/skills/add-to-glossary/SKILL.md">
Done — the convention is codified and pushed (`1f13ffc`, all verifiers and 78 tests green).

What landed:

- **The `/add-to-glossary` skill** now carries the cross-linking rule in its merge step: link related terms **in the definition prose** whenever the relationship can be stated ("distinct from a [plan](…)…"); fall back to a `*See also:*` line — placed after *Seen in:*, capped at 3–4 term links — only for genuine adjacency that no sentence connects. These stay ordinary untyped prose links per the cross-linking policy; deliberately not a `related:` frontmatter field, which stays reserved for machine-traversed edges like `verified_by`.
- **First application, on the recall cluster:** `recall probe` and `recall@k` already named each other in prose, so those mentions became inline links; `recall` got the glossary's first *See also:* line (recall probe, recall@k, semantic search) plus an inline link to `deduplication`, which its prose already referenced.
- The root `log.md` records the ratified convention, and the touched entries' timestamps are bumped.

The branch now holds three commits: the `policy (type)` entry, the `doctrine` entry, and this convention. Say the word if you want a PR opened (`/create-pull-request` will also capture this session and glossary it in the same PR).
</routes>
