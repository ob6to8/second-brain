---
type: policy
title: Merge strategy — history is provenance
description: Pull requests land on main via a true merge commit only; squash and rebase merges are disallowed because the commit graph is a provenance layer — commits carry session trailers and are cited by SHA in durable docs.
section: filing
order: 9
status: active
tags: [meta, governance, git, merge, provenance, history]
timestamp: 2026-07-18
attribution:
  when: 2026-07-11T17:58:27+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
---
**Merge with a true merge commit; never squash or rebase.** The commit graph is
a **provenance layer**, not an implementation detail: session-authored commits
carry the session trailer linking them to the agent session that produced them,
durable docs
(plans, thread docs, logs) cite commits by SHA, and `git blame` is the answer to
"which session changed this and why". A squash-merge lands a brand-new commit
and abandons the originals — severing commit → session traceability and turning
cited SHAs into garbage once the branch is deleted; a rebase-merge rewrites them.
A true merge wires the branch's real history into `main`'s ancestry, so the
cited SHAs stay reachable forever and the branch is safe to delete (see
[why a true merge keeps cited commits reachable](/meta/tutorials/why-a-true-merge-keeps-cited-commits-reachable.md)).

- Agents merging a PR (UI, MCP tools, or API) must use the **merge** method —
  never `squash` or `rebase`, even when they are enabled in repo settings.
- Never rewrite shared history; the usual noise argument for squashing does not
  apply here — agent commits are already atomic and deliberately messaged.
- For a one-line-per-PR reading of `main`, use `git log --first-parent` instead
  of flattening history at the merge boundary.

**The session trailer is harness-injected — protect the setting.** The
`Claude-Session: <url>` git trailer that links a commit to the cloud session
that produced it is added automatically by Claude Code (v2.1.179+) to commits
Claude authors in web sessions, and the PR body gets the session URL on its own
line — no agent action required. Since v2.1.182 the setting
`attribution.sessionUrl: false` disables both. One innocuous-looking line in a
committed settings file would therefore silently sever commit → session
traceability for every future session:

- **Never set `attribution.sessionUrl` to `false`** in any committed settings
  file (`.claude/settings.json` or similar). An agent that finds it set does not
  "clean it up" in either direction silently — it surfaces the finding and
  proposes removal to the operator.

**Known coverage gaps — the trailer is strong evidence, not an invariant.**
Three classes of commit legitimately lack the trailer: commits predating the
feature's arrival in this repo (before 2026-07-07); auto-generated merge
commits (`git merge` default messages, the GitHub merge button) — the harness
injects the trailer only into commit messages Claude authors; and commits from
local-terminal sessions, which are authored under the operator's local git
identity and have no cloud transcript URL. For all of these the **PR is the
fallback anchor**: the PR body carries the session URL, and the thread doc's
`pr:` stamp (see the session-capture policy) links the session record back to
how it landed. Do not treat a missing trailer as evidence a commit bypassed an
agent session.
