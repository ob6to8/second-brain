# Code quality

Maintaining code quality and craft under AI-assisted development — the guardrails,
review layering, and feedback loops that hold a project to its author's standards
as agents generate more of its code.

## Documents

- [Guarding Against AI Drift (Mike Zornek)](/knowledge/SWE/agentic/code-quality/guarding-against-ai-drift.md) — a solo-developer's two-layer playbook against AI quality drift: automated Elixir guardrails (compile/format/lint/security/workflow checks) for the mechanical, plus deliberately non-delegated layered human review, with recurring misses promoted into the standards docs the agent reads.
- [Elixir coding conventions (Zornek's LocalCents standards)](/knowledge/SWE/agentic/code-quality/elixir-coding-conventions-localcents.md) — the transferable Elixir/typespec/documentation conventions from LocalCents' CODING_STANDARDS.md (the very agent-read standards doc the AI-drift feedback loop feeds), foregrounding the `@spec` argument-naming and layout rules.
