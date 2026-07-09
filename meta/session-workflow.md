---
type: note
title: Session capture, routing & route tags — end-to-end guide
description: How a working session becomes a distilled thread doc, a routing ledger, and route tags that materialize a re-derivable excerpt log into each concept — the full pipeline, data model, tooling, invariants, and the Composable Beliefs port it was adapted from.
tags: [meta, governance, threads, capture, routing, route-tagging, workflow, guide]
timestamp: 2026-07-08
---

# Session capture, routing & route tags — end-to-end guide

This is the connective guide for one subsystem of the brain: turning a
non-linear working **session** into a durable, auditable record. It is an
orientation and runbook document — the **authoritative rules** live in the
`session-workflow` policies (compiled into [`/CLAUDE.md`](/CLAUDE.md) §8); the
**procedure** lives in the [`/capture` skill](/.claude/skills/capture/SKILL.md);
the **mechanism** lives in Elixir. This page ties them together and explains
*why* the pieces are shaped the way they are.

> **Sources of truth (don't restate — point):**
> [session-capture](/meta/policy/session-capture.md) ·
> [routing-ledger](/meta/policy/routing-ledger.md) ·
> [route-tagging](/meta/policy/route-tagging.md) policies;
> [`SecondBrain.RouteTags`](/lib/second_brain/route_tags.ex) +
> [`mix brain.route_tags`](/lib/mix/tasks/brain.route_tags.ex).

---

## 1. The problem

A working session (a **thread**) is non-linear. It opens several matters, spins
off side quests, pauses strands on an unanswered question, and resolves others.
Left in the raw transcript, that state lives only in your head: to reply you must
re-read the whole thread and reconstruct which strands dangle and where each
one's conclusions went.

Three things are missing, and this subsystem supplies each:

1. a **readable record** of what was actually said (not the reasoning/tool noise);
2. a **dispatch map** of which strands opened, paused, or routed where; and
3. an **audit trail** from each region of the session to the durable page it feeds.

The transferable idea behind it is filed as a concept:
[routing non-linear work sessions](/SWE/agentic-coding/context-engineering/routing-non-linear-work-sessions.md)
(`sb:d479e3`). This page is the *implementation* of that idea in this bundle.

---

## 2. The pipeline

```
   a working session
          │
          ▼
   ┌──────────────┐   /capture (on-demand skill, once at close)
   │   CAPTURE     │   render substantive responses only; drop reasoning,
   │  (distill)    │   tool calls/results, <300-char pre-tool narration,
   └──────┬───────┘   system/slash wrappers
          │  writes
          ▼
   meta/threads/YYYY-MM-DD-<slug>.md   (type: reference, governance, no sb: id)
   ┌───────────────────────────────────────────────┐
   │ frontmatter                                    │
   │ ## <narrative>   — what it was, where it landed │
   │ ## Routing       — the LEDGER (pointers+states) │◄── router, never a digest
   │ ## User / ## Assistant   — the frozen render    │
   │   <routes ref="sb:… path/…"> … </routes>        │◄── ROUTE TAGS on frozen body
   └──────┬─────────────────────────────────────────┘
          │  mix brain.route_tags --materialize
          ▼
   the referenced concept docs (the SINKS, each with an sb: id)
   ┌───────────────────────────────────────────────┐
   │ … the concept body …                           │
   │ ## Thread excerpts — route-tagged log           │◄── append-only, dated,
   │   ### <thread-slug> (<date>)                    │    GENERATED from the tags
   │   **[`sb:…`]** (co-feeds: …) + region, whole    │
   └──────┬─────────────────────────────────────────┘
          │  mix brain.route_tags   (CI + pre-commit)
          ▼
   re-derives each log from the current tags → FAILS on divergence
```

Everything downstream of the frozen body is one **finalization motion**: because
`/capture` runs once at close, there is no per-turn rewrite to fight — the body
is frozen when written, and tagging + ledger + materialization happen over it.

---

## 3. The four moving parts

### 3a. Capture — retained responses verbatim, only the noise stripped

`/capture` writes the thread doc from the conversation (or, most faithfully, by
parsing the host session log). It **keeps every exchange** and drops only three
things: tool calls and results; reasoning/thinking; and short pre-tool narration —
an assistant text block that is *both* under ~300 chars *and* followed by a tool
call. **Everything it keeps is reproduced verbatim** — the delivered text of each
operator message and agent response, never summarized or paraphrased. Everything
else survives: any longer block (even mid-turn, before a tool), any block **in
isolation** (nothing after it in the turn calls a tool — a closing reply or a
standalone short remark) **even when short**, and all text in a tool-less turn.
This is the exact rule from Composable Beliefs' `transcript_hook.py` — a block is
dropped iff `len(strip) < 300 and followed_by_tool`, so a short statement is
dropped *only* as a pre-tool lead-in, never in isolation — re-homed as an
**on-demand skill** rather than a per-turn Stop hook, so there is no crash-safe
draft lane and no git auto-staging to maintain. "Distilled" means the *noise* is
dropped, not that the kept text is condensed: it is the brain's sole
session-persistence skill, and it **renders and routes** rather than digesting.

### 3b. The routing ledger — a router, never a digest

A `## Routing` table inside the thread doc, one row per topic:

| Topic | State | Routed to | Dangling |
|-------|-------|-----------|----------|
| one line | `open` / `paused` / `closed` | `[concept](/path.md)` or `unrouted` | the open question, or `-` |

The load-bearing invariant: **it holds pointers and states only, never
synthesized content.** Content lives in the routed-to concept; if it were copied
here too, the ledger would become a stale shadow of that concept. *State*
(the strand) and *routed-to* (dispatch) are orthogonal — a strand can be routed
yet still `open`, or `closed` and `unrouted`. It answers exactly one question:
*what would I need to know to reply to this thread without re-reading it?*

### 3c. The concept sink — the per-matter aggregating page

The durable page a strand's content lands in is an OKF **`concept`** doc,
anywhere in the knowledge tree, carrying a stable `sb:` id. It is the aggregating
**sink**: every thread that routes to it appends a dated block to its
`## Thread excerpts — route-tagged log` section, so a matter's whole cross-thread
discussion accretes in one place. A concept **accepts appends while its matter is
unresolved and freezes acceptance when the matter resolves** — per matter, not on
archival.

### 3d. Route tags — the located, auditable back-edge

Over the frozen body, mark each region with the concept(s) it feeds:

```
<routes ref="sb:4c9e1f lib/second_brain/route_tags.ex">
... one paragraph, lifted whole ...
</routes>
```

- **Keyed on canonical ids.** A ref is a concept's `sb:` **id** (the aggregating
  sink) or a **path** (a non-aggregating back-link to code/a file — no log).
  Ids, not free-text topics, so two threads about the same matter emit the *same*
  string and the cross-thread join is exact.
