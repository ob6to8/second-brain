---
type: plan
title: "Attribution: a frontmatter record of the ingestion event"
description: Add a structured `attribution` frontmatter property to bundle concepts recording when the concept was ingested, through which channel and by whom, and why it was deemed worth filing — an immutable event record, distinct from provenance (content origin) and timestamp (last change).
status: accepted
provenance: "Claude Code session, 2026-07-13 — commissioned by the operator: 'create an attribution property for resources absorbed into the knowledge collection — including when it was ingested, how/who, and why'"
tags: [meta, plan, frontmatter, attribution, provenance, intake, auto-intake, schema]
timestamp: 2026-07-13
---

# Attribution: a frontmatter record of the ingestion event

## Problem

When a concept enters the brain, the *ingestion event* — when it arrived, through
which pathway, driven by which actor, and why it was judged worth filing — is
currently scattered across four places, none of which is queryable from the bundle
surface:

- **Free-text `provenance`**, which conflates two different things: where the
  *content* came from (its author/origin, which may long predate the brain) and
  how it happened to *enter* the brain. Compare
  `provenance: "Agent-distilled glossary definition"` (content origin) with
  `provenance: "auto-intaken from /research inbox 2026-07-12"` (ingestion event)
  — the same field is carrying both meanings, unstructured.
- **The `auto-intake` tag**, a single-channel special case invented so the
  operator's post-intake editorial pass could find what `/research` filed. It
  answers "how" for exactly one pathway and says nothing about when or why.
- **The digest line** in `inbox/` (for auto-intaken items), which holds the *why*
  (the reason-tag and category match) — but in a dated file the concept doesn't
  point back to.
- **Git archaeology** (`git log --diff-filter=A --follow`), which answers *when*
  and — via session trailers — *which session*, but is invisible to an agent
  reading the bundle as files, erodes under renames and update-in-place merges,
  and is absent entirely when the bundle is consumed outside this repo (OKF
  bundles are meant to be portable).

