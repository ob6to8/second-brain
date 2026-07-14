---
type: plan
title: Code review toolchain hardening
description: The 2026-07-11 top-down code review + docs staleness audit, retyped as a plan now that its residue is action — the review's findings and verdict as background, then the scoped hardening work it recommends (materialize orphan removal, a verifier type-gate on `verified`, a small hygiene batch) with explicit out-of-scope decisions and a build order.
status: done
provenance: "Claude Code session, 2026-07-11 — operator-requested top-down review; staleness sweep partly delegated to a parallel read-only subagent, every reported finding independently re-verified. Retyped from `type: analysis` at operator direction: the write-up boils down to action."
tags: [meta, plan, code-review, staleness, tooling, route-tagging, verifier, flows]
timestamp: 2026-07-12
attribution:
  when: 2026-07-11T07:13:22+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
  from: [/meta/threads/2026-07-12-code-review-flows-hardening-and-elaborations.md]
---

# Plan — code review toolchain hardening

**Status:** `done` — executed 2026-07-12 per §4 after operator ratification.
P1 landed as the two-directional `materialize` (orphan removal unconditional;
the issue is `resolved`, pinned by two scenario tests). P2 landed as verifier
rule 6 (`verified` only on `claim`/`note`/`concept`; the one live violation —
`verified: false` on the testing methodology — was cleaned in the same
commit). P3 landed as the five hygiene items, with a regression test for the
ledger scoping. The out-of-scope list (§3) stands as decided.

**Question the review answered.** Is the toolchain correct, and does the
documentation still describe the system that actually exists? (Byproduct
mandate: think in terms of `meta/flows/` and document undocumented flows along
the way.)

**Verdict.** The system is in unusually good health. All gates were green at
review start (79 tests after this review's addition; verify, contract,
registry, route-tag checks all pass), every "generated, never hand-kept"
artifact matched its re-derivation, and the three tutorials' concrete claims
about exclusion lists, check counts, and workflow steps match the code
exactly. The review confirmed **two code defects** (one fixed, one filed as an
issue), **one code-vs-policy contradiction** (fixed), and **three stale doc
claims** (fixed). Everything else surveyed — README, `meta/index.md`, both
existing flow docs, the skills registry, glossary counts, plan/issue statuses,
registry header — checks out against the code as of `d830fd9`.

---

## 1. Background — findings already dispatched (done in the review change)

### F1 — Markdown renderer: link syntax inside a code span rendered live (fixed)

`SecondBrain.Markdown.inline/2` extracted **links before code spans**, so
inline code that *displays* link syntax — `` `[route tag](/beliefs/glossary/route-tag.md)` ``
— rendered as a live `<a>` inside `<code>` instead of staying literal.
Reproduced against the live renderer; affected real pages (the glossary hub,
`glossary/index.md`, the compiled contract, `filenames-and-cross-linking` and
`routing-ledger` policies, two skills). The existing "markdown inside a code
span is left literal" test only covered emphasis.

