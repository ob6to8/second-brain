---
id: sb:8e885f
type: reference
title: "How to build an agent — an LLM, a loop, and enough tokens (Thorsten Ball)"
description: A capable code agent demystified to a simple loop feeding an LLM's tool calls and their results back into the conversation, with sophistication coming from engineering rather than any algorithmic trick.
resource: https://ampcode.com/how-to-build-an-agent
provenance: "Distilled from Thorsten Ball, Amp (Sourcegraph), 2025-04-15"
tags: [agentic-loop, ai-agents, thorsten-ball, amp, tool-use, code-agent]
timestamp: 2026-07-06
---

# How to build an agent — an LLM, a loop, and enough tokens (Thorsten Ball)

Ball's thesis is radical simplicity: a working code-editing agent is *"an LLM, a
loop, and enough tokens."* He demonstrates it in ~300 lines of Go with just three
tools (`read_file`, `list_files`, `edit_file`). The loop is plain: send user input
to the model; when the model requests a tool, execute it; feed the result back into
the conversation context; repeat until the task completes. There is no hidden
orchestration algorithm — the model's own training already knows when and how to
invoke tools, so the developer merely supplies the infrastructure and lets the
model drive. Everything that makes a production agent like Amp feel impressive is,
in his words, the *"rest… Elbow grease"* — prompt engineering, tool design, and
iteration, not a conceptual breakthrough. The takeaway for the agentic-loop
lexicon: the loop is trivially small; product quality lives in the surrounding
practical details. This piece launched a wave of "build an agent in N lines"
reimplementations across languages.

# Citations

Thorsten Ball, "How to Build an Agent", Amp (Sourcegraph), 2025-04-15 —
<https://ampcode.com/how-to-build-an-agent>