This matters more as [auto-intake](/meta/plans/auto-intake-featured-research.md)
scales the corpus past what an agent holds in context: trust calibration ("did an
operator vouch for this or did a feed match a keyword?"), the editorial pass, and
staleness triage all want a per-concept answer to *when / how / who / why it got
here* — cheaply, in-band, without re-deriving it from history each time.

## Design

One new frontmatter key, `attribution`, on bundle concepts *and* governance
docs — a small structured map whose fixed sub-keys mirror the question it
answers (four everywhere, plus `from` in the governance namespace; see Scope):

```yaml
attribution:
  when: 2026-07-13T14:02:00Z
  channel: auto-intake
  agent: "Claude Code agent, /research daily Routine"
  why: "featured in the 2026-07-13 digest under agents/orchestration; reason-tag: impactful"
```

| Sub-key | Holds | Form |
|---------|-------|------|
| `when` | The ingestion instant — when the concept entered the bundle | ISO 8601 (date minimum; datetime preferred) |
| `channel` | *How* it entered — the pathway | Controlled vocabulary (below) |
| `agent` | *Who* acted — the operator, or the agent and the automation context it ran in | Free text, one line |
| `why` | Why it was deemed worth filing — the featuring reason, the operator's ask, the gap it fills | Free text, one sentence |

### Channel vocabulary

Controlled and small, growing deliberately (operator ratifies additions, same as
the `type` vocabulary):

- `intake` — operator-initiated `/intake` of pasted material or links.
- `auto-intake` — filed autonomously by `/research` featuring (subsumes the
  `auto-intake` tag; see migration below).
- `glossary` — a term file created by `/add-to-glossary`.
- `agent-authored` — a statement (`claim`/`note`/`concept`) the agent distilled
  directly from a working session, not from external pasted/fetched material.
- `backfill` — attribution reconstructed retroactively from git history for
  concepts that predate this property (see backfill below).

### Semantics — the three load-bearing rules

1. **Attribution is an event record, and events don't change: the event
   sub-keys (`when`/`channel`/`agent`/`why`) are immutable once written**, like
   `id`. Update-in-place merges never rewrite them — `timestamp` carries "last
   meaningful change", the commit graph carries the change narrative, and a
   later merge that absorbs a second source is `provenance`/`# Citations`
   territory. One concept, one ingestion event. The single carve-out is
   governance `from` (ratified 2026-07-13, forced by lineage derivation):
   feature lineage accretes — every thread that substantively revises a doc is
   part of its chain — so **`from` is append-only**: entries are added by later
   sessions' `/create-pull-request` stamping, never removed or rewritten.
2. **Attribution is orthogonal to provenance.** The existing fields keep their
   meanings; attribution takes over the ingestion-event duty that `provenance`
   free text has been informally absorbing:

   | Field | Answers | Mutability |
   |-------|---------|------------|
   | `resource` | *what asset* — canonical URI of the underlying thing | immutable |
   | `provenance` | *where the content came from* — its author/origin, possibly predating the brain | immutable history |
   | `attribution` | *how it got here* — the ingestion event: when / channel / actor / reason | immutable event |
   | `timestamp` | *when it last meaningfully changed* | mutable |

3. **It is not a log.** The
   [retire-hand-kept-logs decision](/meta/plans/retire-hand-kept-logs.md) stands:
   the commit graph remains the single provenance *layer* (the full change
   narrative). Attribution is a single write-once record of one event — it cannot
   drift, because it is never maintained. It summarizes in-band the one commit
   that git makes progressively harder to reach (renames, merges, agents without
   git access, foreign bundle consumers); it does not compete with git for
   anything else.

### Scope

**Bundle concepts** — everything that carries an `sb:` id — going forward from
ratification. The operator's ask named "resources absorbed into the knowledge
collection", and captures (`reference`/`source`) are indeed where attribution
earns the most — but a uniform all-bundle-concepts rule is simpler to state,
enforce, and query than a per-type carve-out, and *why was this filed* is just
as valuable on an agent-authored `claim` as on a capture. Scoping down to
capture types only is kept as an open question.

**Governance namespace — explicitly attributed, not exempt.** The first draft
excluded `meta/` as "already self-describing"; operator review overturned that:
implied attribution — origin recoverable only from free-text `provenance`, a
dated filename, or git — is exactly the ambiguity this plan exists to remove,
and the bundle has already invented explicit governance attribution twice,
piecemeal: the elaboration docs' `thread:` back-link (stamped by
`/create-pull-request`) and the flow docs' CI-checked `lineage:` block. This
plan generalizes that motion instead of leaving it genre-local. Governance docs
(`plan`, `analysis`, `issue`, `todo`, `tutorial`, `doctrine`, `policy`,
`elaboration`) carry `attribution` with one additional sub-key:

| Sub-key | Holds | Form |
|---------|-------|------|
| `from` | The doc(s) this entry was extracted from — the thread it came out of, and/or the concept doc that resulted from that thread | YAML list of refs, route-tag style: an `sb:` id (concept) or a bundle-absolute path (thread or governance doc, which carry no ids) |

- **Timing.** A governance doc authored mid-session can't name its thread — the
  thread doc doesn't exist until `/capture` runs at session close. So
  `/create-pull-request` stamps `attribution.from` with the just-captured
  thread path across every governance doc the session created, exactly as it
  already does for the elaboration `thread:` field. That field is then folded
  into `attribution.from` as a special case rather than kept as a parallel
  mechanism.
- **`from` is required-or-stamped, not optional decoration:** required on
  ratification-flow docs (`plan`, `analysis`, `elaboration`, `issue` — things
  that are always extracted from *somewhere*); permitted to be absent only
  where there is genuinely no source doc (e.g. doctrine the operator dictates
  directly — `agent`/`why` still record that).
- **Exempt:** thread docs themselves (they *are* the session record; `pr:` is
  their anchor — self-attribution is circular), `inbox/` digests (generated,
  dated, self-describing by construction), and generated artifacts
  (`CLAUDE.md`, `meta/registry.md`, materialized excerpt logs — outputs, not
  docs).

## Enforcement — `mix brain.verify`

New rules, in the verifier's existing named-error style:

- **Shape (from day one):** when `attribution` is present it must be a map;
  `when` parses as ISO 8601; `channel` is from the vocabulary; `agent` and `why`
  are non-empty strings — except `why`, which is optional when
  `channel: backfill` (the reason is often unrecoverable from history; invent
  nothing).
