---
id: em:ca7b27
type: concept
title: descriptive premise
description: A truth-apt claim about what is the case — the brain, its material, or its world — that can be true or false and checked against evidence; it grounds a normative conclusion without entailing it.
provenance: "Agent-distilled glossary definition; term introduced by operator request during the 2026-07-22 fit-each-layer doctrine session"
verified: false
tags: [glossary, epistemics, normativity, governance]
sense: dual
timestamp: 2026-07-22
attribution:
  when: 2026-07-22T00:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the is-to-ought analysis authored in the 2026-07-22 qiju/thread-storage session"
---

# descriptive premise

A claim in the *is* register: it asserts how something actually is, so it is
truth-apt — true or false, and in principle checkable against evidence. It is the
counterpart of a [normative conclusion](/beliefs/glossary/normative-conclusion.md)
(a claim about what *ought* to be), and it *grounds* such a conclusion without
logically entailing it: a fact plus a system's purpose makes a direction
reasonable, but no fact alone forces a value.

**In this brain:** descriptive work lives in the epistemic types —
`claim`, `note`, [concept](/beliefs/glossary/concept-type.md) — and in the
`beliefs/` namespace,
where truth can be tracked via `verified`/`verified_by`. "Belief" is this
descriptive register, not a controlled `type` (a dedicated type would collide
with the existing epistemic ones). A belief is something the brain holds *true*; a
[doctrine](/beliefs/glossary/doctrine.md) is something it holds *to*.

*Seen in:* [is-to-ought analysis](/meta/analysis/is-to-ought-belief-grounds-doctrine.md), [future beliefs](/beliefs/future-beliefs.md)

*See also:* [normative conclusion](/beliefs/glossary/normative-conclusion.md), [doctrine](/beliefs/glossary/doctrine.md)

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:ca7b27">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-22-qiju-thread-storage-and-fit-each-layer-doctrine (2026-07-22)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:ca7b27`]**  (co-feeds: `em:6a9e78 em:0c343a`)

**Doctrine vs. belief**

The cleanest way to separate them is by **register** — what kind of statement each one *is*. A **belief** is descriptive (the *is* register): it answers "what is the case?", is truth-apt (true/false, verifiable), and if wrong it is *false* → corrected against evidence. A **doctrine** is normative (the *ought* register): it answers "what should guide design and priorities?", is a commitment (adhered-to, not verified), and if wrong it is *misguided* → the direction is re-decided. In the stack, belief *grounds* doctrine (the *is* that motivates the *ought*), and doctrine *sits above* policy (a policy implements it as an enforceable rule). "Belief" isn't a type while "doctrine" is — because the descriptive register is already covered by `claim`/`note`/`concept`; the normative-direction register had no type, and that gap is what `doctrine` fills. The bridge — each of your two bullets is shaped `descriptive premise → normative conclusion`, and that `→` is the is-to-ought step. Tidy statement of the contrast: **a belief is something the brain holds *true*; a doctrine is something the brain holds *to*.**
