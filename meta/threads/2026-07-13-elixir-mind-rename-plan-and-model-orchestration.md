---
type: reference
title: 2026-07-13-elixir-mind-rename-plan-and-model-orchestration
description: Spec'd the second-brain → elixir-mind rename as a type:plan doc (rescoped mid-session to also migrate the sb: → em: stable-id prefix, retargeted from an earlier elixir-brain), plus a model-orchestration discussion (which tier executes a mechanical refactor; the diverge→converge Fable-plan→Opus-execute workflow; agent-employment judged doctrine-shaped, its model doctrine authored in a separate thread); opened PR #65, then a docs-coverage audit added Decision 6 (name-prose vs. code-identifier sweep) and origin/main was merged in.
provenance: "Claude Code session (Claude Fable 5, then Claude Opus 4.8 via /model), 2026-07-13; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, rename, identity, migration, model-selection, orchestration, planning]
timestamp: 2026-07-13
pr: 65
---

# 2026-07-13-elixir-mind-rename-plan-and-model-orchestration

Verbatim render. Retained operator messages and agent responses are reproduced
**verbatim** (the delivered text); only tool calls, tool results, reasoning, and
short pre-tool narration are stripped. Rendered from context via `/capture`'s
render-from-context path. The session ran on Claude Fable 5 and switched to
Claude Opus 4.8 via `/model` at the point marked below; the in-render discussion
of "Fable plans, Opus executes" is the workflow being reasoned about, and it
matched the session's own arc. **This doc was refreshed in place** after PR #65
opened, extending the render with the later exchanges (the docs-coverage audit,
the Decision 6 edits, and the `origin/main` merge) per the capture update-in-place
rule.

## Where this landed

The operator asked to **spec the rename of this repo and project from
`second-brain`**, and — across the session — the target and scope both moved:
first to `elixir-brain`, then retargeted to **`elixir-mind`**; and the scope was
rescoped from a name-only rename to **also migrate the stable-id prefix**
`sb:` → **`em:`**. The deliverable is one `type: plan` doc,
[`meta/plans/rename-second-brain-to-elixir-mind.md`](/meta/plans/rename-second-brain-to-elixir-mind.md)
(`status: proposed`). The plan was captured, opened as **PR #65**, then
hardened by a docs-coverage audit and caught up to `main`.

Settled shape of the plan:

- **Two atomic PRs.** Workstream A is the name rename (Elixir app/module
  namespace `SecondBrain` → `ElixirMind` / `:elixir_mind` / `lib/elixir_mind/`,
  the session hook, ~15 maintained docs, the frozen-thread `<routes>` path-ref
  sweep, and regenerated artifacts). Workstream B is the id migration: a
  deterministic, tail-preserving `\bsb:([0-9a-f]{6})\b` → `em:$1` pass across
  200 minted ids and ~940 tokens, the code/verifier flip (~65 `"sb:"` sites),
  and a stable-identity policy amendment. Both are atomic by construction — the
  verifiers reject any mixed `sb:`/`em:` state or unresolved path ref, so a
  partial migration can't merge green.
- **The `em:` prefix mirrors the display name** (e­lixir-mind) at the operator's
  direction, but stays opaque in the identity model — edges and route tags key
  on the full token, not its meaning. Because the migration rewrites every token
  in one deterministic pass, the replacement string is free to choose, so `em:`
  costs exactly what an arbitrary `eb:` would have. Decision 1's reasoning was
  inverted mid-session when the operator asked for `em:`: it had argued for
  holding the prefix stable across the brain→mind retarget; it now states the
  mnemonic-but-opaque rationale.
- **Six decisions for ratification** (id-prefix migration + policy amendment;
  a scoped freeze-exception to rewrite `sb:` tokens inside frozen thread bodies
  and dated records; updating `<routes>` path refs in frozen threads; renaming
  the one filed concept whose slug carries the name — plus its body module refs
  and inbound display text; proper-noun vs. category-term prose — where "mind"
  removes the collision "brain" would have had with the standing "second brain"
  category term; and **Decision 6**, added by a post-capture docs-coverage audit:
  sweep *live code identifiers* (`SecondBrain.`, `lib/second_brain/…`,
  `:second_brain`) everywhere they appear — grep-defined across ~37 doc surfaces,
  distinct from name-prose — resolving a keep-list trap where `meta/analysis/`
  was marked frozen yet held live `lib/second_brain/…` links).