- **`from` resolution:** every `from` ref resolves — an `sb:` id to an existing
  concept, a path to an existing file — reusing the route-tag ref-resolution
  machinery (`SecondBrain.RouteTags` already validates exactly this ref shape).
  Broken `from` refs are errors, like broken `verified_by` edges.
- **Governance presence:** ratification-flow docs (`plan`, `analysis`,
  `elaboration`, `issue`) missing `attribution.from` are flagged — as a
  *warning* until `/create-pull-request` stamping has been live for a while,
  then an error. Exempt files (threads, digests, generated artifacts) carrying
  `attribution` is an error.
- **Presence (after backfill completes):** every bundle concept carries
  `attribution` — flipped on as a rule only once the backfill lands, so the rule
  is never aspirational. Until then presence is skill-enforced at filing time,
  not verifier-enforced.

Immutability is not machine-checked (the verifier sees one snapshot, not a diff)
— it is a contract obligation on agents, like "never hand-edit the registry",
with git review as the safety net.

## Writers — skill updates

- **`/intake` step 4 (Distill):** write `attribution` alongside the existing
  fields. `channel: intake`, `agent` = the acting agent/session context, `why` =
  the operator's ask in one sentence (the same natural phrasing step 8 harvests
  for the dedup gold set — one motion, two artifacts).
- **`/research` auto-intake step:** `channel: auto-intake`, `why` = the featuring
  reason (category match + reason-tag), which finally lands the digest's
  rationale *on the concept itself*. The `auto-intake` **tag** is retired in the
  same change (ratified: no transition window) — the skill stops writing it, the
  policy text drops it, and the backfill converts existing tags to
  `channel: auto-intake`; until the query task ships, the editorial pass greps
  `channel: auto-intake` instead of the tag.
- **`/add-to-glossary`:** `channel: glossary`, `why` = which thread/doc surfaced
  the term.
- **Inline agent filing** (a concept distilled mid-session outside any skill):
  `channel: agent-authored`, `why` = what in the session prompted filing it.
- **Inline governance filing** (a plan, analysis, issue, or todo persisted
  mid-session): full `attribution` at write time with `from` left for stamping
  (or set immediately when the source is an already-existing doc, e.g. an
  analysis extracted from a filed thread).
- **`/create-pull-request`:** after `/capture`, stamp `attribution.from` with
  the just-captured thread path in every governance doc the session created or
  substantively updated — the generalization of its existing elaboration
  back-link step, which it replaces.

## Backfill

A one-shot `mix brain.attribution --backfill` derives attribution for the
existing corpus:

- `when` from `git log --diff-filter=A --follow` (first-add date).
- `channel`/`agent` heuristically from `tags` (`auto-intake` → `auto-intake`) and
  `provenance` text where unambiguous; otherwise `channel: backfill` with the
  derivable facts and no invented `why`.
- **Governance docs:** `from` from the existing explicit sources where present —
  elaboration `thread:` fields (migrated, then retired), flow `lineage:` blocks,
  and `provenance` text that names a thread or PR; otherwise omitted rather than
  guessed.
- Output is an ordinary diff for operator review, not a silent rewrite.

After the backfill merges, the verifier's presence rule flips on.

## Tooling (optional phase — the machine consumer)

`mix brain.attribution` as a read-only query surface:
`mix brain.attribution --channel auto-intake --since 2026-07-01` lists matching
concepts (id, path, when, why). This makes the post-auto-intake editorial pass a
one-command listing instead of a tag grep, and is the consumer that justifies the
structured map over free text — same principle as typed edges: structure it only
because a machine will read it. If this phase is deferred, the structured shape
still costs nothing and stays grep-able.

## Interactions

- **Epistemic overlay plan** ([epistemic-overlay](/meta/plans/epistemic-overlay.md),
  `proposed`): no conflict. Attribution is event metadata *on* nodes; the overlay
  is typed edges *between* nodes. Both extend frontmatter under the same
  "document is the concept" commitment. If supersession lands there, a
  superseding concept gets its own fresh attribution (it is a new ingestion
  event), and the chain lives in the overlay's edges, not here.
