---
type: reference
title: 2026-07-11-deprecated-directory-triage-and-machinery-deletion
description: Assessed whether deprecated/ can be deleted (not yet), migrated the first legacy source into the bundle via /intake, deleted the old assertion-graph machinery while keeping the content pending triage, and filed a todo for the rest.
provenance: "Claude Code session, 2026-07-11; verbatim retained messages parsed from the host session log — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, deprecated, migration, intake]
timestamp: 2026-07-11
---

# 2026-07-11-deprecated-directory-triage-and-machinery-deletion

Verbatim render. Retained operator messages and agent responses are reproduced
**verbatim** (the delivered text); only tool calls, tool results, reasoning, and
short pre-tool narration are stripped. Parsed from the host session log via
`/capture`'s parse-the-log path.

## Where this landed

The operator asked whether the `deprecated/` directory — the pre-OKF
"assertion graph" knowledge base — is safe to delete. The session established
it is **not yet**: the machinery is disposable but the content isn't migrated.
Three things happened. First, the initial migration:
`deprecated/sources/ai-agent-memory-markdown-files.md` was processed via
[`/intake`](/.claude/skills/intake/SKILL.md) into
[AI agent memory management — when markdown files are all you need](/SWE/agentic-coding/context-engineering/ai-agent-memory-management-markdown-files.md)
(`sb:41a1e3`), re-fetched from the live dev.to article rather than copied, so
the capture gained detail the legacy summary lacked. Second, on the operator's
direction, the legacy system's **machinery was deleted** (commit `d1ef400`,
3,423 lines): scripts, schema, templates, publish staging, old skills, the
generated `index.json`, and its `CLAUDE.md`/`README.md` — all recoverable from
git history — while the **content** was kept pending triage: 13 source
captures, 9 assertions, a 604-line raw-URL backlog discovered in
`intake/intake.md`, and the old plans, with a new `deprecated/README.md`
tracking migration state. Third, the remaining work was filed as a task
("Go through rest of deprecated/") carrying the batching order (the six-source
agent-memory cluster first), the assertion-folding approach, and the two
operator decisions still open (URL backlog: triage or discard; old plans:
graduate any to `meta/`?). Work happened on branch
`claude/deprecated-directory-deletion-myusjh`.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Migrating `ai-agent-memory-markdown-files` from `deprecated/sources/` into the bundle | closed | [ai-agent-memory-management-markdown-files](/SWE/agentic-coding/context-engineering/ai-agent-memory-management-markdown-files.md) | - |
| Is `deprecated/` safe to delete? — triage of what remains | open | `unrouted` | 13 sources + 9 assertions to migrate; operator to decide fate of the raw-URL backlog and the old plans |
| Deleting the legacy assertion-graph machinery | closed | `unrouted` | - |

## User

Are we clear to delete deprecated directory?

*(This and the next two operator prompts each received only a harness
rate-limit banner — "You've hit your session limit · resets 11:20am (UTC)" —
with no agent response; the work began on the fourth prompt.)*

## User

Continue from where you left off.

## User

/intake ai-agent-memory-markdown-files.md

## User

Continue from where you left off.

## Assistant

The intake is filed, verified, and pushed. Here's where things stand:

