---
type: reference
title: 2026-07-15-bundle-library-separation-plan
description: The operator framed the repo as two conflated concerns — the knowledge bundle (an opinionated OKF collection carrying the Elixir Mind metadata schema) and the Elixir Mind library (the Elixir code and everything not knowledge-document-related) — directed a doc-first delineation, and the session filed the separation plan (status proposed) with the boundary table, a docs Phase 1, and the library spin-out as a deferred phase.
provenance: "Claude Code session (Claude Fable), 2026-07-15; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, architecture, separation-of-concerns, okf, tooling, plan]
timestamp: 2026-07-15
session: https://claude.ai/code/session_01X53jhQ3j7pvGG4VgiC6CTs
pr: 100
---

# 2026-07-15-bundle-library-separation-plan

## Where this landed

A short planning session. The operator observed that the line between knowledge
persisted in the OKF bundle and the machinery around it (the Elixir code, the
infrastructure) is not delineated, and framed the repo as a combination of two
concerns: the knowledge bundle as an opinionated OKF collection carrying the
Elixir Mind metadata schema, and the Elixir Mind library as the Elixir code and
everything else not knowledge-document-related — with the library eventually
spinning out into its own repo (shipping a short demo set of OKF documents for
demonstration purposes only) while this repo remains the operator's maintained
collection. The directed first item was to address the conflation in the docs,
via either an analysis or a plan document. The agent chose a **plan** — the
direction was already decided, so a decision record beats an open investigation
— and filed
[separate-okf-bundle-and-elixir-mind-library](/meta/plans/separate-okf-bundle-and-elixir-mind-library.md)
(`status: proposed`): the two-concerns problem statement, why the separation is
right, a boundary table assigning every surface to a concern (the schema as the
interface; skills mixed; the name itself a symptom), a docs-only Phase 1
(README/preamble/root-index reframing plus a bundle-library-separation
doctrine), deferred phases for the schema-as-artifact spec, a configurability
audit, and the spin-out, and four open questions (who keeps the name, where the
schema spec lives, what tooling-describing policies become, and the dependency
mechanism for a deliberately dependency-free project). Gates green; awaiting
operator ratification (Phase 0).

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| The bundle/library two-concerns separation: conflation named, doc-first delineation, deferred spin-out | paused | [separate-okf-bundle-and-elixir-mind-library plan](/meta/plans/separate-okf-bundle-and-elixir-mind-library.md) | Operator ratification (Phase 0), then Phase 1 docs execution; plus the plan's four open questions |

## User

<routes ref="meta/plans/separate-okf-bundle-and-elixir-mind-library.md">
Currently, the line between knowledge persisted in the OKF bundle and the machinery around it, the infrastructure, the elixir code is not delineated. I'm envisioning this being... this repo being a combination of two concerns. One is the knowledge bundle itself, which should be treated as an opinionated OKF collection, just like any OKF collection of resources might be considered, albeit with a specific metadata schema that relates to the Elixir Mind approach. the second concern and deliverable would be the Elixir Mind library itself, which is the elixir code, and everything not related to the knowledge documents aside from the Elixir Mind schema for metadata. Eventually, I would hope that the library could be spun out into a separate repo, and the the remaining OKF would... collection would just be an example collection and opinion letter collection I would maintain. which way the electric mind code could get independent of the bundle with maybe a short demo set of OKF documents to demonstrate. for demonstration purposes only. You agree with the separation. The first item will item would be to address it in the docs because, currently, these two domains are conflated, and the next could be either an analysis or a plan document
</routes>

## Assistant

<routes ref="meta/plans/separate-okf-bundle-and-elixir-mind-library.md">
Missing `from` is only advisory (a warning) until the session's thread doc exists, so the plan can be filed cleanly now. Writing the plan document — I'm going with a `plan` rather than an `analysis`: the direction is already decided (the separation), so what's needed is a decision record with a doc-delineation phase now and the spin-out as an explicit deferred phase, not an open investigation.

Filed and pushed. Yes — I agree with the separation, and I've recorded it as a **plan** (rather than an analysis) since the direction is already decided; what was needed is a decision record with a build order, not an open investigation.

**What landed** on branch `claude/okf-elixir-mind-separation-7rd3ne` (commit `dd9fc3d`):

- [`meta/plans/separate-okf-bundle-and-elixir-mind-library.md`](https://github.com/ob6to8/elixir-mind/blob/claude/okf-elixir-mind-separation-7rd3ne/meta/plans/separate-okf-bundle-and-elixir-mind-library.md) — `type: plan`, `status: proposed`, awaiting your ratification (no Pages link yet since it's not on `main`).
- `meta/plans/index.md` updated with the new entry under Proposed.

**The plan's shape:**

- **Problem** — the repo is two deliverables sharing one root with nothing saying so: the personal knowledge bundle (an opinionated OKF v0.1 collection carrying the Elixir Mind metadata schema) and the Elixir Mind library (the Elixir code and everything not knowledge-document-related, plus the schema it defines and enforces).
- **A boundary table** assigning every surface to a concern — including the honest edge cases: the metadata schema is the *interface* (library defines/enforces, bundle instantiates), `.claude/skills/` is mixed and needs a per-skill call, and the name "elixir-mind" currently naming both is itself a symptom of the conflation.
- **Phase 1 (your directed first item, docs only):** restructure the README around the two-concerns framing, amend `meta/preamble.md` so the contract states which concern it governs, add a root-index note, and file a `bundle-library-separation` doctrine that future plans can cite.
- **Deferred phases:** the schema written up as a versioned spec artifact; a configurability audit (id prefix, base URL, bundle root lifted into config, with "tests pass against a fixture bundle that isn't this one" as the oracle); and the spin-out itself — library in its own repo with a short demo bundle for demonstration purposes only, this repo remaining your maintained collection consuming it as a dependency.
- **Open questions** flagged for later, notably who keeps the name and how a deliberately dependency-free `mix.exs` consumes an external library without losing offline-readiness.

Full gate suite is green (`brain.verify`, `contract --check`, `registry --check`, `route_tags`, `lineage --check`); the only new warning is the advisory missing `attribution.from`, which is expected until the session thread is captured — `/create-pull-request` will stamp it. If you ratify, the next session executes Phase 1; say the word and I can also run `/create-pull-request` to open the PR for this plan.
</routes>
