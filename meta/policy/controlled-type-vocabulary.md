---
type: policy
title: Controlled type vocabulary
description: The bundle uses a controlled, deliberately-growing list of concept types; the operator ratifies additions.
section: type-vocabulary
order: 1
status: active
tags: [meta, governance, types, vocabulary]
timestamp: 2026-07-05
---
OKF requires a `type` but registers no vocabulary. This bundle uses a **controlled
list** so the brain stays queryable. It **grows deliberately** — an agent may
propose a new type, but the operator ratifies additions (same as directories).

Seed vocabulary:

- `note` — a distilled idea, observation, or thought.
- `claim` — a statement **asserted but not independently verified** (track status with
  the `verified` field; may graduate to `concept` once confirmed).
- `concept` — a definition or mental model (established/accepted).
- `reference` — external material you have **captured and summarized** (article, doc,
  video, thread). A bare URL becomes a `reference` only once processed.
- `source` — a primary source citation (paper, book, dataset).
- `person` — a person.
- `project` — an active, goal-bounded effort.
- `area` — an ongoing responsibility or domain (no end state).
- `snippet` — a reusable command, code fragment, or template.
- `methodology` — a repeatable, prescriptive procedure or playbook: the distilled
  *how-to* for carrying out a recurring task (distinct from a `note`, which merely
  records an idea, and a `concept`, which defines a mental model).
- `policy` — a governance rule for how the brain operates; the source from which
  `CLAUDE.md` is compiled (lives under `meta/policy/`).

If nothing fits, propose a new type rather than forcing a bad one.
