---
type: plan
title: "Library spin-out: knowledge-base repos consuming Elixir Mind as a packaged dependency"
description: Spec for the end-state separation — the Elixir Mind library extracts into its own repo and is pulled into each knowledge-base repo as a versioned Mix dependency (git-tag first, Hex when stable), while this repo sheds the code and remains the operator's knowledge base, keeping its provenance anchors intact.
status: proposed
provenance: "Claude Code session, 2026-07-17 — operator asked to spec out the separation where the knowledge content (knowledge/, analyses, plans, threads) lives in a dedicated knowledge-base repo, the elixir-mind library is abstracted out, and knowledge repos depend on the library, asking specifically whether distribution would be via something like Hex"
attribution:
  when: 2026-07-17T18:01:24Z
  channel: agent-authored
  agent: "Claude Code agent, library spin-out spec session"
  why: "graduates the deferred Phase 4 spin-out of the bundle/library separation plan into its own executable spec, recording the dependency-distribution decision the operator asked about"
tags: [meta, plan, architecture, separation-of-concerns, spin-out, hex, dependency, tooling]
timestamp: 2026-07-17
---

# Library spin-out: knowledge-base repos consuming Elixir Mind as a packaged dependency

This plan graduates **Phase 4** of
[separate-okf-bundle-and-elixir-mind-library](/meta/plans/separate-okf-bundle-and-elixir-mind-library.md)
— the deferred spin-out — into its own spec, per the
[persist-plans policy](/meta/policy/persist-plans.md). The parent plan settled
*that* the repo is two deliverables and *where* the boundary runs; this plan
specs *how* they come apart and how the two artifacts relate afterward.

## Target shape — two kinds of repo

**One library repo, N knowledge-base repos.** The end state is not one split
but a one-to-many relationship:

