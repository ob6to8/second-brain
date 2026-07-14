---
type: analysis
title: "What do Elixir's AST and macro capabilities buy for LLM interaction, agent harnesses, and this brain's future runtime?"
description: A capability evaluation finding that Elixir's four-part metaprogramming stack (AST as stdlib-parseable data, compile-time macros, compilation as a runtime service, an introspectable runtime) makes model output structurally verifiable, turns macro DSLs into constrained generation targets with the compiler as validator, compiles tool definitions from implementations so they cannot drift, and uniquely closes the loop where a running system safely absorbs agent-written code — strengthening the tier-2 Jido case without advancing its timing, and yielding four design constraints for the future owned runtime plus one zero-dependency win available now (a defverb-style macro emitting mix task, function, and MCP tool schema from one definition).
provenance: "Claude Code session (Claude Fable), 2026-07-14 — operator asked what Elixir's AST and macro capabilities imply for interaction with LLMs, agentic processes, software development with agents, and harness-building (Jido 2), and whether there are implications for the elixir-mind project. Jido.Action, Tidewave, and Ash AI facts verified against hexdocs/tidewave.ai the same day"
tags: [meta, analysis, elixir, ast, macros, metaprogramming, dsl, beam, jido, agents, harness, llm, tooling]
timestamp: 2026-07-14
attribution:
  when: 2026-07-14T00:00:00Z
  channel: agent-authored
  agent: "Claude Code session (Claude Fable), operator-directed Elixir metaprogramming discussion"
  why: "operator asked for the AST/macro implications to be assessed and, on review, directed the assessment be filed with verified citations as the third leg of the BEAM/Jido analysis set"
---

# What do Elixir's AST and macro capabilities buy for LLM interaction, agent harnesses, and this brain's future runtime?

