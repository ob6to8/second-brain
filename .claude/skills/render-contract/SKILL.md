---
name: render-contract
description: Recompile CLAUDE.md from the source policy documents under meta/policy/. Use after editing any meta/policy/*.md or meta/preamble.md, or when `mix brain.contract --check` reports the contract is stale. CLAUDE.md is a generated artifact and must never be hand-edited.
---

# /render-contract — compile the operating contract

`CLAUDE.md` is **generated**, not authored. Its source of truth is:

- `meta/preamble.md` — fixed framing text
- `meta/policy/*.md` — the rules, as `type: policy` OKF documents

The compiler is the Elixir mix task `brain.contract` (`lib/elixir_mind/contract.ex`).
It groups each policy under its declared `section`, orders by `order`, and emits a
visible trace link under each rule back to its `meta/policy/<id>.md`.

The end-to-end flow — touch-sequence, actor boundaries, invariants, and the
scenario test that pins the spine — is narrated in
[`meta/flows/render-contract.md`](/meta/flows/render-contract.md).

## When to use
- After adding, editing, superseding, or reordering any policy under `meta/policy/`.
- After editing `meta/preamble.md`.
- When `mix brain.contract --check` reports `CLAUDE.md` is stale.

## Procedure
1. Ensure Elixir/OTP is available: `elixir --version`. If missing in this sandbox,
   install it (e.g. `apt-get install -y elixir`).
2. From the repo root, regenerate the contract:
   ```
   mix brain.contract
   ```
3. Verify:
   ```
   mix brain.contract --check   # should report "up to date"
   mix test                     # compiler + parser tests should pass
   ```
4. Review `git diff CLAUDE.md`, then commit the source change **and** the regenerated
   `CLAUDE.md` together in one commit.

## Rules
- **Never hand-edit `CLAUDE.md`** — it is overwritten on the next compile. Edit the
  policy docs instead.
- To change a rule, edit its `meta/policy/<id>.md`, or add a new one with the correct
  `section` and `order`, then recompile. The **authoritative section list is the
  ordered `@sections` in `lib/elixir_mind/contract.ex`** (as of 2026-07-11:
  composition, directory-structure, filing, type-vocabulary, verification,
  conformance, skills, session-workflow, git-workflow) — a policy naming any other
  section fails the compile, so check the code, not this list, when in doubt.
- Adding a genuinely new contract *section* is a compiler change: add
  `{key, heading}` to `@sections` in `lib/elixir_mind/contract.ex` at the position
  it should render, then recompile.
- Adding a genuinely new *kind* of rule, a new `type`, or a new top-level directory
  still follows governance: propose it to the operator first.
