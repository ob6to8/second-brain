---
id: em:f07159
type: concept
title: id-namespace migration
description: A one-time, operator-ratified, tail-preserving rewrite of the id-namespace prefix on every bundle concept — only the prefix changes, each id's immutable 6-hex tail is kept — done in one deterministic, verifier-atomic pass.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, identity, migration, registry, governance]
sense: repo
timestamp: 2026-07-16
attribution:
  when: 2026-07-14T00:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-14 second-brain to elixir-mind rename-execution thread"
---

# id-namespace migration

Its target is the prefix carried by every bundle concept's
[stable id](/beliefs/glossary/stable-id.md); because only the two-character prefix
changes (e.g. `sb:` → `em:`), the mapping is total, deterministic, and collision-free,
and every typed edge that references an id ([`verified_by`](/beliefs/glossary/verified-by.md),
route-tag refs, `attribution.from`) stays internally consistent under a single regex
pass. **Verifier-atomic** means the id-format checks reject any mixed-prefix state, so a
partial migration cannot merge green — the whole re-key lands in one PR or not at all.

**In this brain:** the [stable-identity policy](/meta/policy/stable-identity.md) treats
the prefix as an opaque namespace token — *not* part of a concept's identity — and
admits this migration as the **only** way it may change (never per-id). One instance
has occurred: the 2026-07 `sb:` → `em:` re-key that mirrored the repository rename
(second-brain → elixir-mind), rewriting ~1200 tokens across the corpus in one pass
while preserving every tail, so a historical `sb:`-prefixed token denotes exactly the
`em:` id sharing its tail. Distinct from [ratification](/beliefs/glossary/ratification.md)
(the operator approval that authorizes it) and a [branch transplant](/beliefs/glossary/branch-transplant.md)
(which moves content between branches, not identity across a namespace).

*Seen in:* [2026-07-14 rename-execution thread](/meta/threads/2026-07-14-execute-second-brain-to-elixir-mind-rename.md), [2026-07-13 elixir-mind rename-plan thread](/meta/threads/2026-07-13-elixir-mind-rename-plan-and-model-orchestration.md)
