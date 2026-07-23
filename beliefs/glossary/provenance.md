---
id: em:ea7acc
type: concept
title: provenance
description: Commonly, the documented origin and history of an artifact — where it came from and how it got here; in this brain, the frontmatter field recording a statement's immutable origin, orthogonal to verification.
provenance: "Agent-distilled glossary definition, pointer to the defining doc"
verified: false
tags: [glossary, frontmatter, provenance]
sense: dual
timestamp: 2026-07-23
attribution:
  when: 2026-07-11T08:41:24+02:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# provenance

The documented origin and history of an artifact — where data, a claim, or an object came from and the chain of custody that brought it here. Data provenance is what lets a reader judge trust and trace errors to their source.

**In this brain:** the frontmatter field recording the immutable origin/history of a statement (e.g. "Claude Opus 4.8, chat thread") — distinct from `resource`, which is a canonical asset URI. Provenance is orthogonal to verification: checking a statement never rewrites where it came from. Defined by the [frontmatter-schema policy](/meta/policy/frontmatter-schema.md).

*Seen in:* [2026-07-05 OKF bootstrap thread](/meta/threads/2026-07-05-greenfield-okf-bootstrap-and-verification-layer.md), [2026-07-12 news→research rename thread](/meta/threads/2026-07-12-rename-news-skill-to-research.md), [2026-07-13 resource-attribution property thread](/meta/threads/2026-07-13-resource-attribution-property-spec-and-build.md), [2026-07-19 session-URL-persistence thread](/meta/threads/2026-07-19-session-url-persistence-and-plan-vs-capture-policy.md), [2026-07-20 evals and observation-records thread](/meta/threads/2026-07-20-evals-harness-ledger-and-observation-records.md), [2026-07-23 dev-history-drift thread](/meta/threads/2026-07-23-dev-history-drift-and-regeneration-flow.md)

*See also:* [attribution](/beliefs/glossary/attribution.md)

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:ea7acc">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-13-resource-attribution-property-spec-and-build (2026-07-13)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:ea7acc`]**  (co-feeds: `/meta/plans/resource-attribution-property.md`)

Spec written, filed, and pushed. The plan is at [`meta/plans/resource-attribution-property.md`](meta/plans/resource-attribution-property.md) (`status: proposed`, awaiting your ratification since it changes the frontmatter schema), indexed in `meta/plans/index.md`, all gates green, pushed to `claude/resource-attribution-spec-l3hzjj`.

**The proposed shape** — one new frontmatter key on bundle concepts:


**Key design decisions in the spec:**

- **It's an immutable event record, not a log.** Written once at filing, never rewritten by update-in-place merges — so it can't drift and doesn't conflict with the retire-hand-kept-logs decision. Git stays the change *narrative*; attribution is the in-band summary of the one commit that renames, merges, and portable-bundle consumption make hard to reach.
- **Orthogonal to the existing fields**, resolving a real ambiguity: `provenance` has been informally carrying both "where the content came from" and "how it entered the brain" (compare the glossary files vs. the auto-intaken ones). The spec gives each field one job: `resource` = what asset, `provenance` = content origin, `attribution` = ingestion event, `timestamp` = last change.
- **The `why` finally lands on the concept.** Today the featuring rationale lives in a dated digest the concept never points back to; `/research` would write it into `attribution.why`, and `/intake` would reuse the operator's natural phrasing (the same text the dedup gold-harvest already collects).
- **Enforcement is phased**: verifier shape rules from day one, presence becomes mandatory only after a git-derived backfill (`mix brain.attribution --backfill`, delivered as a reviewable diff) so the rule is never aspirational. The `auto-intake` tag gets subsumed by `channel` and retired after a transition window.

**Four open questions are flagged for you** at the bottom of the plan: scope (all bundle concepts — my recommendation — vs. only `reference`/`source` captures), whether presence goes verifier-mandatory after backfill, whether `agent` names the pathway or the model, and whether to retire the `auto-intake` tag. No PR opened — say the word (or `/create-pull-request`) when you want one.