- **Measured surface:** `grep -ri 'second[-_ ]?brain'` found 459 occurrences
  across 128 files (most frozen, generated, or category-term prose) at capture
  time; the id side was 200 `id:` fields / ~940 `sb:` tokens / 65 `"sb:"` code
  sites. **The `origin/main` merge (~100 commits) roughly doubled the id count**
  (363 files with `sb:` ids afterward), so the token figures are stale and must
  be re-measured at execution. `deprecated/` is excluded from both.
- **Merge reconciliation.** Merging `main` required adding the now-mandatory
  `attribution` block to the plan doc (main's resource-attribution policy +
  verify rule 8); the thread doc stays exempt. `meta/threads/index.md` conflicted
  (both sides added 2026-07-13 entries) — kept all of main's plus this one. Full
  gate suite green (156 tests).

The second strand was **model/agent orchestration**. The operator asked which
model to use to *execute* the rename (answer: Claude Opus 4.8 — the gate suite
carries the correctness burden, so it's long-horizon mechanical execution, not
frontier reasoning), then proposed and confirmed the **diverge→converge
workflow**: brainstorm a plan with the strongest model, hand the persisted plan
to a fresh executor instance, with Sonnet for volume and Haiku for
simple/parallel mechanical work. The operator then asked whether to codify this
as a **policy for employing agents including subagents**; the recommendation was
that it is **doctrine-shaped, not policy-shaped** (heuristic judgment, no
enforceable oracle; the main-session tier is operator-chosen, so only the
subagent-spawning slice is genuinely agent-actionable). The operator agreed and
leaned toward general scope — but a **separate thread had already authored the
model doctrine**, so no doctrine was created here; this strand closes unrouted
from this branch.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Rename `second-brain` → `elixir-mind` + `sb:` → `em:` id migration (the spec) | open | [rename plan](/meta/plans/rename-second-brain-to-elixir-mind.md) | Awaiting operator ratification (Phase 0), then execution by a fresh session |
| Model/agent tier selection & the diverge→converge workflow | closed | `unrouted` (model doctrine authored in a separate thread/branch) | - |

## User

I would like to rename this repo and all associated naming from "second-brain" to "elixir-brain". Spec out what this lift would look like

## Assistant

I'll survey the codebase for every place the "second-brain" name appears — the repo name, the Elixir app/module naming, the `sb:` id prefix, mix tasks, docs — then write up the rename spec as a `type: plan` doc under `meta/plans/` (status `proposed`, per the persist-plans policy) and push it to the designated branch.

The spec is done and filed as [`meta/plans/rename-second-brain-to-elixir-brain.md`](meta/plans/rename-second-brain-to-elixir-brain.md) (`status: proposed`, per the persist-plans policy), pushed to `claude/rename-second-brain-elixir-9b4d37` with the plans index updated. The full verify suite is green.

**The headline: the lift is smaller than it looks.** A full sweep finds 459 occurrences across 128 files, but most of that is frozen thread prose, the read-only `deprecated/` archive, dated records, and generated artifacts that recompile. The real work is one mechanical in-repo PR plus a few minutes of operator action on GitHub. Two lucky breaks keep it contained: the `mix brain.*` task namespace never mentions the repo name, and the CI workflows contain zero occurrences.

**The one sharp edge** is the route-tag verifier. Frozen thread docs carry path back-links like `<routes ref="lib/second_brain/session_init.ex">`, and `mix brain.route_tags` fails CI when a path ref doesn't resolve to a file on disk — so moving `lib/second_brain/` → `lib/elixir_brain/` breaks CI unless the ref attributes in ~10 thread docs are updated and the excerpt logs re-materialized in the same PR. My recommendation (Decision 2 in the plan): the tags are machinery applied *over* the frozen body, not part of the verbatim retained text, so updating them is routing-layer maintenance, not history rewriting.

**Four decisions await your ratification:**