**Fix:** extract code spans first and restore them last
([markdown.ex](/lib/second_brain/markdown.ex), `inline/2`); a link label
containing a code span still works because the label's code placeholder
survives link extraction. Regression test added
([markdown_test.exs](/test/second_brain/markdown_test.exs), "link syntax
inside a code span is left literal").

### F2 — `mix brain.evidence` contradicted the grounding policy (fixed)

For a concept with no `verified_by` but a `resource`, the task printed
"**Grounded directly by resource:** …" — the exact claim
[verification-grounding](/meta/policy/verification-grounding.md) rejects ("a
statement is never grounded by its own link; storing a link proves nothing").
The verifier enforces the policy correctly; only the narrative output
contradicted it. **Fix:** the note now reads "Capture — stores resource: …
(trusted evidence, not a verifiable statement)."
([brain.evidence.ex](/lib/mix/tasks/brain.evidence.ex)).

### F3 — `materialize` cannot remove orphaned excerpt blocks (filed → §3 P1)

When a sink loses its **last** feeding thread, `run_checks/1` rightly fails on
the orphan block, but `--materialize` never visits unfed sinks, so no tool
path clears it — the only remedy is the hand-edit the section header forbids.
Filed with reproduction as
[route-tags-materialize-leaves-orphan-blocks](/meta/issues/route-tags-materialize-leaves-orphan-blocks.md);
this plan's P1 is its fix.

### F4–F6 — Stale documentation claims (all fixed)

- **F4** [`render-contract` skill](/.claude/skills/render-contract/SKILL.md)
  listed 6 valid contract sections; `contract.ex` defines **8** (`verification`
  and `session-workflow` were missing — both live, holding 5 policies between
  them). A policy authored per the skill's list would have looked invalid.
- **F5** [why-the-toolchain-runs-offline](/meta/tutorials/why-the-toolchain-runs-offline.md)
  said the SessionStart hook "runs `mix brain.contract`"; the hook runs
  `mix compile` to warm the cache and only *mentions* `brain.contract` in its
  ready message. The offline argument stands; the named command was wrong.
- **F6** [`meta/flows/index.md`](/meta/flows/index.md) still contrasted the
  genre against "`specs`" — the genre renamed to `plans` when spec/plan were
  unified.

One dangling reference was left deliberately: root `log.md`'s historical entry
linking `/meta/session-workflow.md` (deleted in the flows collapse) — frozen
log entries stay as written per the repo's own convention. *(Since overtaken:
main retired the hand-kept logs entirely the same day —
[retire-hand-kept-logs](/meta/plans/retire-hand-kept-logs.md) — deleting root
`log.md` and the dangling reference with it.)*

---

## 2. Background — the minor observations (the raw material for §3)

Code — recorded so a future session doesn't re-derive them; §3 decides which
become work:

- `Frontmatter` supports only inline `[a, b]` lists, not dash lists — by
  design (the schema says "inline YAML list"), but nothing *rejects* a dash
  list; it silently parses as no value for the key. Tolerable under
  tolerant-consumer, worth remembering when hand-writing frontmatter.
- The verifier does not restrict `verified` to statement types
  (`claim`/`note`/`concept`) — a resource-less `source` marked
  `verified: true` with edges would pass. The policy's type restriction is
  editorial today; the enforced invariants (capture ≠ verified, verified ⇒
  evidence) are the load-bearing ones.
- `RouteTags.parse_log_section/1` ends a section at the next `## ` heading
  while `replace_section/2` ends at `#` *or* `##` — an h1 immediately after a
  log section would be read as part of the blocks by one and preserved by the
  other. No concept doc currently does this.
- `ledger_doc_sinks/3` parses *every* pipe-table row in a thread doc, not just
  the `## Routing` section's — a non-ledger table whose 4th column links to a
  concept could produce a spurious warn-level ledger-coverage message. Warn
  only, never fails.
- `mix brain.id` requires `---\n` (LF) at byte 0; a CRLF file parses in
  `Frontmatter` (which normalizes) but would refuse minting. Cosmetic
  asymmetry.
- `mix brain.route_tags`'s closing line says "all check out" even when a
  warn-level result printed above it; the warning is visible either way.
- `Markdown.hr?/1` accepts exactly `---`/`***`/`___` (plus spaced variants) —
  a 4-dash rule renders as a paragraph. No bundle doc uses one.
- `Site.json_string/1` doesn't escape control characters below U+0020 other
  than `\n`/`\r`/`\t`; `plain_text/1`'s whitespace collapse makes this
  unreachable in practice.
- `pages.yml` repeats only the four *bundle-integrity* gates, not `mix test` /
  format — intentional and documented in the gating tutorial; noted because
  the workflow comment says "the same integrity checks CI runs", which is
  precise only on that reading.

Docs/tests — genuinely strong: the scenario-test pattern (in-code fixtures,
structured + targeted assertions, live-bundle guard) is applied consistently;
`route_tags_test.exs` has one red test per failure mode; the escaping
properties are pinned; the generated artifacts are all `--check`-guarded in
CI, the pages gate, and pre-commit.

---

## 3. The work — scope decision (implement most, not all)

The review's residue splits three ways: two substantive hardenings, a cheap
hygiene batch, and a set of non-changes where the "defect" is actually a
design stance worth keeping. **Not everything observed should be implemented**
— the out-of-scope list is part of the decision.

### P1 — `materialize/1` removes orphaned excerpt blocks (fixes the open issue)

Make materialization a true projection of the current tags **in both
directions**: also visit every sink that carries a
`## Thread excerpts — route-tagged log` section but no longer appears in
`feeding_pairs`, and remove the section (a sink that lost only *some* threads
is already handled — the full-section rewrite drops stale blocks).

**Design decision (settling the issue's open question): removal is
unconditional, no flag.** The section header itself declares the log
"generated … never hand-edit"; the tags are the single source of truth, so a
vanished tag *must* vanish from the sink or the two sources diverge. The
freeze-on-resolution concern is handled by review, not by the tool: removing a
frozen matter's tag is the anomaly, and the PR diff showing the block deletion
is where it gets caught — the same way every other generated-artifact change
is reviewed.

Deliverables: the `materialize/1` change; scenario-test extension in
[capture_scenario_test.exs](/test/second_brain/capture_scenario_test.exs)
(delete the only feeding region → materialize removes the section → all five
checks green; plus the partial case pinning that a still-fed sink drops a
stale block); mark the
[issue](/meta/issues/route-tags-materialize-leaves-orphan-blocks.md)
`resolved` and move it under Resolved in the issues index; update the
[session-capture flow doc](/meta/flows/session-capture.md) if it states the
one-directional behavior.

### P2 — Verifier: `verified` only on statement types

Enforce the [verification-grounding](/meta/policy/verification-grounding.md)
rule that verification is **only for agent-authored statements**: a `verified`
key (either value) on a concept whose `type` is not `claim`/`note`/`concept`
becomes a verifier error. This converts an editorial rule into a structural
one — the same procedural→structural direction as every other gate in this
repo — and it is cheap (one `grounding_errors/1`-style clause plus tests).

Pre-flight: scan the live registry for existing violations before enabling
(none expected — the `verified` column is populated only by statements and
glossary `concept`s today). Deliverables: the verifier clause; a red test in
[registry_test.exs](/test/second_brain/registry_test.exs) or the intake
scenario; a one-line update to the verifier rule list in
[intake §7](/meta/flows/intake.md) and the
[frontmatter-schema](/meta/policy/frontmatter-schema.md) policy's `verified`
row if its wording needs the sharper edge (then `mix brain.contract`).

### P3 — Hygiene batch (small, zero-risk, one commit)

1. **Scope `ledger_doc_sinks/3` to the `## Routing` section** — parse rows
   only between that heading and the next `##`, eliminating the
   false-positive class entirely (it's the flow's own data model: the ledger
   is a section, not "any table").
2. **Align the section terminators** — make `parse_log_section/1` stop at
   `#` or `##` like `replace_section/2`, removing the asymmetry.
3. **`mix brain.id` tolerates CRLF** — normalize like `Frontmatter` does
   before matching the opening `---`.
4. **`mix brain.route_tags` closing line acknowledges warnings** — "… all
   check out (1 warning above)" when any `:warn` result printed.
5. **`pages.yml` comment precision** — "the same *bundle-integrity* checks CI
   runs" (tests/format intentionally not repeated).

### Out of scope — observed, deliberately not implemented

- **Dash-list rejection in `Frontmatter`** — tolerant-consumer is OKF policy;
  a rejection would be a conformance change, not a fix. Revisit only if a
  silent dash-list actually bites.
- **4-dash `hr`, setext headings, and other renderer generality** — the
  renderer is deliberately scoped to what the bundle uses; generality without
  a consumer is dead weight.
- **`Site.json_string/1` control-char escaping** — unreachable through
  `plain_text/1`; would be code without an input.
- **An eval layer over the judgment steps** — already deferred with rationale
  in [flows-genre-and-scenario-testing §7](/meta/plans/flows-genre-and-scenario-testing.md);
  nothing in this review changes that calculus.

---

## 4. Build order (once ratified)

1. **P1** — materialize both directions + scenario extension; resolve the
   issue; gate suite.
2. **P2** — pre-flight scan, verifier clause + red test, doc/policy touch-ups,
   `mix brain.contract` if a policy changed; gate suite.
3. **P3** — the five hygiene items in one commit; gate suite.
4. Update this plan to `done` (the change narrative lives in the commit
   messages; the hand-kept logs were retired).

Each step lands independently green; P1 is first because it closes the only
open defect. Estimated total: small — the largest piece (P1) is one function
plus tests.

---

## 5. Byproduct of the review: the flows genre grew from 2 to 7

The review walked every multi-step action of the brain; the five that lacked a
flow doc now have one, each following the genre's three-artifact model and
honest about where its deterministic spine ends:

- [render-contract](/meta/flows/render-contract.md) — fully deterministic;
  judgment lives upstream in ratification. *(This branch's `contract-render.md`
  was unified into main's independently-written `render-contract.md` — same
  flow, one doc — when the two merged; main's carries the scenario test.)*
- [site-build-and-deploy](/meta/flows/site-build-and-deploy.md) — fully
  unattended; the deploy gate makes "live site" ≡ "verified bundle".
- [research-inbox](/meta/flows/research-inbox.md) — almost all judgment; the
  structural guarantee is the registry's namespace exclusion.
- [add-to-glossary](/meta/flows/add-to-glossary.md) — intake's spine, shared
  pin; the judgment layer is extract/dedup/define.
- [create-pull-request](/meta/flows/create-pull-request.md) — a composition of
  capture + glossary + the git/GitHub tail; capture-before-commit is the
  load-bearing ordering.

Both pipelines the flows plan named as anticipated follow-ups (the status note
of [flows-genre-and-scenario-testing](/meta/plans/flows-genre-and-scenario-testing.md))
are among them. The pre-existing flows' naming convention
(`<flow>_scenario_test.exs`) was not retrofitted onto contract/site — their
existing module tests already pin those spines, and the new flow docs say so
explicitly rather than demanding duplicate test files.
