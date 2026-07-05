# Plan 005: Memory Policy

## Context

MEMORY.md exists at `~/.claude/projects/.../memory/MEMORY.md` and is auto-loaded into every conversation's context. It currently works but has no formal policy — what goes in, what stays out, when to update, and how it relates to the rest of the knowledge base.

The memory file is a distinct resource from sources and assertions. Sources are external content. Assertions are claims with evidence. Memory is **operational state** — what Claude Code needs to know to resume work effectively across sessions. It's a cache of project context, not a knowledge artifact.

## Policy

### What MEMORY.md is

A concise operational briefing for session startup. It answers: "What is this project, what state is it in, and what should I know before doing anything?"

### What goes in

- **Project architecture** — content types, key files, directory structure (stable, rarely changes)
- **Plan status** — which plans exist, which are executed/pending (updated each session that touches plans)
- **Scripting gotchas** — platform-specific quirks discovered through debugging (e.g., macOS bash v3.2 limits)
- **Ingestion quirks** — per-platform fetch behaviors (Reddit .json trick, X/Twitter JS wall)
- **Outward-facing projects** — things that originated here but live elsewhere (CLI-MCP, itsjustshell.dev)
- **User preferences** — workflow conventions confirmed across sessions (already in CLAUDE.md, only duplicated in memory if CLAUDE.md can't express it)

### What stays out

- **Session-specific context** — current task, in-progress work, temporary state. Dies with the session.
- **Content that belongs in sources/assertions** — if it's a claim or external content, it goes in the DAG, not memory.
- **Speculative conclusions** — don't write to memory based on reading one file. Verify first.
- **Anything already in CLAUDE.md** — memory supplements CLAUDE.md, doesn't duplicate it.

### When to update

- **End of session** — if plans were created/executed, update plan status
- **When architecture changes** — new content types, new scripts, new directories
- **When a gotcha is discovered** — platform quirks, tool behaviors that caused debugging
- **When user explicitly says "remember this"** — immediate write, no multi-session verification needed

### Size constraint

MEMORY.md is truncated after 200 lines in context. Keep it under 150 lines. If a section grows too large, extract it to a separate file in the memory directory (e.g., `memory/scripting-gotchas.md`) and link from MEMORY.md.

### Relationship to the knowledge base

```
CLAUDE.md          — instructions (how to operate)
MEMORY.md          — operational state (what's happened, what to know)
sources/           — external content (evidence)
assertions/        — claims (beliefs)
index.json         — DAG (relationships)
```

Memory is not part of the DAG. It doesn't appear in index.json. It's infrastructure, not content.

## Steps

### Step 1: Add memory policy to schema/

Create `schema/memory.md` documenting the policy above. This makes it discoverable alongside the other schema files.

### Step 2: Add memory section to CLAUDE.md

Brief reference in CLAUDE.md pointing to `schema/memory.md` for the full policy. One line under a new "## Memory" heading.

### Step 3: Audit current MEMORY.md

Review against the policy. Remove anything that duplicates CLAUDE.md or contains stale session-specific context. Ensure it's under 150 lines.

## Files modified

| File | Action |
|---|---|
| `schema/memory.md` | Create |
| `CLAUDE.md` | Add memory reference |
| `MEMORY.md` | Audit and trim if needed |

## Verification

1. MEMORY.md is under 150 lines
2. No duplication between MEMORY.md and CLAUDE.md
3. `schema/memory.md` exists and is consistent with actual memory behavior

## Status

**Pending approval.**