**Question.** Elixir exposes its own syntax tree as ordinary data and builds its
abstraction layer out of compile-time macros. What does that capability imply
for (a) interacting with LLMs, (b) agentic processes and software development
with agents, and (c) building harnesses — concretely, the
[Jido 2](https://github.com/agentjido/jido) framework? And does any of it change
the conclusions this bundle has already filed about a future owned runtime (the
"elixir-mind" direction) in
[the BEAM/Jido evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md)
and [the two-plane analysis](/meta/analysis/claude-managed-agents-vs-beam-jido.md)?

**Thesis.** The AST/macro layer is arguably the strongest *language-level*
argument for the BEAM as a harness substrate — distinct from the *runtime-level*
arguments (supervision, density, fault tolerance) the prior analyses weighed. It
turns model output into checkable data, tool definitions into compiled
artifacts, and harness invariants into compile-time properties; combined with
runtime compilation and hot code loading, it uniquely closes the loop in which a
running system safely absorbs agent-written code. For this bundle, that
*strengthens the case quality* of the already-mapped tier 2 (Jido's abstractions
are the right ones *because* they are macro-native) while *changing nothing
about its timing* — the three blockers and the adoption triggers on record
stand. What it does change is design: four constraints the eventual tier-1/2
plan should carry, and one zero-dependency win available at tier 0 today.

## 1. The capability, precisely

Four properties, each carrying a different implication. All are standard
library, all present in this repo's pinned Elixir 1.14 toolchain.

1. **The AST is ordinary data.** Every Elixir program is representable as
   nested three-element tuples (`{form, metadata, arguments}`), and the stdlib
   round-trips it: `Code.string_to_quoted/1` parses source text into that
   structure, `Macro.to_string/1` and the formatter render it back, and
   `Macro.prewalk/2` / `Macro.postwalk/2` traverse and rewrite it. No external
   parser, no grammar file — the parser *is* the stdlib, and the AST is
   pattern-matchable like any other term.
2. **Macros are compile-time functions from AST to AST.** `quote`/`unquote`
   build code as data; `use`/`__using__` inject whole scaffolds into a module;
   module attributes plus hooks like `@before_compile` let a module inspect and
   validate *itself* during compilation. This is how Elixir DSLs (Ecto schemas,
   Phoenix routers, Jido Actions) exist: a small declarative surface expanding
   into full code, with errors raised at compile time.
3. **Compilation is a runtime service.** `Code.eval_quoted/1`,
   `Code.compile_string/1`, and `Module.create/3` mean a *running* BEAM system
   can compile new modules and hot-load them, under supervision, without
   restarting.
4. **The runtime is introspectable as data.** Docs, typespecs, behaviour
   callbacks, and the process tree are all queryable from a live node
   (`Code.fetch_docs/1`, `Module.__info__/1`, the observer machinery).

Most languages have at most one or two of these; having all four in the
standard library is the differentiator.

## 2. Implications for interacting with LLMs

**Code-as-data makes model output structurally verifiable, cheaply.** An LLM
emits code as text; in most ecosystems, validating that text beyond "does it
compile" means bolting on tree-sitter or a linter framework. In Elixir, the
harness parses it to a quoted form with the stdlib, pattern-matches over the
tree, and enforces *structural* policy before anything executes: whitelist the
allowed node types and remote calls, reject `File.rm_rf/1` or `:os.cmd/1` at
the AST level, cap nesting depth, then re-render canonically formatted source.
That is a deterministic firewall between "the model said" and "the system
runs" — exactly the trust boundary every harness needs, implemented as pattern
matching rather than a sandboxing product. The honest caveat: AST whitelisting
is a *policy* layer, not a security boundary — `apply/3`, dynamic dispatch, and
atom-table exhaustion mean true containment still comes from BEAM process
isolation, timeouts, and heap limits layered underneath. The two compose well;
neither alone suffices.

**Macro-built DSLs are constrained generation targets.** The most reliable way
to get correct code out of a model is to shrink the language it must emit. A
macro DSL does precisely this: the LLM generates a small declarative surface —
an action declaration with a schema, a route table, a resource definition — and
the macro expands it into the real implementation, with compile-time validation
producing precise, early errors the harness feeds straight back to the model as
a retry signal. This is the same insight as schema-constrained structured
output, moved up a level: instead of constraining the model to valid JSON, you
constrain it to a valid *program in a tiny language*, and the compiler is your
validator.

The Elixir ecosystem already demonstrates both halves (verified 2026-07-14):

- **Ash AI** leverages Ash's declarative resource DSL to expose application
  logic to LLMs: resource actions become LLM tools via a `tools do` block,
  prompt-backed actions delegate an action's *implementation* to an LLM with
  structured outputs (`run prompt()`), a `vectorize do` block adds embedding
  strategies, and built-in MCP servers expose the tools — the declarative layer
  is what makes the exposure mechanical rather than hand-written.
- **Tidewave** (Dashbit — the creators of Elixir) is the property-4
  demonstration: runtime intelligence over MCP — database access, logs, code
  execution, documentation lookup from the *running* system — for coding agents
  including Claude Code, integrating with Phoenix and Rails. An agent coupled
  to a live node queries ground truth instead of guessing from source.

**One definition, many surfaces.** A macro can reflect on a function's declared
schema and emit, from a single source of truth: the runnable function, its
validation, its documentation, *and* the JSON-schema tool definition an LLM
consumes. Tool definitions hand-maintained in parallel with implementations
drift; tool definitions *compiled from* implementations cannot. This is not
hypothetical — `jido_action` works exactly this way: `use Jido.Action` takes a
name, description, and schema; configuration is validated at compile time when
the macro expands; parameters are validated at runtime before `run/2`; and
`to_tool/0` converts the same definition into an LLM-compatible tool format.
The "one definition, three surfaces" observation in
[the BEAM/Jido evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md)
works at all *because* the macro layer is the mechanism under it.

**The counter-implication: macros tax model legibility.** Macro-heavy code is
harder for an LLM to *read* than to write, because the semantics live in the
expansion, not on the page. An agent debugging a deep `use` chain is reasoning
about invisible code. The design rule that follows: agent-facing DSLs should be
shallow (one expansion level), heavily documented at the declaration site, and
paired with tooling that shows the expansion (`Macro.expand/2` dumps) when the
agent needs it. Metaprogramming is leverage for the harness author and friction
for the code-reading agent — budget it deliberately.

## 3. Implications for agentic processes and harness-building (Jido 2)

Jido 2's design is essentially a bet on properties 1 and 2, and the prior
analyses undersell one consequence:

- **The reducer plus declarative directives is an AST-shaped harness.** Jido
  agents do not perform effects; they *return data describing effects*
  (directives), which the runtime interprets — the interpreter-tower structure
  the bundle's agentic-loop material already describes. Because directives are
  data, harness invariants become mechanically checkable properties.
  [The two-plane analysis](/meta/analysis/claude-managed-agents-vs-beam-jido.md)
  states the invariant "no action sequence yields a commit directive without
  passing the verification action" as a runtime/replay property. The macro
  layer pushes part of that to **compile time**: a `@before_compile` hook over
  an agent's declared routes and actions can reject, at build, any module
  wiring a commit-capable action without the verification stage ahead of it.
  Most harness frameworks can only *test* their invariants; a macro-built one
  can partially *enforce them in the compiler*. That is a categorical upgrade
  in assurance-per-effort on the mechanical plane, where the harness is most of
  the agent.
- **Runtime compilation closes the capability-acquisition loop.** Combine the
  four properties: a deliberative agent proposes a new mechanical capability
  *as DSL text*; the harness parses it (property 1), structurally validates it
  against policy (the whitelist), compiles it as a new Action module whose
  schema declaration is checked at compile time (property 2), hot-loads it
  under supervision (property 3), and can roll it back. No other mainstream
  runtime does this whole loop natively. This is the concrete meaning of
  "agents writing software for agents" on the BEAM: the system can safely grow
  its own machinery while running, with the compiler as one of the reviewers.
- **The gap to note: nothing here advances the timing.** The blockers on record
  stand — Jido's toolchain floor (Elixir 1.17+/OTP 26+ against this repo's
  1.14), the load-bearing zero-dependency constraint, and the duplicate-runtime
  cost. The AST/macro argument strengthens the *tier-2 case* (Jido's
  abstractions are right *because* they are macro-native) without touching the
  *adoption triggers*. Everything above describes why the BEAM is a distinctive
  substrate for a harness, not a reason to build one before those triggers
  fire.

