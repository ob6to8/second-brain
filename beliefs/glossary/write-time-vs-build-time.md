---
id: em:964c3a
type: concept
title: write-time vs build-time
description: This brain's placement rule for LLM-generated content in a deterministic pipeline — produce it at write-time (the authoring agent commits it as reviewable source) and never at build-time (inside a derivation step, where non-determinism breaks byte-compare checks, demands CI secrets, and destroys reproducibility).
provenance: "Agent-distilled glossary definition, 2026-07-16 session"
verified: false
sense: repo
tags: [glossary, llm-placement, generated-artifact, determinism, terminology]
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T00:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term coined by the derived-index-listings session as the decision rule for where LLM calls belong in the brain's tooling"
---

# write-time vs build-time

This brain's decision rule for where an LLM call may sit in an otherwise
deterministic pipeline. **Write-time** is the authoring edge: an agent session
creates or revises an artifact and commits the LLM-produced content (e.g. a
`summary` frontmatter field) as ordinary reviewable source — the analog of
compile-time inputs. **Build-time** is inside a derivation step (`Site.build`, a
`mix brain.*` generator): a live LLM call there breaks the repo's compile-and-check
idiom three ways — `--check` gates re-derive and byte-compare, which a
non-deterministic step can never pass; CI and the Pages deploy would need API
secrets and per-build spend; and generated artifacts would stop being reproducible
from a commit. The rule, coined in the
[derived-index-listings plan](/meta/plans/derived-index-listings.md): **agents
write, compilers derive, checkers compare** — LLM output enters the system only as
committed source, and the derivation pipeline stays a
[pure function](/beliefs/glossary/pure-function.md) of the repo. On-demand tooling
(a `mix brain.summarize` that generates → operator reviews → commits) is still
write-time architecturally.

*Seen in:* [2026-07-16 derived-index-listings-plan thread](/meta/threads/2026-07-16-derived-index-listings-plan.md)

*See also:* [pure function](/beliefs/glossary/pure-function.md), [materialize](/beliefs/glossary/materialize.md), [compiled contract](/beliefs/glossary/compiled-contract.md)
