# Plan 007: Shellclaw Integration + Publish Pipeline

**Status: EXECUTED 2026-03-03**

## Context

Shellclaw was a library looking for an application. The assertion graph is that application. This plan ports shellclaw's proven patterns (LLM abstraction, JSONL logging, test harness, `--describe` convention), executes Plan 002 (persistent conversations via `llm` CLI), and builds a publish pipeline that transforms assertions into site content for itsjustshell.com.

## What was built

### Phase 1: Shellclaw Primitives
- `scripts/lib/llm-call.sh` — LLM abstraction with 3 backends (llm, claude, stub)
- `scripts/lib/log.sh` — JSONL event logging
- `scripts/lib/test-harness.sh` — test framework
- `--describe` added to all scripts (valid JSON schema output)
- `scripts/test/run_all.sh` + 4 test files (66 tests)

### Phase 2: Persistent Conversations (Plan 002 execution)
- `scripts/context-load.sh` — context assembler (topic, assertion, thread modes)
- `scripts/thread.sh` — conversation management (new/continue/list/export/conclude)
- `scripts/export-conversation.sh` — thread → source file

### Phase 3: Publish Pipeline
- `scripts/publish-post.sh` — compound assertion → NimblePublisher blog post
- `scripts/publish-research.sh` — source → research item with thesis-grounded bullets
- `publish/` staging directory
- `.claude/skills/publish/SKILL.md` — /publish skill

## Source

Ported from `/Users/mark/dev/repos/mine/ITS JUST/shellclaw/` (lib/llm.sh, lib/log.sh, test/test_harness.sh).

## Commits

```
fccbb85 Add LLM call abstraction, JSONL logging, and test harness
bb49589 Add --describe JSON schema to all scripts, test runner
2efaddc Add persistent conversations: context-load, thread, export
896dcee Add publish pipeline: blog posts from assertions, research from sources
```
