# Agentic loop

The **agentic loop** is the core execution cycle of an LLM agent: assemble
context → call the model to reason → act (call a tool) → observe the result →
feed it back and repeat, until a stop condition ends the run. The recurring theme
across these sources is that this loop is *mechanically trivial* (often a few lines
of `while`), and that the real engineering has moved to **"loop engineering"** —
designing the trigger, tools, verifier, stopping condition, budget, and the outer
**harness** that decides when to keep going. This directory captures primary
sources from the 2022–2026 lexicon, filed as `reference` captures.

## Foundations & canonical framing

- [ReAct — reasoning + acting (Yao et al.)](/knowledge/SWE/agentic/agentic-loop/react-reasoning-and-acting.md) — the foundational thought→action→observation loop. `em:f63910`
- [Building effective agents — agents vs. workflows (Anthropic)](/knowledge/SWE/agentic/agentic-loop/building-effective-agents.md) — agents are "LLMs using tools based on environmental feedback in a loop". `em:06d95d`
- [A practical guide to building agents — the 'run' loop (OpenAI)](/knowledge/SWE/agentic/agentic-loop/openai-practical-guide-to-building-agents.md) — "a while loop is central to the functioning of an agent". `em:a030d9`
- [How to build an agent — an LLM, a loop, and enough tokens (Thorsten Ball)](/knowledge/SWE/agentic/agentic-loop/how-to-build-an-agent.md) — a real code agent in ~300 lines. `em:8e885f`
- [smolagents — the agent loop as code-writing ReAct (Hugging Face)](/knowledge/SWE/agentic/agentic-loop/smolagents-agent-loop-as-code.md) — actions expressed as executable code. `em:f948df`

## Anatomy & how-to

- [The agent loop is a while-loop; reliability is the real work (Steve Kinney)](/knowledge/SWE/agentic/agentic-loop/agent-loop-as-a-while-loop.md) — "the loop is the easy part". `em:97d2a8`
- [The agent execution loop (Victor Dibia)](/knowledge/SWE/agentic/agentic-loop/the-agent-execution-loop.md) — the five stages of one run. `em:3fd44a`
- [The agent loop decoded — three levels (Oracle)](/knowledge/SWE/agentic/agentic-loop/the-agent-loop-decoded-three-levels.md) — a maturity ladder from bare loop to in/out-of-loop memory. `em:592342`
- [How coding agents work (Simon Willison)](/knowledge/SWE/agentic/agentic-loop/how-coding-agents-work.md) — the harness = LLM + system prompt + tools in a loop. `em:a832e0`

## Loop engineering (the recent lexicon)

- [Designing agentic loops (Simon Willison)](/knowledge/SWE/agentic/agentic-loop/designing-agentic-loops.md) — the art of the tools, permissions, and sandbox. `em:3384ba`
- [The art of loop engineering / loopcraft (LangChain)](/knowledge/SWE/agentic/agentic-loop/the-art-of-loop-engineering.md) — stacking agent, verification, event-driven, and hill-climbing loops. `em:1aefe2`
- [Loop engineering went mainstream (Sébastien Dubois)](/knowledge/SWE/agentic/agentic-loop/loop-engineering-went-mainstream.md) — "design the system, not just the message". `em:01bb9a`
- [The coming loop — nested agent and harness loops (Armin Ronacher)](/knowledge/SWE/agentic/agentic-loop/the-coming-loop.md) — the harness loop rises; human comprehension recedes. `em:d580ce`

## Control flow, autonomy & context

- [Own your control flow — Factor 8 of 12-Factor Agents (HumanLayer)](/knowledge/SWE/agentic/agentic-loop/own-your-control-flow-12-factor.md) — own the loop so you can pause, resume, and vet. `em:b6353e`
- [Ralph — a coding agent in an infinite bash loop (Geoffrey Huntley)](/knowledge/SWE/agentic/agentic-loop/ralph-infinite-bash-loop-coding-agent.md) — `while :; do cat PROMPT.md | claude-code ; done`. `em:276c61`
- [Effective context engineering for AI agents (Anthropic)](/knowledge/SWE/agentic/agentic-loop/effective-context-engineering-for-agents.md) — curating the context a loop accumulates. `em:c0961a`

## Reliability & long-horizon

- [Agent task time horizons — METR's "Moore's Law for AI agents"](/knowledge/SWE/agentic/agentic-loop/agent-task-time-horizons.md) — the 50% time horizon (task length an agent completes half the time) doubles ~every 7 months, ~14h by early 2026; the 50%/80% gap is reliability decay. `em:c29a22` _(reference)_
- [PARC — a self-reflective agent for long-horizon autonomous execution](/knowledge/SWE/agentic/agentic-loop/parc-self-reflective-long-horizon-agent.md) — a hierarchical agent with an independent self-assessment layer that catches strategic errors, sustaining multi-day autonomous work. `em:f02167` _(reference)_