- **Per-paragraph, multi-ref, lifted whole.** A paragraph feeding two matters
  carries both refs on one region (never nested). The tag boundary *is* the
  auditable selection — no trimming inside a region. A region must not cross a
  `## User`/`## Assistant` boundary.

---

## 4. The data model & ref kinds

| Thing | Where it lives | Identified by | Role |
|-------|----------------|---------------|------|
| Thread | `meta/threads/*.md` (`type: reference`) | filename slug + date | **source** of tags; not a bundle concept, no `sb:` id |
| Ledger | `## Routing` in the thread | — | per-thread dispatch (pointers + states) |
| Concept | anywhere in the tree (`type: concept`) | **`sb:` id** | aggregating **sink**; accretes the excerpt log |
| Excerpt log | `## Thread excerpts — route-tagged log` in the concept | — | generated from tags; verifier-owned |
| Route tag | `<routes ref="…">` region in the frozen body | its ref set | the located back-edge |

**`classify_ref/1` recognises exactly two kinds** (see
[`route_tags.ex`](/lib/second_brain/route_tags.ex)):

- `sb:…` → **`{:doc, id}`** — an aggregating concept sink, resolved to a path via
  the stable-id registry. Accretes a log block.
- anything else → **`{:path, ref}`** — a back-link that must resolve to a real
  file (bundle-absolute `/…` or repo-relative) but accretes **no** log.

This is the one substantive adaptation from the source repo — see §7.

---

## 5. The tooling: `mix brain.route_tags`

Runs beside `mix brain.verify` in [CI](/.github/workflows/ci.yml) and the
[pre-commit hook](/.githooks/pre-commit).

```
mix brain.route_tags               # verify; exits non-zero on any :fail
mix brain.route_tags --materialize # (re)generate each fed concept's log, then verify
```

