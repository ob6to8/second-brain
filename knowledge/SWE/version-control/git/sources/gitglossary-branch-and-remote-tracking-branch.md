---
id: sb:f08c54
type: source
title: gitglossary — branch head and remote-tracking branch
description: Verbatim official glossary definitions establishing that a branch head moves forward with development and a remote-tracking branch follows another repository without local modifications.
resource: https://git-scm.com/docs/gitglossary
provenance: "Verbatim excerpts extracted from the resource URL (gitglossary man page)"
tags: [git, branches, refs, remote-tracking, glossary]
timestamp: 2026-07-05
attribution:
  when: 2026-07-05T19:41:08+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
---

# gitglossary — branch head and remote-tracking branch

Verbatim definitions from the official `gitglossary` documentation.

> **branch** — A "branch" is a line of development. The most recent commit on a
> branch is referred to as the tip of that branch. The tip of the branch is
> referenced by a branch head, which moves forward as additional development is
> done on the branch.

> **head** — A named reference to the commit at the tip of a branch. Heads are
> stored in a file in `$GIT_DIR/refs/heads/` directory, except when using
> packed refs.

> **remote-tracking branch** — A ref that is used to follow changes from
> another repository. It typically looks like *refs/remotes/foo/bar*
> (indicating that it tracks a branch named *bar* in a remote named *foo*), and
> matches the right-hand-side of a configured fetch refspec. A remote-tracking
> branch should not contain direct modifications or have local commits made to
> it.

## What these establish

Local branch heads (`refs/heads/*`) and remote-tracking refs (`refs/remotes/*`)
are distinct ref classes: the former advance as development is done on them;
the latter exist solely to follow another repository and take no local
modifications.
