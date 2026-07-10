---
type: policy
title: Skills registry
description: The available skills and where new skills are added.
section: skills
order: 1
status: active
tags: [meta, governance, skills]
timestamp: 2026-07-10
---
- **`/intake`** — process pasted content into one or more filed concepts. See
  `.claude/skills/intake/SKILL.md`. This is the primary way knowledge enters the
  brain.
- **`/render-contract`** — recompile `CLAUDE.md` from `meta/policy/*.md` after editing
  any policy. See `.claude/skills/render-contract/SKILL.md`. `CLAUDE.md` is a
  generated artifact — never hand-edit it.
- **`/capture`** — persist the current session as a **distilled** thread doc under
  `meta/threads/`: substantive exchanges only (tool calls, reasoning, and short
  pre-tool narration stripped), then a routing ledger and route tags over the frozen
  body. This is the session-persistence skill. See `.claude/skills/capture/SKILL.md`.
- **`/summarize-technical`** — produce a three-part layered breakdown of a technical
  paper/article/spec: a plain-language summary, a glossary of its key technical terms,
  then an integrated technical summary reusing those terms. See
  `.claude/skills/summarize-technical/SKILL.md`.
- **`/news`** — generate today's **inbox**: a daily candidate feed of news, articles,
  papers, and resources matched against the brain's taxonomy, grouped by category and
  reason-tagged (`recent`/`impactful`/`influential`/`groundbreaking`/`buzz`). Writes to
  the non-bundle `inbox/` namespace (candidates, no `sb:` ids); hand off to `/intake` to
  file one into the brain. See `.claude/skills/news/SKILL.md`.
- **`/create-pull-request`** — run `/capture` to completion, then commit the current
  working changes, push the branch, and open a pull request — so the frozen thread doc
  ships in the same PR. Invoking the skill **is** the authorization to open the PR
  (no separate confirmation gate); PR-template detection and the GitHub MCP tools
  handle the rest. See `.claude/skills/create-pull-request/SKILL.md`.

New skills are added under `.claude/skills/<name>/SKILL.md`.
