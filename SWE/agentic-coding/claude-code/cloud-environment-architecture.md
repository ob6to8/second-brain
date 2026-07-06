---
id: sb:52aefa
type: note
title: Claude Code cloud (CCR) — environment and orchestration architecture
description: Claude Code's cloud runtime maps sessions to operator-defined environments backed by per-environment filesystem snapshots, so image-baked state (including the cloned repo) is frozen at snapshot time, containers are ephemeral, and sibling sessions interleave.
tags: [claude-code, cloud, containers, orchestration, dev-environments, agentic-coding]
provenance: "In-container forensics by Claude Code agents (composablebeliefs/composable-beliefs sessions, 2026-07-05), while diagnosing a local main ref 161 commits stale in a day-old session; distilled notes pasted by the operator, then grounded against the official docs"
verified: false
timestamp: 2026-07-06
---

# Claude Code cloud (CCR) — environment and orchestration architecture

Field notes on how Claude Code's cloud runtime is structured, gathered from
in-container forensics and then **grounded against the official docs**
([Use Claude Code on the web](https://code.claude.com/docs/en/claude-code-on-the-web)).
The note stays `verified: false` because it still carries session-specific
forensic anecdotes the docs can't confirm; the **documented backbone** is grounded
in the captured `source` excerpts under [`sources/`](/SWE/agentic-coding/claude-code/sources/index.md)
(see [Grounding](#grounding)).

Confidence per item: **[D]** documented in the official docs · **[E]** evidenced
by in-container forensics · **[I]** inference, unverified. A `→ sb:xxxxxx` tag
points to the captured primary-source excerpt that grounds the item.

## The unit model

- **[D → sb:863b32]** Users create an **environment** and it carries the
  **network-access level, environment variables, and the setup script** that runs
  before a session starts. Sessions run *inside* a VM provisioned from that
  environment. *Nuance surfaced by grounding:* the reference page frames the repo
  as **cloned per session** from the current branch's GitHub remote, whereas the
  "repos attach to the environment as sources" framing comes from the web-app /
  CCR tooling model (the onboarding step is literally "Connect GitHub and create
  an environment"). Both are consistent once caching is accounted for — see the
  [divergence](#divergence-fresh-clone-vs-baked-clone) below.
- **[D/E → sb:eb418b]** An orchestrator maps session → environment → container,
  and the cache key for provisioned state is the **environment, not the repo**:
  "the setup script runs the first time you start a session in an environment
  [...] Anthropic snapshots the filesystem and reuses that snapshot as the
  starting point for later sessions." Two environments attached to the same repo
  can therefore hand out different images.
- **[D/E → sb:eb418b]** Container images are **pre-baked and cached across
  sessions** (warm starts) — now documented, not merely forensic: "New sessions
  start with your dependencies, tools, and Docker images already on disk, and the
  setup script step is skipped." Original forensic proof: `.git/refs/heads/main`
  written 2026-06-30 inside an image handed to a 2026-07-04 session.
- **[I]** Grounding **resolved** part of what was unverified: the snapshot is
  **per-environment** (confirmed → sb:eb418b), and the **invalidation policy** is
  documented — the cache rebuilds when you change the setup script or allowed
  hosts, and on **~7-day expiry** (→ sb:eb418b). Still unstated in the docs:
  shared base layer vs. full per-environment snapshot, and whether warm pools
  exist ("capacity is provisioned on demand" hints against dedicated pools but is
  inconclusive). The `list_environments` MCP tool still needs an interactive
  approval that never reached the operator surface, so in-session environment
  enumeration remains impossible.

## Consequences that bite

- **[D/E → sb:eb418b]** Anything baked into the snapshot is **frozen at snapshot
  time**, not session time. Observed: the local `main` ref (created at image
  build, never advanced — [git fetch only moves remote-tracking refs](/SWE/version-control/git/git-local-branches-dont-auto-advance-on-fetch.md)).
  Rule: base work on `origin/<default>` after a fetch, never the bare local
  default branch. In-repo mitigation: a SessionStart hook that fetches and
  fast-forwards.
- **[E]** Bake-time state also rots in other layers: an apt PPA in the image
  changed its release metadata upstream and plain `apt-get update` then failed
  (fix: `--allow-releaseinfo-change`). *(Forensic only — not in the docs.)*
  Generalization: **any snapshot-baked cache** (refs, apt metadata, toolchains)
  can be stale or broken by the time a session sees it.
- **[D/E → sb:3420c8]** The container is **ephemeral** — "Cloud sessions stop
  after a period of inactivity and the underlying environment is reclaimed."
  Unpushed commits die with it, and the VM "clones from GitHub rather than your
  machine," so local-only work is invisible to it. A sibling session, finding a
  branch missing from origin, concluded the prior session's container was
  reclaimed before push and recreated the work.
- **[D/E → sb:3f35e1]** Two settings/hook layers with different owners:
  repo-tracked hooks (`.claude/settings.json`, part of the clone, fixable
  in-repo) and **non-repo layers injected by Anthropic**. Grounded: "user-level
  settings don't carry over to cloud sessions. In the cloud, hooks come from the
  repo and from your organization's server-managed settings." Forensics saw the
  non-repo layer as `/root/.claude/*`; either way it is **not reachable from any
  repo**, so defects there can only be flagged upstream.
- **[D/E → sb:564b8e]** Commit signing is effectively **deferred to push time**:
  "sensitive credentials such as git credentials or signing keys are never inside
  the sandbox." Forensics: the in-session signing key is empty (0-byte pub, no
  private key), so local commits show `%G? == N` until pushed; push preserves SHAs
  (remote tip identical to local after push).
- **[D/E]** Sessions run **concurrently** — "each `--cloud` command creates its
  own cloud session that runs independently [...] simultaneously in separate
  sessions." Forensic extension: two sessions on the *same repo* interleaved — one
  session's mid-flight push was observed, recovered, and merged by a sibling
  working the same task. Design implication: trust the remote/graph state over any
  in-container assumption; **re-fetch before reasoning about "what exists".**

## Divergence: fresh clone vs. baked clone

The docs say each session runs in "a fresh Anthropic-managed VM with your
repository cloned" and that "the VM clones from GitHub rather than your machine"
(→ sb:863b32, sb:3420c8) — reading as a *fresh clone per session*. Forensics found
the opposite: a **baked, stale** local `main` (written at image-build time, 161
commits behind in a day-old session). These reconcile through **environment
caching**: the snapshot captures the whole filesystem *including the cloned repo*
(→ sb:eb418b), so only the **first, cache-building** session gets a genuinely fresh
clone. Later **warm** sessions inherit the snapshot's clone as of snapshot time; a
`git fetch` then advances only remote-tracking refs, leaving local `main` pinned
at the baked commit. This is precisely why the fetch-and-fast-forward SessionStart
mitigation is needed.

## Grounding

Documented items above are grounded in these captured primary-source excerpts
(verbatim quotes carrying the official `resource` URL — trusted evidence, not
themselves verified statements), under
[`sources/`](/SWE/agentic-coding/claude-code/sources/index.md):

- `sb:863b32` — environments carry config; each session gets a fresh VM
- `sb:eb418b` — environment caching (per-environment filesystem snapshots; ~7-day expiry)
- `sb:3420c8` — environments reclaimed after inactivity
- `sb:564b8e` — credentials and signing keys never inside the sandbox
- `sb:3f35e1` — user-level settings don't carry to cloud; hooks come from repo and org

Primary source: <https://code.claude.com/docs/en/claude-code-on-the-web>
(Anthropic, "Use Claude Code on the web"; research preview).
