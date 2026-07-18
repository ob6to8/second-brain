---
type: reference
title: 2026-07-10-add-to-glossary-skill-and-pr-wiring
description: Built the /add-to-glossary skill and the glossary it maintains (markdown over JSON, pointer entries, a graduation path), wired it into /create-pull-request so every captured thread's terminology ships in the same PR — this session's own capture was the first live run — then restructured the glossary to one concept file per term under /glossary/ so definitions are individually linkable.
provenance: "Claude Code session (Claude Fable 5), 2026-07-10; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, skills, glossary, capture, pull-request]
timestamp: 2026-07-10
pr: 35
---

# 2026-07-10-add-to-glossary-skill-and-pr-wiring

## Where this landed

A tooling session that gave the brain a cross-source glossary. The operator
proposed a `/add-to-glossary` skill — scan a persisted thread, paper, or post
and define the technical terms it uses, saved to `glossary.md` or
`glossary.json` — and the session built it: markdown won over JSON (the
glossary is a bundle concept, `em:0b648f`, so it flows through
verify/registry/site tooling), one cross-domain glossary at the bundle root,
one alphabetical entry per term with *Seen in:* citations, **pointer entries**
deferring to docs that already define a term, and a **graduation path** where
an outgrown entry files as a proper concept via `/intake` and shrinks to a
pointer. The operator then had it wired into `/create-pull-request` as a new
step 2 — run `/add-to-glossary` over the thread doc `/capture` just wrote — so
each session's terminology lands in the glossary in the same PR as its thread.
The session then ran `/create-pull-request` itself: this capture is that run's
first step, and its glossary pass was the new step's first live exercise,
seeding the glossary's first seven entries (PR #35). After the PR opened, the
operator proposed per-term files so definitions can be cited as clickable
links, and the glossary was restructured: one `type: concept` file per term
under `/glossary/` (each with its own `sb:` id), `glossary/index.md` as the
alphabetical listing, `/glossary.md` retained as the hub (it is `em:0b648f`,
the route-tag sink, and keeps the generated excerpt log), and graduation
redefined as *moving* a term file into the domain taxonomy — the id travels —
leaving a pointer stub behind. The capture was refreshed in place to include
that exchange before merge.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| New `/add-to-glossary` skill (scan a thread/paper/post → merge distilled definitions into the glossary) | closed | [/.claude/skills/add-to-glossary/SKILL.md](/.claude/skills/add-to-glossary/SKILL.md) | - |
| Bundle-root glossary scaffold (markdown over JSON; `type: concept`, `em:0b648f`; pointer entries; graduation) | closed | [/glossary.md](/glossary.md) | - |
| Wire `/add-to-glossary` into `/create-pull-request` (glossary step between capture and commit) | closed | [/.claude/skills/create-pull-request/SKILL.md](/.claude/skills/create-pull-request/SKILL.md) | - |
| Run `/create-pull-request` → capture this session, seed the glossary, open the PR | closed | `unrouted` | - |
| Per-term glossary restructure (one concept file per term under `/glossary/`; hub retained; graduation = move) | closed | [/glossary.md](/glossary.md) | - |
| PR #35 readiness check (refresh this capture, confirm mergeable) | closed | `unrouted` | - |

## User

What about creating a skill /add-to-glossary that scans a persisted thread (/meta/threads) or a paper or post, which leads the agent to then parse and define all technical terms or concepts being used? They could be saved in a "glossary.md" or "glossary.json"

## Assistant

<routes ref="em:0b648f .claude/skills/add-to-glossary/SKILL.md">
Built and pushed. The `/add-to-glossary` skill now exists on `claude/add-to-glossary-skill-jz1ewh` (commit `f45940f`), with all verifiers green (`brain.verify`, `brain.route_tags`, contract check, 78 tests passing).

**What it does** (`.claude/skills/add-to-glossary/SKILL.md`): you point it at a persisted thread under `meta/threads/`, a paper or post (URL, pasted text, or PDF), or an already-filed concept. It extracts the technical terms the source actually uses — same selection bar as `/summarize-technical`'s key-terms section, so incidental nouns don't qualify — and merges one-to-three-sentence definitions into a single running glossary at the bundle root.

