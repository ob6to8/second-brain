---
type: policy
title: Skills registry
description: The available skills and where new skills are added.
section: skills
order: 1
status: active
tags: [meta, governance, skills]
timestamp: 2026-07-05
---
- **`/intake`** — process pasted content into one or more filed concepts. See
  `.claude/skills/intake/SKILL.md`. This is the primary way knowledge enters the
  brain.
- **`/render-contract`** — recompile `CLAUDE.md` from `meta/policy/*.md` after editing
  any policy. See `.claude/skills/render-contract/SKILL.md`. `CLAUDE.md` is a
  generated artifact — never hand-edit it.
- **`/persist-thread`** — archive the current conversation into `meta/threads/` as a
  date-prefixed record: exchanges only, operator and agent text **verbatim**, no tool
  calls, numbered turn headings. See `.claude/skills/persist-thread/SKILL.md`.

New skills are added under `.claude/skills/<name>/SKILL.md`.
