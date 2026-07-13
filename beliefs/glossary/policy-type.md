---
id: sb:fa15e7
type: concept
title: policy (type)
description: The controlled type for a standing governance rule about how the brain operates; the source documents under meta/policy/ from which CLAUDE.md is compiled.
provenance: "Agent-distilled glossary definition, pointer to the defining doc"
verified: false
tags: [glossary, types, governance]
sense: repo
timestamp: 2026-07-11
---

# policy (type)

The controlled `type` for a standing governance rule about how the brain operates — the layer that binds every agent session. Policy documents live under `meta/policy/` and are the source from which the [operating contract](/beliefs/glossary/operating-contract.md) (`CLAUDE.md`) is compiled (`mix brain.contract`). Distinct from a [plan](/beliefs/glossary/plan-type.md) (a one-off intended change), an [issue](/beliefs/glossary/issue-type.md) (a problem to track), and a [methodology](/beliefs/glossary/methodology-type.md) (a repeatable how-to): a policy is a durable *rule*, not a task or a procedure. Defined in the [controlled-type vocabulary](/meta/policy/controlled-type-vocabulary.md).

*Seen in:* [2026-07-05 bootstrap thread](/meta/threads/2026-07-05-greenfield-okf-bootstrap-and-verification-layer.md), [2026-07-11 doctrine-vs-policy thread](/meta/threads/2026-07-11-doctrine-vs-policy-and-glossary-cross-linking.md)

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="sb:fa15e7">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-11-doctrine-vs-policy-and-glossary-cross-linking (2026-07-11)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`sb:fa15e7`]**  (co-feeds: `sb:6a9e78`)

**Are "doctrine" and "policy" both defined?**

**No — only "policy" is, and until this session it had no glossary entry either.**

- **Doctrine** appears *nowhere* in the repo — not in the glossary, not in the contract, not in any policy doc, thread, or concept. It isn't part of this brain's vocabulary at all. I did **not** add a glossary entry for it, because the glossary's own guardrail is to define terms that sources actually use — an entry for a term nothing cites would be an orphan. If you want to introduce "doctrine" as a real concept in the brain, that's a quick `/add-to-glossary` or `/intake` away once something actually uses it.
- **Policy** is canonically defined in the [controlled-type vocabulary](meta/policy/controlled-type-vocabulary.md): *"a governance rule for how the brain operates; the source from which `CLAUDE.md` is compiled."* But I found a gap: every other governance type (`plan`, `issue`, `methodology`, `tutorial`, `analysis`) had a glossary pointer entry, and `policy` didn't. I've added [`/glossary/policy-type.md`](glossary/policy-type.md) (`sb:fa15e7`) to fill it, cross-linked to its sibling types and cited to the bootstrap thread where the genre originated.

**The conceptual difference**

In ordinary governance usage, **doctrine** is the layer of *beliefs and principles* — the "why," a body of accepted tenets that guides judgment but doesn't prescribe specific action. **Policy** is the layer of *enforceable rules* — the "what you must do," specific and operational. Doctrine shapes policies; policies implement doctrine. In this brain's terms, the closest thing to "doctrine" is arguably the *preamble + the compiled operating contract as a whole* (the worldview: "the tree is the taxonomy," "distill, don't dump"), while each `type: policy` file is a concrete, enforceable rule — several of them literally machine-enforced by `mix brain.verify`.