**Key design decisions**, since your proposal left a couple open:

- **`glossary.md`, not `glossary.json`.** The glossary is a bundle concept like any other (`type: concept`, id `em:0b648f`), so it flows through `mix brain.verify`/`registry` and the site renderer. JSON would sit outside all of that; the entry structure (alphabetical `##` headings + a *Seen in:* citation line) is regular enough to parse mechanically if tooling ever wants it.
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

Pull request opened: **https://github.com/ob6to8/second-brain/pull/35**

The full `/create-pull-request` flow ran end to end, including the new glossary step for the first time:

1. **Captured the session** → `meta/threads/2026-07-10-add-to-glossary-skill-and-pr-wiring.md` — verbatim render, four-row routing ledger (all closed), and one region route-tagged to the glossary (`em:0b648f`), which materialized the glossary's first thread-excerpt log block.
2. **Glossaried the thread** — the new step 2's first live exercise, run on its own origin story: seven entries seeded into `/glossary.md`. Two are definitions for terms this session coined (*graduation*, *pointer entry*); five are pointer entries for contract machinery the thread used (*concept (OKF)*, *route tag*, *stable id (`sb:` id)*, *thread doc*, *verified_by*), each a one-line gloss linking to its defining policy.
3. **Committed and pushed** (`1a03588`) with threads index and both logs updated, then opened the PR.

The PR carries all three commits on the branch: the skill + glossary scaffold, the `/create-pull-request` wiring, and this capture/seeding. All gates passed before commit — contract and registry checks, `brain.verify`, `brain.route_tags` (34 regions across 12 threads, fidelity clean), and 78 tests with 0 failures.

Want me to watch the PR for review comments and CI via `subscribe_pr_activity`, or merge it into `main` now?

## User

What about making each glossary term its own md file? Then i could ask you to return glossary entry links for your responses, and click those to be taken to the definition

## Assistant

<routes ref="em:0b648f .claude/skills/add-to-glossary/SKILL.md">
Done — restructured and pushed (commit `b61ee57`, now part of PR #35). Each glossary term is its own concept file under `/glossary/`, so I can now cite definitions exactly the way you described: a response can link [route tag](/glossary/route-tag.md), [pointer entry](/glossary/pointer-entry.md), or [verified_by](/glossary/verified-by.md), and clicking lands on the definition — on GitHub and on the Pages site alike.

How the pieces landed:

- **Seven term files** under `/glossary/`, each a full bundle concept with its own minted `sb:` id, frontmatter, definition, and *Seen in:* citations. `glossary/index.md` lists them alphabetically with one-line descriptions.
- **`/glossary.md` stayed, repurposed as the hub.** It couldn't simply be deleted: it's `em:0b648f`, the route-tag sink for this session's thread, and it carries the generated excerpt log — ids are immutable and the verifier re-derives that log. So it now describes the system and points into the directory, and all existing links to it still resolve.
- **Graduation got more elegant.** Since every term is already a concept, an outgrown term no longer needs re-filing via `/intake` — the file just *moves* into the domain taxonomy, its id travels with it, and a pointer stub stays at `/glossary/<slug>.md` so old glossary links keep landing somewhere useful.
- **The `/add-to-glossary` skill** was updated to the per-term model (kebab-slug files, per-file merge rules, index upkeep) and gained a "Citing terms in responses" section: link a term's first use in a response, not every occurrence. The skills-registry policy, `CLAUDE.md`, `/create-pull-request`'s step 2, the root `index.md`, and the registry are all in sync, and every gate passes (verify, route tags, contract/registry checks, 78 tests).

One governance note: `glossary/` is a new top-level directory, which the taxonomy protocol normally has me propose rather than create — your message was the proposal and direction here, and the whole shape ships in PR #35 for you to ratify or push back on in review. From here on, just ask for "glossary links" in any answer and I'll cite terms inline; anything I define along the way can be `/add-to-glossary`'d into its own linkable file.
</routes>

## User

Does the pr have everything, ready to merge?

## Assistant

_(the readiness check that closed the session: this capture was refreshed in place with the per-term restructure exchange, the gates re-run, and PR #35 confirmed to carry the full session — the answer itself lives in the PR conversation.)_
