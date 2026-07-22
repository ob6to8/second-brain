---
id: em:bec37f
type: concept
title: distill, don't dump
description: A retired slogan (through 2026-07-22) that framed the brain's whole retention stance as a single distill-vs-dump axis; reframed as the per-layer doctrine "fit each layer to its purpose", with its one true filing injunction preserved in the capture-knowledge-cite-the-source policy.
provenance: "Agent-distilled glossary definition, pointer to the defining doc"
verified: false
tags: [glossary, filing, distillation, governance]
sense: repo
timestamp: 2026-07-16
attribution:
  when: 2026-07-13T20:28:57+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-13 council-round-suitability-evaluation thread; pointer entry deferring to the repo's own filing policy"
---

# distill, don't dump

It failed on three counts. Its two labels fit neither end cleanly: thread docs
strip noise rather than dump, and knowledge docs often *expand* a fragment (the
fragment serving as provenance) rather than boil it down. Its one dial implied
one right answer, when retention is set independently per layer by that layer's
purpose. And it applied a single rule across levels that need opposite rules —
"always distill" mischaracterizes the provenance layer, whose correctness
*depends on* fidelity. The [session capture](/beliefs/glossary/session-capture.md)
sense of "distilled" (noise-stripped, kept text verbatim) is the record-layer
half of what replaced it.

*Seen in:* [2026-07-13 council-round thread](/meta/threads/2026-07-13-council-round-suitability-evaluation.md)

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:bec37f">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-22-qiju-thread-storage-and-fit-each-layer-doctrine (2026-07-22)

2 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:bec37f`]**

**What Qiju is, and how it stores "threads"**

Qiju is a **local-first session-record system for AI coding agents** — a shared memory layer that Claude Code, Codex, Kiro, and Cursor all write to and read from, so an agent can "continue from verifiable development history" after the context window compacts or you switch tools. Three commands: `/qiju-log` (record what's worth keeping), `/qiju-search` (retrieve), `/qiju-review` (mine recent records for patterns).

The crux — and the part most relevant to us — is **what it stores and how**: it stores distilled decision records, never transcripts. A record is a structured JSON object (title, tags, search_terms, next_steps, redactions, body_md). The docs are explicit: *"Qiju does not capture sessions silently and does not ingest raw transcripts… decisions, evidence, failed paths, and next steps survive the session that produced them."* Three-tier storage keyed on age/access — hot (`<project>/.qiju/short.jsonl`), durable (`~/.qiju/long/<project>.jsonl`), archive (monthly parquet) — with reads merging all tiers and deduping by id, and a deliberately embedding-free two-phase retrieval (explicit filters → hydrate by id).

---

**[`em:bec37f`]**  (co-feeds: `em:1b3c79`)

You're right to push, and part of what I told you earlier was sloppy. First, the correction: routing is *not* distillation. The thread body is verbatim; the doc-side route-tagged excerpt log *lifts the tagged regions whole* — verbatim excerpts, headers demoted. So the entire routing/route-tagging apparatus is **provenance wiring, not distillation**. If anyone claimed "the tags/ledger over the threads *are* the distillation," that claim is false — and I effectively made it. You cannot call expository/provenance layering over a verbatim record "distillation." Conceded.

What's actually going on: two artifacts, two policies, two senses of one word. **Knowledge documents** (governed by distill-dont-dump) genuinely distill — raw material goes to citations. **Thread docs** (governed by session-capture) are deliberately verbatim; the policy *explicitly narrows* the word: *"'Distilled' here means the noise is dropped, not that the kept text is condensed."* So the thread doc is a dump minus the noise — that's not a bug, it's the archive layer doing its job. The two layers serve opposite masters: knowledge wants concision + queryability; provenance wants fidelity (you cannot reconstruct "what did we decide and why" from a lossy summary — a condensed record is a *worse* record).
