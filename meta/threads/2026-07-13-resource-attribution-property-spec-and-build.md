---
type: reference
title: 2026-07-13-resource-attribution-property-spec-and-build
description: Spec'd, ratified, and fully built the attribution frontmatter property — the ingestion event (when/channel/agent/why, plus append-only governance from) recorded on every bundle concept and governance doc; operator review made governance attribution explicit, all five open questions were ratified, and six build steps shipped same session, including a 265-doc git-derived backfill and rewiring mix brain.lineage to derive from attribution.from.
provenance: "Claude Code session (Claude Fable 5, then Claude Opus 4.8), 2026-07-13; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, attribution, provenance, frontmatter, intake, lineage, backfill, verifier]
timestamp: 2026-07-13
pr: 66
---

# 2026-07-13-resource-attribution-property-spec-and-build

## Where this landed

The operator asked for an attribution property recording how each resource was
absorbed into the brain — when, how/who, and why. The session ran the full arc
in one sitting: a proposed spec, one substantive operator revision (governance
docs must be **explicitly** attributed, not left self-describing), ratification
of all five open questions, and then the complete six-step build.

Settled design: a structured `attribution` frontmatter map —
`when`/`channel`/`agent`/`why`, plus an append-only `from` back-link on
governance docs — carried by every bundle concept and every governance doc.
It is an immutable *event* record (event sub-keys write-once; governance `from`
append-only), orthogonal to `resource` (what asset), `provenance` (content
origin), and `timestamp` (last change). Enforced by `mix brain.verify` rule 8;
presence is mandatory after the git-derived backfill landed.

Ratified answers: (1) scope = all bundle concepts; (2) presence
verifier-mandatory; (3) `agent` names the pathway, not the model; (4) the
`auto-intake` tag retires immediately; (5) flow `lineage:` derives from
`attribution.from` + thread `pr:` anchors. All six build steps shipped —
policy + contract, verifier rule 8, skill writers, a 265-doc backfill, lineage
derivation (confirmed byte-identical to the retired hand-kept blocks before
deletion), and the `mix brain.attribution` query surface. The plan is
`status: done`.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Attribution property design (the ingestion event: when/channel/agent/why) | closed | [resource-attribution-property](/meta/plans/resource-attribution-property.md) | - |
| Make governance attribution explicit (the `from` back-link) | closed | [resource-attribution-property](/meta/plans/resource-attribution-property.md) | - |
| Compile the design into an enforceable contract rule | closed | [resource-attribution policy](/meta/policy/resource-attribution.md) | - |
| Attribution vs. provenance orthogonality | closed | [provenance](/beliefs/glossary/provenance.md) | - |
| Retire the `auto-intake` tag in favor of `channel: auto-intake` | closed | [auto-intake](/beliefs/glossary/auto-intake.md) | - |
| Derive flow lineage from `attribution.from` instead of a hand-kept block | closed | [lineage](/beliefs/glossary/lineage.md) | - |

## User

Lets create an attribution property for resources absorbed into the knowledge collection - including when it was ingested, how/who, and why. Spec out

## Assistant

<routes ref="/meta/plans/resource-attribution-property.md sb:ea7acc">
Spec written, filed, and pushed. The plan is at [`meta/plans/resource-attribution-property.md`](meta/plans/resource-attribution-property.md) (`status: proposed`, awaiting your ratification since it changes the frontmatter schema), indexed in `meta/plans/index.md`, all gates green, pushed to `claude/resource-attribution-spec-l3hzjj`.

**The proposed shape** — one new frontmatter key on bundle concepts:

```yaml
attribution:
  when: 2026-07-13T14:02:00Z
  channel: auto-intake          # controlled vocab: intake | auto-intake | glossary | agent-authored | backfill
  agent: "Claude Code agent, /research daily Routine"
  why: "featured in the 2026-07-13 digest under agents/orchestration; reason-tag: impactful"
```

**Key design decisions in the spec:**

