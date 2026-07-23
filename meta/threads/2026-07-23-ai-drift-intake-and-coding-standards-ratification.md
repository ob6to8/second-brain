---
type: reference
title: 2026-07-23-ai-drift-intake-and-coding-standards-ratification
description: "Intake of Zornek's Guarding Against AI Drift article and his LocalCents CODING_STANDARDS.md into a new code-quality subdirectory, then operator-ratified absorption into the repo itself: an elixir-coding-standards contract policy (new section 10) and three new guardrails (test warnings-as-errors, the xref coupling gate, CI-only actionlint), with a dev-history staleness catch and fix along the way."
provenance: "Claude Code session (Opus 4.8, then Fable 5), 2026-07-23; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, intake, code-quality, coding-standards, guardrails, drift, ci]
timestamp: 2026-07-23T18:10:00Z
session: https://claude.ai/code/session_01Mj8gmkjrbZgNdDqewr3Uam
---

# 2026-07-23-ai-drift-intake-and-coding-standards-ratification

## Where this landed

Two connected `/intake`s, then a ratified absorption pass. The operator asked to
intake Mike Zornek's "Guarding Against AI Drift" article and examine it for
aspects worth absorbing; mid-session they added his LocalCents
`CODING_STANDARDS.md` (pinning the `@spec` section, L47–L70) with the same ask.
Both were filed as `reference` docs in a new
`knowledge/SWE/agentic/code-quality/` subdirectory — and turned out to be two
halves of one loop: the standards file *is* the agent-read doc the article's
recurring-miss feedback loop promotes fixes into. The operator then ratified
implementing the strongest recommendations: a new
[elixir-coding-standards policy](/meta/policy/elixir-coding-standards.md)
rendered as contract section 10 (the contract is this repo's agent-read
coding-standards file — no freestanding `CODING_STANDARDS.md` that could
drift), plus three guardrails — `mix test --warnings-as-errors` (CI +
pre-commit), `mix xref graph --label compile-connected --fail-above 0` (CI +
pre-commit; zero coupling today, gate keeps it there), and actionlint over the
workflow files (CI-only carve-out, pinned 1.7.7). The gate-suite tutorial was
renumbered to the ten-gate table. The first push went red — not from the new
gates but from the dev-history freshness test catching that
`meta/dev-history.md` (last regenerated at PR #88) had diverged after PRs
#130–#132 merged to main; syncing the branch with main and regenerating fixed
it, and the follow-up run was green end to end. Two dedup gold rows were
harvested; no plain-recall regression.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| AI-drift article intake (Zornek) | closed | [guarding-against-ai-drift](/knowledge/SWE/agentic/code-quality/guarding-against-ai-drift.md) | - |
| LocalCents coding-standards intake (pinned `@spec` section) | closed | [elixir-coding-conventions-localcents](/knowledge/SWE/agentic/code-quality/elixir-coding-conventions-localcents.md) | - |
| Absorption: coding-standards policy + contract section 10 | closed | [elixir-coding-standards](/meta/policy/elixir-coding-standards.md) | - |
| Absorption: three new guardrails and gate renumbering | closed | [the-gate-suite-and-where-it-runs](/meta/tutorials/the-gate-suite-and-where-it-runs.md) | - |
| Dedup gold-row harvest from operator phrasings | closed | [dedup-probe](/meta/evals/dedup-probe.md) | - |
| dev-history staleness caught by CI; regenerated through PR #132 | open | `unrouted` | upstream branch `claude/regenerate-dev-history` duplicates this fix — close whichever lands second |
| Gate-suite tutorial residual drift (glossary/lineage/dev_history gates absent from its table) | open | `unrouted` | refresh the tutorial's table to the full current CI list, or file a todo |

## User

/intake https://mikezornek.com/posts/2026/7/guarding-against-ai-drift/?utm_source=reddit&utm_campaign=guarding-against-ai-drift

also, examine it for aspects that could/should be absorbed into this repo

## Assistant

I have the full picture. The repo already embodies the article's core thesis (structural gates against drift), and most of its Elixir-specific tooling either already exists here or conflicts with the deliberate no-dependency/offline design. Let me file the article, then report the absorption analysis.

Placement: this is a solo-dev guardrail playbook against AI quality drift — distinct from `adoption` (org maturity models). I'll create `knowledge/SWE/agentic/code-quality/` (a subdirectory under the established `agentic` domain — autonomous per the taxonomy protocol).

## User

also /intake https://github.com/zorn/local_cents/blob/4b5e4f4b190aa3b4e6803746a92d3a9a25c83401/CODING_STANDARDS.md?plain=1#L47-L70

and examine for possible coding standards worth absorbing?

## Assistant

<routes ref="em:8d9b89 em:1ec778">
The full standards file is now captured. Notably, `local_cents` is Zornek's own repo — so this `CODING_STANDARDS.md` is literally the "standards doc the agent reads" that the AI-drift article's feedback loop feeds into. The two intakes are directly connected.
</routes>

Let me check whether this repo has its own coding-standards doc and how its `lib/` code uses `@spec`, to ground the "worth absorbing" analysis.

Both rows parse correctly. `guarding against ai drift` hits plain search; `coding standards worth absorbing` is a plain miss recovered by its expanded variants — exactly the vocabulary-gap case the gold set exists to track (non-gating). Let me verify the committed baseline table is internally consistent.

Committed baseline matches a fresh run — internally consistent, no regression, and the probe is non-gating in CI. All content gates are green (`verify`, `route_tags`, `contract --check`; the one `route_tags` warning is pre-existing and unrelated). Let me run the remaining `--check` gates CI uses and review the diff.

Both intakes are filed, verified, committed, and pushed to `claude/ai-drift-article-review-l04pr2`.

**What was filed**

I created a new `knowledge/SWE/agentic/code-quality/` subdirectory (autonomous — it sits under the established `agentic` domain) holding two `reference` docs that turned out to be directly connected (both by Mike Zornek; the second is literally the standards doc the first article's feedback loop feeds):

<routes ref="em:8d9b89">
- **[Guarding Against AI Drift (Mike Zornek)](https://github.com/ob6to8/elixir-mind/blob/claude/ai-drift-article-review-l04pr2/knowledge/SWE/agentic/code-quality/guarding-against-ai-drift.md)** (`em:8d9b89`) — the AI-drift concept + the two-layer remedy (automated guardrails / non-delegated layered review) + the misses-update-the-standards-doc loop.
</routes>

<routes ref="em:1ec778">
- **[Elixir coding conventions (Zornek's LocalCents standards)](https://github.com/ob6to8/elixir-mind/blob/claude/ai-drift-article-review-l04pr2/knowledge/SWE/agentic/code-quality/elixir-coding-conventions-localcents.md)** (`em:1ec778`) — the transferable `@spec`/typespec/doc conventions, foregrounding the pinned L47–L70 section.
</routes>

Both link fetched and captured in full (small enough to distill faithfully). Indexes updated, ids minted, registry regenerated, two dedup gold rows harvested (**no plain-recall regression**). Gates green: `verify`, `route_tags`, `contract --check`, `registry --check`, `glossary`.

**Examine — what's worth absorbing into this repo**

The headline: **this repo already embodies both sources' core thesis** — convert discipline into structure so drift announces itself (the gate suite + compiled contract). Most specifics are either already here or deliberately declined.

<routes ref="em:8d9b89">
**From the AI-drift article — mostly already covered or in tension:**
- Already running: `mix compile --warnings-as-errors`, `mix format --check-formatted`, `mix test`, plus the brain-specific validators.
- Design tension, not a drop-in: Credo/Dialyzer/Sobelow/mix_audit are dependency-based scanners; this repo is deliberately **dependency-free and offline**, and it has no Phoenix/deps to scan. Adopting them would break that stance for little signal.
- **Genuinely worth considering** (all operator-ratifiable, none autonomous): `actionlint` on `.github/workflows/ci.yml`; test-warnings-as-errors (`mix test --warnings-as-errors`); `mix xref graph --label compile-connected` as a coupling check on `lib/`. `mix docs --warnings-as-errors`, coverage, Dependabot, usage_rules don't apply (no ExDoc, no deps).
</routes>

<routes ref="em:1ec778">
**From CODING_STANDARDS.md — transferable to this repo's plain Elixir tooling:**
- **`@spec` argument naming** (name generic types like `binary()`/`String.t()`; leave domain types bare) — directly applicable; this repo's `@spec`s do carry unnamed primitives.
- **Long-spec one-per-line layout**, and **don't restate the return tuple in `@doc` prose** — applicable.
- **`_ = expr` for ignored returns**, and the **why-not-what moduledoc/comment style** — the latter matters because `mix brain.codemap` derives from `lib/` docstrings.
- **Meta-principle match:** its "keep each fact in one place; the standards file is an index that links, not restates" *is* this brain's single-overview/compiled-contract move.
- **Notable contrast, not to absorb:** LocalCents mandates **no AI attribution/co-authorship trailers** — the exact opposite of this bundle's `merge-strategy` policy relying on the `Claude-Session:` trailer for commit→session traceability.
</routes>

These absorption items are governance/tooling changes for you to ratify — I've captured them in the docs but haven't changed any repo tooling or added a coding-standards file. If you'd like, I can file the strongest candidates (actionlint, `@spec` naming, test-warnings-as-errors) as `/todo`s, or draft a first `meta/policy` or `CONTRIBUTING`-style conventions doc for review.

## User

captured them in what docs?
yes let's both implement the strongest recommendations and implement a coding standards file that reflects the state and philosophy of the repo

## Assistant

They're captured in the two reference docs I filed — the [AI-drift doc's "Relevance to this bundle" section](https://github.com/ob6to8/elixir-mind/blob/claude/ai-drift-article-review-l04pr2/knowledge/SWE/agentic/code-quality/guarding-against-ai-drift.md) and the [LocalCents doc's "transferable conventions" sections](https://github.com/ob6to8/elixir-mind/blob/claude/ai-drift-article-review-l04pr2/knowledge/SWE/agentic/code-quality/elixir-coding-conventions-localcents.md) — i.e. as *knowledge about* the recommendations, not as any change to the repo's tooling or governance. Nothing was implemented yet.

Now let's implement. First, some ground-truth checks: whether the candidate gates actually work on this toolchain (the repo pins Elixir 1.14, and `mix test --warnings-as-errors` may postdate it), whether `xref` shows any compile-connected coupling today, and how the contract compiler orders policy sections — since the right home for a standards file in *this* repo's philosophy is a `type: policy` doc compiled into `CLAUDE.md`, not a freestanding root file that can drift.

All 16 tasks already carry `@impl Mix.Task` — the convention is fully in place (my earlier grep only looked for `@impl true`). So the policy codifies existing practice there, which is exactly what "reflects the state of the repo" wants. No code retrofit needed.

Now implementing. First, validate actionlint against the existing workflows locally before I wire it into CI — I don't want to push a red gate:

The failure is **not** the new warnings flag — it's the dev-history freshness test: `DevHistory.check()` returned `{:stale, "meta/dev-history.md"}` on CI's full-history checkout (locally it self-skips on our shallow clone, so it can't reproduce here). Run 811 passed at 05:11 with the same test, so `main` has likely moved since — let me confirm how the check derives and whether this is drift from a merge on `main` today:

`origin/main` moved today — PRs #130–#132 merged after our branch was cut, so the branch's checked-in `meta/dev-history.md` went stale beyond what the lag-tolerance accepts. The fix is the repo's own prescription: sync the branch with main and regenerate. Let me look at why lag-tolerance didn't cover it, then sync:

Regenerated — now current through PR #132 and the check is green. (I also noticed an upstream branch `claude/regenerate-dev-history` appeared — another session may have spotted the same drift; the operator may want to close whichever lands second.) Now the full local gate pass — with the unshallowed clone, the previously-skipped live dev-history test now actually runs:

## User

Continue from where you left off.

## Assistant

**CI is fully green** — run 827 passed every step, including all three new guardrails. Both requests are complete.

**The coding standards file**

<routes ref="meta/policy/elixir-coding-standards.md">
Following the repo's own philosophy (a freestanding `CODING_STANDARDS.md` would be a second agent-read surface that can drift), the standards live as a **`type: policy` doc compiled into the contract** — the contract *is* this repo's agent-read standards file, and the article's "recurring miss → update the standards doc" loop maps onto the existing edit-policy-recompile flow:

- **[`meta/policy/elixir-coding-standards.md`](https://github.com/ob6to8/elixir-mind/blob/claude/ai-drift-article-review-l04pr2/meta/policy/elixir-coding-standards.md)** → rendered as new **contract section 10, "Elixir tooling — coding standards"** (I added the `tooling-standards` section key to `contract.ex` and recompiled `CLAUDE.md`). It carries: the structural gates; the guardrail **admission rule** (signal beats upkeep + runs offline as plain mix, with a CI-only carve-out for checks whose subject exists only in CI); the **intentional gaps** (no Credo/Dialyzer/Sobelow/coverage gate — zero-dependency stance, re-evaluate if `lib/` grows); and the editorial conventions absorbed from LocalCents (`@impl` names the behaviour, `@spec` argument naming and wrap layout, load-bearing moduledocs, no restating specs in `@doc`, `_ = expr`, narrowest-public-surface testing). Notably the codebase **already conformed** to `@impl Mix.Task` throughout, so that codifies practice rather than forcing a retrofit.
</routes>

**The implemented guardrails**

1. **`mix test --warnings-as-errors`** — CI + pre-commit hook.
2. **`mix xref graph --label compile-connected --fail-above 0`** — CI + pre-commit; the compile-coupling count is zero today and the gate keeps it there.
3. **actionlint** (pinned `1.7.7`) — CI-only over the workflow files; both workflows lint clean.

The gate-suite tutorial was updated to the new ten-gate table with renumbered prose.

**One find along the way**

The first push went red — but not from my gates: the **dev-history freshness test** caught that `meta/dev-history.md` (last regenerated at PR #88) had diverged from the merge graph after PRs #130–#132 landed on `main` today. I merged `origin/main` into the branch, regenerated the view through #132, and the follow-up push went green. Two things you may want to act on: there's an upstream branch `claude/regenerate-dev-history` that looks like another session addressing the same drift (now redundant), and the gate-suite tutorial's table still predates the `glossary`/`lineage`/`dev_history` CI gates — pre-existing drift I didn't expand into; happy to refresh it or file a todo.

Three commits are pushed to `claude/ai-drift-article-review-l04pr2` (intake, ratification, dev-history sync), CI green end to end. Say the word if you'd like `/create-pull-request`.
