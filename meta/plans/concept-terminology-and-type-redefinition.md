---
type: plan
title: "Concept terminology: the document/concept split (done) and the concept-type redefinition (open)"
description: Record of the operator-ratified adoption of "document" for the OKF unit, plus the follow-on investigation into the concept type itself — whose one-line definition, machine enforcement, and actual usage tell three different stories — ending in the open questions a future session must resolve.
status: proposed
provenance: "Claude Code session, 2026-07-13 — operator-driven terminology review; this conversation is the investigation"
tags: [meta, plan, terminology, types, vocabulary, glossary, verification]
timestamp: 2026-07-13
---

# Concept terminology: the document/concept split and the concept-type redefinition

## Status & provenance

**Proposed.** Part 1 (the unit rename) was ratified and executed in the
originating session (commit `fe5aa52`, branch
`claude/concept-definition-review-wmvtl2`); it is recorded here as settled
context. Part 2 (redefining the `concept` type) is **undecided** — this plan
exists so a fresh session can pick up the investigation's findings and put the
closing questions to the operator without re-deriving anything.

## Problem

The word **"concept"** was doing double duty in the bundle's governance
vocabulary:

1. **The unit sense** — the OKF spec calls the atomic unit of a bundle a
   *concept document*: any UTF-8 markdown file with YAML frontmatter and a
   body. This is a purely structural (format-level) definition; nothing in it
   guarantees concept-like content.
2. **The type sense** — `concept` is also one entry in the controlled `type`
   vocabulary: "a definition or mental model (established/accepted)."

