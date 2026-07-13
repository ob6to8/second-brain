---
type: reference
title: 2026-07-13-concept-terminology-document-unit-and-type-questions
description: A terminology review that split the overloaded word "concept" — Part 1 (executed) adopts "document" for the OKF unit and reserves bare "concept" for the type, fixing the routing-ledger collision; Part 2 (open) finds type:concept is two speech acts (term definition vs accepted proposition) under an "(established/accepted)" label no tooling checks, filed as a plan ending in operator-ratification questions.
provenance: "Claude Code session (Claude Fable 5, then Claude Opus 4.8 for capture), 2026-07-13; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, terminology, types, vocabulary, glossary, verification]
timestamp: 2026-07-13
# pr: added by /create-pull-request once the PR is opened
---

# 2026-07-13-concept-terminology-document-unit-and-type-questions

## Where this landed

The operator questioned whether the word **concept** was pulling its weight. It
was doing double duty: the OKF unit sense (any frontmatter-plus-body markdown
file — pure format) and the controlled `type: concept` (a definition or mental
model). Part 1 was ratified and executed: adopt **document** for the unit,
reserve bare **`concept`** for the type, and — following the verifier's actual
behavior — reword the routing-ledger policy so routed-to targets are "documents,
bundle or governance, of any type" with the tag cross-check scoped to
`sb:`-bearing bundle documents (commit `fe5aa52`, thirteen policies swept, the
anatomy policy and glossary entry renamed, artifacts regenerated).

The operator then turned to the `concept` type itself. The investigation found
it defined in four disagreeing places — a one-line vocabulary entry, scattered
contrast clauses, a verifier that treats `claim`/`note`/`concept` identically,
and a corpus that is 98% unverified glossary term definitions plus one verified
proposition-shaped graduated claim — i.e. two different speech acts sharing a
name under an "(established/accepted)" label nothing enforces. Because
redefining a type is a shape change, the session stopped at questions and
persisted everything as [`meta/plans/concept-terminology-and-type-redefinition.md`](/meta/plans/concept-terminology-and-type-redefinition.md)
(`status: proposed`, commit `cef9192`) so a fresh session can run it from
scratch and put the ratification questions to the operator.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| "document" for the OKF unit; reserve "concept" for the type | closed | [document-anatomy policy](/meta/policy/document-anatomy.md) | - |
| Routing-ledger wording matched to the verifier (targets of any type; cross-check scoped to `sb:` bundle docs) | closed | [routing-ledger policy](/meta/policy/routing-ledger.md) | - |
| How `type: concept` is defined — two speech acts under an unchecked label | closed | [concept-terminology plan](/meta/plans/concept-terminology-and-type-redefinition.md) | - |
| Redefining `type: concept` — open ratification questions | paused | [concept-terminology plan](/meta/plans/concept-terminology-and-type-redefinition.md) | Own type for glossary terms vs narrowing `concept`? Drop claim→concept graduation vs define what a proposition-`concept` is? Drop or make "(established/accepted)" enforceable? |

## User

Reference the policy "bundle and concept anatomy. " a "concept" Seems to have the only definition of having yaml frontmatter and a body. Is this correct? If so, this seems to be more of a format indication than a document type, and the word concept may imply something that is not backed up by the usage. Thoughts?

## Assistant

<routes ref="/meta/policy/document-anatomy.md /meta/policy/routing-ledger.md">
Yes — your reading is correct, and the tension you're sensing is real. Here's what I found.

**The anatomy policy defines a format, not a semantics.** In [`meta/policy/concept-anatomy.md`](/meta/policy/concept-anatomy.md), a "concept" is exactly what you said: a UTF-8 markdown file with YAML frontmatter and a body, whose ID is its path. Nothing in that definition requires the file to contain anything concept-like. The word comes from upstream — the OKF spec itself defines a bundle as "a plain directory of UTF-8 markdown *concept* documents", so the anatomy policy inherited the spec's vocabulary rather than choosing it.

**Meanwhile "concept" is also a `type`.** The controlled vocabulary defines `type: concept` as "a definition or mental model (established/accepted)" — one of eighteen types. So the word does double duty: the *unit* sense (any bundle document, format-level) and the *type* sense (a specific kind of document). In practice the type sense has drifted even narrower: of 155 `type: concept` files, 149 are glossary term entries.

**The overload causes real ambiguity, not just aesthetic discomfort.** The clearest collision is in the routing-ledger policy, which states "Routed-to targets are `concept` docs" — with `concept` in backticks, reading like the type. But an actual thread ledger (`2026-07-12-stamp-threads-with-pr-not-branch.md`) routes to [`meta/policy/session-capture.md`](/meta/policy/session-capture.md), which is `type: policy`. So either the policy means the unit sense and is misleadingly formatted, or it means the type sense and the ledger violates it. Other spots depend on the type sense being unambiguous: "a `claim` may graduate to `concept`", and the `verified` field being legal only on `claim`/`note`/`concept` (machine-enforced by `mix brain.verify`).