1. **The library repo** (working name `elixir-mind` — naming is an open
   question inherited from the parent plan): the Elixir package. Contains
   `lib/`, `mix.exs`, `test/` (running against a small fixture bundle), a
   demo OKF bundle for demonstration and tests, the versioned **metadata
   profile spec** (the parent plan's Phase 2 artifact), reusable CI workflow
   definitions, and the tool-wrapper agent skills. It knows nothing about any
   particular collection.
2. **Knowledge-base repos** (this repo is the first and, initially, only
   one): pure OKF collections plus their governance — `knowledge/`,
   `beliefs/`, `inbox/`, `deprecated/`, the whole `meta/` namespace
   (policies, plans, analyses, threads, issues, todos, doctrine,
   elaborations, flows, evals), the root `index.md` tree, the compiled
   `CLAUDE.md`, the editorial skills, and a **thin Mix skeleton** whose only
   job is to pull the library in and configure it for this bundle.

The operator's framing was "knowledge … saved into a dedicated knowledge base
repo." That end state is reached **by subtraction, not by moving the
content**: the library extracts *out*, and what remains of this repo *is* the
dedicated knowledge-base repo. The direction matters for provenance:

- Thread docs anchor on **`pr: <N>`**, and PR numbers are repo-scoped —
  migrating the content to a fresh repo would turn every `pr:` anchor into a
  dangling reference to another repo's PR list.
- Durable docs and the dev-history view cite **commit SHAs** reachable in
  this repo's merge graph; the
  [merge-strategy policy](/meta/policy/merge-strategy.md) exists precisely to
  keep those reachable. A content exodus would orphan all of them.

So: **the bundle keeps the repo; the code leaves.** (Whether the remaining
repo also keeps the *name* is open question 1 below.)

## The dependency mechanism — yes, a Hex-style dep, staged

The operator's question: *would the library be distributed via something like
Hex, and pulled into each knowledge repo as a dep?* **Yes — that is the right
end state**, reached in two stages rather than one jump:

**Stage A — git dependency pinned to a release tag.**

```elixir
# knowledge repo's mix.exs
defp deps do
  [{:elixir_mind, github: "ob6to8/<library-repo>", tag: "v0.2.0"}]
end
```

- Zero publishing ceremony: cutting a release is `git tag` + push, so the
  library can iterate fast while its API surface is still settling.
- Works with a private repo through existing GitHub auth — no Hex
  organization (paid) needed while the library is private.
- Mix compiles the dep and its **`Mix.Tasks.Brain.*` modules become
  available in the consuming project automatically** — `mix brain.verify`,
  `mix brain.contract`, `mix brain.site` all run from the knowledge repo
  exactly as today; nothing about the operator's workflow changes except a
  one-time `mix deps.get`.

**Stage B — publish to Hex** once the library has a stable v1 API, the
metadata profile spec is versioned, and (if desired) the library goes public:

- Semver resolution (`{:elixir_mind, "~> 1.0"}`), hexdocs-hosted API docs,
  and a checksum-verified, immutable release artifact — the standard way an
  Elixir library is consumed, and the natural move if the library is meant
  for adoption beyond the operator's own bundles.
- Hex is public by default; publishing is also the moment the library's
  README, demo bundle, and profile spec become its public face. Private Hex
  requires a paid organization — hence Stage A first, and Stage B only
  with a deliberate go-public decision.

**Rejected alternatives** (weighing the parent plan's open question 4):

- **Vendored archive** (committing the library into each knowledge repo):
  preserves today's zero-fetch offline property but makes every upgrade a
  manual copy-sweep across N repos and forfeits lockfile/checksum integrity.
  The offline property is better preserved by committing `mix.lock` and
  caching deps in CI; the sandbox environments the no-deps rule was written
  for do have network for `deps.get`.
- **Path dependency**: only works when both checkouts are co-located; fine
  as a local development convenience (`MIX_ENV`-gated override), not a
  distribution mechanism.

The one real cost: `mix.exs` stops being dependency-free, so a fresh sandbox
needs one `mix deps.get` before the toolchain runs. The committed `mix.lock`
pins the exact version; CI caches the fetch; and the SessionStart hook can run
`deps.get` so agents never see the difference.

## What the library must gain first — the config surface

The spin-out is blocked on the parent plan's **Phase 3 configurability
audit**. For N bundles to share one library, every bundle-specific constant
must move from code to the consuming repo's `config/config.exs`, which
becomes in effect the **bundle manifest**:

| Setting | Today | Post-split |
|---------|-------|-----------|
| Site base URL, repo URL | Already in `config/config.exs` | Unchanged — pattern to copy |
| Id namespace prefix (`em:`) | Hardcoded across verifier, registry, route tags, dedup probe | `config :elixir_mind, id_prefix: "em"` — each bundle mints its own namespace |
| Bundle root | Assumed = cwd/repo root | Configurable path (default `.`) |
| Excluded / non-bundle directories (`deprecated/`, `inbox/`, `.claude/`, …) | Hardcoded carve-out lists | Configurable list with the current values as defaults |
| Controlled `type` vocabulary | In verifier + policy prose | Bundle-declared list; library enforces membership-in-declared-list, not a fixed list — vocabulary ratification stays a per-bundle governance act |
| Attribution `channel` vocabulary | Same | Same treatment |
| Reserved filenames, frontmatter schema shape | Library code | Stay in the library — this **is** the Elixir Mind metadata profile, the interface every conforming bundle shares |

The last row is the boundary test from the parent plan: what is *profile* (the
library defines and enforces it, versioned with the package) versus what is
*instance* (each bundle declares it in config). The oracle for Phase 3
completeness is unchanged: **the library's tests pass against a fixture
bundle that is not this one.**

## What each knowledge-base repo keeps

- **A thin `mix.exs`** — app name, the `:elixir_mind` dep, nothing else.
- **`config/config.exs`** — the bundle manifest (table above).
- **Thin CI** — the gate suite invoked from the dep. Preferably the library
  repo publishes a **reusable workflow** (`workflow_call`) so each bundle's
  `ci.yml` shrinks to a few lines and gate-suite evolution ships with library
  releases; `pages.yml` stays per-bundle (deploy target and cadence are
  bundle concerns) but calls the same tasks.
- **Editorial skills** (`/intake`, `/capture`, `/add-to-glossary`,
  `/research`, …) — they encode *this bundle's* policy and stay. Tool-wrapper
  skills (`/render-contract` and kin) move to the library and are consumed as
  a Claude Code plugin or vendored templates (open question 3).
- **`CLAUDE.md`** — still compiled per-bundle from that bundle's
  `meta/policy/` by the library's contract compiler; still CI-checked. A
  library upgrade that changes compiled framing shows up as `--check` drift
  the upgrade PR must recompile — the version pin makes contract changes
  reviewable events rather than ambient drift.

## Migration mechanics

1. **Create the library repo** by history extraction, not fresh start: `git
   filter-repo` over `lib/`, `test/`, `mix.exs`, and workflow files, so the
   library's own commit → session provenance survives in its new home. This
   rewrites nothing here — this repo's history is untouched.
2. **Author the demo bundle** in the library repo: a dozen-document OKF
   collection exercising every schema feature (ids, attribution,
   verification edges, route tags, glossary), doubling as the test fixture.
3. **Land Phase 3** (config surface) in the library repo, gated on the
   fixture-bundle oracle.
4. **The removal PR here**: delete `lib/`, `test/`, most of `mix.exs`; add
   the dep + manifest config; swap CI to the reusable workflow; recompile
   generated artifacts. One PR, one true merge — the deletion is ordinary
   additive history, severing nothing.
5. **Tag `v0.1.0`** on the library; this repo pins it. Hex publication
   (Stage B) waits for API stability and the go-public call.

## Scope boundaries

- **No renames decided here.** Which artifact carries "elixir-mind" outward
  is the parent plan's open question 1, decided by the operator at
  execution.
- **No schema changes.** The split moves the schema's *enforcement point*,
  not its content.
- **This plan does not execute anything.** It is the spec the parent plan's
  Phase 4 deferred to; execution follows ratification, after the parent
  plan's Phases 1–3 land.

## Open questions

1. **Naming** (inherited): if the library takes `elixir-mind`, the remaining
   knowledge repo needs a name — and a repo rename would sever the deployed
   Pages URL and remote refs, so it needs its own ratified motion (the
   2026-07 rename plan is the template).
2. **Public or private library?** Stage B (Hex) implies public; private
   forever means staying on git-tag deps, which is workable indefinitely.
3. **Skill distribution**: Claude Code plugin from the library repo (clean
   updates, new machinery) vs. vendored skill templates (simple, drifts).
4. **Governance-doc dedup post-split**: which `meta/policy/` docs that
   restate library-enforced mechanics shrink to pointers at the library's
   docs (parent plan's open question 3) — needs a doc-by-doc pass in the
   removal PR.
