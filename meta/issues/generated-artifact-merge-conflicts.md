---
type: issue
title: "Generated/shared artifacts are recurring merge-conflict magnets across parallel sessions"
description: Worktree isolation prevents working-tree collisions but not merge-level ones — parallel sessions that each regenerate the same generated artifact (CLAUDE.md, registry.md, code-map.md, derived index.md files) 3-way-conflict at merge time, as seen in PRs #97/#98; the fix is to rebuild these files on merge rather than merge them line-by-line, and to lane sessions by domain where they are independent.
status: open
provenance: "Claude Code session (2026-07-22) — surfaced by the version-control workflow audit"
tags: [meta, issue, git, merge, generated-artifacts, ci, parallel-sessions]
timestamp: 2026-07-22
attribution:
  when: 2026-07-22T00:00:00Z
  channel: agent-authored
  agent: "Claude Code agent, version-control-audit session"
  why: "the audit identified a recurring merge-conflict class worth tracking as a problem, distinct from the recommended fix"
---

# Generated/shared artifacts are recurring merge-conflict magnets

## Summary

Sessions run in isolated worktrees, which prevents *working-tree* collisions but
not *merge-level* ones. When two sessions each touch a **generated or shared
artifact**, the second PR to merge conflicts. The prime magnets are the files
every session tends to regenerate:

- `CLAUDE.md` (compiled from `meta/policy/*.md`)
- [`meta/registry.md`](/meta/registry.md) (compiled from on-disk ids)
- `meta/code-map.md` (compiled from `lib/` docstrings)
- derived `index.md` listings

This is not hypothetical: PRs **#97** (`pr-64-merge-conflicts`) and **#98**
(`pr-70-merge-conflicts`) exist specifically to resolve this class. It maps
directly to the "give each AI its own lane / merge-conflict hell" advice weighed in
the [version-control audit](/meta/analysis/version-control-workflow-vs-trunk-based-reference.md).

## Why it happens

These files are **re-derivations**, not hand-authored source. Two sessions that both
run `mix brain.registry` produce two *correct* but textually different registries
against a moving id set; git has no way to know the right resolution is "re-derive
from the merged inputs," so it reports a line conflict. Merging them by hand is
busywork and error-prone — the freshness `--check` gates will reject a hand-merge
that does not match the true re-derivation anyway.

## Candidate fixes (a plan should pick among these before implementation)

1. **Rebuild-on-merge.** A `.gitattributes` merge driver for the generated files
   that runs the generator and takes its output, instead of 3-way-merging text. The
   merge just re-derives the artifact from the merged inputs.
2. **Regenerate-in-CI postsubmit.** Let the conflict resolve to either side, then a
   post-merge job runs the generators and commits the corrected artifacts. Simpler to
   wire; costs an extra trunk commit per conflicting merge.
3. **Lane by domain.** Where sessions are genuinely independent, scope them so they
   do not touch the same source inputs — the "own lane" advice. Reduces frequency but
   does not eliminate the class (any two sessions that add ids both move the registry).

Options 1 and 2 are the structural fixes; 3 is complementary. Design and build order
belong in the
[gate-suite hardening plan](/meta/plans/gate-suite-hardening-review-depth.md) or a
dedicated plan when this is picked up.

## Resolution condition

`status: resolved` once conflicts on the generated artifacts no longer require a
hand-merge — a merge driver or a post-merge regeneration step is in place and pinned
by a test or a demonstrated conflicting-merge that resolves cleanly.
