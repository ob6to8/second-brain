---
type: plan
title: "Flow lineage: frontmatter provenance + a derived lineage flowchart"
description: Give every flow doc a canonical `lineage:` frontmatter block (analysis → plan → thread → PR), render it as a per-doc prose blockquote and derive a cross-flow flowchart index from all blocks with a --check-gated mix task, then retrofit the remaining flow docs — the flow-scoped precursor of the epistemic-overlay's typed lineage edges.
status: done
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-12 — operator asked whether the analysis → plan → PR → flow arc should be made explicit in flow docs; chose frontmatter + a derived flowchart index + include the thread, and to begin with the dedup reference instance then plan the full retrofit"
tags: [meta, plan, flows, lineage, provenance, tooling, governance]
timestamp: 2026-07-12
---

# Flow lineage: frontmatter provenance + a derived flowchart

## Status & provenance

**Done** (2026-07-12). All four open questions resolved by the operator; tooling built,
all eight flow docs retrofitted, `--check` wired into CI and the pre-commit hook.

- **The instrument:** [`SecondBrain.Lineage`](/lib/second_brain/lineage.ex) +
  [`mix brain.lineage`](/lib/mix/tasks/brain.lineage.ex) (`--materialize` / `--check`),
  pinned by [`test/second_brain/lineage_test.exs`](/test/second_brain/lineage_test.exs).
  It parses each flow doc's `lineage:` block (a small nested-YAML reader, since the
  bundle's flat `Frontmatter` parser can't), materializes the per-doc blockquote between
  markers, and derives [`meta/flows/lineage.md`](/meta/flows/lineage.md) — a Mermaid
  flowchart plus a dependency-free table.
- **The retrofit:** all eight `meta/flows/*.md` carry a `lineage:` block and a generated
  blockquote; the convention is codified in [`meta/flows/index.md`](/meta/flows/index.md);
  the [flows-genre plan](/meta/plans/flows-genre-and-scenario-testing.md) §11 points here.
- **The gate:** `mix brain.lineage --check` runs in `ci.yml` and `.githooks/pre-commit`,
  beside the contract/registry drift gates.

### Feature lineage, not doc-authorship lineage (a decision to flag)

