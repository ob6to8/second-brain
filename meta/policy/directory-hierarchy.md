---
type: policy
title: Unix-like directory hierarchy
description: Concepts live in a lowercase, kebab-case unix-like hierarchy; create the natural path even for a single concept.
section: directory-structure
order: 1
status: active
tags: [meta, governance, taxonomy, structure]
timestamp: 2026-07-05
attribution:
  when: 2026-07-05T12:30:48+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
  from: [/meta/threads/2026-07-05-greenfield-okf-bootstrap-and-verification-layer.md]
---
- Organize concepts into a **unix-like hierarchy**: lowercase, kebab-case directory
  names (short, established acronyms like `SWE` may stay uppercase); each directory
  holds a coherent set of related concepts.
- **Create the natural directory path even for a single concept.** Do not flatten to
  avoid nesting — a lone note about git belongs in `knowledge/SWE/version-control/git/`, not
  dumped at the root. Depth that mirrors the real structure of the knowledge is good.
