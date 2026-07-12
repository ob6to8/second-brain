---
type: plan
title: "Auto-intake featured /news items: move the human from the intake gate to the editorial surface"
description: Automatically run /intake on the items /news already featured, so the brain grows a real corpus for the downstream evals — relocating the operator's role from a pre-intake gate (which the operator judges artificial) to post-intake editorial work (prune, relabel, merge, retag), gated behind the tier-1 dedup fix.
status: done
provenance: "Claude Code session (claude-opus-4-8), 2026-07-12 — operator proposal + design discussion in this session; authorized to persist and execute"
tags: [meta, plan, news, intake, automation, dedup, corpus]
timestamp: 2026-07-12
---

# Auto-intake featured /news items

## Status & provenance

**Done** — proposed by the operator on 2026-07-12, refined and shipped in the same
session. The Fork A dependency (the dedup-recall-probe's tier-1 synonym-expanded
`/intake` fix) landed via PR #50; the `/news` skill then gained its §6 auto-intake
step (with the flow-doc mirror and the skills-registry description updated). The
operator's framing is the load-bearing decision: the pre-intake
approval click ("this looks interesting, intake it") is *not* editorial work —
you cannot evaluate a candidate's filing, cross-links, or duplication against a
URL until it is actually in the system. Gating intake on that judgment is close
to tautological. The operator's real, irreplaceable contribution is **post-intake
editorial**: pruning, relabeling, fixing taxonomy, spotting duplication — the
collaborative work that only becomes possible once material is filed. This plan
moves the human's locus of control accordingly.

## Problem

`/news` writes a daily candidate feed into the [inbox namespace](/glossary/inbox-namespace.md);
a candidate enters the bundle only when the operator says "intake the <…> item",
which runs `/intake`. That human gate was designed as a quality filter, but:

- The featured set is **already filtered** — `/news` [featuring](/glossary/featuring.md)
  applies relevance → novelty (two dedup passes) → a reason tag → source quality,
  then a quality-over-volume cap. The operator's click is a *second* filter on an
  already-curated set.
- The gate produces **no corpus growth** while three active plans
  (the [dedup-recall probe](/meta/plans/dedup-recall-probe.md), cross-linking, the
  [epistemic overlay](/meta/plans/epistemic-overlay.md)) all need a *larger corpus*
  to be meaningful. The brain is currently too small for those evals to bite.
- The gate is a poor lever for the behavior it was meant to prompt: real editorial
  judgment happens after filing, not before.

## Core principle

**The human moves from the intake gate to the editorial surface.** Auto-intake
fills the brain from the already-featured set; the operator (with the agent)
does the post-hoc editorial pass. Failures that emerge from operator
disengagement are treated as *emergent system failures worth surfacing*, not as
reasons to withhold progress behind a nag-gate. The brain is a collaborative
effort; the operator shows up editorially, by design.

## Decisions

1. **Auto-intake exactly the items `/news` featured.** The featuring cap is the
   volume knob (≈4–10/day) — no new threshold to tune.
2. **The step lives in `/news` itself,** not the Routine — so it fires on manual
   runs and sidesteps the still-open
   [daily-Routine-not-landing issue](/meta/issues/daily-news-routine-runs-not-landing.md).
3. **Bounded to the known tree.** Auto-intake files into *established* domains
   autonomously; an item that would require a **new top-level directory** is
   *deferred* — left in the inbox, flagged for operator ratification — per the
   taxonomy-evolution protocol (new top-level shape is never autonomous).
4. **Prefer update-in-place aggressively.** When a featured item carries a
   `relates to sb:xxxxxx` hint (the digest already computes it), intake **updates
   that concept in place** rather than creating a sibling. This is free dedup that
   keeps [residual fragmentation](/glossary/residual-fragmentation.md) small, so the
   editorial pass reconciles the *residual*, not the bulk.
5. **Every auto-filed concept is tagged** (`tags: [auto-intake]` + provenance) and
   the digest line is marked `✓ auto-intaken → /path`, so the editorial surface —
   what came in, what to review — is a single query.

## Sequencing — Fork A (operator's choice)

**Gate on the dedup fix first.** Auto-intake activates only *after* the tier-1
synonym-expansion [dedup](/glossary/deduplication.md) step from the
[dedup-recall-probe plan](/meta/plans/dedup-recall-probe.md) lands. Rationale: a
fragmentation committed to history is costlier to reconcile (reassigning
[`sb:` ids](/glossary/stable-id.md) and redirecting
[`verified_by`](/glossary/verified-by.md) edges) than one avoided at write time,
so the firehose should not open until intake dedup can merge in place. The
operator chose this over ship-now-with-guardrails.

**Dependency:** the dedup-recall-probe plan's tier-1 `/intake` change — currently
being executed in a **parallel thread**. This plan's build order resumes once that
lands.

## Risks & tradeoffs

- **[Cognitive debt](/glossary/cognitive-debt.md)** — the operator's understanding
  lagging the corpus as it grows faster than they internalize it. Mitigated by the
  operator's stated intent to keep reading each item, plus the `auto-intake` tag
  making periodic review cheap. Named and accepted, not eliminated.
- **Residual fragmentation** — near-duplicates the cheap dedup misses; handled by
  the editorial pass (that is the point of the reframe), minimized by decision 4.
- **Thin/aggregator distillations** slipping in — mitigated by the featuring
  source-quality gate and post-hoc review; a hard quality floor is deferred.
- **Loss of the curation signal** (which items the operator chose to intake) —
  judged minor for a personal brain where "it's all pertinent."

## Build order (all shipped 2026-07-12)

1. ✅ *(prerequisite, PR #50)* tier-1 synonym-expansion `/intake` dedup step.
2. ✅ `/news` gains the §6 auto-intake step: featured items → `/intake`, updating in
   place on a `relates to sb:` hint, deferring new-top-level-domain items, tagging
   `auto-intake`.
3. ✅ Digest lines marked `✓ auto-intaken` / `✓ merged` / `⏸ deferred` in the same run.
4. ✅ Mirrored in the [news-inbox flow doc](/meta/flows/news-inbox.md) and the
   [skills-registry policy](/meta/policy/skills-registry.md) (contract re-rendered)
   per the no-drift rule.

## Open questions (for the operator)

1. **Quality floor:** add an explicit skip/flag for aggregator-only or paywalled
   sources, or trust the featuring gate + editorial pass?
2. **Update-vs-append on a `relates to` hint:** always update the related concept
   in place, or only when the item is a genuine continuation (vs a contrasting
   datapoint that deserves its own file)? Decision 4 currently says update.
