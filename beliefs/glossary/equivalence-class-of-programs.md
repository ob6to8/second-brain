---
id: em:9152da
type: concept
title: equivalence class of programs
description: The set of all programs that satisfy a given specification — each interchangeable for the properties the spec pins while every unpinned choice is left free — so it, rather than any single program, is what a description actually selects.
provenance: "Agent-distilled glossary definition, Claude Code session"
verified: false
sense: common
tags: [glossary, specs, regeneration, verification, testing]
timestamp: 2026-07-20
attribution:
  when: 2026-07-20
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-20 code-as-compilation-target-and-dsp-testing-model thread"
---

# equivalence class of programs

Reframing a specification's output as a class rather than a point explains why
regeneration is legitimately non-deterministic: rebuilding from the same spec lands
on *some* member, and two members differ only in the free region, exactly as two
competent engineers hand the same ticket produce different, equally acceptable code.
The width of the class is set by how much is pinned — tests, types, and
[invariants](/beliefs/glossary/nyquist-shannon-sampling-theorem.md) narrow it — and
whatever stays unpinned is what a rebuild is free to vary, which is where
[Hyrum's law](/beliefs/glossary/hyrums-law.md) bites once an artifact is in use.

*Seen in:* [2026-07-20 code as compilation target and DSP testing model](/meta/threads/2026-07-20-code-as-compilation-target-and-dsp-testing-model.md)

*See also:* [Hyrum's law](/beliefs/glossary/hyrums-law.md), [test oracle](/beliefs/glossary/test-oracle.md)
