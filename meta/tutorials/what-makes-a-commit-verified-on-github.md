---
type: tutorial
title: What makes a commit show as "Verified" on GitHub — author, committer, and signatures
description: A commit carries two identities (author and committer), and GitHub's "Verified" badge is fundamentally about a cryptographic signature, not an email address. This note untangles the two, explains why re-authoring an agent commit to noreply@anthropic.com is what lets this environment's signature attach, and why only unpushed commits may be rewritten.
tags: [meta, git, github, commits, signing, verified, provenance, workflow]
timestamp: 2026-07-09
attribution:
  when: 2026-07-09T07:16:05+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
---

# What makes a commit show as "Verified" on GitHub

This note exists because of a small inaccuracy worth correcting. When a stop-hook
flagged some commits on a branch as *Unverified*, the fix was to run
`git config user.email noreply@anthropic.com` and then
`git commit --amend --no-edit --reset-author` on the tip, after which the reply
was: *"the tip commit now has both author and committer set to
noreply@anthropic.com, so GitHub will show it as verified."*

That sentence is a useful shorthand but it is **not literally how it works**.
GitHub's "Verified" badge is about a **cryptographic signature**, not about an
email string. The email mattered here for a more specific reason. Untangling the
two is the point of this note.

## Every commit carries two identities

A git commit records **two** name/email/timestamp triples, not one:

- **Author** — who *wrote* the change. Set from `user.name` / `user.email` (or
  `GIT_AUTHOR_*`) at the time the change was first committed.
- **Committer** — who *created this commit object*. Usually the same person, but
  they diverge whenever a commit is *re-made*: a rebase, an amend, a cherry-pick,
  a squash-merge, or a commit made on your behalf by a platform.

`git log --format='%an <%ae>  |  %cn <%ce>'` prints both. They drift apart more
often than people expect:

- **Rebase / amend** — you become the *committer* of commits you may not have
  *authored*; the author is preserved, the committer is you-now.
- **GitHub merge button** — GitHub creates the merge commit, so its committer is
  `GitHub <noreply@github.com>` (a "web-flow" commit), not you.
- **An agent** — a commit made by tooling records whatever identity that tooling
  configured.

`--reset-author` on an amend is the knob that rewrites the **author** to the
current `user.*` (the committer is always rewritten by an amend anyway), so after
it *both* identities read the configured address.

## What "Verified" actually means

The green **Verified** badge on GitHub means exactly one thing: the commit is
**cryptographically signed**, and GitHub could validate that signature against a
public key (GPG, SSH, or S/MIME) that it associates with an account. Signing puts
a signature block in the commit object over its content; GitHub checks it and,
crucially, checks that the signature's identity **matches the commit's committer
email**.

So an email address alone **never** produces a Verified badge — an unsigned
commit is "Unverified" no matter what email it carries. But the committer email
is not irrelevant either: a signature only verifies if it is **bound to that
committer identity**. Email and signature are two halves of one check.

This is why the honest version of the shorthand is: *setting the committer
identity is a necessary condition, and the signature is the sufficient one.*

## Why the email fix was what this environment needed

In this setup, agent commits are signed/attributed **on behalf of the Anthropic
bot identity**, keyed on the committer email `noreply@anthropic.com`. The
signature is attached for commits made under that identity; a commit committed
under some other address falls outside that path and lands on GitHub as
Unverified. The stop-hook encodes exactly this as a **local proxy check** —
"missing signature, *or* committer email is not `noreply@anthropic.com`" — so you
catch a mis-attributed commit *before* pushing, rather than discovering the grey
"Unverified" label after the fact.

That is the whole reason `git config user.email noreply@anthropic.com` +
`--reset-author` worked: it moved the commit onto the identity the signing path
keys on, so the verification attaches. The email did not *become* the
verification; it *enabled* it.

(The `GitHub <noreply@github.com>` merge commits the same hook listed are a
separate case: those are GitHub's own web-flow commits, signed by **GitHub's**
key and shown as Verified *on GitHub* — the local hook flags them only because
they aren't the Anthropic identity it wants. That mismatch is also exactly why
they are left alone: see the next section.)

## The mechanics — and the one rule that constrains them

Fixing attribution is commit-rewriting, and commit-rewriting has one hard rule.

```bash
git config user.email noreply@anthropic.com
git config user.name  Claude

# the tip commit only:
git commit --amend --no-edit --reset-author

# earlier commits on the branch (rewrites history from there forward):
git rebase --exec "git commit --amend --no-edit --reset-author" origin/<branch>
```

**The rule: only ever rewrite commits you have not pushed to shared history.**
An amend or rebase produces *new commit objects with new hashes*; every commit
after the rewrite point is replaced. Doing that to commits others have already
based work on (anything merged into `main`, anything on a shared branch) forces a
divergent history and a force-push that can clobber their work.

That is why, when the hook listed both an unpushed tip *and* some already-merged
`noreply@github.com` merge commits, only the **tip** was re-authored: it was the
one unpushed, still-private commit. The merge commits were already on `main`'s
shared history — rewriting them would be worse than a grey badge. A cosmetic
verification status never justifies rewriting published history.

## In one sentence

GitHub's "Verified" is a signature check bound to the commit's committer
identity, so re-authoring an agent commit to `noreply@anthropic.com` doesn't
*make* it verified — it puts it on the identity this environment signs for, which
is only ever safe to do while the commit is still unpushed.