- **It's an immutable event record, not a log.** Written once at filing, never rewritten by update-in-place merges — so it can't drift and doesn't conflict with the retire-hand-kept-logs decision. Git stays the change *narrative*; attribution is the in-band summary of the one commit that renames, merges, and portable-bundle consumption make hard to reach.
- **Orthogonal to the existing fields**, resolving a real ambiguity: `provenance` has been informally carrying both "where the content came from" and "how it entered the brain" (compare the glossary files vs. the auto-intaken ones). The spec gives each field one job: `resource` = what asset, `provenance` = content origin, `attribution` = ingestion event, `timestamp` = last change.
- **The `why` finally lands on the concept.** Today the featuring rationale lives in a dated digest the concept never points back to; `/research` would write it into `attribution.why`, and `/intake` would reuse the operator's natural phrasing (the same text the dedup gold-harvest already collects).
- **Enforcement is phased**: verifier shape rules from day one, presence becomes mandatory only after a git-derived backfill (`mix brain.attribution --backfill`, delivered as a reviewable diff) so the rule is never aspirational. The `auto-intake` tag gets subsumed by `channel` and retired after a transition window.

**Four open questions are flagged for you** at the bottom of the plan: scope (all bundle concepts — my recommendation — vs. only `reference`/`source` captures), whether presence goes verifier-mandatory after backfill, whether `agent` names the pathway or the model, and whether to retire the `auto-intake` tag. No PR opened — say the word (or `/create-pull-request`) when you want one.
</routes>

## User

I've read the plan regarding the governance namespace. Shouldn't attribution be explicit? I believe the plan states this is being implied. but it would seem that governance entries should be explicitly attributed to the thread they were extracted from or the concept document that resulted from that thread.

## Assistant

<routes ref="/meta/plans/resource-attribution-property.md">
You're right, and the bundle itself already proves the point: it has invented explicit governance attribution twice, piecemeal — the elaboration docs' `thread:` back-link (stamped by `/create-pull-request`) and the flow docs' CI-checked `lineage:` block. My "already self-describing" exclusion was recreating exactly the free-text implicitness this plan exists to remove. Let me revise the spec to make governance attribution explicit.
</routes>

## Assistant

<routes ref="/meta/plans/resource-attribution-property.md">
Agreed and revised — the plan now makes governance attribution explicit rather than implied. Pushed as `c8844bb`, all gates green.

What changed in the spec:

- **The exemption is gone.** Governance docs (`plan`, `analysis`, `issue`, `todo`, `tutorial`, `doctrine`, `policy`, `elaboration`) now carry `attribution` too, with one extra sub-key: **`from`** — a list of explicit refs to the thread the entry was extracted from and/or the concept doc that resulted from that thread. Refs follow the route-tag convention (an `sb:` id for concepts, a bundle-absolute path for threads and governance docs, which have no ids), so the verifier can reuse the existing ref-resolution machinery and broken back-links fail like broken `verified_by` edges.
- **The timing problem is solved by an existing mechanism, generalized.** A doc written mid-session can't name its thread — the thread doc doesn't exist until `/capture` runs. `/create-pull-request` already solves exactly this for elaborations by stamping their `thread:` field after capture; the plan promotes that step to stamp `attribution.from` across every governance doc the session created, and the elaboration `thread:` field is folded in and retired.
- **`from` is required-or-stamped on ratification-flow docs** (`plan`/`analysis`/`elaboration`/`issue`), permitted absent only where there is genuinely no source doc (e.g. doctrine you dictate directly). Still exempt: thread docs themselves (self-attribution is circular; `pr:` is their anchor), `inbox/` digests, and generated artifacts.
- **Backfill covers governance**: `from` is derived from the existing elaboration `thread:` fields, flow `lineage:` blocks, and provenance text that names a thread — never guessed.

One thing worth flagging: your review actually exposed that the bundle had already built explicit governance attribution *twice*, genre-locally — the elaboration back-link and the flow `lineage:` block. This plan unifies the first outright; whether flow `lineage:` should eventually be *derived* from the `attribution.from` chain (rather than remain a parallel mechanism) is recorded as new open question 5, and the revision itself is documented in a dated revision note at the bottom of the plan.
</routes>

