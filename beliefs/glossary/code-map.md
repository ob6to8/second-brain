---
id: em:5b3608
type: concept
title: code map
description: This brain's generated glossary of its own tooling — meta/code-map.md, compiled from every lib/ module's @moduledoc/@doc/@typedoc by mix brain.codemap so the code that sits alongside the bundle (and carries no em: id) still has a browsable statement of module, function, and type intent.
provenance: "Agent-distilled glossary definition, coined in the 2026-07-16 code-tutorial session"
verified: false
tags: [glossary, tooling, documentation, codegen]
sense: repo
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T12:13:13Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term coined by the 2026-07-16 code-tutorial-and-code-map thread"
---

# code map

The [generated artifact](/beliefs/glossary/generated-artifact.md)
[`meta/code-map.md`](/meta/code-map.md): a browsable glossary of the
`elixir_mind` tooling's intent — one section per module compiled from its
`@moduledoc`, public functions, and declared types. The tooling in `lib/` sits
*alongside* the knowledge bundle rather than in it (no `em:` id, excluded from
the site's registry), so it never gets a concept page; the code map is where its
per-module and per-function intent lives instead. It is compiled from the source
docstrings by `mix brain.codemap` (extraction via Elixir's stdlib
`Code.fetch_docs/1`, so it stays dependency-free and offline) and drift-checked
with `mix brain.codemap --check` in the [gate suite](/beliefs/glossary/gate-suite.md),
on the same discipline as the [compiled contract](/beliefs/glossary/compiled-contract.md).
The prose counterpart — how the modules compose — is the
[tooling-architecture tutorial](/meta/tutorials/the-tooling-architecture.md);
prose is authored, the code map is compiled, and they meet at the docstrings.

*Seen in:* [2026-07-16 code-tutorial-and-generated-code-map thread](/meta/threads/2026-07-16-code-tutorial-and-generated-code-map.md)