The five checks, in order (a `:fail` fails the task; a `:warn` never does):

| Check | Level | What it enforces |
|-------|-------|------------------|
| **tag wellformedness** | fail | regions line-anchored & outside fenced code, balanced, never nested, never crossing a turn boundary, non-empty ref set |
| **ref resolution** | fail | every ref resolves — `sb:` ids to a bundle concept, paths to a real file |
| **sink logs** | fail | every concept a tagged thread feeds carries a dated block for that thread |
| **log fidelity** | fail | each block equals its re-derivation from the current tags; a block for a thread that no longer tags the sink is an **orphan** and fails |
| **ledger cross-check** | warn | every concept-routed ledger row is covered by ≥1 tag; a thread with routing rows but no tags is reported once |

**Why the split.** Log *completeness for tags that exist* is mechanizable, so the
first four checks **fail**. Tag *coverage* — did you tag every paragraph that
feeds a matter — has no mechanical oracle and stays editorial, so the ledger
cross-check only **warns**, lifting coverage to row granularity without pretending
to prove it.

**`--materialize`** makes the log *generated, not hand-kept*: it writes each fed
concept's `## Thread excerpts — route-tagged log` from the current tags (adding
the section if absent, replacing it if present), using the canonical
`derive_block/3` format. The verifier is then the structural backstop: edit a
tagged paragraph without re-materializing and **log fidelity goes red**.

---

## 6. Invariants (the whole point)

- **The ledger holds pointers and states only** — never synthesized content.
- **Refs are canonical ids** (a concept's `sb:` id, or a code path) — never
  free-text topic phrases, or the cross-thread join silently fails.
- **The routed-to sink concept is the aggregating ref** (it accretes the log);
  a path is an optional non-aggregating back-link with no log block.
- **Tags are lifted whole** — the tag boundary is the auditable selection; no
  within-region trimming.
- **The excerpt log is append-only and date-stamped**, each block quoting a
  *frozen* thread so it never goes stale; the verifier closes completeness by
  re-deriving from current tags and failing on divergence. Tag coverage stays
  editorial (warn only).
- **A concept freezes excerpt acceptance when its matter resolves** — per matter,
  not on archival.

---

## 7. Provenance: the Composable Beliefs port

Adapted from the [Composable Beliefs](https://github.com/composablebeliefs/composable-beliefs)
repo, at the **OKF floor only** — the belief graph / DAG (`cb:bNNN` ids, mint
manifests, rigor tiers, planting/minting) was explicitly out of scope. What
changed in translation to this bundle:

| Composable Beliefs | This bundle |
|--------------------|-------------|
| proto-belief doc (`beliefs/nursery/`) | OKF `concept` doc, anywhere in the tree |
| thread (`beliefs/nursery/threads/`) | thread doc under `meta/threads/` (governance) |
| capture as an automatic Stop **hook** | `/capture` as an on-demand **skill** |
| route-tag ref = flat slug or `cb:bNNN` | route-tag ref = **`sb:` id** or **path** (no belief kind) |
| `mix cb.verify.route_tags` | **`mix brain.route_tags`** |

The key adaptation is the ref model. cb resolves doc refs by *flat slug* because
all its proto-belief docs share one directory; this bundle spreads concepts
across a deep tree and gives each a stable `sb:` id, and its contract already
says *typed edges reference ids, not paths* — so the aggregating sink ref here is
the **`sb:` id**, and `classify_ref/1` collapses to two kinds instead of three.

---

## 8. Worked example & quickstart

The first end-to-end instance is thread
[2026-07-08-adopt-session-capture-routing-and-route-tags](/meta/threads/2026-07-08-adopt-session-capture-routing-and-route-tags.md),
whose route tag `<routes ref="sb:d479e3 lib/second_brain/route_tags.ex">`
materialized the excerpt log in concept `sb:d479e3` (with `route_tags.ex` shown
as a co-feeding back-link). Read the two files side by side to see the tag → log
round trip.

To capture a session yourself: run **`/capture`** and follow
[its SKILL.md](/.claude/skills/capture/SKILL.md) — render, narrative, `## Routing`
ledger, route tags on the frozen body, then `mix brain.route_tags --materialize`
and `mix brain.route_tags` to lock it in.
