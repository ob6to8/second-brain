---
name: priorities
description: List the brain's open work as a prioritized appraisal — open issues, todos, active plans, and dangling thread strands, with a heuristic top-3 the agent refines with judgment. Use when the operator says "/priorities", "what should I work on", "what's the top priority", or "show me open work".
---

# /priorities — the open-work appraisal

Surface everything the brain has left open and rank it, so a session can decide
what to work on. This is the on-demand successor to the old SessionStart digest:
the [session-init digest](/beliefs/glossary/session-init-digest.md) is no longer injected
automatically at session start — it is produced here, when the operator asks for
it. Follow the [operating contract](/CLAUDE.md).

The engine is unchanged: this skill runs the existing
[`mix brain.session_init`](/lib/elixir_mind/session_init.ex) task, which scans
four surfaces already kept current by policy and ends in a heuristic top-3. The
full mechanics — the four sources, the class weights, the `priority:` escape
hatch, and why *the script ranks, the agent judges* — are narrated in
[`meta/tutorials/the-session-init-digest.md`](/meta/tutorials/the-session-init-digest.md).

## Procedure

1. **Generate the digest.** From the repo root:
   ```
   mix brain.session_init
   ```
   (If Elixir is missing in this sandbox, install it: `apt-get install -y elixir`.)
   The task reads `meta/issues/` (status `open`), `meta/todos/` (status `open`),
   `meta/plans/` (`proposed`/`accepted`/`in-progress`), and the `## Routing`
   ledgers under `meta/threads/` (rows `open`/`paused`, or carrying a dangling
   question), then prints a markdown digest closing with a heuristic top-3.

2. **State your own appraisal.** Relay the digest, then give the operator your
   **top-3 priority appraisal** — start from the heuristic ranking, adjust it
   with judgment (the script is deterministic but semantics-blind; you know what
   this session is actually about), and say *why* each pick ranks where it does.
   The script ranks; you judge.

## Notes
- **Read-only.** This skill changes no files — it is a reader, not a gate. To act
  on a pick, hand off to the relevant skill (`/todo`, `/issue`, `/plan`) or open
  the doc directly.
- **The operator's escape hatch.** An issue/todo/plan carrying an integer
  `priority:` frontmatter key (1 = most urgent) is pinned above every heuristic
  class. If the ranking is wrong, that key — not this skill — is where the
  operator corrects it.
- Never touch `deprecated/`.