## User

Commit and push

## Assistant

Already done — the working tree is clean and the branch is fully pushed. Both commits are on `origin/claude/resource-attribution-spec-l3hzjj`:

- `57022f6` — the attribution spec plan (`meta/plans/resource-attribution-property.md` + index entry)
- `c8844bb` — the governance-attribution revision (explicit `from` back-link)

There was nothing new to commit since the revision was committed and pushed as part of the last change. If you'd like this captured and opened as a PR, say `/create-pull-request`.

## User

Re: operator questions:
1- all
2- verifier mandatory
3- agree, pathway
4- retire asap
5- i would think lineage deriving would be cleaner and should be implemented asap, what are your thoughts?

## Assistant

<routes ref="/meta/plans/resource-attribution-property.md sb:f97e44">
All five ratified — I'll record the decisions in the plan and flip it to `accepted`. On Q5, my thoughts first, because agreeing with it has one structural consequence:

**I agree derivation is cleaner, and it fits a pattern this bundle already trusts** — the registry, `CLAUDE.md`, and the excerpt logs are all "hand-write the source once, compile the view, gate on `--check`". A hand-kept `lineage:` block is itself drift-prone (ironic, given the flow-lineage plan was anti-drift motivated). But deriving it forces one amendment to the spec: **`from` must be append-only, not frozen.** Feature lineage accretes — every thread that revises a plan is part of the chain — so if `from` were locked at creation like the rest of attribution, the derived lineage would stop at the first session. So the immutability rule splits: the event sub-keys (`when`/`channel`/`agent`/`why`) stay write-once, while `from` grows as later sessions' `/create-pull-request` stamps them. And "ASAP" has a hard dependency: derivation can only ship after the governance backfill populates `from` across the existing chain — so it slots in right after backfill in the build order, with the backfill diff doubling as the check that derived lineage matches the existing hand-kept blocks. Updating the plan now:
</routes>

## Assistant

<routes ref="/meta/plans/resource-attribution-property.md sb:f97e44 sb:f8ae3a">
All five decisions are recorded and the plan is now `status: accepted` — pushed as `e615742`, gates green, and the index entry moved into "Accepted / In progress" (its first occupant).

How each answer landed in the spec:

1. **Scope: all bundle concepts** — the capture-type carve-out question is closed.
2. **Presence: verifier-mandatory after backfill** — for both the bundle-concept rule and the governance `from` rule.
3. **`agent` = pathway** — locked in as the ratified convention.
4. **`auto-intake` tag retires immediately** — no transition window. The skill stops writing it in build step 3, the backfill converts existing tags to `channel: auto-intake`, and until the query task ships the editorial pass greps the channel instead.
5. **Lineage derives from `from`** — with the two consequences I flagged folded in: semantics rule 1 now splits immutability (event sub-keys write-once; governance `from` append-only, since feature lineage accretes across sessions), and derivation is sequenced as build step 5, immediately after the governance backfill that populates `from` — the backfill diff doubles as the migration check that derived chains reproduce today's hand-kept `lineage:` blocks before those get deleted. A pleasant side effect: `mix brain.lineage` becomes the first machine consumer of `from`, which is what earns the typed edge under the bundle's own rule — so I also promoted `mix brain.attribution` from optional to build step 6, since the traversal code will already exist.

The build order now reads: policy + contract render → verifier shape rules → skill writers (including `/create-pull-request` stamping, tag and `thread:` retirement) → backfill + flip mandatory → lineage rewire → query surface. The spec phase is complete; say the word when you want execution to start (step 1, the policy doc + `/render-contract`, is a natural first slice), and `/create-pull-request` whenever you want this session's work captured and opened as a PR.
</routes>

## User

Commit then proceed with execution

## User

I have some other threads with work to merge, and this touches many things. I will merge those rhen return here

