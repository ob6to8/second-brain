# Plan 008: "It's Just Shell" Thesis Revision

**Status: PENDING**

## Problem

The itsjustshell.dev thesis conflates two distinct ideas:

1. **Shell as interface contract** — tools should be composable, observable, text-based, invocable from a terminal, pipeable, and inspectable.
2. **Bash as implementation language** — tools should be written in bash/POSIX shell.

The assertion graph project hit the complexity ceiling of bash (no data structures on macOS bash 3.2, no recursion support for DAG traversal, string-only composition, manual error handling). Migrating to Elixir preserves every property the thesis values while dropping the constraint that caused the failure.

This reveals the thesis was always about the interface, not the implementation. It needs to say so explicitly.

## The Revised Thesis

**"Shell" is an interface contract, not an implementation language.**

A tool satisfies the shell contract if:

1. **Invocable from a terminal** — has a CLI entry point (`mix task`, escript, binary, script)
2. **Composable via pipes** — reads stdin, writes stdout, uses exit codes
3. **Observable** — behavior is inspectable at every step (logs, `--verbose`, `--dry-run`)
4. **No hidden state** — persistent state lives in a known, queryable store (files, database) — not in memory across invocations
5. **Text-based data flow** — structured output (JSON, CSV) that other tools can consume
6. **Self-describing** — `--help` for humans, `--describe` (or equivalent) for machines
7. **Stateless invocations** — each call is independent; no daemon required for basic operation

Bash satisfies this contract. So does an Elixir escript. So does a Go binary. So does a Python CLI built with Click. The thesis is about the *properties*, not the *runtime*.

## What Changes on itsjustshell.dev

### Content that holds as-is
- The critique of MCP overhead — still valid
- The argument that LLMs already understand CLIs — still valid
- The CLI-MCP convention (Plan 004) — still valid, now implementable in any language
- "Tools should compose in a pipeline" — still valid
- "You should be able to inspect every step" — still valid

### Content that needs revision
- Any claim that bash specifically is the answer (bash is *one* valid implementation)
- Any implication that using a "real language" violates the philosophy
- The framing that shell tools = shell scripts
- The name itself may need clarification — "it's just shell" means "the interface is the shell," not "the code is shell script"

### New content needed
- **"Shell is an interface, not a language"** — the core conceptual piece
- **The complexity gradient** — when bash suffices (glue, prototypes, <500 LOC tools), when it doesn't (data structures, recursion, error handling at scale), and why that's fine
- **Case study: assertion graph migration** — started in bash, hit the wall, migrated to Elixir, retained every shell property. Proof the thesis survives implementation changes.
- **The litmus test** — "Can I pipe it? Can I inspect it? Can I call it from cron?" If yes, it satisfies the thesis regardless of implementation language.

## The CLI-MCP Relationship

Plan 004 (CLI-MCP spec) becomes stronger, not weaker. The `--describe` convention and `serve.sh` bridge work identically whether the underlying tool is bash, Elixir, or anything else. Tidewave gives Elixir tools MCP for free — which is the thesis in action: the tool doesn't need to be rewritten for MCP, the interface handles it.

The revised thesis would present Tidewave as evidence: "A well-structured Elixir tool gets MCP compatibility without changing a line of application code. The interface layer handles protocol translation. This is what we mean by 'it's just shell' — the tool's contract is stable, the transport is someone else's problem."

## Execution

1. Write the "shell is an interface" essay for itsjustshell.dev
2. Revise existing content to decouple shell-the-interface from bash-the-language
3. Add the complexity gradient guide
4. Add the assertion graph case study (after migration is complete)
5. Update Plan 004 to be language-agnostic (it mostly is already)

## Open Questions

- Does the site name "itsjustshell.dev" still work? It could — "shell" meaning the terminal interface, not bash. But it might need an explicit "what we mean by shell" statement up front.
- Should the site advocate for specific languages at specific complexity tiers? Or stay language-agnostic and only specify the interface contract?
- Does this weaken the accessibility argument? Bash's strength is universality — everyone has it. Elixir requires a runtime. The thesis should acknowledge this tradeoff honestly.
