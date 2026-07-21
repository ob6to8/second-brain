# Issues

Tracked operational problems, defects, and open concerns about how the brain or its
tooling and automation behave — recorded for future reference and follow-up. A
separate namespace from `policy` (the rules that compile into the contract) and
`tutorials` (the "why" explainers).

Each issue is a `type: issue` doc carrying a `status` (`open` · `resolved` ·
`wontfix`). Resolved issues stay filed as a record of what happened and how it was
fixed. Entries within each section are ordered by `timestamp`, most recent first
(see the [collection-view-by-date plan](/meta/plans/collection-view-by-date.md)).

## Open

- [Orphaned remote branches: 15 merged undeleted, 6 unmerged untriaged](/meta/issues/orphaned-remote-branches-cleanup.md) — merged-branch deletion **executed by the operator 2026-07-13** (zero merged `claude/*` remain); unmerged-branch dispositions audited into the [triage todo](/meta/todos/triage-the-six-kept-unmerged-claude-branches.md) (four small ports + one big transplant, two false orphans to ratify deleting); resolves once the auto-delete setting is confirmed on. `status: open`.
- [Daily /research Routine: automated runs not landing on `main`](/meta/issues/daily-news-routine-runs-not-landing.md) — the scheduled Routine's fresh-session runs produce no commit/push; an environment-wide tool-approval gate is the suspected cause. Workaround: run `/research` manually. `status: open`.

## Resolved

- [route_tags: materialize cannot remove orphaned excerpt blocks](/meta/issues/route-tags-materialize-leaves-orphan-blocks.md) — `materialize/1` now projects the tags in both directions, removing an unfed sink's log section unconditionally (hardening plan P1); pinned by two scenario tests. `status: resolved`.