The operator challenged sense 1 first ("this seems to be more of a format
indication than a document type"), then turned to sense 2. Part 1 resolved the
first collision; Part 2 found that the type itself is incoherent in a parallel
way and stopped at questions requiring operator ratification.

## Part 1 — decided and executed: "document" for the unit

**Decision (operator-ratified):** the bundle-local word for the unit is
**document**; bare **`concept`** refers strictly to `type: concept`. The OKF
spec's own term ("concept document") is acknowledged in a terminology clause
rather than adopted.

**Evidence that forced the issue** (kept because it motivates Part 2 as well):

- The anatomy policy's definition of the unit was pure syntax (frontmatter +
  body + path-derived ID). The semantic aspiration the word "concept" implies
  (one coherent idea per file) is actually carried by *other* policies
  (distill-don't-dump, update-in-place), not by the anatomy definition.
- Real collision: the routing-ledger policy said "Routed-to targets are
  `concept` docs" (backticked, reading as the type), while an actual thread
  ledger routed to `meta/policy/session-capture.md` — a `type: policy` doc.
  Either reading made the policy wrong or misleading.
- The verifier resolved the ambiguity in favor of neither reading:
  `SecondBrain.RouteTags.ledger_doc_sinks/3` cross-checks only routed targets
  that resolve to a **registry entry** (a bundle document carrying an `sb:`
  id); `meta/` is excluded from the registry entirely, so governance targets
  silently drop out of the check.

**What shipped** (commit `fe5aa52`): `meta/policy/concept-anatomy.md` renamed
to `document-anatomy.md` with an explicit terminology clause; unit-sense
"concept" swept to "document" across thirteen policies (type-sense uses
untouched); the routing-ledger policy fixed to match the verifier ("routed-to
targets are documents — bundle or governance, of any `type`; the cross-check
covers only bundle documents"); glossary term `concept (OKF)` retitled to
`document (OKF)` (file renamed, stable id `sb:317879` unchanged);
`CLAUDE.md` and `meta/registry.md` regenerated; all gates green.

**Deferred from Part 1:** the Elixir code's internal vocabulary still says
"concept" (`SecondBrain.RouteTags` / `SecondBrain.Registry` docstrings, check
messages, and identifiers like `bundle_concepts`, plus `mix brain.registry`'s
output line). A mechanical rename touching tests — do it in one sweep, ideally
alongside whatever Part 2 decides so the code vocabulary only moves once.

## Part 2 — findings: how the `concept` type is actually defined

The type is defined in four places that do not agree.

### 1. The formal definition is one line

`meta/policy/controlled-type-vocabulary.md`:

> `concept` — a definition or mental model (established/accepted).

That is the entire positive definition; the epistemic status is a parenthetical.

### 2. The rest is definition-by-contrast, scattered across the vocabulary

- `claim` — "asserted but not independently verified … **may graduate to
  `concept` once confirmed**". So `concept` is implicitly the terminal state of
  a verification ladder.
- `methodology` — "distinct from … a `concept`, which defines a mental model".
- `elaboration` — "distinct from a glossary `concept` (one *term*,
  source-independent)".
- `meta/policy/verification-grounding.md` restates the graduation rule: a
  claim grounded via `verified_by` "may graduate to `concept`".

### 3. Machine enforcement is much weaker than the prose

In `SecondBrain.Verifier`, `concept` appears only as one of
`@statement_types ~w(claim note concept)`:

- a `verified` field (either value) is legal only on those three types;
- `verified: true` requires a non-empty `verified_by` and no `resource`.

The verifier makes **no distinction between `claim`, `note`, and `concept`**.
"Established/accepted" has no mechanical meaning; the only enforceable
difference between a `claim` and a `concept` is which word is in the
frontmatter.

### 4. Usage tells a third story

Census at time of writing: **155** live `type: concept` documents.

- **149** are glossary term entries under `/beliefs/glossary/` plus the
  glossary hub (`/beliefs/glossary.md`, `sb:0b648f`) — mass-produced by
  `/add-to-glossary`, nearly all `verified: false` (explicitly *unchecked*
  agent-distilled definitions).
- **4** are topical knowledge docs, and they split revealingly:
  - `knowledge/machine-learning/deep-learning/deep-belief-networks.md`,
    `knowledge/SWE/version-control/git/git-worktrees-for-parallel-agents.md`,
    `knowledge/SWE/agentic-coding/context-engineering/routing-non-linear-work-sessions.md`
    — genuine "mental model" docs, all `verified: false`.
  - `knowledge/SWE/version-control/git/git-local-branches-dont-auto-advance-on-fetch.md`
    — `verified: true`, `verified_by: [sb:a3d27b, sb:f08c54]`. Its title is a
    **proposition** ("local branches don't auto-advance on fetch"), not a
    definition: it is a graduated claim wearing the `concept` type.

### The synthesis

`type: concept` is **two different things sharing a name, with an epistemic
promise neither keeps**:

- **Sense A — term definition** ("what does X mean"): the glossary machinery's
  output; source-independent, one per term; dominant in the corpus (98%);
  almost never verified.
- **Sense B — accepted proposition** ("X is true, with evidence"): the
  graduation target for a verified `claim`; rare (one instance); shaped like a
  claim, not like a definition.

These are different speech acts. A definition is not the kind of thing that
graduates from a claim (it asserts a meaning, not a fact); a verified
proposition is not a definition of anything. Meanwhile the parenthetical
"(established/accepted)" is contradicted by the dominant usage and checked by
nothing.

This is the same defect pattern Part 1 fixed one level down: a word doing
double duty, and a written definition claiming a property that neither the
verifier nor the corpus backs.

## Open questions (the point of this plan)

These require operator ratification — type-vocabulary changes are shape
changes. A session executing this plan should put them to the operator **in
the chat, not the dialog box** (per the session-capture policy), with this
plan's findings as context:

1. **Should glossary entries get their own type** (e.g. `term`), or should
   `concept` *narrow* to mean strictly "term definition / mental model"?
   Either way the 149-entry glossary corpus is the bulk of the migration;
   `/add-to-glossary` and its SKILL.md, the glossary hub, and the
   `elaboration` type's contrast clause all encode the current coupling.
2. **What happens to claim→concept graduation?** Options: (a) drop it —
   graduated claims stay `claim` with `verified: true` carrying the epistemic
   weight, and `concept` sheds Sense B entirely (the one existing graduated
   doc, `git-local-branches-dont-auto-advance-on-fetch.md`, would revert to
   `claim`); or (b) keep it — then define what a proposition-shaped `concept`
   *is* and how it differs from a verified `claim`, which today is nothing.
3. **Should "(established/accepted)" be dropped or made enforceable?** If
   dropped, the definition honestly describes unverified definitions. If kept,
   what is the oracle — `verified: true`? Operator ratification? Something
   else? Today it is checked by nothing and false for 98% of the corpus.
4. **(Housekeeping, rides along with whatever is decided)** — sweep the
   code-side vocabulary deferred from Part 1 (`bundle_concepts`, "concept
   sink", verifier/registry messages) so code, policy, and corpus vocabulary
   move together, in one commit with the type migration if there is one.

## Scope boundaries

- Part 1 is **done**; do not reopen the unit-sense rename.
- Frozen thread docs under `meta/threads/` keep their original wording in all
  cases — the freeze rule outranks terminology consistency.
- Any new type or type rename must go through the controlled-vocabulary
  ratification protocol and, if adopted, a registry/verifier-safe migration
  (ids never change; `type` edits are frontmatter-only).
