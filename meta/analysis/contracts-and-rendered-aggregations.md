---
type: analysis
title: "Is 'contract' a necessary abstraction, and what family does it belong to?"
description: An examination of the operating contract against the bundle's other generated artifacts finds "rendered aggregation" is a multi-instance pattern while "contract" is a deliberate singleton distinguished by authority, not mechanism; the name marks a role decoupled from the CLAUDE.md mounting point, an "Agent-contract" qualifier adds no contrast, and skills belong to the pattern as sources, not targets.
provenance: "Claude Code session (2026-07-11) — distilled from an operator dialogue on the branch-deletion-policy branch questioning whether 'contract' obscures that only CLAUDE.md exists"
tags: [meta, analysis, contract, compiled-artifact, abstraction, skills, naming]
timestamp: 2026-07-11
---

# Is "contract" a necessary abstraction, and what family does it belong to?

**Question.** The operator observed that if `CLAUDE.md` is the only contract we
can imagine having, "contract" may be an unnecessary abstraction obscuring that
we are only really dealing with one file. Is the term earning its keep? Are
there other instances — of contracts, or of the wider pattern? And are skills a
potential compilation target of the same kind?

## Evidence: the rendered-aggregation family

The generated-not-hand-kept pattern (see
[compiled contract](/beliefs/glossary/compiled-contract.md), `sb:23f009`) has several
live instances in this bundle, each aggregating scattered sources into one
derived view with a drift check:

| Artifact | Sources | Compiler | Persisted? | Drift gate |
|----------|---------|----------|------------|------------|
| `/CLAUDE.md` | `meta/preamble.md` + `meta/policy/*.md` | `mix brain.contract` | committed | `--check` (CI + pre-commit) |
| [`meta/registry.md`](/meta/registry.md) | per-file `sb:` ids | `mix brain.registry` | committed | `--check` (CI) |
| `## Thread excerpts` logs in concepts | `<routes>` tags in frozen threads | `mix brain.route_tags --materialize` | committed | `mix brain.route_tags` (fails on divergence) |
| GitHub Pages site | the whole bundle | `mix brain.site` | published | rebuilt per deploy |
| Session-init digest | `meta/issues/` · `meta/todos/` · `meta/plans/` · thread ledgers | `mix brain.session_init` | ephemeral (per session) | re-rendered each start, never stale |

## Findings

1. **"Rendered aggregation" is a real, multi-instance abstraction** — five
   instances, one discipline: sources are canonical, the view is derived,
   freshness is structural (a gate) rather than procedural (remembering).
2. **The contract is a singleton within that family, distinguished by
   authority, not mechanism.** Among the artifacts above, only `CLAUDE.md`
   *binds agent behavior* — the registry indexes, the excerpt logs quote, the
   site presents, the digest orients; the contract commands. One brain, one
   set of operating rules: no second contract is imaginable in this design,
   and none should be designed for.
3. **The name marks a role, not a file.** `CLAUDE.md` is the *mounting point*
   — a filename dictated by the Claude Code harness for where agents look. The
   *contract* — the compiled aggregation of `meta/policy/` — would survive a
   harness change (`AGENTS.md`, a second surface) with only the output path in
   [`contract.ex`](/lib/second_brain/contract.ex) moving. The abstraction's
   price is one word and one module name; its purchase is harness
   independence. It would become speculative generality only if the compiler
   started abstracting over hypothetical second instances — it hasn't.
4. **"Agent-contract" was considered and declined.** A qualifier earns its
   place by disambiguating; there is no operator-contract or reader-contract
   to contrast with, and there cannot be — the operator ratifies rules rather
   than obeying them, so agents are the only bindable party. That fact is now
   stated in one sentence in [`meta/preamble.md`](/meta/preamble.md) instead
   of encoded in a rename.
5. **Skills share the *mounting point* nature of `CLAUDE.md` but sit on the
   opposite side of the compile.** Each `.claude/skills/<name>/SKILL.md` is
   harness-consumed like the contract — but it has no aggregation problem: one
   procedure, one file, and the `SKILL.md` *is* the source of truth. Compiling
   skills *from* bundle docs would create the dual-home drift the contract
   compiler exists to kill. The observed drift (2026-07-11, twice) runs the
   other way: the hand-kept skills-registry policy duplicates what each
   skill's frontmatter already declares. So skills belong to the pattern as
   **sources**, with the contract's §7 as the derived view.

## Recommendation

Keep the name "contract" (unqualified); state the bound party in the preamble
(done, same session); and invert the skills compile — executed as the
operator-commissioned, top-priority plan
[compile-skills-registry-from-skill-frontmatter](/meta/plans/compile-skills-registry-from-skill-frontmatter.md).
The issue↔todo cross-deferral convention discussed in the same dialogue stays
uncodified until it recurs.
