---
id: em:81a3ae
type: concept
title: self-referential lag
description: The structural ceiling on any generated artifact that snapshots history up to and including its own commit — a commit's content (and thus its own hash) has to exist before it can be committed, so no commit can render a history that already includes itself; only the size of the resulting lag is a design choice, not whether it exists.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, generated-artifact, git, ci]
sense: repo
timestamp: 2026-07-23
attribution:
  when: 2026-07-23T20:37:15Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term coined in the 2026-07-23 dev-history-drift thread while evaluating why a CI-bot auto-commit couldn't fully close the dev-history staleness gap"
---

# self-referential lag

Any [generated artifact](/beliefs/glossary/generated-artifact.md) that renders a
snapshot of history "up to now" hits the same wall the moment "now" is defined as
including the commit doing the rendering: the commit's own hash is a function of
its content, so that content cannot already describe a commit that does not yet
exist. The lag this forces is unavoidable — what varies is only *how much* of it a
design tolerates and *who* closes the remaining gap.

`meta/dev-history.md`'s [lag-tolerant check](/beliefs/glossary/lag-tolerant-check.md)
accepts exactly one PR of this lag, because a PR's branch structurally cannot
contain its own merge commit. Moving the regeneration to a CI bot firing on the
merge itself, outside any PR, shrinks the lag (from "until the next PR" to "until
the bot's own follow-up commit") but does not eliminate it — the bot's commit is
subject to the same constraint. The ceiling is a property of the recursion, not of
where in the pipeline the regeneration happens.

*Seen in:* [2026-07-23 dev-history-drift thread](/meta/threads/2026-07-23-dev-history-drift-and-regeneration-flow.md), [dev-history staleness analysis](/meta/analysis/dev-history-staleness-and-ci-regeneration.md)

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:81a3ae">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-23-dev-history-drift-and-regeneration-flow (2026-07-23)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:81a3ae`]**  (co-feeds: `/meta/analysis/dev-history-staleness-and-ci-regeneration.md em:ea7acc`)

It can be — technically nothing stops a workflow on `push: branches: [main]` (the trigger `pages.yml` already uses) from checking staleness after the merge lands, regenerating, and pushing a commit straight to `main`. That would shrink the lag from "one PR" down to "one bot commit." Two things make that a real departure from how this repo works, though, not just a style preference:

1. **It breaks the PR-only-landing convention.** Every other write to `main` here goes through a branch → PR → merge. A bot pushing directly to `main` after the fact is a commit that never went through review, was never on a branch, and doesn't fit anywhere in that flow — it's the exact pattern ("never commit to a default branch") the rest of the workflow is built to avoid.

2. **It has no session behind it.** The merge-strategy policy treats the commit graph as a provenance layer specifically *because* every commit traces to an agent session (the `Claude-Session:` trailer, the PR that carries it). A scheduled CI job isn't a session — there's no transcript, no trailer possible. The policy already carves out a few known trailer-less cases (pre-feature-era commits, the GitHub merge button's auto-generated merge commits, local-terminal sessions), but a bot auto-commit would be a genuinely new, uncatalogued category — adopting it would mean amending that policy, not just adding a workflow file.

There's also a smaller structural wrinkle worth knowing: even a "fires right on the merge, outside the PR" bot can't fully close the gap — a commit still can't contain a snapshot of history that includes itself (you'd need the commit's own hash before you could render it into the file). So the bot's own commit is always one generation behind too; it just shrinks the lag window from "until the next PR" to "until the bot's next run," it doesn't eliminate the self-referential lag entirely.

That's why folding it into `/create-pull-request` is the better fit here: it keeps the same "regenerate inside your own session's commit" discipline the other generated docs already use, just extends it to dev-history too. Want me to make that change now?