**Is the unit-level word entirely unjustified?** Not entirely — the name signals the *aspiration* that each file holds one coherent idea. But notice that this aspiration isn't carried by the anatomy policy; it's carried by *other* policies (distill-don't-dump, update-in-place). Strip those away and "concept" at the anatomy level is indeed just "file with frontmatter". Your instinct is right: the anatomy definition is syntax, and the word is borrowing semantic credibility from elsewhere.

**My recommendation**, if you want to act on this: don't rename either thing. The unit term is OKF's, and renaming `type: concept` would touch 155 files for marginal gain ("concept = mental model" is standard PKM usage). Instead, tighten the prose convention in the policies: use "concept document" or just "document" for the unit sense, and reserve bare backticked `` `concept` `` strictly for the type. The one place that genuinely needs fixing under that convention is the routing-ledger policy's "Routed-to targets are `concept` docs" line — the evidence shows targets are documents of any type, so it should say so (e.g. "routed-to targets are bundle or governance documents"). That's a policy edit, so it's yours to ratify — say the word and I'll draft it and re-render the contract.
</routes>

## User

I would strongly lean towards "document" for the unit sense. I imagine the policy would then read "routed-to targets are okf documents" then?

## Assistant

<routes ref="/meta/policy/document-anatomy.md /meta/policy/routing-ledger.md">
Done — the terminology change is committed and pushed to `claude/concept-definition-review-wmvtl2` (commit `fe5aa52`, 20 files). All gates pass: `mix brain.verify`, `mix brain.route_tags`, and the 116-test suite.

On your specific wording question: I went with plain "**documents**" rather than "OKF documents" for the routed-to line. Inside this repo every markdown file is OKF-shaped, so the qualifier adds little — and the distinction that actually matters there is a different one, which the verifier code made explicit: `ledger_doc_sinks` only cross-checks routed targets that resolve to a *bundle* document (one carrying an `sb:` id); governance targets under `meta/` are excluded from the registry and silently drop out of the check. The bullet now reads:

> **Routed-to targets are documents** — bundle or governance, of any `type` — linked by bundle-absolute path. The route-tagging cross-check reads this column to confirm every row routed to a **bundle** document (one carrying a stable `sb:` id) is covered by a tag; governance targets carry no id and drop out of that check.

What the change comprises:

- **`meta/policy/concept-anatomy.md` → `document-anatomy.md`** (git mv, history preserved), now defining "**A document**" with an explicit terminology clause: OKF's own term is *concept document*, this bundle says *document* because the anatomy is purely structural, and bare `concept` is reserved for the type. "Concept ID" became "Document ID".
- **Unit-sense sweep across twelve other policies** (directory-hierarchy, distill-don't-dump, frontmatter-schema, stable-identity, route-tagging, verification-grounding, etc.). Type-sense uses — `claim`/`note`/`concept`, "graduate to `concept`", glossary entries — are untouched, and the glossary's "one concept file per term" became "one `concept` document per term" since glossary entries genuinely are `type: concept`.
- **The glossary term itself**: `concept (OKF)` retitled to `document (OKF)` (file renamed to `document-okf.md`, stable id `sb:317879` kept — ids survive renames by design), with a note recording the old title and the rationale.
- **Regenerated artifacts**: `CLAUDE.md` and `meta/registry.md` recompiled; policy and glossary indexes updated; timestamps bumped.

Two things deliberately left out, flagged in the commit message: the Elixir code's internal vocabulary (`bundle_concepts`, "concept sink" in `RouteTags` docstrings and check messages) still says "concept" — a rename there is mechanical but touches tests, so it's a natural follow-up; and frozen thread docs keep their original wording, per the freeze rule. I didn't open a PR — say the word (or `/create-pull-request`) when you want one.
</routes>

## User

Okay. Now turning to the concept type. How is the concept type defined?

## Assistant

<routes ref="/meta/plans/concept-terminology-and-type-redefinition.md">
Here's the complete picture — the `concept` type is defined in four places, and they don't fully agree.

**The formal definition is a single line.** In [`controlled-type-vocabulary.md`](/meta/policy/controlled-type-vocabulary.md): "`concept` — a definition or mental model (established/accepted)." That's the entire positive definition — one sentence, with the epistemic status relegated to a parenthetical.

**The rest of the definition is by contrast, scattered through other vocabulary entries.** A `claim` is "asserted but not independently verified" and "may graduate to `concept` once confirmed" — so `concept` is implicitly the terminal state of a verification ladder. A `methodology` is distinct from "a `concept`, which defines a mental model". An `elaboration` is distinct from "a glossary `concept` (one *term*, source-independent)". The verification-grounding policy adds the graduation rule from the other side: a claim grounded via `verified_by` "may graduate to `concept`".

**What the machine enforces is much weaker than the prose.** In `SecondBrain.Verifier`, `concept` appears only as one of `@statement_types ~w(claim note concept)`: it may carry a `verified` field, `verified: true` requires a non-empty `verified_by` and no `resource`. That's it — the verifier makes no distinction whatsoever between a `claim`, a `note`, and a `concept`. "Established/accepted" has no mechanical meaning; the only enforceable difference between `claim` and `concept` is which word sits in the frontmatter.

**And actual usage tells a third story.** Of the 155 `type: concept` docs in the live bundle, 149 are glossary term entries plus the glossary hub — nearly all carrying `verified: false`, i.e. explicitly *not* checked. Only four are topical knowledge docs, and they split revealingly:

- `deep-belief-networks.md`, `git-worktrees-for-parallel-agents.md`, `routing-non-linear-work-sessions.md` — genuine "mental model" docs, all `verified: false`.
- `git-local-branches-dont-auto-advance-on-fetch.md` — `verified: true` with two evidence captures. But look at its title: it's a *proposition* ("local branches don't auto-advance"), not a definition. It's a graduated claim wearing the `concept` type.

So the honest answer to "how is it defined": as **two different things that share a name, with an epistemic promise neither keeps**. Sense one is *term definition* — what the glossary machinery mass-produces: "what does X mean", source-independent, one per term. Sense two is *accepted proposition* — the graduation target for a verified `claim`: "X is true, and here's the evidence". These are different speech acts: a definition isn't the kind of thing that graduates from a claim, and a verified proposition isn't a definition of anything. Meanwhile the parenthetical "(established/accepted)" is contradicted by the dominant usage — 98% of concept docs are unverified agent-distilled definitions, and nothing in the tooling ever checks "establishedness".

The same pattern as last time, one level up: the word "concept" is again doing double duty, and the written definition again claims a property (established/accepted) that neither the verifier nor the corpus backs. If you want to pull on this thread, the natural questions are whether glossary entries deserve their own type (or `concept` narrows to "term definition" and graduated claims stay `claim` with `verified: true` doing the epistemic work), and whether "(established/accepted)" should be dropped or made to mean something enforceable. Happy to lay out those options properly if you want to go there.
</routes>

## User

Create a plan summing up the learnings and questions relayed in this thread. Make sure to include the final pulling up the thread questions at the end here. The the plan needs to be self contained so that another agent can run it from scratch and understand all the considerations listed here.

## Assistant

<routes ref="/meta/plans/concept-terminology-and-type-redefinition.md">
Plan filed and pushed — [`meta/plans/concept-terminology-and-type-redefinition.md`](/meta/plans/concept-terminology-and-type-redefinition.md), `status: proposed`, with the plans index updated (commit `cef9192`, verifiers green).

It's written to be runnable from scratch by a fresh agent, so it carries everything, not pointers to this chat:

- **Part 1 as settled context** — the ratified "document"-for-the-unit decision, the evidence that forced it (the structural-only anatomy definition, the routing-ledger collision where a "concept doc" target was actually `type: policy`, and the verifier's registry-only cross-check), what shipped in commit `fe5aa52`, and an explicit "do not reopen" scope boundary.
- **Part 2 findings in full** — the four disagreeing definition sources quoted (the one-line vocabulary entry, the contrast clauses, `@statement_types ~w(claim note concept)` with no concept-specific enforcement, and the usage census: 149 unverified glossary entries + hub + three unverified mental-model docs + one verified proposition-shaped graduated claim), synthesized as the two-speech-acts diagnosis under an "(established/accepted)" label nothing checks.
- **The pulling-the-thread questions at the end**, framed as ratification items for the operator: (1) a separate type for glossary terms vs. narrowing `concept`; (2) drop claim→concept graduation (with the one existing graduated doc reverting to `claim`) vs. keep it and finally define what a proposition-shaped `concept` is; (3) drop "(established/accepted)" or name its oracle; plus (4) the deferred code-side vocabulary sweep, to ride along with whatever migration is decided. It also reminds the executing agent to pose these in chat rather than the dialog box, per the session-capture policy.

Both commits are on `claude/concept-definition-review-wmvtl2`. When you're ready to land the session — thread capture, glossary pass, and PR in one motion — `/create-pull-request` will do it.
</routes>
