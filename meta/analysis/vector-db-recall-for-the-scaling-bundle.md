---
type: analysis
title: "Would a vector DB improve recall as this bundle scales? A dedup-recall probe says fix intake first"
description: An evidence-backed evaluation, run against the live 39-concept corpus, finding that grep-based dedup already misses existing concepts on natural-phrasing queries (a semantic — not typographic — failure), so the right first move is synonym-expanded intake dedup plus a repeatable recall probe, not a standalone vector database.
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-09 — operator asked to stress-test a prior 'not yet' recommendation on adding a vector DB"
tags: [meta, analysis, recall, dedup, vector-database, embeddings, search, intake, tooling]
timestamp: 2026-07-09
attribution:
  when: 2026-07-09T23:15:17+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
  from: [/meta/threads/2026-07-09-vector-db-recall-evaluation-and-analysis-type.md]
---

# Would a vector DB improve recall as this bundle scales?

**Question.** As the brain grows, should it add a vector database (Chroma,
sqlite-vec, LanceDB, …) to improve *recall* — chiefly the ability to find an
existing concept during intake dedup so we don't file near-duplicates? A prior
pass landed on *"not yet, revisit on signal"* and leaned tentatively toward
sqlite-vec (or even fuzzy lexical search) if/when it became worth doing. This
analysis stress-tests that call against the live bundle.

**Bottom line.** The "no signal yet" premise is **falsified**: grep-based dedup
already misses existing concepts at ~39 concepts. But the fix the evidence points
to is **not** a vector DB — it's a change to intake dedup plus a repeatable recall
eval, both zero-dependency. Recall ≠ structure; nothing here touches the
hand-curated tree (see [tree-is-the-taxonomy](/meta/policy/tree-is-the-taxonomy.md)).

## The probe (reproducible)

Take concepts that demonstrably exist, then search the way a human — or a future
intake agent that isn't holding the whole tree in context — would phrase it when
they *don't* remember the exact title. Check whether `grep` surfaces the right
file. Run over `SWE/` + `ai-industry/` at 39 concepts:

| Natural query | Target concept (its actual wording) | grep result |
|---|---|---|
| `context pollution` | conversation-tree-architecture (uses "poisoning") | 2 hits, **neither is the target** |
| `lost in the middle` | context-rot-chroma-research | **0 hits** |
| `long context degradation` | context-rot-chroma-research | **0 hits** |
| `stale branch` | git-local-branches-dont-auto-advance | **0 hits** |
| `branch not updating` | git-local-branches-dont-auto-advance | **0 hits** |
| `codebase graph` | gitnexus ("code knowledge graph") | **0 hits** |
| `inference margin` | ai-margin-collapse ("inference gross margins") | 1 hit, **not the target** |
| `MQA` / `reranking` / `context poisoning` (exact) | kv-cache / rag-pruning / conv-tree | found |

**~6 of 14 natural-phrasing dedup queries miss an existing concept today.** The
hypothesized failure — search "context window pollution", miss the concept titled
with "poisoning" — reproduces exactly: the word "pollution" appears **zero** times
in the conversation-tree file, so grep returns two unrelated files and a future
agent files a duplicate.

## Why it hasn't bitten yet

Grep-based dedup is already lossy at 39 concepts. It hasn't caused a visible
duplicate because (a) the operator still holds the whole tree in memory, and
(b) the intake **agent** reads `index.md` and reasons semantically — **the LLM is
currently the semantic-search layer**, silently compensating for grep's blindness.
So the thing that degrades with scale isn't grep; it's how much of the tree that
agent can hold in context at once. That is the real signal to watch, and it is
measurable now.

## Answers to the three questions

### 1. Is "not yet, revisit on signal" right?

No — the signal is already here; it was just being absorbed by the agent's own
reasoning. The concrete early-warning check is the probe above: formalize it as a
fixed list of `(natural query → expected concept id)` pairs reporting recall@k
(a `mix brain.dedup_probe`-style task, fitting the existing `lib/mix/tasks/brain.*`
pattern, zero deps). When recall drops as concepts are added, *that* is the
quantified trigger — not a guessed size threshold.

### 2. sqlite-vec vs LanceDB vs Meilisearch/Typesense

The measured misses adjudicate this, and not the way the prior lean guessed. The
dominant failure is **vocabulary mismatch (synonyms/jargon), not typos**:
"lost in the middle" ≈ "context rot" share zero tokens. Therefore:

- **Meilisearch/Typesense typo-tolerance cannot bridge any of the real misses.**
  Edit-distance fixes `recieve`→`receive`; it does nothing for synonym gaps.
  Lexical search still buys **relevance ranking** and **stemming/prefix** — which
  fix the *other* failure mode (cluster saturation: `grep "agent loop"` → 8 files,
  `"context engineering"` → 9, undifferentiated and unranked) — but not the
  dominant one. (Both engines now offer *hybrid vector* search, but that needs an
  embedding model, collapsing them back into "you need embeddings anyway" minus the
  single-file portability.)
- Among the semantic options, **sqlite-vec** wins on both axes the repo values:
  single-file, no service (git-portable), and reachable *inside mix* via `exqlite`
  loading the extension. **LanceDB** is built for millions of vectors, has no
  first-class BEAM binding (you'd shell out to Python/Rust, breaking mix cohesion),
  and is the right tool two orders of magnitude past where this bundle will be.
- **But at this corpus's lifetime scale you don't need the "DB" part of either.**
  1,000 concepts × 384-dim float32 ≈ 1.5 MB; even 10k ≈ 15 MB. Brute-force cosine
  in `Nx` is sub-millisecond. ANN indexing only earns its keep past ~100k vectors —
  a hand-curated brain will not get there. "Which vector DB" is close to a
  non-question: the answer is *an embeddings file + a linear scan*, not a database.

### 3. The middle ground (this is the recommendation)

The failure is localized to one moment (**intake dedup**) and is **semantic**, so:

- **Tier 1 — zero new dependency, do this first.** Change the `/intake` dedup step
  to require the agent to **generate 3–5 alternate phrasings/synonyms** of the
  candidate and grep each, not just the obvious title terms. This uses the model
  already in the loop as the semantic layer and would have caught 5 of the 6 misses
  above. It respects the repo's explicit `deps: []` invariant (`mix.exs`: "runs
  offline in any sandbox") — a design property a vector DB or bundled embedding
  model would break.
- **Tier 2 — embeddings-at-intake, still no vector DB** (adopt only when the recall
  probe starts failing). Cache `meta/embeddings.jsonl`: one vector per concept,
  keyed by stable `id` **and a content hash**. At intake, embed the candidate's
  title+description, brute-force cosine against the cache, surface the top-5 nearest
  as "possible duplicates — check these". The staleness worry mostly dissolves:
  keyed by content hash, it recomputes lazily only for changed files, and it is a
  *derivable, rebuildable cache* — never load-bearing, so it doesn't compromise
  portability the way a persistent ANN index would. The one genuine new dependency
  is the embedding model itself (local via Bumblebee/Nx, or a hosted API) — that is
  the real cost to weigh, not the store.
- **Do not** stand up Chroma/sqlite-vec/LanceDB as a persistent always-on index: it
  solves a scale problem (fast ANN over 100k+) the bundle doesn't have, at the cost
  of the portability it explicitly values, to fix a problem that lives entirely at
  intake time.

## Recommendation

1. Ship the **synonym-expansion dedup** change to `/intake` + a **recall-probe**
   eval now (both zero-dependency).
2. Graduate to **intake-time embedding dedup** (cached, brute-force, no DB) if/when
   the probe shows recall dropping.
3. **Never** reach for a standalone vector DB at this corpus's scale.

The prior architectural instinct (recall is separable from the curated tree) is
correct and untouched; only the "no signal yet" timing call was wrong.

## Relation to other concepts

- [Context rot (Chroma)](/knowledge/SWE/agentic-coding/context-engineering/context-rot-chroma-research.md)
  — the concept the "lost in the middle" / "long context degradation" queries fail
  to find, and the capture that seeded this whole question.
- [Conversation Tree Architecture](/knowledge/SWE/agentic-coding/context-engineering/conversation-tree-architecture.md)
  — the "poisoning" vs "pollution" miss.
- [tree-is-the-taxonomy](/meta/policy/tree-is-the-taxonomy.md) — why recall tooling
  never replaces the hand-curated tree.
- [Pruning RAG context with a small LLM](/knowledge/SWE/llm-engineering/rag-context-pruning-with-a-small-llm.md)
  — adjacent evidence that a cheap LLM scoring step beats heavier retrieval
  machinery, echoing the Tier-1 "use the model already in the loop" move.
