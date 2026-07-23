---
id: em:1ec778
type: reference
title: "Elixir coding conventions (Zornek's LocalCents standards)"
description: The transferable Elixir/typespec/documentation conventions from LocalCents' CODING_STANDARDS.md — an agent-read standards index built on the house rule of keeping each fact in one place — foregrounding the @spec argument-naming and layout rules the operator pinned.
resource: https://github.com/zorn/local_cents/blob/4b5e4f4b190aa3b4e6803746a92d3a9a25c83401/CODING_STANDARDS.md
provenance: "Mike Zornek, LocalCents repo (zorn/local_cents), CODING_STANDARDS.md @ 4b5e4f4"
tags: [elixir, typespec, coding-standards, documentation, craft, agentic-coding, code-review]
timestamp: 2026-07-23T00:00:00Z
attribution:
  when: 2026-07-23T00:00:00Z
  channel: intake
  agent: "operator via /intake, Claude Code session"
  why: "operator pinned CODING_STANDARDS.md L47-L70 and asked which standards are worth absorbing into this repo"
---

# Elixir coding conventions (Zornek's LocalCents standards)

This is the *standards document the agent reads* — the very artifact the feedback
loop in [Guarding Against AI Drift](/knowledge/SWE/agentic/code-quality/guarding-against-ai-drift.md)
(same author) promotes recurring AI misses into. Its own governing principle is
one this brain shares: it is an **index, not a restatement** — where a rule
already has an authoritative home (a guide, an ADR, or `CLAUDE.md`) the file
*links* there rather than copying it, keeping each fact in one place. Only
homeless rules are written out in full. `/code-review`'s Standards axis discovers
the file automatically.

Below are the **transferable** conventions — the ones that apply to plain Elixir
library code, distilled from the source. App-specific rules (Phoenix v1.8
layouts, LiveView events, Tailwind/Bond/Storybook frontend, Rust/Tauri) are noted
at the end as *not* transferable to this bundle's tooling code.

## Typespec conventions (the pinned section, L47–L70)

- **Name `@spec` arguments whose type doesn't reveal their role.** Annotate a
  primitive or generic argument type with a name so the argument's purpose is
  legible from the spec alone, without opening the function body. The test: can a
  reader tell what the argument is *from its type*? If not — `binary()`,
  `String.t()`, `integer()`, `number()`, `map()`, `keyword()`, `term()` — name it;
  match the name to the actual parameter.

  ```elixir
  # Not this — opaque types, no idea what each is:
  @spec add_expense(binary(), String.t(), number(), integer()) :: binary()

  # This — each argument reads for itself:
  @spec add_expense(
          doc_bytes :: binary(),
          description :: String.t(),
          amount :: number(),
          time :: integer()
        ) :: binary()
  ```

- **Leave a type bare when it is already self-describing.** A domain type carries
  its own meaning and a name would be noise: `Book.id()`, `Expense.t()`,
  `DateTime.t()`, `Plug.Conn.t()` — *unless* two of the same type sit side by side
  (`now :: DateTime.t()`, `then :: DateTime.t()`).

- **Component `@spec`s use the precise public type, not `map()`.** For a Phoenix
  component, `alias Phoenix.LiveView.{Rendered, Socket}` once at the module top and
  write `@spec my_component(Socket.assigns()) :: Rendered.t()` — `Socket.assigns()`
  is the exact public type (`map | assigns_not_in_socket()`); the alias keeps the
  line readable. (Phoenix-specific in form, but the *principle* — spec the precise
  public type over a bare `map()` — generalizes.)

- **Stack a long `@spec` one entry per line, return type on its own line.** When a
  spec wraps, put each argument on its own line and pull the return type onto its
  own line after `::`. A newline right after the opening `(` nudges the formatter
  into keeping the shape. Short specs stay on one line.

  ```elixir
  @spec add_expense(
          doc_bytes :: binary(),
          description :: String.t(),
          amount :: integer(),
          time :: integer()
        ) ::
          binary()
  ```

## Documentation & comment conventions

- **`@impl` names the behaviour; never `@impl true`.** Annotate callbacks with the
  explicit behaviour module (`@impl Phoenix.LiveView`, `@impl GenServer`, …). `@impl
  true` is ambiguous about *which* contract the callback implements.

