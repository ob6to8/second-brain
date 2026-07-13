---
type: tutorial
title: Why the brain's toolchain runs offline in CI and any sandbox
description: The mix brain.* tooling (including the GitHub Pages site generator) has zero external dependencies, so once an Elixir/OTP runtime exists it needs no network — which is what a restricted CI runner and a no-egress, snapshot-booted Claude Code sandbox both require.
tags: [meta, tooling, ci, sandbox, elixir, dependency-free, offline, github-actions]
timestamp: 2026-07-08
attribution:
  when: 2026-07-08T18:55:45+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
---

# Why the brain's toolchain runs offline in CI and any sandbox

A design note on a property every `mix brain.*` task shares — the contract
compiler, the registry, the verifier, and the GitHub Pages
[site generator](/knowledge/SWE/agentic/anthropic/claude-code/cloud-environment-architecture.md):
**the only thing a build needs from the outside world is an Elixir/OTP runtime.**
Once `mix` exists on the machine, nothing the tooling does reaches the network.
Cut the cable after `elixir` is installed and every task still succeeds. This note
records *why* that holds and *which specifics of CI and the sandbox make it matter*.

## The one decision that buys it

"Offline" is not automatic; it falls out of a single deliberate choice in
`mix.exs`:

```elixir
defp deps, do: []
```

Zero dependencies. There is deliberately no `mix.lock`, because a lockfile only
exists to pin *fetched* packages — with nothing to fetch, there is nothing to lock.
Everything the tooling needs is already in the box:

- **File & path work** → `File`, `Path` (Elixir stdlib)
- **Frontmatter / Markdown parsing / link rewriting** → `Regex`, `String`, `Enum`
- **JSON search index** → a hand-written serializer (no `Jason`/`Poison`)
- **Stable ids** → `:crypto`, a built-in OTP application (declared in
  `extra_applications`)

The operating contract states the same rationale for the contract compiler: it
*"parses the small YAML frontmatter subset the bundle uses with the standard
library only, so it runs offline in any sandbox with Elixir/OTP installed."* The
site generator extends that discipline rather than inventing a new one.

## The dependency chain a normal build has — and this one doesn't

A typical static-site or app build inserts one network-dependent step between a
clean machine and a working build:

| Toolchain | Install step | Network hit |
|-----------|-------------|-------------|
| Jekyll (GitHub's default) | `bundle install` | rubygems.org |
| MkDocs / Sphinx | `pip install` | PyPI |
| Docusaurus / Eleventy | `npm install` | npm registry |
| A typical Elixir/Phoenix app | `mix deps.get` | hex.pm |

Every one resolves a dependency tree and downloads packages *before* the build can
start. That download is the offline-breaker. This toolchain collapses the table to
one row with no network hit: **install Elixir → run the mix task.**

## The CI specifics that make this matter

GitHub Actions runners are fresh, ephemeral VMs — each job starts from a clean
image with nothing project-specific on it. A normal Elixir CI job therefore reads
`setup-beam → mix deps.get → mix test`. This repo's `ci.yml` and `pages.yml` have
**no `deps.get` step**: after `setup-beam` installs the runtime (the one network
step, and it belongs to the CI platform, not the build), every step — compile,
format check, tests, `brain.contract`, `brain.registry`, `brain.verify`,
`brain.site` — is pure local computation. Consequences:

- **No hex.pm dependency.** A registry outage or rate-limit cannot turn CI red.
- **No supply-chain surface.** Nothing is downloaded at build time, so no
  transitive package can change under you or ship a compromised version.
  Reproducibility is trivial: same source + same OTP ⇒ same output.
- **Speed & simplicity.** No resolution, no download, no dependency cache to warm
  or invalidate.
- **Restricted-egress runners just work.** A runner with locked-down outbound
  network needs no allowlist entries for this build.

## The sandbox specifics that make this matter more

This is the part specific to how the brain is operated. Claude Code cloud sessions
run in a sandbox whose **network-access level is chosen when the environment is
created** — and "no network" or a tight allowlist is a legitimate, common choice.
Containers are ephemeral and provisioned from a **filesystem snapshot**, and
user-level settings don't carry into the cloud (see
[Claude Code cloud environment architecture](/knowledge/SWE/agentic/anthropic/claude-code/cloud-environment-architecture.md)).
Chain those facts and the requirement follows:

1. **A fresh, sandboxed agent may have no outbound network at all.** If any
   `mix brain.*` task ran `mix deps.get`, that agent could not build, test, or
   even validate the bundle — dead on arrival in the very environment the repo is
   designed to be operated from.
2. **The `SessionStart` hook depends on this.** `.claude/hooks/session-start.sh`
   warms the build cache with `mix compile` *before the operator types anything*,
   so `mix brain.contract` and the test suite are ready the moment the session
   opens; that compile (and every `mix brain.*` task after it) must succeed
   without a network round-trip, from a cold snapshot, every time.
3. **Snapshots freeze state at bake time.** Because the container boots from a
   snapshot rather than a live install, anything not baked in isn't guaranteed to
   be fetchable later. Dependency-free sidesteps the whole "is the dep cache
   present / stale / reachable?" question — there is no dep cache.

## The tripwire — keeping the property from silently breaking

The guarantee is only as durable as the discipline about `deps`. Adding a single
hex package (say `Earmark` for Markdown or `Jason` for JSON) turns `deps: []` into
a real dependency list, materializes a `mix.lock`, and makes every build *require*
`mix deps.get`. The offline property would vanish quietly — surfacing only the next
time a no-network sandbox tried to run the startup hook. Two guards:

- **The build is a CI gate.** `ci.yml` runs `mix brain.site` (alongside the
  `--check` gates for the contract and registry); if the generator ever fails to
  build — including because a newly added dep can't be fetched on a restricted
  runner — CI goes red.
- **`deps: []` is a visible invariant.** Treat any change to it as a deliberate
  architectural decision, not a routine dependency bump: it trades away the offline
  property for whatever the library provides. For the site, the trade wasn't worth
  it — a focused Markdown converter covers exactly the constructs the bundle uses
  and keeps the whole toolchain runnable anywhere Elixir is.

## In one sentence

The build needs nothing but the language runtime, so the single network-dependent
step (`deps.get`) that normally sits between a clean machine and a working build
simply doesn't exist — which is exactly what a network-restricted CI runner and a
no-egress, snapshot-booted Claude Code sandbox both require.
