---
type: plan
title: "Separate the two concerns: the OKF knowledge bundle and the Elixir Mind library"
description: Delineate the repo's two conflated deliverables — the personal knowledge bundle (an opinionated OKF v0.1 collection carrying the Elixir Mind metadata schema) and the Elixir Mind library (the Elixir tooling and everything else that is not knowledge content) — first in the docs, then progressively in the code, toward an eventual spin-out of the library into its own repo with a small demo bundle.
status: proposed
provenance: "Claude Code session, 2026-07-15 — operator observed that the line between knowledge persisted in the OKF bundle and the machinery around it is not delineated, framed the repo as a combination of two concerns (the bundle as an opinionated OKF collection; the library as the Elixir code and everything not knowledge-document-related, plus the metadata schema), and directed that the first item is to address the conflation in the docs via an analysis or plan document"
attribution:
  when: 2026-07-15T09:11:14Z
  channel: agent-authored
  agent: "Claude Code agent, bundle/library separation planning session"
  why: "persists the operator's two-concerns framing and the doc-first delineation path per the persist-plans policy, so the boundary decision and the deferred spin-out survive the session"
  from: [/meta/threads/2026-07-15-bundle-library-separation-plan.md, /meta/threads/2026-07-17-library-spin-out-spec.md]
tags: [meta, plan, architecture, separation-of-concerns, okf, tooling, governance]
timestamp: 2026-07-15
---

# Separate the two concerns: the OKF knowledge bundle and the Elixir Mind library

## Problem

This repository is **two deliverables sharing one root**, and nothing currently
says so. The line between *knowledge persisted in the OKF bundle* and *the
machinery around it* is not delineated — the docs, the directory layout, and
even the name treat them as one thing:

1. **The knowledge bundle** — the operator's personal second brain: an
   **opinionated OKF v0.1 collection**, like any OKF collection of resources,
   albeit carrying a specific metadata schema that reflects the Elixir Mind
   approach (stable `em:` ids, `attribution`, `verified`/`verified_by` evidence
   edges, route tags, the controlled `type` vocabulary).
2. **The Elixir Mind library** — the Elixir code and everything else that is
   not knowledge-document content: `lib/`, `test/`, `mix.exs`, the `mix
   brain.*` task suite (contract compiler, verifier, registry, route tags,
   site generator, session-init), CI gates, and the **definition** of the
   metadata schema those tools enforce.

The operator's end state: the library eventually **spins out into a separate
repo** — independent of this bundle, shipping a short demo set of OKF
documents for demonstration purposes only — while this repo remains the
operator's maintained, opinionated OKF collection, consuming the library as a
dependency. This plan records that direction and sequences the work, starting
where the operator directed: **address the conflation in the docs first**.

## Why the separation is right

The agent concurs with the separation, for reasons worth recording:

- **The bundle should be pure data.** OKF's promise is a portable, plain-
  markdown collection any conforming consumer can read. A bundle whose root is
  also a Mix project root — with `lib/`, `_build/`, `config/`, `test/`
  interleaved — undercuts that: every consumer (and every policy) must carry a
  carve-out list of "alongside but not part of" directories.
- **The library is reusable; the brain is personal.** The verifier, contract
  compiler, registry, route-tag engine, and site generator are generic
  machinery for *any* bundle that adopts the Elixir Mind schema. Today they
  can only be exercised against the operator's live personal data; a spun-out
  library tests and demos against a small fixture bundle instead.
- **Independent versioning and change cadence.** Knowledge accretes daily;
  tooling changes deliberately. One repo means every intake PR and every code
  PR share a history, CI budget, and review surface. Separated, the bundle
  pins a library version and upgrades on its own schedule.
- **The schema becomes a real interface.** Today the "Elixir Mind schema" is
  implicit — half in `meta/policy/` prose, half in verifier code. Naming it as
  the boundary artifact (defined and enforced by the library, *instantiated*
  by the bundle) forces it to be specified well enough that a second
  collection could adopt it. That is the test of whether the separation is
  real.

## The boundary — what belongs to which concern