<routes ref="sb:41a1e3">
**Intake result.** `deprecated/sources/ai-agent-memory-markdown-files.md` is now migrated into the bundle as [`SWE/agentic-coding/context-engineering/ai-agent-memory-management-markdown-files.md`](/SWE/agentic-coding/context-engineering/ai-agent-memory-management-markdown-files.md) (`sb:41a1e3`, `type: reference`). I re-fetched the dev.to article rather than just copying the legacy capture, which added detail the old summary lacked (the author's name, Manus's `task_plan.md`/`notes.md`/deliverables pattern, and OpenClaw's 70:30 vector-to-BM25 weighting at 89% recall). It's cross-linked to the Anthropic memory-tool reference and the context-engineering essay, and the provenance records the migration from the legacy bundle. Directory `index.md`, root `log.md`, and `meta/registry.md` are updated; `mix brain.verify`, `brain.route_tags`, and `brain.contract --check` all pass. Committed and pushed to `claude/deprecated-directory-deletion-myusjh` (no PR opened — say the word or run `/create-pull-request` when you want one).
</routes>

<routes ref="deprecated/README.md">
**Are we clear to delete `deprecated/`? Not yet.** This was the *first* migration — after it, `deprecated/` still holds **13 unmigrated sources and 9 assertions** whose content exists nowhere else in the bundle. The rest of the directory (scripts, schema, templates, plans, publish tooling for the old assertion-DAG system) is legacy machinery I'd consider safe to drop, but the knowledge content needs triage first. Roughly:

- **Worth migrating** — the agent-memory cluster this intake belongs to (`openclaw-memory-architecture`, `basic-memory-mcp-knowledge-graph`, `context-engineering-and-persistent-agent-memory`, `design-patterns-long-term-memory-llm-architectures`, `persistent-memory-for-openclaw-mem0-plugin`, `logseq-markdown-vs-sqlite-discussion`), the Claude Code pair (`everything-claude-code-config-repo`, `longform-guide-everything-claude-code`), and probably `mcp-is-dead-long-live-the-cli` and `state-of-agentic-coding-ep3-armin-ben`.
- **Judgment calls** — `llm-cli-logging-to-sqlite`, `cli-mcp-conversation`, `macos-system-data-disk-cleanup` (the last looks like one-off ops trivia, likely not worth a concept).
- **The 9 assertions** — legacy atomic claims (e.g. "industry converged on markdown canonical, sqlite derived", "hybrid search outperforms pure vector or keyword"). These map naturally onto the `claim` type, or can be folded into the concepts their evidence migrates into rather than kept as standalone files.
</routes>

So the path to deletion is: keep draining via `/intake` (one command per file, or I can batch the whole cluster in one session), then delete once the triage list is empty. Want me to continue with the rest of the agent-memory cluster next?

## User

What about deleting the artifacts you deem safe to remove, old code etc?

## Assistant

Done — the legacy machinery is deleted and pushed (commit `d1ef400`, 3,423 lines removed, all verification suites green).

<routes ref="deprecated/README.md">
**Deleted** (all recoverable from git history): `scripts/` (the whole shell toolchain and its tests), `schema/`, `templates/`, `publish/` staging, the old `.claude/skills/` (`search`, `conclude`, `publish` — this also stops them auto-loading into sessions), the generated `index.json`, and the old system's `CLAUDE.md` and `README.md`, which only described the machinery that's now gone. I also removed `sources/ai-agent-memory-markdown-files.md`, since its content now lives in the bundle as `sb:41a1e3`.

**Kept — it's content, not code**: `sources/` (13 captures), `assertions/` (9 claims), `plans/` (the old system's architecture decision records), and one thing worth flagging: `intake/intake.md` turned out to be a **604-line backlog of raw collected URLs** — a reading list you gathered in March that was never processed. That's real material, so it stayed. I replaced the README with a short one that states what remains, why, and tracks migration status, and logged the deletion in root `log.md`.
</routes>

So `deprecated/` is now exactly the pending-migration set. The remaining path to full deletion: intake the 13 sources (I'd batch the agent-memory cluster first), fold the 9 assertions into the concepts their evidence migrates into (or file them as `claim`s), decide whether the URL backlog gets triaged or discarded, and decide if any of the old plans deserve a home in `meta/` as historical decision records. Want me to keep going with the agent-memory source cluster?

## User

What does "Want me to keep going with the agent-memory source cluster?" mean?

Thinking to pause for now

Add to todos: "go through rest of deprecated"

## Assistant

It was shorthand for: of the 13 legacy sources left in `deprecated/sources/`, six are all about the same topic — file-based memory for AI agents (`openclaw-memory-architecture`, `basic-memory-mcp-knowledge-graph`, `context-engineering-and-persistent-agent-memory`, `design-patterns-long-term-memory-llm-architectures`, `persistent-memory-for-openclaw-mem0-plugin`, `logseq-markdown-vs-sqlite-discussion`). Since they cover one subject and cross-reference each other, migrating them together in one pass (rather than one `/intake` per file across separate sessions) lets me dedup them properly, cross-link them, and file them as a coherent set next to the article we just migrated. I was offering to do that batch next.

Pausing is fine — let me add the todo.

Todo added — **Task #1: "Go through rest of deprecated/"** — with the full remaining inventory baked into its description (the source batching order, the 9 assertions, the URL backlog and old plans that need your call, and the branch/commit references), so a future session can pick it up without re-deriving any of this.

Pausing here. Current state: branch `claude/deprecated-directory-deletion-myusjh` is pushed with two commits — the first migration (`sb:41a1e3`) and the machinery deletion — and `deprecated/` now contains only content pending triage. No PR has been opened; when you're ready to resume, "continue with deprecated" (or just pointing at the task) is enough.

## User

/create-pull-request
