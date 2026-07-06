---
id: sb:a3d27b
type: source
title: Pro Git — remote-tracking branches and fetch
description: Verbatim passages from the Pro Git book establishing that fetch moves remote-tracking pointers and does not modify local branches or the working directory.
resource: https://git-scm.com/book/en/v2/Git-Branching-Remote-Branches
provenance: "Verbatim excerpts extracted from the resource URL (Pro Git, 2nd ed., §3.5)"
tags: [git, fetch, remote-tracking, branches]
timestamp: 2026-07-05
---

# Pro Git — remote-tracking branches and fetch

Verbatim excerpts from *Pro Git* (2nd edition), §3.5 "Git Branching — Remote
Branches", the official book hosted by the git project.

> Remote-tracking branches are references to the state of remote branches.
> They're local references that you can't move; Git moves them for you whenever
> you do any network communication, to make sure they accurately represent the
> state of the remote repository.

> To synchronize your work with a given remote, you run a `git fetch <remote>`
> command (in our case, `git fetch origin`). This command looks up which server
> "origin" is [...], fetches any data from it that you don't yet have, and
> updates your local database, moving your `origin/master` pointer to its new,
> more up-to-date position.

> It's important to note that when you do a fetch that brings down new
> remote-tracking branches, you don't automatically have local, editable copies
> of them. In other words, in this case, you don't have a new `serverfix`
> branch — you have only an `origin/serverfix` pointer that you can't modify.

> While the `git fetch` command will fetch all the changes on the server that
> you don't have yet, it will not modify your working directory at all. It will
> simply get the data for you and let you merge it yourself.

## What these establish

Fetch moves **remote-tracking** pointers (`origin/*`) only; it creates no local
branches and modifies nothing local — incorporating fetched work into a local
branch is a separate, explicit act (merge/pull).
