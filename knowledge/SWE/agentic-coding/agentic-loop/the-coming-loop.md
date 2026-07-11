---
id: sb:d580ce
type: reference
title: "The coming loop — nested agent and harness loops (Armin Ronacher)"
description: Ronacher frames agentic development as two nested loops — the model's inner tool-calling loop and an outer harness loop that decides when work is done — warning this shift sidelines human comprehension.
resource: https://lucumr.pocoo.org/2026/6/23/the-coming-loop/
provenance: "Distilled from Armin Ronacher, Armin Ronacher's Thoughts and Writings, 2026-06-23"
tags: [agentic-loop, ai-agents, loop-engineering, harness, code-quality, developer-workflow]
timestamp: 2026-07-06
---

# The coming loop — nested agent and harness loops (Armin Ronacher)

Ronacher distinguishes two nested loops: the internal **agent loop** (a model
calling tools iteratively) and an external **harness loop** where orchestration
decides whether to keep going. He argues the harness level is becoming dominant,
reducing the developer's job: *"The harness decides when work is finished... My
role is reduced to that of a messenger."* Loops excel at mechanical or throwaway
work — code porting, performance exploration, security scanning, research — but
unsupervised loops tend to produce over-defensive, complex, poorly-architected
code that sacrifices human comprehension. He sees adoption as unavoidable:
competitive pressure and adversaries who loop continuously mean developers cannot
fully opt out. The deeper risk is cognitive dependency — teams losing the ability
to maintain codebases without machine help. The core tension: loops deliver speed
and scale, yet erode software engineering's traditional values of clarity,
responsibility, and human understanding.

# Citations

Armin Ronacher, "The Coming Loop", 2026-06-23 —
<https://lucumr.pocoo.org/2026/6/23/the-coming-loop/>