- **Frontmatter-schema policy:** gains one row (`attribution` | When applicable →
  Mandatory after backfill | sub-key table or a pointer to the new policy).
- **Flow lineage** ([flow-lineage plan](/meta/plans/flow-lineage-index.md),
  `done`): **derives from attribution** (ratified 2026-07-13). The hand-kept
  `lineage:` block retires; `mix brain.lineage` instead computes each flow's
  chain by walking `from` transitively from the flow doc (flow → plan →
  analysis, collecting the threads stamped along the way) plus each thread's
  `pr:` anchor — and keeps producing exactly what it produces today: the
  per-doc blockquote and the cross-flow flowchart index, `--check`-gated. Same
  outputs, one edge source instead of a parallel hand-kept block. This is what
  forces the append-only `from` carve-out above, and it can only ship after the
  governance backfill populates `from` across the existing chain — the backfill
  diff doubles as the migration check that derived lineage reproduces the
  current hand-kept blocks (any divergence is resolved by fixing `from`, not by
  keeping two sources).
- **Elaboration `thread:` field:** subsumed by `attribution.from`. Migration is
  part of the governance backfill; the elaboration policy text and
  `/create-pull-request` skill update in the same change.
- **Verification grounding:** untouched — attribution says how a concept
  *arrived*, never anything about whether it is *true*. `verified`/`verified_by`
  semantics are unaffected.

## Build order

1. **Policy + contract** (plan ratified 2026-07-13): write
   `meta/policy/resource-attribution.md` (section: composition) and run
   `/render-contract`.
2. **Verifier shape rules** + ExUnit tests (mirroring the rule-6 pattern from the
   [code-review hardening plan](/meta/plans/code-review-toolchain-hardening.md)).
3. **Skill updates** (`/intake`, `/research`, `/add-to-glossary`,
   `/create-pull-request` stamping) so every new doc is born attributed; the
   `auto-intake` tag and the elaboration `thread:` writer retire in this step.
4. **Backfill task** (bundle + governance, including tag → channel and
   `thread:` → `from` conversion), operator-reviewed diff, then flip the
   verifier presence rules to mandatory.
5. **Lineage derivation:** rewire `mix brain.lineage` to compute chains from
   `from` + `pr:`, confirm the derived output reproduces the hand-kept blocks,
   then delete the `lineage:` blocks. Immediately after backfill — it is the
   first machine consumer of `from` and locks the edge in under the
   typed-edge rule.
6. **`mix brain.attribution` query surface** (promoted from optional: with the
   tag retired, the editorial pass and trust queries read attribution, and the
   lineage walker's traversal code is already in hand).

## Ratified decisions (operator, 2026-07-13)

The open questions were put to the operator and all five resolved; this plan
moved `proposed` → `accepted` on their answers.

1. **Scope within the bundle: all bundle concepts**, not a capture-type
   carve-out. *(Governance scope was settled the same day: explicit attribution
   with `from` — see the revision note below.)*
2. **Presence: verifier-mandatory** once the backfill lands, for both the
   bundle-concept rule and the governance `from` rule.
3. **`agent` names the pathway**, not the model — the model is already in the
   commit trailer; pathway is what trust calibration reads.
4. **The `auto-intake` tag retires immediately** — no transition window; the
   backfill converts existing tags to `channel: auto-intake`.
5. **Flow `lineage:` derives from `attribution.from`** — implemented as soon as
   its dependency allows, i.e. immediately after the governance backfill (build
   step 5). Consequences folded into the spec: the append-only `from` carve-out
   (semantics rule 1) and `mix brain.attribution` promoted from optional to
   build step 6.

## Revision note — governance attribution made explicit (2026-07-13)

The first draft exempted the governance namespace as "already self-describing".
Operator review rejected the exemption: governance entries should be explicitly
attributed to the thread they were extracted from, or to the concept doc that
resulted from that thread — implied attribution is the same free-text ambiguity
this plan removes elsewhere. The Scope, Enforcement, Writers, Backfill, and
Interactions sections were revised accordingly: governance docs carry
`attribution` with a `from` sub-key (route-tag-style refs), stamped by
`/create-pull-request` for mid-session docs, subsuming the elaboration
`thread:` back-link.
