---
type: reference
title: 2026-07-11-glossary-backfill-from-thread-docs
description: Ran /add-to-glossary over the eleven previously-unprocessed thread docs under meta/threads/, growing the glossary from 7 to 68 terms (46 new term files + 15 pointer entries), then committed, opened, and squash-merged PR #37.
provenance: "Claude Code session (claude-opus-4-8), 2026-07-11; verbatim retained messages parsed from the host session log — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, glossary, capture, terminology]
timestamp: 2026-07-11
---

# 2026-07-11-glossary-backfill-from-thread-docs

Verbatim render. Retained operator messages and agent responses are reproduced
**verbatim** (the delivered text); only tool calls, tool results, reasoning, and
short pre-tool narration are stripped. Parsed from the host session log via
`/capture`'s parse-the-log path.

## Where this landed

The operator asked to run [`/add-to-glossary`](/.claude/skills/add-to-glossary/SKILL.md)
over *all* the persisted thread docs, since only one
([the add-to-glossary thread](/meta/threads/2026-07-10-add-to-glossary-skill-and-pr-wiring.md))
had been processed. Eleven threads remained. Rather than read them serially in
the main context, the session fanned the reading out to four parallel `Explore`
subagents (three threads each) that extracted candidate terms with
source-independent definitions and pointer targets, then consolidated their
output centrally so a term seen across several threads became **one** file with
several citations. All entries were written from a single controlled generator
script to keep the format byte-identical to the existing seven.

The [glossary](/glossary.md) grew **7 → 68 terms**: **46 new term files** and
**15 pointer entries** (the latter deferring to the policy/skill docs that
canonically define their terms), plus appended *Seen in:* citations on the six
existing entries the threads also touched. Ids were minted (`mix brain.id`),
[`meta/registry.md`](/meta/registry.md) refreshed,
[`/glossary/index.md`](/glossary/index.md) regenerated alphabetically, and the
root `log.md` updated; `mix brain.verify` and `mix brain.route_tags` stayed
green. The work landed as **PR #37**, squash-merged to `main` (`d830fd9`) after
CI `verify` passed. A follow-up resolved the one open matter: bare skill-command
names (`/intake`, `/capture`, `/news`) stay **out** of the glossary — a command's
canonical link is its own `SKILL.md`, and the *concept* a skill enacts (not its
handle) is what earns an entry. The [skill](/glossary/skill.md) category got a
single pointer entry and the principle was codified as an `/add-to-glossary`
guardrail.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Backfilling the glossary from the eleven unprocessed thread docs — 46 new + 15 pointer entries, 7→68 terms, deduped across threads | closed | [Glossary hub](/glossary.md) | - |
| Whether bare skill-command names (`/intake`, `/capture`, `/news`) deserve glossary pointer entries | closed | `unrouted` | - |
| PR #37 lifecycle — open, CI `verify`, squash-merge to `main` | closed | `unrouted` | - |

## User

Use /add-to-glossary to process all the existing thread docs, only one has been processed. Work through as much as you can, and if any questions save them til end. Be mindful of context - once you are halfway to your limit, pause

## Assistant

This is a substantial task — 12 threads. To conserve my context for the curation/dedup/writing work, I'll delegate the reading and term-extraction to parallel subagents, then consolidate their output myself (so term files don't collide across threads). Let me set up task tracking and launch the extractors.

## Assistant

`mix brain.id` auto-mints ids for any file lacking one, so I'll write term files without an `id` line. Given the volume (~46 new terms + pointer entries across 12 threads), the most reliable and context-efficient path is a single generator script I fully control. Let me confirm the environment and check the existing citation-line format + root log.

## Assistant

Done. All 12 outstanding thread docs are now processed into the glossary.

<routes ref="sb:0b648f .claude/skills/add-to-glossary/SKILL.md">
**Approach:** four parallel Explore subagents read the 12 threads and extracted candidate terms (source-independent definitions + pointer targets), so I could dedup across threads before writing — a term seen in three threads gets **one** file with three citations, not three files. I then generated all entries from a single controlled script to keep the format byte-identical to the existing entries.

**Result — glossary grew from 7 → 68 terms:**
- **46 new term files** across scheduling/automation (Routine, cron expression, fresh-session-per-fire, approval gate), the news inbox (query profile, candidate feed, digest), flows & testing (flow/touch-sequence, scenario test, deterministic spine, golden test, ExUnit, property-based testing), the site generator (static-site generator, dependency-free, markdown renderer, GitHub Pages, deploy gating, HTML escaping, XSS, GFM), retrieval (recall, dedup, recall probe, recall@k, vector database, embeddings, semantic search, ANN), Composable Beliefs/epistemics (typed edge, epistemic overlay, supersession, proto-belief document, route-tag sink), and skills (namespacing, delegation, plugin).
- **15 pointer entries** that defer to the canonical policy/skill docs (routing ledger, session capture, provenance, verification grounding, reason tags, featuring, the `issue`/`analysis`/`methodology`/`plan`/`tutorial` types, etc.) instead of duplicating definitions.
- **6 existing entries** got *Seen in:* citations appended for the threads that also used them.
</routes>

