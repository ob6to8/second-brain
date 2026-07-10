---
type: reference
title: 2026-07-10-add-to-glossary-skill-and-pr-wiring
description: Built the /add-to-glossary skill and the bundle-root glossary it maintains (markdown over JSON, pointer entries, a graduation path to /intake), then wired it into /create-pull-request so every captured thread's terminology ships in the same PR — with this session's own capture as the first live run.
provenance: "Claude Code session (Claude Fable 5), 2026-07-10; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, skills, glossary, capture, pull-request]
timestamp: 2026-07-10
---

# 2026-07-10-add-to-glossary-skill-and-pr-wiring

## Where this landed

A tooling session that gave the brain a cross-source glossary. The operator
proposed a `/add-to-glossary` skill — scan a persisted thread, paper, or post
and define the technical terms it uses, saved to `glossary.md` or
`glossary.json` — and the session built it: markdown won over JSON (the
glossary is a bundle concept, `sb:0b648f`, so it flows through
verify/registry/site tooling), one cross-domain glossary at the bundle root,
one alphabetical entry per term with *Seen in:* citations, **pointer entries**
deferring to docs that already define a term, and a **graduation path** where
an outgrown entry files as a proper concept via `/intake` and shrinks to a
pointer. The operator then had it wired into `/create-pull-request` as a new
step 2 — run `/add-to-glossary` over the thread doc `/capture` just wrote — so
each session's terminology lands in the glossary in the same PR as its thread.
The session closed with `/create-pull-request` itself: this capture is that
run's first step, and its glossary pass is the new step's first live exercise,
seeding the glossary's first entries.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| New `/add-to-glossary` skill (scan a thread/paper/post → merge distilled definitions into the glossary) | closed | [/.claude/skills/add-to-glossary/SKILL.md](/.claude/skills/add-to-glossary/SKILL.md) | - |
| Bundle-root glossary scaffold (markdown over JSON; `type: concept`, `sb:0b648f`; pointer entries; graduation) | closed | [/glossary.md](/glossary.md) | - |
| Wire `/add-to-glossary` into `/create-pull-request` (glossary step between capture and commit) | closed | [/.claude/skills/create-pull-request/SKILL.md](/.claude/skills/create-pull-request/SKILL.md) | - |
| Run `/create-pull-request` → capture this session, seed the glossary, open the PR | closed | `unrouted` | - |

## User

What about creating a skill /add-to-glossary that scans a persisted thread (/meta/threads) or a paper or post, which leads the agent to then parse and define all technical terms or concepts being used? They could be saved in a "glossary.md" or "glossary.json"

## Assistant

<routes ref="sb:0b648f .claude/skills/add-to-glossary/SKILL.md">
Built and pushed. The `/add-to-glossary` skill now exists on `claude/add-to-glossary-skill-jz1ewh` (commit `f45940f`), with all verifiers green (`brain.verify`, `brain.route_tags`, contract check, 78 tests passing).

**What it does** (`.claude/skills/add-to-glossary/SKILL.md`): you point it at a persisted thread under `meta/threads/`, a paper or post (URL, pasted text, or PDF), or an already-filed concept. It extracts the technical terms the source actually uses — same selection bar as `/summarize-technical`'s key-terms section, so incidental nouns don't qualify — and merges one-to-three-sentence definitions into a single running glossary at the bundle root.

**Key design decisions**, since your proposal left a couple open:

- **`glossary.md`, not `glossary.json`.** The glossary is a bundle concept like any other (`type: concept`, id `sb:0b648f`), so it flows through `mix brain.verify`/`registry` and the site renderer. JSON would sit outside all of that; the entry structure (alphabetical `##` headings + a *Seen in:* citation line) is regular enough to parse mechanically if tooling ever wants it.
- **One glossary, cross-domain, at the bundle root** — listed under a new "Cross-domain" heading in the root `index.md`. A term seen in three threads and a paper gets one entry with four citations, which is the thing `/summarize-technical`'s per-document glossaries can't give you.
- **Pointer entries instead of duplicates.** A term already canonically defined by a filed concept (or by the operating contract itself, like *route tag*) gets a one-line gloss plus a link, honoring update-in-place/don't-fragment.
- **A graduation path.** When an entry outgrows a few sentences it gets filed as a proper concept via `/intake` and the glossary entry shrinks to a pointer — the glossary is a staging layer, not a terminal home.
- The whole doc stays `verified: false` (agent-authored definitions); individual claims can graduate and get grounded through the normal `verified_by` machinery.

The skill is registered in `meta/policy/skills-registry.md` with `CLAUDE.md` re-rendered via `mix brain.contract`, the empty glossary scaffold is seeded, and both `log.md` and `meta/log.md` carry dated entries. The glossary has no entries yet — a natural first run would be `/add-to-glossary` on the 2026-07-05 bootstrap thread. I didn't open a PR since you didn't ask for one; say the word (or `/create-pull-request`) and I will.
</routes>

## User

Lets call this from within /create-pull-request so it processes the created thread doc

## Assistant

<routes ref=".claude/skills/create-pull-request/SKILL.md .claude/skills/add-to-glossary/SKILL.md">
Wired in and pushed (commit `1e4e548`). `/create-pull-request` now runs `/add-to-glossary` as its new step 2, immediately after `/capture` writes the thread doc and before anything touches git — so each captured session's terminology merges into `/glossary.md` and ships in the same PR as the thread it came from, exactly the way the thread doc itself already does.

Two edge cases are handled explicitly in the skill: if capture is skipped (nothing substantive to persist), the glossary step is skipped too; and if the thread yields no terms that clear the selection bar, that's a legitimate no-op rather than a reason to pad the glossary.

Alongside the procedure change (steps renumbered to capture → glossary → survey → commit → push → open PR, guardrail extended), the `/add-to-glossary` skill now notes it's invoked automatically by `/create-pull-request`, both bullets in `meta/policy/skills-registry.md` were updated, `CLAUDE.md` re-rendered via `mix brain.contract`, and the change logged in `meta/log.md`. All verifiers (`brain.verify`, `brain.route_tags`, contract check) and the 78 tests pass.

One consequence worth noting: since this session will presumably end with a `/create-pull-request`, that run will be the first live exercise of the new step — the captured thread about building the glossary will itself seed the glossary's first entries.
</routes>

## User

_(operator invoked `/create-pull-request`)_

## Assistant

_(this capture — freezing the session into this thread doc — is step 1 of that `/create-pull-request` run; step 2 runs `/add-to-glossary` over this very doc, seeding the glossary's first entries, followed by the commit, push, and PR.)_