### 2026-07-23-dev-history-drift-and-regeneration-flow (2026-07-23)

2 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:ea7acc`]**  (co-feeds: `/meta/analysis/dev-history-staleness-and-ci-regeneration.md`)

Nothing stops it technically — a workflow triggered on `push` to main (or `pull_request`) can run `mix brain.dev_history`, diff it, and commit-and-push it automatically. That's a well-worn pattern (lockfile bots, `terraform fmt` bots, etc.).

The reason it isn't built that way here is a deliberate tradeoff baked into this repo's provenance model, not an oversight. Every other generated-but-committed doc (`CLAUDE.md`, `meta/registry.md`, `meta/code-map.md`, the lineage views) is kept fresh by **hard-failing** CI when a PR doesn't regenerate it — that forces the regeneration to happen *inside* the authoring session's own commit, so it still carries a `Claude-Session:` trailer and lands via the normal PR flow. The merge-strategy policy leans hard on that: every commit should trace back to a session. `meta/dev-history.md` was made lag-tolerant instead of hard-fail for a narrower reason — a PR's branch literally cannot contain its own merge commit, so perfect freshness is structurally impossible for the PR that ships it. That's a one-PR gap by necessity, not "nobody remembers."

A CI bot auto-committing to `main` would close the gap completely, but it introduces a new class of commit with no session and no PR behind it — something the contract's provenance model doesn't currently have a category for (the closest analogues it already tolerates are auto-generated merge commits and pre-trailer-era commits, both called out as known gaps).

Given virtually every PR into this repo is already Claude-session-authored via `/create-pull-request`, folding the regen into that skill's commit step gets the same practical result — dev-history caught up through the last merge, every time — without adding a bot-commit class the policy doesn't account for.

Which do you want: the CI auto-commit bot (fully automatic, but a new kind of unattributed commit), or fold it into `/create-pull-request` (keeps every commit session-traceable, self-heals every PR opened that way)?

---

**[`em:ea7acc`]**  (co-feeds: `/meta/analysis/dev-history-staleness-and-ci-regeneration.md em:81a3ae`)

It can be — technically nothing stops a workflow on `push: branches: [main]` (the trigger `pages.yml` already uses) from checking staleness after the merge lands, regenerating, and pushing a commit straight to `main`. That would shrink the lag from "one PR" down to "one bot commit." Two things make that a real departure from how this repo works, though, not just a style preference:

1. **It breaks the PR-only-landing convention.** Every other write to `main` here goes through a branch → PR → merge. A bot pushing directly to `main` after the fact is a commit that never went through review, was never on a branch, and doesn't fit anywhere in that flow — it's the exact pattern ("never commit to a default branch") the rest of the workflow is built to avoid.

2. **It has no session behind it.** The merge-strategy policy treats the commit graph as a provenance layer specifically *because* every commit traces to an agent session (the `Claude-Session:` trailer, the PR that carries it). A scheduled CI job isn't a session — there's no transcript, no trailer possible. The policy already carves out a few known trailer-less cases (pre-feature-era commits, the GitHub merge button's auto-generated merge commits, local-terminal sessions), but a bot auto-commit would be a genuinely new, uncatalogued category — adopting it would mean amending that policy, not just adding a workflow file.

There's also a smaller structural wrinkle worth knowing: even a "fires right on the merge, outside the PR" bot can't fully close the gap — a commit still can't contain a snapshot of history that includes itself (you'd need the commit's own hash before you could render it into the file). So the bot's own commit is always one generation behind too; it just shrinks the lag window from "until the next PR" to "until the bot's next run," it doesn't eliminate the self-referential lag entirely.

That's why folding it into `/create-pull-request` is the better fit here: it keeps the same "regenerate inside your own session's commit" discipline the other generated docs already use, just extends it to dev-history too. Want me to make that change now?
