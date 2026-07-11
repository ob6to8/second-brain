---
type: plan
title: "The daily read: a cross-domain synthesis lede for /news digests"
description: Promote the ad-hoc per-domain framing paragraph in /news digests to a first-class '## The read' section at the top of each digest — a short, sb:-id-grounded perspective that reads the day's selections as a set against the brain's standing concerns, connecting threads across domains.
status: done
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-11 — operator proposed the feature after the 2026-07-11 digest; ratified and implemented same session"
tags: [meta, plan, news, inbox, synthesis, skills]
timestamp: 2026-07-11
---

# The daily read: a cross-domain synthesis lede for /news digests

## Status & provenance

**Done** — proposed by the operator on 2026-07-11 ("what if we introduce a daily
summary, which presents a perspective on the day's news selections in the context of
the existing repo's concerns and focuses?"), ratified in the same session, and
implemented immediately: the `/news` skill and the 2026-07-11 digest were updated as
part of this plan. Filed as the durable decision record per the persist-plans policy.

## Problem

The `/news` digest is a good *list* but a weak *read*. Its body is per-domain
buckets of item synopses; the only synthesis is whatever framing paragraph the agent
happens to write inline (e.g. the 2026-07-11 ai-industry lede: "the throughline is
that the brain's margin-collapse thesis `sb:07610c` is now actively contested").
That framing is the most valuable part of the digest — it's what turns a pile of
links into *a view of where things are moving relative to what the brain already
cares about* — but it was incidental, single-domain, and non-guaranteed.

Two things the per-domain lists structurally can't do:

1. **Connect across domains.** The day's real story often spans buckets — e.g.
   2026-07-11's lossless inference (`sb:266c5e`), long-horizon agents (agentic-loop),
   and worktree isolation all point at one arc: *agents running longer and cheaper*.
   Nothing in the digest says that.
2. **Read the set against standing concerns.** Whether today's items *reinforce,
   contest, or extend* the brain's filed positions is exactly the intake-relevant
   signal, and it lives above any single item.

## The change

Add a **`## The read`** section as the **first** body section of every digest,
before the per-domain lists.

- **1–3 short paragraphs.** A *perspective*, not a re-listing — the item synopses
  stay in the domain sections below; the read never restates them.
- **Grounded in `sb:` ids.** It names the standing concepts the day bears on
  (`sb:07610c`, `sb:2867ac`, …) so the synthesis is anchored to the actual taxonomy,
  not free-floating commentary. This mirrors the route-tagging discipline of keying
  on ids, not phrases.
- **Cross-domain by mandate.** Its explicit job is the connective tissue the buckets
  can't hold: the trend, tension, or throughline that runs across domains.
- **Candidate-side, like everything in `/news`.** No `sb:` id, `inbox/` namespace,
  distilled, and asserts nothing beyond what the day's selections support. It is a
  reading of candidates, not a filed claim.

The pre-existing per-domain lede paragraphs (like the ai-industry one) remain
allowed as *domain-level* framing; `## The read` is the *cross-domain* layer above
them. When a day is single-domain, the read collapses to a short one-paragraph take.

## Artifact shape

Digest body order becomes:

```
# Inbox — YYYY-MM-DD
<one-line candidate-feed preamble>

## The read
<1–3 paragraphs, sb:-grounded, cross-domain perspective>

## <domain-1>
<optional domain lede> + item bullets

## <domain-2>
...
```

## Build order

1. **`/news` SKILL.md** — insert a new step **§4.5 "Write the daily read"** between
   selection (§4) and digest-write (§5), and update the §5 body template to lead with
   `## The read`. (done)
2. **Backfill 2026-07-11** as the first worked instance — lift the ai-industry
   throughline up into a proper cross-domain read. (done)
3. **This plan** + plans index + log. (done)

## Scope boundaries

- **Not a summary of items.** If it restates synopses it becomes a stale shadow of
  the lists below — the same anti-duplication rule the routing ledger follows.
- **Not an essay.** The inbox is a waiting room; the read stays to a few tight
  paragraphs.
- **No new reason tags, no new namespace, no bundle writes.** Purely an addition to
  the digest body; the selection contract and guardrails are unchanged.
- **No mechanical check.** Like tag *coverage*, the quality of the read is editorial;
  there's no verifier for "is this a good synthesis." It rides on the agent.

## Deferred

- **A standing "arc" across digests.** A future step could let the read reference
  *yesterday's* read to track a multi-day throughline (e.g. the margin-collapse
  debate escalating over a week). Deferred until the single-day read has proven out.
