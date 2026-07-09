---
type: issue
title: "Daily /news Routine: automated runs not landing on main"
description: The scheduled daily /news Routine's fresh-session runs produce no commit, branch, or push; an environment-wide tool-approval gate is the suspected cause.
status: open
resource: "trigger:trig_01PAiKWrWgVs4djSkhELoLYw"
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-09 — setup/verification of the /news Routine"
tags: [meta, issue, inbox, news, automation, scheduling, approval-gate]
timestamp: 2026-07-09
---

# Daily /news Routine: automated runs not landing on `main`

## Summary

The daily news-inbox Routine — claude-code-remote trigger
`trig_01PAiKWrWgVs4djSkhELoLYw` (cron `0 13 * * *`, fresh session per fire, env
`env_011CUozZFcUmXQWzMusBiZQp`; see
[the setup thread](/meta/threads/2026-07-09-daily-news-inbox-routine.md)) — is
created and enabled, but its **automated runs do not land any change on `main`**.
The intended pipeline (run `/news` → write `inbox/YYYY-MM-DD.md` → `mix
brain.verify && mix brain.route_tags` → commit & push) never produces a commit.

## Evidence

Polled `origin/main` at 2026-07-09 15:17 UTC — ~2h after the first scheduled fire
at **2026-07-09T13:01:53 UTC**:

- Top commit unchanged (`f570fc2`, last committed 12:41 UTC — *before* the fire).
- `inbox/2026-07-09.md` byte-identical to the prior-session original (blob
  `029108ef…`, from commit `7efb6be`). No regeneration.
- No news-related branch or PR appeared; the newest `claude/*` branch predates
  13:00 UTC.

In the same session, **tool-approval calls to the claude-code-remote MCP server
failed**: `send_later` returned *"Tool permission stream closed before response
received"* and `list_triggers` returned *"MCP tool call requires approval"*. This
matches the authoring agent's prediction that the approval gate is
**environment-wide** rather than a per-session glitch.

## Suspected cause

An environment-wide tool-approval gate. Because the gate blocks even a read-only
`list_triggers` from this session, the fresh scheduled sessions likely cannot
complete their run (or the scheduler cannot fire them) under the same gate. This
is **not** a bug in the Routine's config — the trigger's config is correct.

Not fully confirmed: from inside a session it was not possible to distinguish
*"fired and failed"* from *"never fired"*, because the query tool itself is gated.

## Impact

The daily feed is not self-generating. Everything else is healthy: the `/news`
skill, the `inbox/` namespace, and the verification plumbing (`mix brain.verify`
and `mix brain.route_tags` both pass on a clean tree).

## Workaround (current)

The trigger is **left in place** (enabled). For now the operator runs **`/news`
manually each day** to generate the digest. This produces the same artifact the
Routine would.

## Resolution criteria

Resolve this issue when a scheduled fire lands a digest commit on `main` without
manual help. Likely fixes, in order of likelihood:

1. Clear the environment-wide approval gate (manage the Routine from the
   scheduled-triggers UI at <https://claude.ai/code>, where runs execute under the
   UI's own approval context rather than a tool-approval stream). Docs:
   <https://code.claude.com/docs/en/claude-code-on-the-web>.
2. Confirm via the UI whether the 13:01 fire actually ran and inspect its run log.
3. Re-create the trigger through the UI with the same config (`0 13 * * *`,
   fresh-session-per-fire) if the tool-created one is the problem.

When fixed, set `status: resolved`, note the fix here, and move the entry from
**Open** to **Resolved** in [the issues index](/meta/issues/index.md).
