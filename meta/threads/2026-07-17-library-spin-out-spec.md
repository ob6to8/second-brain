---
type: reference
title: 2026-07-17-library-spin-out-spec
description: Spec'd the library spin-out as its own plan — graduating Phase 4 of the bundle/library separation plan — settling the dependency mechanism (git-tag Mix dep first, Hex when stable), the direction of the split (code leaves, bundle keeps this repo), the naming decision (elixir-mind stays; the library is composable-beliefs-3), and per-bundle id namespaces (em: here, cb: in the demo bundle).
provenance: "Claude Code session (Fable), 2026-07-17; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, architecture, separation-of-concerns, spin-out, hex, dependency, id-namespace]
timestamp: 2026-07-17
pr: 118
---

# 2026-07-17-library-spin-out-spec

## Where this landed

The operator asked to spec the end-state separation — knowledge content in a
dedicated knowledge-base repo, the library abstracted out and consumed as a
dependency — and specifically whether distribution would be Hex-style. The
session found the direction already recorded as Phase 4 (deferred) of the
[separation plan](/meta/plans/separate-okf-bundle-and-elixir-mind-library.md)
and graduated it into the
[library spin-out plan](/meta/plans/library-spin-out-and-dependency-distribution.md)
(`status: proposed`): one library repo, N knowledge-base repos; the code
leaves and the bundle keeps this repo (preserving `pr:` anchors and cited
SHAs); distribution staged as a git-tag Mix dependency first, Hex once the
API stabilizes and a go-public call is made; config as the per-bundle
manifest. A second exchange resolved naming (this repo keeps **elixir-mind**;
the library spins out as **composable-beliefs-3**) and settled that id
namespaces are per-bundle (`em:` stays here; the library's demo/fixture
bundle mints under `cb:`; identity never transfers across bundles), which the
plan now records. The plan awaits operator ratification.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Spin-out spec: target shape, migration mechanics, config surface | open | [library-spin-out plan](/meta/plans/library-spin-out-and-dependency-distribution.md) | operator ratification of the proposed plan |
| Dependency distribution: Hex vs git-tag vs vendored | closed | [library-spin-out plan](/meta/plans/library-spin-out-and-dependency-distribution.md) | - |
| Naming: elixir-mind stays; library = composable-beliefs-3 | closed | [library-spin-out plan](/meta/plans/library-spin-out-and-dependency-distribution.md) | - |
| Per-bundle id namespaces (em: / cb:) | closed | [library-spin-out plan](/meta/plans/library-spin-out-and-dependency-distribution.md) | - |
| Parent plan bookkeeping (Phase 4 graduation, open question 1 resolved) | closed | [separation plan](/meta/plans/separate-okf-bundle-and-elixir-mind-library.md) | - |

## User

Spec out what a separation would look like, where what is currently "knowledge", as well as any related analyses/plans/threads would be saved into a dedicated knowledge base repo, but the general library of elixir-mind would be abstracted out, so that knowledge base repos would depend on the lib but be decoupled from it. Would it be that the elixir-mind library would be distributed via something like hex, and pulled into each knowledge repo as a dep?

## Assistant

