---
type: analysis
title: "Reconciling a mid-flight doctrine retirement into an open branch"
description: An account of how an open feature branch was reconciled after main retired the filing doctrine the branch's work was built on — conform the knowledge/deliverable layer to the new doctrine and drop the retired name, keep the provenance/record layer faithful, take the retiring branch's stubs in conflicts — with the layer-split itself read as an application of fit each layer to its purpose.
status: active
provenance: "Claude Code session, 2026-07-22 — the survey-tier branch merged main mid-flight and hit a doctrine collision; written at operator request to persist the reconciliation approach"
attribution:
  when: 2026-07-22T00:00:00Z
  channel: agent-authored
  agent: "Claude Code agent, survey-tier design session"
  why: "persists the how-to for reconciling an open branch when main retires a doctrine the branch depends on, so the layer-scrub judgment survives the session"
  from: [/meta/threads/2026-07-22-survey-tier-and-bookmarks-register.md]
tags: [meta, analysis, governance, doctrine, filing, branch, merge, provenance]
timestamp: 2026-07-22
---

# Reconciling a mid-flight doctrine retirement into an open branch

## The situation

A feature branch (the [survey tier](/beliefs/glossary/survey-tier.md)) was open and
pushed, its PR green. While it sat open, `main` merged a separate PR that **retired a
long-standing filing doctrine** — deleting its `policy` file, formalizing the accurate
direction as the
[fit each layer to its purpose](/meta/doctrine/fit-each-layer-to-its-purpose.md)
doctrine, adding the
[capture-knowledge-cite-the-source](/meta/policy/capture-knowledge-cite-the-source.md)
policy in its place, and turning the retired term's glossary entry into a
deliberate retired-term stub.

The open branch's work **depended on the retired doctrine throughout**: its policy
carve-out, glossary term, plan, skill, and register all named it and linked its
now-deleted policy file, and its captured thread discussed it at length. Merging
`main` in produced both real content conflicts and a pile of stale-by-reference
links. The operator's instruction was unambiguous: conform all of the branch's work
to the new doctrine, with **no residual trace of the retired slogan** in that work.

## The reconciliation

The move that made it tractable was to **split the branch's artifacts by layer** and
apply opposite rules to each — which is exactly what the new doctrine prescribes:

- **Knowledge / deliverable layer** — the policy carve-out, the glossary term, the
  plan, the skill, and the register. These are consulted as *current truth*, so they
  must state the world as it now is. **Conform them to the new doctrine and drop the
  retired name entirely**: rewrite every reference to point at the new doctrine and
  the new policy, repoint links off the deleted file, and re-derive any generated
  surfaces (contract, glossary index, excerpt logs) so nothing reintroduces the old
  name.
- **Provenance / record layer** — the captured thread. A record's job is fidelity: it
  answers *what was actually said and decided*, so it is faithful only if it is not
  rewritten to match later reality. (This is the tension the operator's "no residual
  **record**" instruction sits in, and where the record-vs-knowledge split has to be
  made explicitly rather than assumed.)
- **Merge conflicts** — where the retiring PR and the branch touched the same lines,
  **take the retiring side's artifacts** (the retired-term stub, the reframed
  descriptions) and re-add only the branch's *additive* content (a new citation, a new
  sense) on top, never re-adding the retired framing.

## The principle

**Which layer scrubs and which stays faithful is itself an application of
[fit each layer to its purpose](/meta/doctrine/fit-each-layer-to-its-purpose.md).**
The knowledge layer optimizes for a clean, current statement, so a superseded name is
noise to be removed; the record layer optimizes for fidelity, so the same name is
signal to be preserved. A retirement that reflexively scrubs *everywhere* damages the
record; one that scrubs *nowhere* leaves the knowledge base citing a dead doctrine.
The correct motion is per-layer, not global — the same judgment the doctrine makes
about retention, applied to a rename.

## Recommendation

When `main` retires or renames a doctrine a live branch depends on:

1. Merge `main` in early rather than at the end, so the collision surfaces before the
   work calcifies around the old framing.
2. Reconcile the **knowledge-layer** artifacts to the new doctrine and drop the retired
   name; re-derive all generated surfaces and confirm with a repo-wide search that the
   branch's own work carries no residual reference.
3. Decide the **record-layer** treatment *explicitly with the operator* — fidelity and
   a clean scrub pull in opposite directions here, and only the operator can set which
   wins for the record.
4. In conflicts, prefer the retiring PR's artifacts; re-add only additive branch
   content on top.
