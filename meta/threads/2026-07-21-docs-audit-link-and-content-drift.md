---
type: reference
title: 2026-07-21-docs-audit-link-and-content-drift
description: A two-pass docs overhaul since the 2026-07-11/12 audit — an independent broken-link scan (one live fix in the inbox digest) and a content-drift sweep (one live fix in a tutorial index), both landing on ungated prose surfaces while gated/generated surfaces stayed clean.
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-21; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, docs-audit, link-audit, drift, verification]
timestamp: 2026-07-21
session: https://claude.ai/code/session_01TKU4LdfJv9r7j9ZnH1WDhQ
---

# 2026-07-21-docs-audit-link-and-content-drift

## Where this landed

Two audit passes over the bundle since the last docs overhaul (the 2026-07-11/12
docs-audit session, PRs #48/#49). **Pass one — links:** an independent scan of
all 4243 internal markdown links across 680 docs, replicating `ElixirMind.Links`'
exemptions (frozen `meta/threads/` bodies and `## Thread excerpts — route-tagged
log` sections). The only genuinely-live breakage was three `agentic-coding` →
`agentic` pointers in `inbox/2026-07-11.md` (the rename swept live docs but missed
the digest); fixed. **Pass two — content drift:** a prose-vs-reality sweep for
stale identifiers from the recent features (elixir-mind lib separation, `sb:`→`em:`
migration, the retired auto-injected SessionStart digest, growth to 25 policies).
One methodological misstep — an edit to `compiled-contract.md` that landed inside a
frozen excerpt log and broke `mix brain.route_tags` fidelity — was caught by the
gate and reverted; the scan was then rebuilt to strip excerpt logs. The lone real
content drift was an ungated index description (`meta/tutorials/index.md` still
called the session-init digest one "the SessionStart hook injects"); fixed.
**Pass three — plans sweep:** every old-name reference in `meta/plans/` turned out
to be legitimate rename-documentation ("from"-side of an arrow, "predate", "ported
from", "retired"), so nothing changed. Net: two live-drift fixes, both on ungated
prose surfaces — reproducing the prior audit's own thesis that gated and generated
surfaces carry zero drift by construction.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Broken-link audit; fix stale `agentic-coding` inbox pointers | closed | `unrouted` (landed in the commit) | - |
| Content-drift sweep; fix retired-SessionStart tutorial index description | closed | `unrouted` (landed in the commit) | - |
| Erroneous edit inside a frozen excerpt log, caught by the fidelity gate | closed | `unrouted` (methodology note, in narrative) | - |
| Plans old-name sweep — all refs are legitimate rename-documentation | closed | `unrouted` (no change needed) | - |
| Inbox digests: frozen record vs. maintained navigable pointers | closed | `unrouted` (resolved: verifier flags them ⇒ maintained) | - |

## User

reference the last 20-30 prs, go as far back as you can find that the last docs overhaul and cleanup was done. then do another pass over the docs referencing all the new work that was done. make sure all cross links between docs is correct, make sure that all links themselves are correctly linking to an existing doc. ask questions if needed

## Assistant

The glossary target files exist — so those `/glossary/...` links are broken only because they sit inside `## Thread excerpts — route-tagged log` sections (frozen verbatim quotes), which the verifier correctly strips. My scan didn't strip those. Let me refine the scan to match the exemptions (frozen threads + excerpt logs) to isolate the *genuinely live* broken links.

Independent scan now matches the verifier: **only 3 genuinely-live broken links, all in `inbox/2026-07-11.md`** (the rest were frozen threads / route-tag excerpt logs, correctly exempt). Now let me (a) check whether those 3 inbox targets exist under a renamed path, and (b) go beyond mere resolution to check *semantic* cross-link correctness.

All three inbox targets exist — just under the renamed `agentic/` path (the `agentic-coding` → `agentic` rename swept live docs but missed this digest). These are the "✓ intaken →" navigation pointers, so working links are clearly the intent — safe to fix. Now for *semantic* correctness (links that resolve but may point at renamed/wrong targets), let me sweep live docs for stale identifiers from the big renames since the last audit (`second-brain`→`elixir-mind`, `agentic-coding`→`agentic`, `sb:`→`em:`, old `meta/flows/`).

Three inbox digests exist (07-09, 07-11, 07-12); only 07-11 has broken links — the other two resolve, confirming inbox links are meant to be *navigable*, not frozen. The three targets are the same docs (stable ids `em:f02167`, `em:c29a22`, `em:532b22`) relocated by the `agentic-coding`→`agentic` rename that swept live docs but missed this digest. Fixing them is a pure mechanical rename that restores navigation — squarely "make links point to existing docs".

Committed and pushed to `claude/docs-overhaul-link-audit-tqt6c4`. Here's the full audit.

## What I did

**Anchored the scope.** The last docs overhaul was the **docs-audit session (PRs #48/#49), 2026‑07‑11/12**. The ~75 PRs since (roughly #50→#124) are the "new work" — the elixir-mind rename, the `sb:`→`em:` id migration, the `agentic-coding`→`agentic` restructure, plus dozens of intakes, analyses, plans, and glossary additions.

**Ran an independent, full-bundle link scan** (not just trusting one tool): 680 docs, **4,243 internal links**. I cross-checked my scan against `mix brain.verify`'s `ElixirMind.Links`, replicating its two policy exemptions — frozen `meta/threads/` bodies and `## Thread excerpts — route-tagged log` sections (both quote frozen history verbatim, so a stale link in them is a record, not drift).

**Verified semantic correctness too**, not just resolution: swept every live markdown link carrying a stale rename token (`second_brain`, `agentic-coding`, `sb:`). All but one were legitimate — they're the actual filenames of docs *about* the renames (`rename-second-brain-to-elixir-mind.md`, `comparison-with-the-2026-second-brain-field.md`). The one exception (`ai-agent-memory…:99`) sits inside a frozen excerpt log — correctly exempt.

## The one real finding — fixed

Across the entire bundle, the **only genuinely-live broken links** were 3 in `inbox/2026-07-11.md`. The `agentic-coding`→`agentic` rename swept the live docs but missed this daily digest, so its three "✓ intaken →" pointers still aimed at `/knowledge/SWE/agentic-coding/…`. The targets are the *same documents* (stable ids `em:f02167`, `em:c29a22`, `em:532b22`) relocated under `/knowledge/SWE/agentic/…`. I swapped the 6 occurrences (the links plus the adjacent "would file under" path prose). Post-fix: **0 live broken links.**

## Everything else is green
- `mix brain.verify` — clean (ids, edges, grounding; 0 link warnings).
- `mix brain.registry --check` / `mix brain.contract --check` — up to date.
- `mix brain.route_tags` — tags, refs, sink logs, and log fidelity all pass. (One *pre-existing editorial* warning: thread `2026-07-13-execute-branch-transplant-ports` routes its ledger to a concept but carries no route tags — that's a tagging-coverage note, not a link issue, and outside this audit.)
- Index coverage — every directory has an `index.md` and every doc is listed.

The bundle is in genuinely good shape — the CI/pre-commit link gate plus the last audit kept cross-links clean; the inbox digest was the one spot the gate flags but never *fails* on, so it slipped through.

**One judgment call to flag:** I treated the inbox digest as *maintained* (fix the pointers) rather than *frozen* like thread docs. My reasoning: the verifier actively flags inbox link breakage (threads are explicitly exempt, inbox is not), the other two digests' links all resolve, and the stable ids mean the fix preserves the historical fact while restoring navigation. If you'd rather inbox digests be frozen-at-write records (leave stale paths as history), say so and I'll revert that one file.

I did **not** open a PR (not requested). Want me to open one, or run `/create-pull-request` to capture the session alongside it?

## User

ok great. now what about a doc audit related to actual content? i assume they must have drifted from recent features

## Assistant

Good — that's a different and harder audit: **content drift**, where a doc's *prose* describes tooling/skills/policies that have since changed, even though its links resolve. Let me first establish ground truth (what tooling/skills/modules actually exist now) and reuse the framework from the last content audit, then find where docs describe the system in stale terms.

The enumerating tutorials (gate-suite, three-scanners) are current and internally consistent — the strong gating culture kept them fresh. Drift concentrated in **ungated inline prose** (glossary concept bodies, index descriptions) where facts were hardcoded. Let me sweep for other stated-count/stated-path facts that could have drifted the same way.

Wait — critical catch. The `## Thread excerpts — route-tagged log` heading in `compiled-contract.md` is at **line 26**, so my edits at lines 36 and 54 landed **inside the frozen excerpt-log**, not the live body. Those "twenty-one policies" / `lib/second_brain` / `SecondBrain.Contract` strings are **frozen thread quotes — history, not live drift**. My content grep didn't exclude excerpt logs (my *link* scan did). Let me confirm the fidelity gate now fails and revert.

Confirmed my error: the **live body** (lines 17–25) is already **correct and current** — it says `lib/elixir_mind/contract.ex`, states no policy count, and has no `SecondBrain.Contract`. The stale strings I edited were frozen thread quotes in the excerpt log — history that must stay verbatim, and `mix brain.route_tags` now **FAILS** fidelity because I corrupted the materialized block. Reverting immediately.

With proper excerpt-log stripping, the live content-drift picture is now clean and honest:

- **`second_brain` (134 hits): all legitimate** — filenames (`rename-second-brain-to-elixir-mind.md`, `comparison-with-the-2026-second-brain-field.md`), prose *documenting* the rename, or discussion of the external "second-brain" product genre. No drift.
- **`SecondBrain.` module (7 hits): all in the rename plan** documenting `SecondBrain.X → ElixirMind.X`. No drift.
- **`sb:` id (1), stated count (1): both point-in-time plan content.** Not drift.
- **3 glossary entries reference not-yet-built commands** (`brain.decisions`, `brain.graph`, `brain.summarize`) — need to confirm they're framed as *proposed*.

Committed and pushed. Here's the content-drift audit result.

## Method
I checked whether docs' *prose* describes tooling/skills/policies that have since changed — the harder audit, since these links all resolve. I established ground truth (16 mix tasks, 13 skills, 25 policies, actual module names) and swept live docs for stale identifiers from the recent structural features (the `elixir-mind` lib separation #100/#118, `sb:`→`em:` id migration, the retired auto-injected SessionStart digest, policy growth).

**Crucial correction mid-audit:** my first content grep flagged `beliefs/glossary/compiled-contract.md` as having 3 stale facts ("twenty-one policies", `lib/second_brain/contract.ex`, `SecondBrain.Contract`) and I edited them — but those strings live in that doc's **frozen route-tag excerpt log** (materialized thread quotes, history that must stay verbatim). `mix brain.route_tags` fidelity **failed**, catching the mistake; I reverted, then rebuilt the scan to strip excerpt logs *and* frozen threads (matching how the link scan already worked). The doc's live body was already current.

## What the corrected audit found
The bundle is **remarkably clean** — the renames and lib-separation were swept comprehensively through live prose:
- **`second_brain` (134 live hits): all legitimate** — filenames, prose documenting the rename, or discussion of the external "second-brain" product genre.
- **`SecondBrain.` module (7 hits): all in the rename plan**, documenting `SecondBrain.X → ElixirMind.X`.
- **Nonexistent `mix brain.X` commands** (`graph`, `decisions`, `summarize`, etc.): all correctly framed as **proposed** tooling in plans, or plan-derived glossary concepts that say "proposed" explicitly.
- **Enumerating tutorials** (gate-suite, three-scanners), the **README**, root **index**, and **skills-registry** — all current.

## The one real fix
`meta/tutorials/index.md` still described the session-init digest as one "the SessionStart hook injects" — but that coupling was **retired** (the tutorial body and CLAUDE.md already reflect on-demand `/priorities` delivery). The index description was the stale outlier. Fixed → "surfaced on demand by the `/priorities` skill."

## The takeaway
This audit reproduced the *prior* audit's own thesis (quoted in the glossary): **CI-gated and generated surfaces carry zero drift by construction; the only staleness sits on ungated prose** — last time it was the README and a couple index entries; this time it was a single index description. Combined with task 1 (the inbox links), both live-drift misses were on exactly those ungated surfaces.

**Two things I deliberately left (flagging, not fixing):**
- `meta/plans/glossary-single-overview-and-dedup-check.md` references `lib/second_brain/` and `SecondBrain.Glossary` — but it's an *accepted* plan (a point-in-time decision record, aware of the rename). Plans aren't frozen like threads, but they document state at authoring. Want me to sweep old-module-name references in the plans too, or leave plans as historical records?

Both commits are on `claude/docs-overhaul-link-audit-tqt6c4`; no PR opened yet. Say the word if you'd like one (or `/create-pull-request` to capture the session with it).

## User

Yes sweep plans too

## Assistant

Swept every plan. **The plans are already clean — nothing to change.** Reading the full context of every old-name reference confirms each is legitimate:

| Ref | Verdict |
|-----|---------|
| `derived-index-listings.md:173` — "predate the `second-brain` → `elixir-mind` rename (`sb:` ids, `lib/second_brain` paths)" | Describes the rename's *scope* — keep |
| `derived-index-listings.md:190` — "re-minted fresh (`em:59cff6`) rather than tail-carrying `sb:715275`" | Explains a migration *decision* — keep |
| `glossary-single-overview.md:26` — "`SecondBrain.*` → `ElixirMind.*`, `lib/second_brain/` → `lib/elixir_mind/`" | *Is* the rename mapping — keep |
| `glossary-single-overview.md:29` — "its new module/thread use **retired** `sb:` ids and `SecondBrain.*` names" | Explicitly flags them as retired — keep |
| `glossary-single-overview.md:81` — "`lib/elixir_mind/glossary.ex` — `ElixirMind.Glossary` … ported from PR #64's `SecondBrain.Glossary`" | Uses the **new** name; old name is "ported from" provenance — keep |

Every hit sits on the *from*-side of an explicit rename arrow, or is labelled "predate / ported from / retired." Editing them would corrupt the record (e.g. "`second-brain` → `elixir-mind` rename" would become "`elixir-mind` → `elixir-mind` rename" — nonsense). None is a stale pointer that names current code by its old identifier.

So I have to walk back the flag I raised last turn: when I actually read `glossary-single-overview-and-dedup-check.md` in full (rather than trusting the raw grep hit), it's **correct as written** — it even names the artifact by its current `lib/elixir_mind/glossary.ex` / `ElixirMind.Glossary` identity and cites `SecondBrain.Glossary` only as historical provenance. No commit this turn; there was nothing to fix.

**Net across the whole docs overhaul:** two genuine live-drift fixes landed (the inbox `agentic-coding` links, and the `tutorials/index.md` SessionStart description) — both on ungated prose surfaces, exactly where the gating leaves gaps. Everything else — threads, excerpt logs, plans, the rename/lib-separation references — is correct history that should stay as-is.
