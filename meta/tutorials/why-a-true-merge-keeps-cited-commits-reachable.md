---
type: tutorial
title: Why a true merge (not a squash) keeps cited commits reachable
description: Deleting a branch deletes a ref, not commits — commits live or die by reachability. A squash-merge lands a brand-new commit and abandons the originals, so any document that cites them by SHA ends up pointing at garbage; a true merge wires the branch's history into main's ancestry, making the cited SHAs permanent and the branch safe to delete.
tags: [meta, git, merge, squash, reachability, history, provenance, workflow]
timestamp: 2026-07-10
attribution:
  when: 2026-07-10T23:11:22+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
  from: [/meta/threads/2026-07-10-merge-commit-reachability-tutorial.md]
---

# Why a true merge (not a squash) keeps cited commits reachable

This note exists because of one sentence from a working session, delivered when
a ported feature had just landed and the question was whether its branch could
be cleaned up:

> I used a true merge rather than a squash on purpose: PLAN.md cites the port
> commits (`0fdee9e..e6ae1f9`) as the reference for re-adoption, and the merge
> commit keeps them permanently reachable from main even after the branch is
> deleted. So the branch is now safe to delete whenever you like.

Packed into that sentence is the single most useful mental model in git —
**reachability** — and a merge-strategy rule that follows directly from it:
*the moment a document cites commits by SHA, how you merge stops being a
matter of taste.* Unpacking that is the point of this note.

## Commits live or die by reachability

Git's object store is content-addressed and append-only in spirit, but it is
**garbage-collected** in practice. What protects a commit from collection is
not that it was ever important — it's that it is **reachable**: you can start
at some *ref* (a branch, a tag, `HEAD`) and walk parent pointers back to it.

That gives you the two facts everything else in this note rests on:

- **A branch is just a ref** — a 41-byte file containing a SHA, a movable
  entry point into the commit graph. **Deleting a branch deletes the pointer,
  never the commits.** The commits it pointed at are only *at risk* if that
  branch was the last ref from which they could be reached.
- **Ancestry is permanent.** Once a commit is an ancestor of `main`'s tip, it
  is reachable for as long as `main` exists. Nothing you do to branches later
  can un-ancestor it.

So "is this branch safe to delete?" always reduces to one question: *is
everything on it reachable from somewhere else?* The answer is decided
entirely by how the branch was merged.

## What each merge style does to the branch's commits

GitHub's merge button offers three strategies, and they differ exactly here:

- **True merge** ("Create a merge commit") — creates a commit with **two
  parents**: `main`'s old tip and the **branch's actual tip**. That second
  parent is the whole story: through it, every commit on the branch becomes an
  ancestor of `main`. The branch ref is now redundant — one of two paths to
  the same history — and deleting it orphans nothing.
- **Squash merge** — replays the branch's *net diff* as **one brand-new
  commit** with a new SHA and a **single parent** on `main`. The original
  commits are not in `main`'s ancestry at all; the branch ref is the only
  thing keeping them alive. Delete it, and they are unreachable.
- **Rebase merge** — recreates each branch commit on top of `main`, again
  with **new SHAs** (new parent, new committer — the hash covers both). The
  *shape* of the history survives, but every SHA anyone wrote down refers to
  the abandoned originals, not the copies that landed.

The dot-dot range in the quote — `0fdee9e..e6ae1f9` — is git's own notation
for "the commits reachable from `e6ae1f9` but not from `0fdee9e`", i.e. the
port work itself. After a true merge, `git log 0fdee9e..e6ae1f9` answers
correctly in any clone of `main`, forever. After a squash-and-delete, both
endpoints of that range are unknown objects and the citation is dead.

## "But GitHub still shows the commit" — for a while

Unreachable does not mean instantly gone, which is what makes this failure
mode sneaky. Locally, an orphaned commit survives until reflogs expire and
`git gc` prunes it (~90 days by default). On GitHub, a deleted branch's
commits linger server-side and the PR page keeps rendering them for a long
time.

None of that is a contract. A fresh `git clone` fetches **only reachable
objects** — the cited commits simply aren't in anyone's new clone. GitHub
eventually garbage-collects orphans too. A citation that works when you write
it and dangles when a future session needs it is worse than no citation: it
*looks* load-bearing while quietly rotting. In a brain whose whole premise is
that records outlive the session that produced them, that's the exact failure
the merge choice must prevent.

## The rule, and the exception that proves it

**If anything durable cites commits by SHA — a plan, a tutorial, an issue, a
provenance note — those SHAs must stay reachable from a permanent ref, which
means: true-merge the branch, then delete it freely.** The merge commit is
doing double duty: landing the change *and* acting as the anchor that makes
the citation permanent. In the quoted case, `PLAN.md` names the port commits
as the reference for re-adopting the feature later; the true merge is what
turns "safe to delete whenever you like" from optimism into a statement about
graph structure.

When nothing cites the individual commits, squash is a perfectly good
default — it keeps `main` linear and folds "fix typo" noise into one coherent
unit. The choice is not squash-bad/merge-good; it's that **SHA citations
convert history from disposable to load-bearing**, and the merge strategy has
to notice.

If you're stuck with a squash workflow (some repos enforce it) and still need
the originals, the escape hatch is the same reachability trick from another
angle: put a **tag** on the branch tip before deleting the branch. A tag is a
permanent ref too; reachability doesn't care which kind of ref anchors the
history.

## In one sentence

Deleting a branch deletes a pointer, not commits — so a true merge, whose
second parent wires the branch's real history into `main`'s ancestry, is what
lets you cite commits by SHA in a durable document *and* delete the branch,
while a squash makes those same SHAs garbage the moment the branch ref goes
away.
