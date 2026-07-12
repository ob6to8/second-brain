---
id: sb:6a9e78
type: concept
title: doctrine
description: The governance layer of guiding principles and accepted tenets — the "why" that shapes judgment — as distinct from policy, the layer of specific enforceable rules.
provenance: "Agent-distilled glossary definition; term introduced by operator question (doctrine vs. policy), 2026-07-11 session"
verified: false
tags: [glossary, governance, terminology]
timestamp: 2026-07-11
---

# doctrine

The layer of guiding principles and accepted tenets in a governance system — the "why" that shapes judgment without prescribing specific action. Doctrine informs policy; a [policy](/beliefs/glossary/policy-type.md) implements doctrine as a concrete, enforceable rule. This brain's controlled vocabulary has no `doctrine` type: the closest analogue is the preamble and compiled [operating contract](/beliefs/glossary/operating-contract.md) read as a whole (its worldview — "the tree is the taxonomy", "distill, don't dump"), while each `type: policy` file is a single standing rule.

*Seen in:* [2026-07-11 doctrine-vs-policy thread](/meta/threads/2026-07-11-doctrine-vs-policy-and-glossary-cross-linking.md)

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="sb:6a9e78">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-11-doctrine-vs-policy-and-glossary-cross-linking (2026-07-11)

2 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`sb:6a9e78`]**  (co-feeds: `sb:fa15e7`)

**Are "doctrine" and "policy" both defined?**

**No — only "policy" is, and until this session it had no glossary entry either.**

- **Doctrine** appears *nowhere* in the repo — not in the glossary, not in the contract, not in any policy doc, thread, or concept. It isn't part of this brain's vocabulary at all. I did **not** add a glossary entry for it, because the glossary's own guardrail is to define terms that sources actually use — an entry for a term nothing cites would be an orphan. If you want to introduce "doctrine" as a real concept in the brain, that's a quick `/add-to-glossary` or `/intake` away once something actually uses it.
- **Policy** is canonically defined in the [controlled-type vocabulary](meta/policy/controlled-type-vocabulary.md): *"a governance rule for how the brain operates; the source from which `CLAUDE.md` is compiled."* But I found a gap: every other governance type (`plan`, `issue`, `methodology`, `tutorial`, `analysis`) had a glossary pointer entry, and `policy` didn't. I've added [`/glossary/policy-type.md`](glossary/policy-type.md) (`sb:fa15e7`) to fill it, cross-linked to its sibling types and cited to the bootstrap thread where the genre originated.

**The conceptual difference**

In ordinary governance usage, **doctrine** is the layer of *beliefs and principles* — the "why," a body of accepted tenets that guides judgment but doesn't prescribe specific action. **Policy** is the layer of *enforceable rules* — the "what you must do," specific and operational. Doctrine shapes policies; policies implement doctrine. In this brain's terms, the closest thing to "doctrine" is arguably the *preamble + the compiled operating contract as a whole* (the worldview: "the tree is the taxonomy," "distill, don't dump"), while each `type: policy` file is a concrete, enforceable rule — several of them literally machine-enforced by `mix brain.verify`.

---

**[`sb:6a9e78`]**

Done — [`doctrine`](glossary/doctrine.md) is committed and pushed (`5a57194`, `sb:6a9e78`, all verifiers and 78 tests green). It defines doctrine as the principles layer ("the why") versus policy's enforceable rules, cross-links to `policy-type` and `operating-contract`, and notes that this brain has no `doctrine` type — the closest analogue being the preamble plus compiled contract read as a whole. The glossary is now 71 terms.