## Assistant

Understood — good call, since the execution will touch the verifier, the contract, several skills, and every concept file (backfill), so a stale base would make for painful merges. Pausing here.

Where things stand for when you return:

- **Everything decided is committed and pushed** on `claude/resource-attribution-spec-l3hzjj` (`e615742`): the accepted plan with all five ratifications, and the index entry. The working tree is clean — execution hasn't touched a file yet, so there's nothing half-done to conflict with your other merges.
- **The six-step build order is queued as tasks** (policy+contract → verifier rules → skill writers → backfill → lineage derivation → query surface), all pending.
- **One technical finding from reconnaissance worth carrying forward:** the bundle's `Frontmatter` parser is deliberately flat — scalars and inline lists only, no nested maps — so the `attribution:` block will need parsing support. The good news is `SecondBrain.Lineage` already solved exactly this for the `lineage:` block (its own indentation-aware block parser over the raw frontmatter lines), so the clean move is to generalize that into a shared nested-block parser both can use — which also dovetails with step 5, where lineage derivation replaces that block anyway.

When your other threads have merged, come back and I'll rebase this branch onto the updated `main` (a true merge from `origin/main`, per the merge-strategy policy — no rebase of pushed history) and proceed from step 1.

## User

Other threads have merged, pull main

## Assistant

<routes ref="/meta/plans/resource-attribution-property.md lib/second_brain/attribution.ex lib/second_brain/attribution/backfill.ex lib/second_brain/lineage.ex lib/mix/tasks/brain.attribution.ex">
Execution complete — all six build steps shipped, gates green (141 tests, verify/contract/registry/lineage/route-tags all pass), and everything is pushed on `claude/resource-attribution-spec-l3hzjj` as five commits, one per build phase:

**What landed:**

1. **Policy + contract** (`308a993`) — `meta/policy/resource-attribution.md` compiles into contract §1; the frontmatter-schema table gains the `attribution` row.
2. **Verifier rule 8** (`d514c85`) — a new `SecondBrain.Attribution` module checks shape (ISO 8601 `when`, controlled `channel`, non-empty `agent`, `why` optional only on `backfill`), `from` restricted to governance docs with resolving refs, and exemption placement (threads, digests, indexes, generated artifacts must *not* carry it). The frontmatter parser gained one level of nested block maps to support this.
3. **Skill writers** (`84b3e7f`) — `/intake`, `/research`, `/add-to-glossary`, and `/elaborate` all write the event at filing time; `/create-pull-request` step 3 now stamps the captured thread into `attribution.from` across all session governance docs, subsuming the elaboration `thread:` back-link. The `auto-intake` tag is retired.
4. **Backfill + mandatory presence** (`cb2d837`) — the interesting one. `mix brain.attribution --backfill` reconstructed 265 docs: `when` from git first-add commits (with a fallback across the root reorganization, which `--follow` can't track through the merge topology), and governance `from` derived *precisely* — first-add commit → introducing PR → the thread doc carrying that `pr:`. That took the advisory `from` warnings from 24 down to 1; six docs whose branch merged through two PRs were hand-stamped after confirming each thread's routing ledger links the doc. The one remaining warning is the attribution plan itself, whose `from` gets stamped when this session is captured — by the very mechanism it specified.
5. **Lineage derivation** (`3617e13`) — `mix brain.lineage` now derives chains from `attribution.from` + thread `pr:` anchors. The migration check confirmed the derived views reproduced the hand-kept `lineage:` blocks **byte-for-byte** before I deleted them from all eight flow docs.
6. **Query surface** (`48c48e9`) — `mix brain.attribution --channel auto-intake --since <date>` is now the one-command editorial pass.

Also fixed along the way: two thread docs were missing their `pr:` stamp (derived 60 and 50 from merge history), and the clone was shallow, which had to be unshallowed for first-add dating.

Say the word for `/create-pull-request` when you want this captured and opened as a PR — that run will also be the first live exercise of the new `from`-stamping step.
</routes>
