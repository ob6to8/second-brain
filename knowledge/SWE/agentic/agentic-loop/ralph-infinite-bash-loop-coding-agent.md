---
id: em:276c61
type: reference
title: "Ralph — running a coding agent in an infinite bash loop (Geoffrey Huntley)"
description: "Ralph" is a brute-force agentic technique that pipes one prompt into a coding agent inside an endless shell loop, trusting successive iterations to converge on working software.
resource: https://ghuntley.com/ralph/
provenance: "Distilled from Geoffrey Huntley, ghuntley.com, 2025-07-14"
tags: [agentic-loop, ai-agents, autonomous-agents, coding-agents, iteration, context-window]
timestamp: 2026-07-06
attribution:
  when: 2026-07-06T15:34:55+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
---

# Ralph — running a coding agent in an infinite bash loop (Geoffrey Huntley)

Ralph reduces the agentic loop to its crudest form: `while :; do cat PROMPT.md |
claude-code ; done` — feed the same prompt to a coding agent forever until the work
is done. Named after Ralph Wiggum, the technique leans into imperfection: *"the
technique is deterministically bad in an undeterministic world,"* yet still makes
directional progress. The discipline is in the constraints, not the loop itself.
Each iteration must implement exactly one thing to conserve the ~170k-token context
window, forcing focused incremental steps. Planning and spec documents
(`@fix_plan.md`, `@specs/*`) are deterministically re-loaded each cycle as stable
reference points against LLM non-determinism. Feedback signals — tests, build
validation, error logs — let the loop self-correct, documenting failures for future
passes. Ralph favors eventual consistency over immediate perfection, treating
autonomous development as an iterative tuning process where each cycle surfaces
deficiencies that shape the next iteration's behavior.

# Citations

Geoffrey Huntley, "Ralph Wiggum as a 'software engineer'", 2025-07-14 —
<https://ghuntley.com/ralph/>
