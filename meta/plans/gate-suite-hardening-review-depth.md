---
type: plan
title: "Gate-suite hardening — review depth and pre-deploy verification"
description: A proposed change to add substance-level checks the deterministic gate suite structurally cannot provide — an independent second-model/Copilot changelist review, a pre-deploy link-crawl of the built site (the "click through the artifact" analog), and optional banned-word and cyclomatic-complexity scans (the "dictionary check against the binary" analog) — imported from the two-tier reference workflow while keeping the single-trunk, offline-toolchain model; motivation, per-item design, the offline-CI tension, scope boundaries, and a build order.
status: proposed
provenance: "Claude Code session (2026-07-22) — recommendations from the version-control workflow audit, gathered into a design/decision record for operator ratification"
tags: [meta, plan, git, ci, gates, code-review, deployment, banned-words, complexity]
timestamp: 2026-07-22
attribution:
  when: 2026-07-22T00:00:00Z
  channel: agent-authored
  agent: "Claude Code agent, version-control-audit session"
  why: "the audit's review-depth and pre-deploy recommendations are proposed changes that need design and operator ratification before executing — persisted as a plan rather than executed in-session"
---

# Plan — gate-suite hardening: review depth and pre-deploy verification

**Status:** `proposed` — awaiting operator ratification. None of the items below are
built; this record captures the design so a later session (or the operator) can
decide and execute without re-deriving it.

**Motivation.** The [gate suite](/meta/tutorials/the-gate-suite-and-where-it-runs.md)
checks **form** — does it parse, does it match its re-derivation, do ids resolve. It
structurally cannot check **substance** — is a claim true, is a doc a good
distillation, does it contradict an existing one, is the prose LLM-slop, is a
function over-long. The
[version-control audit](/meta/analysis/version-control-workflow-vs-trunk-based-reference.md)
recommended importing a small set of the two-tier reference's practices to close
that gap, without importing its long-lived branches. This plan is those items.

## Item 1 — Independent second-model changelist review

**What.** A reviewer with no stake in the change reads the diff against the operating
contract and reports substance-level findings (file/line/severity): contract
violations, unsupported `verified: true`, distill-don't-dump violations, silent
contradictions with existing docs, banned phrasing, missing index updates.

**Two designs (pick one to start):**

- **(a) Agent-invoked, pre-PR — recommended start.** The machinery mostly exists
  (`/code-review`, `security-review`, the `ReportFindings` tool). Have
  [`/create-pull-request`](/.claude/skills/create-pull-request/SKILL.md) spawn an
  **independent** subagent (fresh context — not the authoring session grading its own
  work) over the working diff before opening the PR. No CI secret, no network — keeps
  the [offline-toolchain](/meta/tutorials/why-the-toolchain-runs-offline.md) property.
  Advisory by nature (relies on the flow running it).
- **(b) CI-hosted, on PR — enforced.** A GHA job posts a review on every PR, either
  via `request_copilot_review` (no key management) or a workflow calling a model API
  with the diff. The API path can *gate* a defined subset but **breaks the "every gate
  runs offline" invariant** (needs a secret + network) — a real tradeoff.

**Decision to make:** which design, and which findings gate vs. warn. The value is in
**independence**; that is non-negotiable whichever design is chosen.

## Item 2 — Pre-deploy link-crawl of the built site

**What.** `mix brain.site` proves the site *builds*; nothing crawls the *built
output*. `brain.verify` already *warns* on broken internal links but tolerates them
per OKF conformance. Add a crawl of the rendered site that follows internal links and
flags unreachable pages — the closest analog to the reference's "click through the
deployed artifact before it ships."

**Decision to make:** gate vs. warn, and where it runs (a new `mix brain.*` task in
the [Pages build job](/meta/tutorials/gating-the-pages-deploy-on-a-verified-bundle.md),
before publish). Gating changes the standing "broken links are tolerated" stance — a
deliberate policy shift, not a silent one.

## Item 3 — Banned-word and cyclomatic-complexity scans (optional)

**What.** A banned-LLM-slop-word scan over rendered site text (the "dictionary check
against the binary" analog), and Credo for cyclomatic complexity on `lib/`. Both are
cheap `mix`-level, offline gates that fit the existing model cleanly.

**Decision to make:** the banned-word list (and whether it scans source, rendered
output, or both); whether complexity is a gate or a warn given `lib/` is small.

## Out of scope (decided)

- **The reference's `dev`/`master` branches and batched daily releases.** The audit
  found these are the least trunk-based parts of the reference; a
  continuously-deployed single trunk should not import them.
- **DB migrations / full app runtime testing.** The bundle has no equivalent runtime
  surface; Item 2 (link-crawl) is the entire analog.

## Build order

1. **Item 1(a)** — independent pre-PR review subagent. Highest value, no CI/secret
   changes, exercises the "review depth" idea before committing to CI plumbing.
2. **Item 2** — pre-deploy link-crawl, as a warn first, promoted to a gate once the
   existing broken-link warnings are cleared.
3. **Item 3** — banned-word + complexity scans, if still wanted after 1–2.
4. **Item 1(b)** — CI-hosted/enforced review, only if the pre-PR pass proves it
   worth the offline-invariant tradeoff.

Independent of this plan and already tracked: auto-wiring the pre-commit hook
([todo](/meta/todos/wire-pre-commit-hook-in-session-start.md)) and generated-artifact
merge handling ([issue](/meta/issues/generated-artifact-merge-conflicts.md)).