Most flows have **two** provenance layers: the session/PR that built the underlying
*feature*, and the (usually later) session/PR that wrote the *flow doc + scenario*. The
recorded `lineage:` traces the **feature** — the arc from problem-identified to the
running system the flow describes — matching the dedup reference instance (where feature
and doc were the same session). The doc-authorship push (most of flows 4–7 were written
together in PR #48) is deliberately **not** recorded, because it answers "when was this
page written", not "how did this system come to be". If the operator would rather trace
doc authorship, the blocks are one edit each.

Commissioned by the operator on 2026-07-12. Asked whether the research arc — *an idea or
problem identified in an `analysis` → a `plan` → implemented in a PR → this flow* — should
be made explicit in flow docs so the doc reads the story from the beginning. Two decisions
the operator made explicitly (correcting the agent's initial prose-only default):

1. **Encoding = frontmatter, with a derived index.** "Do frontmatter, and then a
   registry/index can be derived which acts as a flowchart of sorts." The canonical
   record is structured frontmatter; the human-readable views (per-doc blockquote,
   cross-flow flowchart) are *generated* from it — the same generated-not-hand-kept
   discipline as [`/CLAUDE.md`](/meta/flows/render-contract.md) and
   [`meta/registry.md`](/meta/registry.md).
2. **Include the thread.** The chain is `analysis → plan → thread → PR → flow`, not just
   `analysis → plan → PR`. The captured session ([`meta/threads/`](/meta/threads/index.md))
   is the durable session record and the anchor the `pr:` is stamped onto; it belongs in
   the lineage.

## Problem

A flow doc narrates how an action *runs now* but is silent on *how it came to be*. The
provenance exists only as backward-running prose citations (flow → plan → analysis), so:

- The upstream `analysis` and `plan` never point **forward** to what they became — you
  can walk the chain in reverse if you already know to, but the analysis that started it
  all is a dead end when read on its own.
- The full arc *problem-identified → designed → built → running system* is legible only
  by opening three or four docs in sequence and reconstructing the order by hand.
- There is **no cross-flow view** — no way to see, at once, which flows trace back to a
  deliberate analysis, which emerged directly as a plan, and which share an origin.

The commit graph is the provenance layer for *code*, but the genre-level story (an
analysis' idea becoming a running flow) lives above individual commits and has no home.

## Decisions

1. **Canonical record: a `lineage:` frontmatter block on each flow doc.** Shape:

   ```yaml
   lineage:
     analysis: /meta/analysis/<slug>.md   # optional — omit if the flow had none
     plan:     /meta/plans/<slug>.md       # optional
     thread:   /meta/threads/<date>-<slug>.md  # the session that built it
     pr:       50                          # the merging PR number
   ```

   **Heterogeneous by design:** omit any hop a flow lacks (some flows emerged directly as
   a plan with no upstream analysis; the flows genre itself has neither). A flow may
   legitimately have *several* threads/PRs across its build; represent multiples as a YAML
   list. Governance docs (`analysis`/`plan`/`thread`) carry no `sb:` id, so they are
   referenced **by path**; `pr` is an integer. This differs from the identity rule that
   typed edges use ids — because these targets are outside the identity registry, path is
   the only stable handle they have.

2. **Two derived, never-hand-kept views.**
   - **Per-doc blockquote** — a one-line `> **Lineage —**` rendering at the top of each
     flow doc, materialized from that doc's own block (like the route-tag excerpt logs).
   - **Cross-flow flowchart index** — a generated artifact listing every flow and its
     chain as a flowchart (a Mermaid `graph LR` of `analysis → plan → thread → PR → flow`
     nodes, plus a fallback table), so the whole genre's provenance reads at a glance.

3. **A `mix` task owns both, `--check`-gated in CI.** `mix brain.lineage` scans every
   `meta/flows/*.md` `lineage:` block, (re)materializes each doc's blockquote and writes
   the flowchart index, and with `--check` fails on divergence — identical discipline to
   `mix brain.contract --check` and `mix brain.registry --check`. Zero new deps; pure
   parse-and-render over frontmatter already in the bundle.

4. **Tolerant, not gating on content.** Missing lineage on a flow doc **warns**, never
   fails (a flow may predate the convention or genuinely lack an origin) — the same
   warn-don't-fail call the route-tags ledger cross-check and the dedup probe make. Only
   *staleness* of the generated views (`--check` divergence) is a hard failure.

5. **Reference instance first, then retrofit.** The dedup flow proves the block; the
   remaining seven flow docs are backfilled once the schema and the derived views are
   ratified — tracing each one's originating analysis/plan/thread/PR.

## Artifact shape

- **`lineage:` frontmatter** on each `meta/flows/*.md` (extra-keys-allowed; inert to
  `mix brain.verify`).
- **`lib/second_brain/lineage.ex`** — parse the blocks, render the per-doc blockquote,
  render the flowchart index; pure core so a scenario test can pin it.
- **`lib/mix/tasks/brain.lineage.ex`** — thin task wrapper (`--check`, `--materialize`),
  matching the existing `brain.*` pattern.
- **The flowchart index** — `meta/flows/lineage.md` (generated; or a generated section of
  [`meta/flows/index.md`](/meta/flows/index.md) — see open question 2).
- **`test/second_brain/lineage_test.exs`** — fixture flow docs with/without hops; assert
  parsing, blockquote materialization, flowchart rendering, heterogeneous omission, and
  `--check` divergence detection.
- **One line in `.github/workflows/ci.yml`** and an entry in the gate suite / pre-commit
  hook, beside `brain.contract --check` and `brain.registry --check`.

## Build order

1. Ratify the frontmatter schema + the two open questions below.
2. `lib/second_brain/lineage.ex` + `mix brain.lineage` + tests. Blockquote materialization
   first, then the flowchart index.
3. Wire `--check` into CI + the pre-commit gate suite.
4. Retrofit the seven remaining flow docs with their `lineage:` blocks (research each
   one's analysis/plan/thread/PR), then run `mix brain.lineage --materialize`.
5. Record the generated flowchart index; link it from `meta/flows/index.md`.

## Scope boundaries (deliberate exclusions)

- **Not the epistemic overlay.** This is flow-scoped provenance over four fixed roles
  (analysis/plan/thread/pr), not the general typed-edge graph over *all* concepts the
  [epistemic-overlay plan](/meta/plans/epistemic-overlay.md) proposes. If that overlay is
  built, this becomes a special case that folds into it — this plan is deliberately the
  smaller, shippable precursor.
- **No `sb:` ids minted for governance docs.** Analyses/plans/threads stay outside the
  identity registry; lineage references them by path.
- **No new `type`.** Flow docs remain `type: note`; `lineage:` is an extra frontmatter key.
- **No origin beyond the four roles in v1.** `issue`/`todo` origins (a flow that began as
  a tracked defect) are a natural extension but deferred until one occurs.

## Open questions — resolved by the operator (2026-07-12)

1. **Field multiplicity** → **scalar-or-list per field.** A bare value for the common
   single-hop case, a YAML list (block `-` items or inline `[a, b]`) when a flow was built
   across several threads/PRs. The parser normalizes both to lists.
2. **Where the flowchart index lives** → **standalone** generated
   [`meta/flows/lineage.md`](/meta/flows/lineage.md), so the hand-written genre definition
   and the generated flowchart never share a file where `--check` could clobber prose.
3. **Mermaid vs. table** → **both** — a Mermaid `flowchart LR` (renders on GitHub and the
   Pages site) with a dependency-free table beneath it.
4. **Auto-materialize the per-doc blockquote** → **materialize**, consistent with the
   route-tag logs and the no-hand-kept-derived rule; `mix brain.lineage --materialize`
   owns the block between the `lineage:start`/`lineage:end` markers.