| Surface | Concern | Notes |
|---------|---------|-------|
| Knowledge documents (`knowledge/`, `beliefs/`, root `index.md` tree) | **Bundle** | The OKF collection proper |
| `meta/` governance docs (policies, plans, analyses, threads, issues, todos, doctrine…) | **Bundle** | Governance of *this* collection — the "opinionated" part of the opinionated collection |
| `inbox/`, `deprecated/` | **Bundle** (non-bundle namespaces of it) | Travel with the collection |
| The metadata schema (ids, attribution, verification, route tags, frontmatter shape) | **Library** (definition + enforcement); **Bundle** (instance) | The interface between the two concerns |
| `lib/`, `test/`, `mix.exs`, `config/`, `_build/` | **Library** | The Elixir code |
| CI workflows (`ci.yml`, `pages.yml`) | **Library** (the gate suite) invoked by the **bundle** (this repo's CI) | Post-spin-out the bundle repo calls the library's tasks |
| `.claude/skills/` | **Mixed — needs a per-skill call** | Editorial skills (`/intake`, `/add-to-glossary`, `/capture`) encode bundle policy; tool-wrapper skills (`/render-contract`) front library tasks |
| `CLAUDE.md` (compiled contract) | **Bundle** artifact, produced by a **Library** tool | Stays with the collection it governs |
| The name "elixir-mind" | **Currently both — a symptom of the conflation** | See open question 1 |

## Build order

**Phase 0 — ratify.** Operator approves this plan and the boundary table
above; `status` → `accepted`.

**Phase 1 — delineate in the docs** (the operator-directed first item; one
session, no code changes):

1. **README restructure.** Lead with the two-concerns framing: this repo is
   (a) a personal knowledge bundle in OKF v0.1 and (b) the Elixir Mind
   library that governs and publishes it — with sections for each, and the
   intended spin-out named so readers know the cohabitation is transitional,
   not the design.
2. **Preamble / contract framing.** Amend `meta/preamble.md` (and recompile
   `CLAUDE.md`) so the contract's opening states the two concerns and which
   one the contract governs (the bundle, using the library's tooling), rather
   than presenting one undifferentiated "repository".
3. **Root `index.md` note.** One line clarifying that the Elixir tooling
   directories are the library concern, not part of the OKF collection.
4. **A doctrine doc.** File `meta/doctrine/bundle-library-separation.md`
   (`type: doctrine`): the standing direction that the bundle and the library
   are distinct deliverables, that new work must not entangle them further,
   and that designs should prefer the configurable/generic choice on the
   library side and the schema-conformant choice on the bundle side. Plans and
   analyses can then cite this doctrine as the direction they serve.

**Phase 2 — schema as an artifact** (deferred; own session):

- Write the **Elixir Mind metadata profile** as a versioned spec document —
  the frontmatter schema, id scheme, attribution map, verification model, and
  route-tag format, extracted from the policies' prose into one normative
  reference that a second collection could implement. Decide its home (it is
  a *library* deliverable even while it lives here).

**Phase 3 — configurability audit** (deferred; own session):

- Inventory and lift every bundle-specific constant out of library code into
  config: the site base URL (already in `config/config.exs`), the id
  namespace prefix (`em:`), the bundle root path, excluded directories,
  reserved filenames. The oracle: the library compiles and its tests pass
  against a fixture bundle that is *not* this one.

**Phase 4 — spin-out** (deferred; graduated into its own plan 2026-07-17 —
see
[library-spin-out-and-dependency-distribution](/meta/plans/library-spin-out-and-dependency-distribution.md),
which specs the target shape, decides the dependency mechanism weighed in open
question 4 below (git-tag dep first, Hex when stable), and records why the
bundle keeps this repo while the code leaves):

- New repo for the library; a short demo OKF bundle inside it for tests and
  demonstration purposes only; this repo consumes the library as a dependency
  (mechanism open — hex package, git dependency, or vendored archive) and
  keeps only the collection, its governance, and thin CI that invokes the
  library's gate suite.

## Scope boundaries — what this plan does *not* do

- **No code moves now.** Phase 1 is documentation only; the Mix project stays
  at the repo root until the spin-out plan executes.
- **No schema changes.** Delineating who *owns* the schema does not alter it.
- **No skills relocation.** The per-skill bundle/library call is recorded in
  the boundary table as mixed; deciding each skill's home is Phase 4 work.
- **No renames.** Whether "elixir-mind" ultimately names the library, the
  bundle, or both is an open question below — not decided here, and any
  rename would be its own ratified plan (the 2026-07 rename plan shows the
  cost of moving a name).

## Open questions

1. **Who keeps the name?** "Elixir Mind" most naturally names the *approach*
   and hence the library; the operator's framing ("the remaining OKF
   collection I would maintain") suggests the library carries the name
   outward and the collection could keep it or take its own. Operator call at
   spin-out time. **Resolved 2026-07-17** (in the
   [spin-out plan](/meta/plans/library-spin-out-and-dependency-distribution.md)):
   this repo keeps **elixir-mind**; the library spins out as
   **composable-beliefs-3**.
2. **Where does the schema spec live post-spin-out?** In the library repo (it
   defines and enforces it) with the bundle citing a version, or duplicated as
   a governance doc here? Leaning library-side with a version pin here.
3. **What do `meta/policy/` docs that describe tooling become?** Some policies
   (merge strategy, skills registry) govern *agent behavior in this repo*;
   others restate what the library enforces. Post-spin-out the latter should
   defer to the library's docs rather than duplicating them.
4. **Dependency mechanism for a no-deps project.** `mix.exs` is deliberately
   dependency-free so the toolchain runs in any sandbox. A hex/git dependency
   reintroduces a fetch step; a vendored archive keeps offline-readiness but
   complicates upgrades. To be weighed in the spin-out plan.