Ids minted (`mix brain.id`), registry refreshed, `index.md` regenerated alphabetically, root `log.md` updated. `mix brain.verify`, `mix brain.route_tags`, and `mix brain.contract --check` all pass. Committed and pushed to `claude/glossary-thread-docs-zwfk6i`.

I deliberately **did not** create glossary files for bare skill-command names (`/intake`, `/capture`, `/news`, etc.) — they're documented in `CLAUDE.md`'s skills registry and read as commands rather than terms of art, matching the existing glossary's convention. If you'd rather each skill have a citable pointer entry too, say the word and I'll add them. Otherwise no open questions — the run is complete. I did not open a PR (branch is pushed and ready if you want one).

## User

Commit

## Assistant

Already committed and pushed — nothing left to do.

- **Commit:** `7d35104 Backfill glossary from remaining thread docs`
- **Branch:** `claude/glossary-thread-docs-zwfk6i` (local HEAD == `origin`, fully synced)
- **Working tree:** clean

All 61 new glossary files, the six updated existing entries, the regenerated `index.md`, `meta/registry.md`, and the `log.md` entry are in that commit. If you'd like, I can open a PR next.

## User

Open pr

## Assistant

PR opened: **https://github.com/ob6to8/second-brain/pull/37** — "Backfill glossary from remaining thread docs" (`claude/glossary-thread-docs-zwfk6i` → `main`).

No PR template exists in the repo, so I wrote a standard summary covering the 7→68 term growth, the coverage areas, the bookkeeping (ids/registry/index/log), and the passing verifiers.

Want me to watch the PR for CI results and review comments? I can subscribe to its activity and autofix failures or respond to reviews as they come in.

## User

Merge pr

## Assistant

Merged. ✅

**PR #37** — "Backfill glossary from remaining thread docs" — is squash-merged into `main` (merge commit `d830fd9`). CI `verify` was green and the branch merged cleanly.

The glossary is now fully backfilled from all thread docs — 68 terms total, up from 7.

## User

/create-pull-request

## Assistant

`/create-pull-request` complete. Here's what happened end to end:

**1. Captured the session** → `meta/threads/2026-07-11-glossary-backfill-from-thread-docs.md` — a verbatim render parsed from the host session log (drop rule applied mechanically: tool calls, reasoning, and short pre-tool narration stripped), plus a `## Where this landed` narrative and a `## Routing` ledger. A route tag feeds the glossary hub (`sb:0b648f`); `mix brain.route_tags --materialize` appended its excerpt block.

**2. Glossaried the thread** → this session's own terminology (the glossary-system terms it discussed) is already defined in the glossary from the #37 work; the thread introduced no *new* terms clearing the selection bar, so per the skill that's a legitimate no-op — I didn't pad the glossary to show activity.

**3–5. Committed & pushed** → the merged PR #37 branch had to be restarted from `main` first (a merged PR is finished). Since the old remote branch held only already-merged history, I force-with-lease pushed the fresh capture commit on top of merged `main`. Full gate suite green: contract, registry, verify, route_tags, and 78/78 tests.

**6. Opened the PR** → **https://github.com/ob6to8/second-brain/pull/38** — "Capture 2026-07-11 glossary-backfill thread" (`claude/glossary-thread-docs-zwfk6i` → `main`). No PR template in the repo, so I wrote a standard body.

**One matter carried forward** (recorded as `paused` in the routing ledger): whether bare skill-command names (`/intake`, `/capture`, `/news`) should get glossary pointer entries, or stay out as commands-not-terms.

Want me to watch PR #38 for CI and review comments, or merge it once checks pass?

## User

whether bare skill-command names (`/intake`, `/capture`, `/news`) should get glossary pointer entries, or stay out as commands-not-terms — Expand on that

## Assistant

Here's the fuller version of that paused matter.

**The actual question**

It's narrower than "should skills be in the glossary." The *concepts* the skills embody are largely **already** glossaried — `session capture`, `thread doc`, `route tag`, `reason tags`, `featuring`, `inbox namespace`, and this session added `skill namespacing`, `skill-to-skill delegation`, and `plugin`. So a reader who wants to know *what capturing a session is* already has a landing page.

