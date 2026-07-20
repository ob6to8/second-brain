---
type: reference
title: "Thread — daily news-inbox Routine (scheduled /news trigger)"
description: Created a daily scheduled trigger (Routine) that fires a fresh session at 13:00 UTC to run the /news skill and push today's inbox digest.
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-09; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, inbox, news, automation, scheduling]
timestamp: 2026-07-09
session: https://claude.ai/code/session_01ApehodRgmk12tpfeAytt9D
pr: 20
---

# Thread — daily news-inbox Routine (scheduled /news trigger)

## Where this landed

The operator asked to stand up a daily scheduled trigger (a claude-code-remote
**Routine**) that regenerates the news inbox automatically. Using the
`create_trigger` tool, a Routine was created for `ob6to8/second-brain`:
`create_new_session_on_fire: true`, cron `0 13 * * *` (daily 13:00 UTC), named
"Daily news inbox (/news)". Each firing spawns a fresh session in the repo's
environment (`env_011CUozZFcUmXQWzMusBiZQp`) and runs the full `/news` pipeline
— build the query profile from the taxonomy, search per domain, dedup, reason-tag,
write `inbox/YYYY-MM-DD.md`, update `inbox/index.md` + `inbox/log.md`, run
`mix brain.verify && mix brain.route_tags`, then commit and push to `main`. The
Routine is enabled; **trigger id `trig_01PAiKWrWgVs4djSkhELoLYw`**, first run
2026-07-09T13:01:53Z. No repository code changed — this session's only artifact is
the Routine itself (plus this capture).

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Daily scheduled trigger (Routine) that runs the `/news` skill and pushes the inbox digest | closed | `unrouted` (operational; back-linked to [`/news` skill](/.claude/skills/research/SKILL.md)) | - |

## User

Create a daily scheduled trigger (Routine) for the ob6to8/second-brain repo using the claude-code-remote create_trigger tool. Settings: create_new_session_on_fire: true, cron_expression: "0 13 * * *", name "Daily news inbox (/news)". When the tool asks for approval, approve it, then report the trigger id. Use this as the trigger's prompt:

Generate today's news inbox for this second-brain knowledge base. Run the /news skill (.claude/skills/news/SKILL.md): build the query profile from the taxonomy (root index.md + each domain's index.md), search per domain for news, articles, papers, and resources from the recent window, dedup against both the bundle and recent inbox/ digests, select and reason-tag the strongest items (recent/impactful/influential/groundbreaking/buzz), and write today's dated digest at inbox/YYYY-MM-DD.md grouped by KB category with a one-line synopsis and filing hint per item. Then update inbox/index.md (point "Latest" at today, prepend to the archive) and prepend a dated entry to inbox/log.md; do not modify previous days' digests. The inbox is a non-bundle namespace: no sb: ids, no verified field. Finally run mix brain.verify && mix brain.route_tags, then commit and push to main. Follow CLAUDE.md throughout

## Assistant

<routes ref=".claude/skills/research/SKILL.md">
The Routine is created and enabled.

**Trigger ID: `trig_01PAiKWrWgVs4djSkhELoLYw`**

Summary:
- **Name**: Daily news inbox (/news)
- **Schedule**: `0 13 * * *` (daily at 13:00 UTC) — first run at **2026-07-09T13:01:53Z**
- **Mode**: fresh session per firing (`create_new_session_on_fire: true`) in environment `env_011CUozZFcUmXQWzMusBiZQp`
- **Enabled**: yes
- **Prompt**: runs the `/news` skill to build today's inbox digest, update `inbox/index.md` + `inbox/log.md`, verify (`mix brain.verify && mix brain.route_tags`), then commit and push to `main`

Each firing starts a clean session in this repo's environment and executes the full `/news` pipeline autonomously. You can pause or delete it anytime via the trigger ID.
</routes>