The existing plan `meta/plans/separate-okf-bundle-and-elixir-mind-library.md` already records the separation direction (its Phase 4 defers the spin-out, which is exactly what you're asking to spec). I'll graduate that deferred phase into its own full spec plan, answering the Hex question. Setting up the branch first.

<routes ref="meta/plans/library-spin-out-and-dependency-distribution.md">
The spec is filed and pushed. Direct answer to your question first: **yes — a Hex-style Mix dependency is the right end state, but staged**: a git dependency pinned to release tags first (`{:elixir_mind, github: ..., tag: "v0.2.0"}` — zero publish ceremony, works while private), then Hex publication once the API stabilizes and you deliberately decide to go public (Hex is public by default; private Hex needs a paid org). Either way, Mix tasks from a dependency are automatically available in the consuming project, so `mix brain.verify`, `mix brain.contract`, etc. run from a knowledge repo exactly as today — the only workflow change is a one-time `mix deps.get`, mitigated by a committed `mix.lock`, CI caching, and the SessionStart hook.
</routes>

One important finding shaped the spec: a plan for this separation already existed — [separate-okf-bundle-and-elixir-mind-library](https://ob6to8.github.io/elixir-mind/meta/plans/separate-okf-bundle-and-elixir-mind-library.html), filed 2026-07-15, which settled the boundary table and deferred the spin-out as its Phase 4. So rather than duplicating it, I graduated that deferred phase into its own full spec: `meta/plans/library-spin-out-and-dependency-distribution.md` (status `proposed`), pushed on `claude/elixir-mind-lib-separation-i11rpf` (no PR opened — page URL will exist once it merges).

<routes ref="meta/plans/library-spin-out-and-dependency-distribution.md">
Key decisions the spec records:

- **Direction of the split: the code leaves; the bundle keeps this repo.** Your framing was "knowledge saved into a dedicated knowledge base repo," but the spec argues that's reached by subtraction — moving the content out instead would sever provenance, because thread docs anchor on `pr: <N>` (PR numbers are repo-scoped) and durable docs cite commit SHAs reachable only in this repo's merge graph. Once `lib/` and friends extract out (via `git filter-repo`, so the library keeps its own commit history), what remains here *is* the dedicated knowledge repo.
- **One library, N knowledge repos.** The library repo carries `lib/`, tests against a small demo/fixture OKF bundle, the versioned metadata-profile spec, reusable CI workflow definitions, and tool-wrapper skills. Each knowledge repo keeps its content plus a thin skeleton: a two-line `mix.exs`, a `config/config.exs` acting as the **bundle manifest** (id prefix — `em:` is currently hardcoded in the verifier/registry/route-tags and must be lifted, site/repo URLs, excluded dirs, and the type/channel vocabularies, which become bundle-declared rather than library-hardcoded so vocabulary ratification stays a per-bundle governance act), thin CI calling a reusable workflow, and the editorial skills, which encode bundle policy and stay.
- **Prerequisite**: the parent plan's Phase 3 configurability audit is the blocker, with its oracle unchanged — the library's tests must pass against a fixture bundle that isn't yours.
- **Rejected**: vendoring the library into each knowledge repo (manual upgrade sweeps across N repos, no lockfile integrity) and path deps (co-location only, fine as a dev convenience).
</routes>

Open questions left for you: who keeps the name "elixir-mind" (a knowledge-repo rename would need its own ratified motion, like the 2026-07 rename), public-vs-private for the library (decides whether Stage B/Hex ever happens), and whether skills ship as a Claude Code plugin or vendored templates. When you're ready, say the word and I can run `/create-pull-request` to capture this session and open the PR.

## User

for now, we would keep this repo as elixir-mind, and make the new spun out library composable-beliefs-3. should ids be assigned per repo? so for instance, ids of documents being kept would be 'em', while documents being split out to the lib would be 'cb'?

## Assistant

All gates pass and the updates are pushed. Both decisions are now recorded in the spec: this repo keeps **elixir-mind**, the library spins out as **composable-beliefs-3**, and the parent plan's naming question is marked resolved.

On your id question — **yes, ids should be assigned per repo**, and that's exactly what the configurability work anticipates: the prefix becomes a bundle-manifest setting (`config :composable_beliefs_3, id_prefix: "em"` here, `cb` there), and the library enforces only the *shape* (`<prefix>:` + 6 hex), never a particular prefix. But there's one refinement to the "documents being split out get `cb:`" framing worth flagging:

<routes ref="meta/plans/library-spin-out-and-dependency-distribution.md">
- **Almost nothing carrying an `em:` id actually moves.** The documents that belong to the library concern — tooling tutorials, the code map, plans and analyses about the machinery — live in the governance namespace and carry no `em:` id at all. Bundle documents with `em:` ids are knowledge content, and they all stay. So `cb:` isn't a re-labeling of migrated documents; it's the namespace the library's **demo/fixture bundle** mints fresh ids under.
- **Identity is bundle-scoped and never transfers.** If a document ever genuinely relocated across bundles, it would be filed as a new document minting a fresh id under the destination prefix, with the source id retiring (minted once, never reused). Tail uniqueness is per-bundle too — two bundles could coincidentally mint the same 6-hex tail, and the prefix is what keeps fully-qualified ids collision-free, which is what would make any future cross-bundle reference scheme possible.
- **A nice side effect**: the demo bundle using `cb:` rather than `em:` doubles as the acceptance test for the configurability audit — the library's tests passing against a non-`em:` fixture is the proof the prefix was genuinely lifted into config rather than hardcoded.
</routes>

The prefix stays opaque per the stable-identity policy — `cb` mnemonically mirrors composable-beliefs the way `em` mirrors elixir-mind, but nothing depends on the letters. One small detail I left as a publication-time note: whether a future Hex package keeps the ordinal (`composable_beliefs_3`) or drops it.

The spec now reflects the full picture on the branch (two commits). Want me to run `/create-pull-request` to capture the session and open the PR for ratification?
