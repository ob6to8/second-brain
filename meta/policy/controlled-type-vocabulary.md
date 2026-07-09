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
- `tutorial` — a long-form explanatory note meant to be read start to finish (the
  "why"/"how" behind the tooling or a topic); distinct from a terse `note` and from
  a `reference` capture of external material (lives under `meta/tutorials/`).
- `issue` — a tracked operational problem, defect, or open concern about how the
  brain or its tooling/automation behaves, recorded for future reference and
  follow-up. Carries a `status` (`open`/`resolved`/`wontfix`); distinct from a
  `policy` (a rule) and a `note` (a distilled idea) — an issue is a *problem to
  track* (lives under `meta/issues/`).
- `plan` — intended work on the brain or its tooling: a design/decision record for a
  proposed change, capturing motivation, the shape of the change, scope boundaries,
  and open questions, so a future session can execute it. Carries a `status`
  (`proposed`/`accepted`/`in-progress`/`done`/`superseded`); distinct from an `issue`
  (a *problem* to track) and a `methodology` (a *repeatable* how-to) — a plan is a
  *one-off intended change* (lives under `meta/plans/`).

If nothing fits, propose a new type rather than forcing a bad one.