What's missing is only the **literal command handles** — `/intake`, `/capture`, `/news`, `/add-to-glossary`, `/create-pull-request`, `/summarize-technical`, `/render-contract` — as resolvable `/glossary/<slug>.md` links. So the real decision is: *do we want the bare command strings to be glossary-addressable, on top of the concepts they enact?*

**The case for adding them**

- **Consistency with the glossary's premise.** Its whole reason to exist is "every term individually linkable by bundle-absolute path." Commands are referenced constantly across threads and concepts; a `[/capture](/glossary/capture.md)` link is the same affordance the glossary gives everything else.
- **Pointer entries are cheap and non-duplicating.** They defer to the `SKILL.md`, so the definition can't drift — exactly what the pointer-entry mechanism is for.
- **Cold-reader value.** Someone hitting `/news` for the first time needs to know what it is; that's the same bar as any term of art.
- **Side benefit:** the glossary index doubles as a command reference.

**The case against**

- **A command isn't a term of art.** The glossary guardrail is explicit: "Don't glossary the incidental." A slash command is an *interface handle*, closer to a proper noun / UI affordance than a concept.
- **The canonical home already exists and is authoritative.** `CLAUDE.md` §7 (compiled from the skills-registry policy) plus each `SKILL.md`. A per-command glossary layer is a **second index that must be kept in sync** — every new/renamed/removed skill now needs a matching glossary edit, or the glossary silently drifts from the registry. Pointer entries stop *definition* drift, not *set* drift.
- **For a command, the glossary is a pointless hop.** This is the strongest one. When I want to link `/capture` in a response, the most useful target is `SKILL.md` **directly** — `[/capture](/.claude/skills/capture/SKILL.md)`. A glossary pointer just bounces the reader one extra click to that same file. The glossary indirection earns its keep when the canonical definition is *buried* (a policy sub-section) — which is why `session capture` → policy is genuinely useful, but `/capture` → SKILL.md is not.
- **Scope creep.** If `/capture` gets an entry, the line to `mix brain.verify`, `mix brain.route_tags`, and every other invocable is arbitrary. "Skill" is a fuzzy stopping point.

**My recommendation**

**Keep bare command names out** — but close the linkability gap two ways:

1. **Lean on the concept entries** (mostly done). When a response needs to reference what a skill *does*, link the concept (`session capture`, `thread doc`) or the `SKILL.md` directly. Neither needs a command-named glossary file.
2. **Optionally add one `skill` concept entry** — a pointer to the skills-registry policy defining what a *skill* is in this brain. That rounds out the trio already added (`skill namespacing` / `delegation` / `plugin`) and gives the *category* a landing page, without minting one file per command or creating a registry-shadowing index.

Net: the decision reduces to a clean principle worth codifying — **"the glossary holds terminology, not invocables; a command's canonical link is its `SKILL.md`, and the concept it enacts (not its handle) is what gets a glossary file."**

Or, if you'd rather go the other way (full per-command pointer set), say so and I'll generate the seven entries instead. Which direction?

## User

Agree

## Assistant

The verifier only warns (never fails), but a persistent warning is noise — and it's actually more honest to mark this row `unrouted`, since the decision was reached in this follow-up conversation, not in the frozen session body (the policy explicitly allows "closed and unrouted"). The `skill` entry is already linked from the narrative.

## User

Add a line to /create-pull-request to log the assigned name of the thread doc after everything is done

## Assistant

Done — all three actions landed on the open PR (**#38**), plus your mid-turn skill edit.

**The decision, executed:**
- **`glossary/skill.md`** (`sb:aa0003`) — one category pointer entry for *skill*, deferring to the skills-registry policy, stating that the concept a skill enacts (not its `/command` handle) is what earns a glossary file.
- **`/add-to-glossary` guardrail** — codified "**terminology, not invocables**" so future runs don't re-litigate it.
- **Thread doc** — the routing-ledger row flipped `paused → closed` (marked `unrouted`, since the decision was reached in this follow-up, not the frozen body — which also keeps the route-tag verifier warning-free), and the narrative's open-matter sentence rewritten to record the resolution.
- Logs updated (`log.md`, `meta/log.md`); glossary is now **69 terms**.

**Your skill request:**
- Added a line to `/create-pull-request` step 6 — after opening the PR, report the captured `meta/threads/YYYY-MM-DD-<slug>.md` path (or note capture was skipped).

Full gate suite green (contract, registry, verify, route_tags, 78 tests) and pushed (`3c66978..5fea729`).

Per that very rule I just added: the thread doc this `/create-pull-request` run captured is **`meta/threads/2026-07-11-glossary-backfill-from-thread-docs.md`**.

PR #38 now carries both the capture and this resolution.

## User

Ready to close. I assume i should run /create-pull-request
