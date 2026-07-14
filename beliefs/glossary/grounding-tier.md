---
id: em:8c4c5c
type: concept
title: grounding tier
description: The third tier of three-level documentation — one level of abstraction below whatever the source document is — anchored by an implemented_by frontmatter edge (paths to enforcing code for a policy, paths to implementing policies for a doctrine) plus optional prose.
provenance: "Agent-distilled glossary definition; the one-abstraction-below generalization coined by the operator in the 2026-07-13 three-level documentation session"
verified: false
attribution:
  when: 2026-07-13T14:29:00Z
  channel: glossary
  agent: "Claude Code agent, /create-pull-request → /add-to-glossary over the session thread"
  why: "the operator's one-abstraction-below generalization, load-bearing in the ratified plan"
tags: [glossary, documentation, levels, edges, terminology]
sense: repo
timestamp: 2026-07-13
---

# grounding tier

The downward tier of [three-level documentation](/beliefs/glossary/three-level-documentation.md): **one level of abstraction below whatever the source is**. The tier is relative, not fixed at "code" — a machine-enforced policy grounds into the code that enforces it, a doctrine grounds into the policies that implement it, a tooling doc into its modules and tasks. It is anchored by a planned `implemented_by` frontmatter edge (an inline list of `em:` ids and/or repo paths, following the same ref rule as [route tags](/beliefs/glossary/route-tag.md): id for bundle concepts, path for targets outside the identity registry) plus an optional prose block; the edge is mechanically checkable, the prose is editorial. Defined in the [three-level documentation plan](/meta/plans/three-level-documentation.md).

*Seen in:* [2026-07-13 three-level-documentation thread](/meta/threads/2026-07-13-three-level-documentation-plan-and-model-doctrine.md), [three-level documentation plan](/meta/plans/three-level-documentation.md)
