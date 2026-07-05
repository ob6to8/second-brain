---
type: source
source_type: conversation
title: "Context engineering and persistent agent memory"
tags: [ai, context-engineering, llm-architecture, agent-memory, simon-willison, llm-cli]
participants: [mark, claude]
date_started: "2026-02-25"
date_captured: "2026-02-25"
summary: >
  Investigation into why LLM conversations are ephemeral by default,
  whether the context window is an artificial constraint masking a
  persistence problem, and how Simon Willison's llm CLI could architect
  truly persistent exchanges where every round is atomically saved.
seed_question: "Why do we do context engineering such that an ephemeral chat transcript is built and then an ad hoc attempt is made to persist its learnings?"
related: []
---

## Seed

Why do we do context engineering in that an ephemeral chat transcript is built and then an ad hoc attempt is made to persist its learnings and progress before the agent is re-initialized and the context is cleared? Is it for the illusion of conversation? Is the fact that persistence needs to be tacked on as an imperfect afterthought (i.e., "before we clear context, commit these learnings to memory somehow somewhere") ideal? Are Claude Code "memories" — i.e., files that are subjective summaries limited to a window the user has no awareness of or even knowledge of what's in them — ideal?

The alternative might be: each round — question, tool calls, and response — MUST be intentionally and transparently persisted, before "continuing the conversation" (illusion). The "conversation" just becomes an infinite set of turns, the context window becomes irrelevant, and every exchange is a fresh agent — BUT that agent is led to load the correct context so that each exchange essentially functions as being links in a conversational chain. Is this possible? How might this be architected using Simon Willison's `llm` in the command line?

## Discussion

### The core tension

The context window is treated as the unit of work, but it's actually a *viewport* — a temporary, lossy view into an ongoing process. The current pattern:

1. Start a session
2. Build up context through exchanges
3. Hit a boundary (token limit, session end, crash)
4. Scramble to persist what matters
5. Start fresh, hope the persistence was good enough

Step 4 is where things break. Persistence is reactive, not structural. What gets saved depends on what the agent (or user) thinks to save, filtered through whatever summarization window happens to be active. Information is lost by design.

### Why it's done this way

The ephemeral model exists because LLMs are stateless functions. Each API call is independent. The "conversation" is a prompt that includes prior turns — it's context engineering, not memory. This creates three problems:

1. **The illusion problem** — users think they're having a continuous conversation, but they're actually rebuilding context each turn via the transcript
2. **The persistence problem** — when the transcript is lost (session end, context overflow), anything not explicitly extracted is gone
3. **The opacity problem** — Claude Code's memory files are agent-written summaries the user never sees, stored in locations the user may not know about, with contents the user didn't approve

### The inversion: persistence-first architecture

The proposal: make persistence the *primary action*, not an afterthought.

Every exchange follows this protocol:
1. **Load** — agent reads relevant prior context from a persistent store
2. **Execute** — agent processes the current turn (question + tool calls + response)
3. **Persist** — the full exchange is atomically written to the store *before* returning the response to the user
4. **The context window is just a cache** — it helps performance but isn't the source of truth

This means:
- No context is ever "lost" — it was persisted at creation time
- The user can inspect every exchange (it's in the store, not hidden in a transcript)
- A new agent can reconstruct any conversation by querying the store
- The context window size becomes a performance parameter, not a correctness constraint

### How `llm` enables this

Simon Willison's [`llm`](https://llm.datasette.io/) CLI already implements the storage layer:

- Every prompt/response pair is logged to SQLite (`~/.local/share/io.datasette.llm/logs.db`)
- Conversations are tracked by ID
- The full exchange history is queryable via `llm logs`
- It's transparent — the user can inspect, search, and export any exchange

A persistence-first architecture on `llm` would look like:

```bash
# Each exchange is a single llm call with loaded context
llm -s "$(load-context thread-id)" "user's question here"

# load-context queries SQLite for relevant prior turns,
# plus any related notes from the assertion-graph index,
# and formats them as a system prompt

# The response is automatically persisted by llm to SQLite
# No explicit "save" step needed — persistence is the default
```

The `load-context` function is the key innovation. It replaces the context window's role as memory by:
1. Querying the conversation thread from SQLite
2. Checking `index.json` for related knowledge base entries
3. Composing a focused context payload (only what's relevant, not the full history)
4. Injecting it as the system prompt for the next `llm` call

### Open questions

- **Latency vs. fidelity** — loading context each round adds overhead. How much is acceptable?
- **Context selection** — who decides what prior turns are relevant? Embedding similarity? Recency? Topic tags?
- **Tool call persistence** — `llm` logs prompts and responses, but not intermediate tool calls. Would need a plugin or wrapper.
- **Editing** — can the user correct or annotate persisted exchanges? The SQLite store is mutable.
- **Conversation boundaries** — when does a "thread" end and a new one begin? Or is that distinction artificial too?