1. **Keep the `sb:` id prefix** (strongly recommended). Ids are opaque and immutable by policy; migrating to `eb:` would rewrite every concept, evidence edge, route tag, and gold-set row — a separate, much larger plan if you ever want it.
2. **Update `<routes>` path refs in frozen threads** — the fix for the sharp edge above.
3. **Rename `elixir-second-brain-testing-methodology.md`** → `elixir-brain-testing-methodology.md`; its `sb:d58da3` id survives the move. (The "2026 second-brain field" analysis stays — there the term is the product category, not this repo.)
4. **Prose policy**: proper-noun uses ("Second Brain" as this repo's name) become Elixir Brain; generic category uses ("a personal second brain") keep the term, since the repo still *is* one.

**One permanent breakage to know about**: GitHub redirects git remotes, web URLs, and PR links after a repo rename, but **GitHub Pages does not** — `ob6to8.github.io/second-brain/` will 404 once the site redeploys at `/elixir-brain/`. The site itself needs no code changes (all links are relative), but any external bookmarks to the old Pages URL die.

The plan's build order: Phase 0 you ratify; Phase 1 is the in-repo PR (app/module rename, hook, ~15 maintained docs, ref sweep, regenerate all artifacts, full gate suite); Phase 2 you rename the repo in Settings and re-point the Claude Code environment source; Phase 3 is a first-session verification in the renamed repo. Say the word and I can execute Phase 1 on this branch.

## User

I would like to rescope The plan to include changing the IDs from Sb to Eb. I understand this increases scope.

## Assistant

The plan is rescoped and pushed — the id migration is now workstream B of the spec, with the original keep-`sb:` recommendation recorded as considered and overridden by your ruling.

**How the migration is designed to be safe.** It's a **prefix swap, never a re-mint**: every id keeps its 6-hex tail (`sb:4c9e1f` → `eb:4c9e1f`), so the mapping is total, collision-free, and reversible, and every cross-reference — `verified_by` edges, route tags, the dedup gold set, prose citations — stays consistent under one regex: `\bsb:([0-9a-f]{6})\b` → `eb:$1`. I measured the surface: **200 minted ids**, **~940 tokens** across the markdown corpus, and **65 `"sb:"` string sites** in `lib/` and `test/` (the format regexes in `registry.ex`, `verifier.ex`, `dedup_probe.ex`, the `classify_ref` clause in `route_tags.ex`, plus test fixtures).

**Two things your ratification of the plan now covers explicitly:**

1. **A stable-identity policy amendment.** The policy currently makes ids immutable outright; it gets reworded so the *tail* is the immutable identity and the *prefix* is the bundle's id namespace, changeable only by an operator-ratified bundle-wide migration — with this one recorded as the instance.
2. **A scoped frozen-body exception.** `sb:` ids appear in verbatim thread prose (e.g. the worked example quoting `sb:d479e3`), not just machinery. The plan recommends the rewrite be **global including frozen bodies and inbox digests** — leaving them would strand hundreds of permanently dangling identifiers, and since the mapping is 1:1 and documented, `eb:4c9e1f` denotes exactly what `sb:4c9e1f` did. The exception is scoped to that exact regex and nothing else; `deprecated/` stays untouched (its single token remains a legible fossil).

**Build order changed:** Phase 1 is now two sequential atomic PRs — **1a** the name rename (as before), **1b** the id migration (code flip + policy amendment + corpus rewrite + regeneration in one PR). The atomicity is enforced by your own tooling: the verifiers reject any mixed `sb:`/`eb:` state, so a partial migration can't merge green. One operational caveat in the risks: don't run other filing sessions while 1b is open, or they could mint a stale `sb:` id.

Estimate is now two focused sessions for Phase 1 instead of one, plus the same minutes of GitHub/operator action. Ratify the plan (status → `accepted`) and I can start executing 1a on this branch.

## User

What would be the best model to use for this

## Assistant

For executing this rename, **Claude Opus 4.8** (`claude-opus-4-8`) is the right choice for both PRs — and here's the reasoning specific to this task rather than generic model advice.

**Why the task doesn't need the top-tier model.** What makes this lift unusual is that your own tooling carries most of the correctness burden. Both phases end in a hard gate suite — `mix brain.verify`, `brain.route_tags`, the contract and registry `--check`s, the test suite, and the residue greps — and the plan is deliberately structured so a partial rename *cannot* merge green (the verifiers reject any mixed `sb:`/`eb:` state or unresolved path ref). When the harness is the safety net, you're paying for a model's diligence in driving a deterministic checklist to completion, not for frontier reasoning. That's exactly the profile Opus 4.8 is strongest at: it's state-of-the-art on long-horizon agentic execution — multi-hour mechanical refactors that finish without human correction — at half the price of Fable 5 ($5/$25 versus $10/$50 per million tokens).

**Where you're currently overpaying.** This session is running on Fable 5 (`claude-fable-5`), Anthropic's most capable model. It was a reasonable fit for the *spec* work — the policy-amendment reasoning in Decision 1 and the frozen-body exception in Decision 2 are the genuinely judgment-heavy parts of this plan, and they're now done and written down. Executing the plan is a different workload: the decisions are made, the steps are enumerated, and the verifiers adjudicate. Fable 5 would do it fine, but you'd be buying premium reasoning for grep-and-sed work.

Concretely, per phase:

| Work | Model | Why |
|---|---|---|
| Phase 1a (name rename) and 1b (id migration) | **Opus 4.8**, effort `xhigh` (Claude Code's default) | Long mechanical sweeps + regeneration + gate-driving; the plan doc is the full up-front spec Opus 4.8 works best from |
| The one prose-judgment step — wording the stable-identity amendment (1b step 2) | Opus 4.8 is sufficient | The *decision* is already ratified in the plan; the execution is drafting text against a settled design |
| Sonnet 5 as a budget alternative | Workable for 1a | Near-Opus on coding at $3/$15; I'd still use Opus for 1b since it touches every file in the bundle in one atomic PR |
| Haiku 4.5 | No | Wrong tier for a repo-wide atomic migration |

One practical note: give the executing session the plan doc as its starting instruction ("execute Phase 1a of `meta/plans/rename-second-brain-to-elixir-brain.md`"). Opus 4.8 performs best with the full task specification in one well-specified opening turn — which is precisely what the persisted plan gives you. If you want faster wall-clock time, fast mode (`/fast` in Claude Code) is available on Opus 4.8 at premium pricing, though for an unattended migration run, normal speed is the sensible default.

## User

_(model switched to Claude Opus 4.8 via `/model` at this point)_

So a good workflow could be - iterate and brainstorm with fable until a plan document is created, then load a fresh instance of opus to build off of the plan?

Where might sonnet and haiku be useful?
Also - lets change the name of this repo and project to "elixir-mind"

## Assistant

Both good questions, and yes — your workflow instinct is exactly the design intent. Let me answer that, then update the plan for the new name.

## The workflow

That's the intended shape, and it maps cleanly onto what each tier is built for:

- **Fable 5 — diverge.** Brainstorming, weighing alternatives, the genuinely load-bearing judgment calls (here: whether to migrate the id prefix at all, how to word the policy amendment, whether rewriting frozen bodies is legitimate). This is where you want the most capable reasoning and you don't mind minutes-long turns.
- **Fresh Opus 4.8 — converge.** Load the persisted plan as the opening instruction and execute. Opus 4.8 is strongest with the full spec given up front in one turn, which is *precisely* what a `type: plan` doc is. A fresh instance also sheds the brainstorming context, so it isn't re-litigating settled decisions — it just builds. The persist-plans policy is what makes this handoff possible at all: the plan survives the session boundary.

The key insight: the plan doc **is** the handoff artifact. Fable produces it; Opus consumes it. Nothing lives only in chat.

## Where Sonnet and Haiku fit

**Sonnet 5** is the volume workhorse — near-Opus quality on coding at $3/$15 vs Opus's $5/$25. Good fits here:
- Executing a **well-scoped, low-risk phase** where the gate suite backstops correctness. Phase 1a (the name sweep) is a candidate; I'd keep Opus on 1b since it re-keys every id in the bundle in one atomic PR.
- Any **high-throughput or repeated** job — batch intake runs, the `/research` feed, glossary backfills across many files.
- The **default for interactive coding** when you're iterating and cost adds up over many turns.

**Haiku 4.5** is for speed-critical, low-judgment work at $1/$5:
- **Classification and extraction** — "which directory does this concept belong in," tagging, routing decisions.
- **Mechanical single-file edits** where the change is fully specified.
- **Fast lookups** inside a larger pipeline (a subagent that greps and reports).

Rough rule: **Fable** when being wrong is expensive and reasoning is the bottleneck → **Opus** for long autonomous execution against a spec → **Sonnet** when you want most of Opus at scale → **Haiku** when the task is small, well-defined, and you want it now. A nice pattern for this repo: an Opus orchestrator that fans out Haiku subagents for the mechanical file-by-file sweeps, since those are independent and parallelizable.

## User

Continue

## Assistant

Done — the plan is retargeted to **elixir-mind** and pushed. The file was renamed to [`meta/plans/rename-second-brain-to-elixir-mind.md`](meta/plans/rename-second-brain-to-elixir-mind.md) (git tracked the move), the index entry updated, and the gate suite is green.

**What changed with the retarget:**
- Module namespace target is now `ElixirMind` / `:elixir_mind` / `lib/elixir_mind/`, repo `ob6to8/elixir-mind`, Pages `ob6to8.github.io/elixir-mind/`, concept slug `elixir-mind-testing-methodology.md`.
- I recorded the retarget explicitly in the plan (provenance, "The ask") so a future session sees that elixir-mind supersedes the earlier elixir-brain, rather than treating it as a fresh idea.

**Two judgment calls worth flagging**, both captured in the doc:
1. **The `eb:` prefix stays `eb:`, not `em:`.** The id prefix is an opaque namespace token with no obligation to abbreviate the display name — holding it stable across brain→mind avoids a second, gratuitous re-key of all 200 ids. If you ever *want* the prefix to mirror the name, that's its own ratified migration under the amended policy. Say the word if you'd rather it track the name.
2. **"Mind" actually improves Decision 5.** With "brain" as the target there was a subtle tension — the repo would be *named* "brain" while "second brain" remained the category term. "Mind" isn't the category word at all, so the new proper noun and the standing "second brain" category term no longer collide. I noted this in the decision.

---

On the workflow: your loop is the right one, and this exchange is a small live demo of it — Fable did the plan, and this retarget-and-rewrite (mechanical edit against a settled spec, gated by the verifiers) is exactly the converge-phase work Opus 4.8 is suited to, which is why the session switching to Opus mid-way fits cleanly. When you're ready to execute Phase 1a, a fresh Opus session pointed at this plan is the move.

## User

1- make the prefix em. This should either be the cost of changing the plan, or the samw cost of a rename to eb that was already done
2- Shall we make a policy regarding how and when to employ different agents, including subagents?

## Assistant

Two good threads. Let me handle the prefix change first — and your framing is exactly right, so let me make the cost explicit.

**Nothing has been executed yet** — the `eb:` migration lives only in the plan as `status: proposed`. So flipping `eb:` → `em:` is a pure plan edit (a few paragraphs), which is "the cost of changing the plan." And your second framing holds too: *had* the migration already run, re-keying `eb:` → `em:` would be the identical one-pass tail-preserving regex — the migration rewrites every token regardless of the replacement string, so the target prefix is free either way. `em:` (for **e**lixir-**m**ind) it is. Let me update the plan and invert the reasoning that previously argued for holding the prefix stable.

Done — item 1 is committed and pushed. The `em:` prefix now threads through the plan and index; Decision 1's reasoning is inverted (it previously argued for holding the prefix stable — now it states the prefix mirrors the name as a free mnemonic while the amended policy keeps it opaque); the only surviving `eb:` is the deliberate "costs exactly what `eb:` would have" comparison. Gates pass.

## On a policy for agent employment

Yes — it's worth codifying, and the persist-plans instinct applies: this guidance currently lives only in this chat, which is exactly the "durable decision stranded in a scrolling conversation" failure the brain is built to avoid. But I'd push back on one word in your question — **"policy" is probably the wrong genre**, and the reason is instructive.

The controlled vocabulary draws a sharp line:
- **`policy`** = a machine- or operator-*enforceable* rule; the source `CLAUDE.md` compiles from.
- **`doctrine`** = a standing *direction that informs judgment* without prescribing an enforceable action; sits *above* policy.

Model-tier selection is doctrine-shaped, not policy-shaped: "Fable to diverge, Opus to converge, Sonnet for volume, Haiku for the simple stuff" is a heuristic a session applies with judgment. There's no verifier that could gate "did you pick the right tier," and no crisp rule to enforce — which is the litmus test for policy vs. doctrine here.

There's also a subtlety that changes the shape of the artifact: **who actually acts on each piece.**

| Guidance | Who chooses | Genre fit |
|---|---|---|
| Main-session model tier | The **operator** (via `/model`) — the agent can only *recommend*, it can't self-select | Doctrine (informs the operator's judgment) |
| **Subagent** model + when to spawn vs. work directly | The **agent** (via the Agent tool's `model`/`subagent_type`) | The one genuinely agent-actionable slice |
| Plan→execute handoff (Fable plans, fresh Opus builds) | Orchestration pattern | Already half-encoded in persist-plans |

The subagent-spawning discipline is the only part a *fresh sandboxed agent* both controls and would benefit from having in front of it. And that surfaces the real fork: **doctrine doesn't compile into `CLAUDE.md`** (only `meta/policy/` does), so a doctrine doc under `meta/doctrine/` guides sessions that read it but won't automatically reach a fresh agent booting off the contract.

**My recommendation:** a `type: doctrine` doc — *"match the model to the work"* — under `meta/doctrine/`, capturing the tier heuristics and the diverge→converge workflow. Then, *if* you want the subagent-spawning discipline to bind fresh agents, add a thin `policy` that implements that one enforceable-ish slice and compiles into the contract's operations section (doctrine-implemented-as-policy is exactly the layering the vocab describes).

Two things I'd want you to settle before I draft it, since they change the artifact and adding governance is a shape change you ratify:

1. **Doctrine only, or doctrine + a compiled policy pointer** for the subagent slice? (I lean doctrine + thin policy, so fresh agents inherit the spawning discipline.)
2. **Scope:** just this brain's tooling work, or general enough to guide any agentic work the operator runs?

Say the word and I'll draft it as `status`-carrying governance for your review rather than committing it outright.

## User

1 agree
2 lean towards any and all, if you think that is wise

Another thread ended up creating the model doctrine. We can just wrap with the plan

## Assistant

Confirmed. The model doctrine lives in the other thread's branch — it's not in this working tree (this branch carries only the rename plan), so there's nothing to duplicate or reconcile here. And the two concerns are cleanly separate: the rename plan is about the `second-brain → elixir-mind` lift, not model selection, so it doesn't need to cite the doctrine. Nothing to wrap together at the file level.

**Where this branch stands** — `claude/rename-second-brain-elixir-9b4d37`, working tree clean, four commits pushed:

1. Initial rename spec (elixir-brain, `sb:` kept)
2. Rescope to include the `sb:` → `eb:` id migration
3. Retarget elixir-brain → **elixir-mind**
4. Prefix `eb:` → **`em:`** (mirrors the name, stays opaque in the model)

The deliverable is [`meta/plans/rename-second-brain-to-elixir-mind.md`](meta/plans/rename-second-brain-to-elixir-mind.md), `status: proposed`, gates green. It's a complete, ratifiable spec: two atomic PRs (name rename → id migration), five decisions, explicit scope boundaries, and a verifier-backed build order.

That's the session wrapped. Whenever you're ready, the natural next steps are independent of this branch:
- **Ratify** the plan (`status` → `accepted`) and hand it to a fresh Opus session to execute Phase 1a — per the workflow we discussed, the persisted plan is the whole handoff.
- Or **open the PR** for this planning branch if you want the spec reviewed/merged first — just say so and I'll run `/create-pull-request`.

No action needed from me unless you want one of those.

## User

_(invoked `/create-pull-request`)_

## Assistant

Done. **PR #65 is open:** https://github.com/ob6to8/second-brain/pull/65

What `/create-pull-request` did, in order:

1. **Captured** the session to `meta/threads/2026-07-13-elixir-mind-rename-plan-and-model-orchestration.md` — verbatim render, a `## Where this landed` narrative, and a two-row routing ledger. No route tags, because the session's only durable artifacts are the plan (a `type: plan`, no `sb:` id) and a doctrine that lives in another thread — there's no `sb:`-id concept sink to feed.
2. **Glossary** — a legitimate no-op: the vocabulary is already in the glossary (148 terms), and the new orchestration concepts belong with the separately-authored model doctrine.
3. **Elaboration back-links** — none created this session, skipped.
4. **Committed and pushed** the capture, then **stamped `pr: 65`** into the thread frontmatter and pushed that.

**The captured thread doc's final name:** `meta/threads/2026-07-13-elixir-mind-rename-plan-and-model-orchestration.md`.

All gates were green before the PR (`route_tags`, `contract --check`, `registry --check`, `verify`). The branch now carries six commits: four building the plan, one capture, one PR-stamp.

**Two honesty notes on the capture:**
- The render reproduces my mid-session claim that "this session is running on Fable 5" verbatim, and the provenance reflects it as `Claude Fable 5, then Claude Opus 4.8 via /model` — consistent with the commit co-authors and the `/model` switch, though I'll flag that the environment's own identity line named Opus 4.8 throughout, so there's some genuine ambiguity about the pre-switch model.
- Nothing about the model doctrine was written to this branch, per your instruction — it stays with the thread that authored it.

Want me to **watch this PR** for CI and review comments (via `subscribe_pr_activity`)? I won't subscribe unless you say so.

## User

Does this cover all docs as well as code?

## Assistant

Here's the honest answer: **the plan's categories are complete, but its docs coverage has a real gap — and one active conflict.** The audit found **37 doc files** carrying *live code-identifier* references (`SecondBrain.` modules, `lib/second_brain/…` paths, `:second_brain`), and the plan's docs-sweep step (1a.4) names only about half the surfaces they live in.

The distinction that matters — the plan half-conflates these:

- **Name-as-prose** ("Second Brain" the project, "the second-brain field" the category) → correctly handled: frozen threads stay, category term stays (Decision 5).
- **Code identifiers** (`SecondBrain.Contract`, `lib/second_brain/contract.ex`) → these are *live pointers into the code that Workstream A moves*. A dangling code pointer isn't frozen history; it's a broken reference. And these appear in surfaces the sweep list omits.

**What 1a.4 covers:** skills, flows, tutorials, policy examples, README, root index, preamble. ✅

**What it misses** (all carrying live code refs):
- `beliefs/glossary/` (7 entries — e.g. `compiled-contract.md` refs `lib/second_brain/contract.ex`, `markdown-renderer.md` refs `SecondBrain.Markdown`) + `beliefs/glossary.md`, `beliefs/future-beliefs.md`
- `knowledge/SWE/testing/elixir-second-brain-testing-methodology.md` — Decision 4 renames the *file*, but says nothing about the `SecondBrain.Frontmatter`/`SecondBrain.Policy` refs in its *body*, or the "Second Brain testing methodology" display text in its 3 inbound links
- `meta/issues/`, `meta/evals/`, `meta/elaborations/`, and several `meta/plans/`

**The active conflict:** `meta/analysis/` (3 files) contains live `lib/second_brain/contract.ex` links, yet the plan's scope boundaries put "point-in-time `meta/analysis/` docs" on the **frozen — not renamed** keep-list. So the plan's own keep-list would *mislead an executor into leaving broken code pointers there.*

The mitigant is that the step-8 residue grep (`grep -ri 'second[-_ ]?brain'`) would surface every one of these — so a careful executor won't *ship* dangling refs. But they'd be making ad-hoc keep/rename calls the plan should have pre-classified, and the keep-list points them the wrong way on analysis.

**The fix is three targeted plan edits:**
1. **Redefine the sweep by identifier, not file list.** 1a.4 becomes: *sweep every live occurrence of the code identifiers across all non-frozen, non-`deprecated/` surfaces — the grep is the worklist (37 doc files today).*
2. **Split the frozen boundary:** frozen threads and analysis keep their *name-prose* verbatim, but their *live code pointers* get updated. (Thread-*body* prose code mentions can stay as historical record — those aren't links the tooling repoints; analysis links are.)
3. **Extend Decision 4** to cover the testing-methodology file's in-body module refs and inbound display text, not just the slug.

Want me to make those three edits to the plan now? It's a cheap plan-edit that tightens the spec before ratification — and it's exactly the kind of gap better closed now than discovered mid-execution.

## User

Make those plan edits

## Assistant

The three edits are in, gates pass, and the push has updated **PR #65**. Here's what changed in the plan:

**1. Docs sweep is now grep-defined, not file-list-defined.** The inventory gained a "Live code-identifier refs across *all* doc surfaces" row, and build-order step 1a.4 split into two: a **name-prose sweep** (Decision 5 — proper-noun uses, leaving the category term) and a **code-identifier sweep** (Decision 6 — every live `SecondBrain.` / `lib/second_brain/` / `:second_brain` across the ~37 doc files, worklist = the grep).

**2. The frozen boundary is split by kind, resolving the conflict.** New **Decision 6** draws the line the plan was blurring: *name-prose* (frozen threads, the "second brain" category, analysis prose) stays; *code identifiers* are live pointers into moving code and move wherever they're live. `meta/analysis/` is now "name-prose frozen, code pointers updated" — no longer a keep-list trap. The one carve-out: prose code mentions inside frozen thread *bodies* stay as historical record (only `<routes>` refs repoint, per Decision 3).

**3. Decision 4 covers the whole file, not just the slug** — the testing-methodology rename now also fixes its in-body `SecondBrain.*` refs and the three inbound links' display text ("Second Brain testing methodology" → "Elixir Mind…") and paths.

Supporting updates: Phase 0 ratification now covers Decisions 5–6; step 1a.9 gained a **dedicated code-identifier residue check** (expects zero live-tree hits outside frozen threads) alongside the name grep; the estimate reflects the ~37-file code sweep; the index entry notes the sixth decision.

**Net effect:** an executor following the plan can no longer be misled into leaving a dangling `lib/second_brain/contract.ex` link in a glossary entry or analysis doc — the sweep is defined by what's actually live, and the two residue greps are the completeness oracle. Your question caught a real hole; it's closed before ratification rather than mid-execution.

The plan is still `status: proposed` — ready for your Phase 0 ratification whenever you want to green-light execution.

## User

Merge main into branch

## Assistant

`main` is merged into the branch and pushed — **PR #65** now reflects it. It was a true merge (per policy), catching the branch up on ~100 commits.

**What needed reconciling:**

- **`meta/threads/index.md` — content conflict.** Both sides appended 2026-07-13 entries. Kept all of main's and added the elixir-mind thread entry at the end of the day's group.
- **`meta/plans/index.md`** — auto-merged cleanly (distinct additions on each side).
- **New mandatory `attribution` block.** Main landed a resource-attribution policy with `mix brain.verify` rule 8 requiring an `attribution` map on every governance doc. My rename plan predated it, so verify failed — I added the block (`channel: agent-authored`, `from:` → this session's thread doc). The thread doc is correctly left **without** attribution, since main's policy makes threads exempt (it's an *error* for them to carry it — they use `provenance` + `pr`).

**Verification:** full gate suite green — `brain.verify`, `route_tags`, `contract`/`registry`/`lineage --check`, and 156/156 tests. The only remaining warnings are advisory and pre-existing on main (unresolved `inbox/` links and one main thread's route-tag coverage) — none from this branch. `dev_history --check` skipped (shallow clone, expected).

One thing worth surfacing from the merge: main has moved a lot while this plan sat — notably the **`attribution` property is now on every concept/governance doc**, and there's a new **`sense` field on glossary terms**. Neither changes the rename plan's logic, but when Phase 1b's corpus rewrite eventually runs, the `\bsb:([0-9a-f]{6})\b` → `em:$1` pass will now also sweep `sb:` ids inside `attribution.from` lists and any `sb:` refs in the new content — the regex already covers them, so it's in scope, just a larger token count than the ~940 measured earlier. Worth re-measuring at execution time. The plan stays `status: proposed`.

Want me to leave PR #65 as-is, or is there anything else on it before you review?

## User

Have sb refs been changed to em yet, or is that in the plan you've written?
Are we ready for /create-pull-request ?

## Assistant

**Q1 — No, nothing has been migrated.** Confirmed by the repo state:
- **0** `em:` minted ids anywhere; **363** files still carry `sb:` ids; the id-format code is still `~r/^sb:[0-9a-f]{6}$/`.
- The only `em:` tokens in the entire repo are the *illustrative examples inside the plan doc*. The `sb:` → `em:` migration is entirely described in the rename plan, `status: proposed` — not executed.

One thing the merge changed: that `363` was `~200` when I first measured. Pulling in main's ~100 commits roughly doubled the id count (new glossary terms and concepts), so the plan's "200 ids / ~940 tokens" figures are now stale — worth re-measuring at execution time. The migration regex still covers everything; it's just a bigger corpus now.

**Q2 — We already ran it; PR #65 is open.** So the answer isn't "run `/create-pull-request`" — that would try to open a *second* PR for the same branch. The state is:

- PR #65 exists, branch pushed, gates green. ✅
- But the **captured thread doc is now stale.** It was written at the "wrap with the plan" point, *before* three later exchanges: the docs-coverage audit, the Decision 6 edits, and this main-merge. Per the capture policy's update-in-place rule, the right move is to **regenerate that same thread doc** to include those exchanges, then push to #65 — not open a new PR.

So the precise readiness answer: **the branch is ready; the thread record is one refresh behind.**

Want me to **refresh the capture** — regenerate `2026-07-13-elixir-mind-rename-plan-and-model-orchestration.md` in place with the later exchanges (docs audit → Decision 6 → merge), re-check the glossary (likely still a no-op), and push to PR #65? That's the finalize motion here, rather than a fresh `/create-pull-request`.