- **When a `@spec` states the return shape, don't restate the tuple in `@doc`
  prose.** The `@spec` (rendered inline by ExDoc) and a doctest own the literal
  shape; reserve prose for what the spec can't express — a behavioral summary and
  the *condition* under which each branch happens. Name outcomes semantically ("a
  `:not_found` error for an unknown id", "returns the created `Expense`") rather
  than transcribing `{:ok, …}` / `{:error, …}`. This extends "explain the *why*,
  not the *what*" and "never restate the signature" to the return value.

- **Moduledocs/typedocs & comments follow a house style**: summary-first line,
  explain the *why*, backtick domain concepts; inline comments carry durable *why*
  and never restate the signature. Single-use, reviewer-facing rationale goes in a
  PR comment, not the source; future-work asides become issues.

## General Elixir hygiene

- **Discard an ignored return with `_ = expr`.** When a call is fire-and-forget and
  its result genuinely doesn't matter (e.g. a best-effort
  `Phoenix.PubSub.broadcast/3` after the real work already succeeded), bind it to
  `_` so the disinterest is *explicit* rather than a bare dangling expression.

- **Test observable behavior through the narrowest public surface** — default to a
  context's boundary API over its internals; reach inside only for a guarantee the
  API can't express.

- **Coverage is a local, exploratory tool, not a gate** — no threshold, absent from
  precommit and CI (matches this bundle's own stance).

## Meta-principles worth noting

- **Keep each fact in one place; the standards file is an index that links to the
  authoritative home** rather than a second copy that can drift. This is exactly
  this brain's [single-overview convention](/beliefs/glossary/single-overview-convention.md)
  and [compiled-contract](/beliefs/glossary/compiled-contract.md) move, applied to
  a coding-standards doc.
- **A notable *contrast* with this repo:** LocalCents mandates **no AI attribution
  or co-authorship trailers** on commits/PRs (attribution is to the human author) —
  the opposite of this bundle's [merge-strategy](/meta/policy/merge-strategy.md)
  policy, which relies on the harness-injected `Claude-Session:` trailer for
  commit→session traceability. Same craft instinct, opposite provenance decision.

## Not transferable (app-specific)

Phoenix v1.8 conventions (Layouts.app wrapper, `<.input>`/`<.icon>`,
`current_scope` routing, `Req` HTTP client), snake_case LiveView event names,
Tailwind v4 + hand-authored Bond components mirrored in Storybook, `_display`-suffixed
component attributes, `:boundary` compiler contexts, `"<kind>:<id>"` PubSub topic
naming, and Rust/Tauri minimalism — all specific to a Phoenix/Tauri desktop app and
inapplicable to this bundle's dependency-free mix-task tooling.

# Citations

- Mike Zornek, `CODING_STANDARDS.md`, LocalCents (`zorn/local_cents`), commit
  `4b5e4f4`.
  <https://github.com/zorn/local_cents/blob/4b5e4f4b190aa3b4e6803746a92d3a9a25c83401/CODING_STANDARDS.md>

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:1ec778">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-23-ai-drift-intake-and-coding-standards-ratification (2026-07-23)

3 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:1ec778`]**  (co-feeds: `em:8d9b89`)

The full standards file is now captured. Notably, `local_cents` is Zornek's own repo — so this `CODING_STANDARDS.md` is literally the "standards doc the agent reads" that the AI-drift article's feedback loop feeds into. The two intakes are directly connected.

---

**[`em:1ec778`]**

- **[Elixir coding conventions (Zornek's LocalCents standards)](https://github.com/ob6to8/elixir-mind/blob/claude/ai-drift-article-review-l04pr2/knowledge/SWE/agentic/code-quality/elixir-coding-conventions-localcents.md)** (`em:1ec778`) — the transferable `@spec`/typespec/doc conventions, foregrounding the pinned L47–L70 section.

---

**[`em:1ec778`]**

**From CODING_STANDARDS.md — transferable to this repo's plain Elixir tooling:**
- **`@spec` argument naming** (name generic types like `binary()`/`String.t()`; leave domain types bare) — directly applicable; this repo's `@spec`s do carry unnamed primitives.
- **Long-spec one-per-line layout**, and **don't restate the return tuple in `@doc` prose** — applicable.
- **`_ = expr` for ignored returns**, and the **why-not-what moduledoc/comment style** — the latter matters because `mix brain.codemap` derives from `lib/` docstrings.
- **Meta-principle match:** its "keep each fact in one place; the standards file is an index that links, not restates" *is* this brain's single-overview/compiled-contract move.
- **Notable contrast, not to absorb:** LocalCents mandates **no AI attribution/co-authorship trailers** — the exact opposite of this bundle's `merge-strategy` policy relying on the `Claude-Session:` trailer for commit→session traceability.