## 4. Implications for the elixir-mind direction

Reading "elixir-mind" as the prospective owned runtime — the tier-1/tier-2
resident system mapped in
[the BEAM/Jido evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md)
and the owned mechanical plane of
[the two-plane analysis](/meta/analysis/claude-managed-agents-vs-beam-jido.md) —
the implications are mostly *design constraints for later*, plus one thing
usable now:

1. **The tier-0 verdict is unchanged, and the macro argument reinforces the
   zero-dep constraint.** Macros are stdlib: parsing, validation, DSL
   definition, and tool-schema generation all need zero dependencies. The one
   near-term, no-deployment use: when the `brain.*` verbs eventually need an
   MCP surface (tier 1's thin tool server), a small hand-rolled macro
   (`defverb`-style) can emit the mix task, the callable function, and the MCP
   tool schema from one definition, keeping the three surfaces from drifting
   *without* pulling in Jido — the one-definition-three-surfaces claim made
   real inside the existing zero-dep core.
2. **Specify the write-gatekeeper as a compile-time property, not just a
   runtime gauntlet.** The two-plane analysis places enforcement in reducer
   invariants (mechanical side) and credential custody (deliberative side).
   The macro capability adds a third layer the eventual tier-1 design should
   carry: make the commit-directive constructor *unreachable* except through
   the verification stage — an opaque struct only the verifier module can
   build, checked at compile time. "Illegal writes are unrepresentable" is a
   stronger claim than "illegal writes are caught," and Elixir's compile-time
   layer makes it cheap.
3. **The DSL boundary is the ratification surface.** This brain's governance —
   agents act autonomously inside ratified shapes; the operator ratifies
   changes to shape — maps exactly onto the DSL split: the *DSL grammar* (what
   kinds of agents, actions, and directives can exist) is operator-ratified
   shape; *declarations in the DSL* (a new sensor, a new sweep) are the
   autonomous zone, machine-validated by the compiler. If the elixir-mind is
   built, designing its DSL *is* designing its constitution, and the
   taxonomy-evolution protocol already says how amendments work.
4. **Keep the mind's language legible to its own minds.** The deliberative
   plane (Claude sessions) will be what reads, reviews, and extends the
   mechanical plane's code. A macro tower elegant to a human Elixir expert but
   opaque to the reviewing model works against the system's own operating
   loop. Shallow DSLs, expansion-dumping dev tools, and runtime introspection
   exposed as agent tools (the Tidewave pattern) should be first-class
   requirements in the tier-1 plan, not afterthoughts.

**Recommendation.** Adopt nothing now — the timing verdict of the prior
analyses stands untouched. Carry the four design constraints above into
whatever plan executes tier 1, and treat the `defverb`-style macro as the first
concrete build item *of* that tier (it is also the only item here with tier-0
value, if the MCP surface is wanted early). When tier 2 is re-evaluated against
the recorded triggers, weigh this analysis alongside the granularity argument:
Jido is preferred not only because its unit of agency fits the mechanical
plane, but because its macro-native construction is what makes a *governable*
harness — compile-time invariants, compiled tool schemas, replayable reducers —
cheap rather than heroic.

# Citations

- Elixir stdlib metaprogramming — https://hexdocs.pm/elixir/Code.html ·
  https://hexdocs.pm/elixir/Macro.html · https://hexdocs.pm/elixir/Module.html
  (all APIs named in §1 present well before this repo's Elixir 1.14 floor).
- Jido.Action — https://hexdocs.pm/jido_action (verified 2026-07-14: `use
  Jido.Action` with name/description/schema; compile-time configuration
  validation at macro expansion; runtime parameter validation before `run/2`
  via NimbleOptions/Zoi; `to_tool/0` producing an LLM-compatible tool
  definition).
- Tidewave — https://tidewave.ai (verified 2026-07-14: Dashbit; runtime
  intelligence over MCP — database access, logs, code execution, docs lookup —
  for coding agents including Claude Code; Phoenix/Rails integration).
- Ash AI — https://hexdocs.pm/ash_ai (verified 2026-07-14: `tools do` exposing
  resource actions as LLM tools; prompt-backed actions via `run prompt()`;
  `vectorize do`; MCP server support).
- Prior analyses this extends —
  [BEAM deployment and Jido 2 evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md) ·
  [managed minds, owned machinery](/meta/analysis/claude-managed-agents-vs-beam-jido.md).
- Caveats: the BEAM-sandboxing point in §2 (AST whitelisting is policy, not
  containment) is from general BEAM knowledge, not re-verified against a
  primary source this session; Jido version/floor facts are carried from the
  2026-07-12 baseline in the BEAM/Jido evaluation, not re-checked.
