---
type: reference
title: 2026-07-11-branch-deletion-policy-and-contract-as-abstraction
description: Created the git-branch-deletion policy and git-workflow contract section, audited and part-executed the orphaned-branch cleanup (deletion 403-blocked agent-side; first todo filed), added the render-contract flow doc + scenario test, and distilled a dialogue on contracts as rendered aggregations into a preamble sentence, an analysis, and a top-priority skills-compile plan.
provenance: "Claude Code session (claude-fable-5), 2026-07-11; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, git, branches, policy, contract, compiled-artifact, flows, plans, todos]
timestamp: 2026-07-11
session: https://claude.ai/code/session_01MHv6q9awxJjAZvjAzCe2JK
pr: 46
---

# 2026-07-11-branch-deletion-policy-and-contract-as-abstraction

## Where this landed

The session started as a filing task — create a `git-branch-deletion` policy
(new `git-workflow` contract section, first `git-` filename-prefix namespace) —
and grew three limbs. First, operations: an audit found 21 orphaned `claude/*`
branches; after merging `main` mid-session (which landed the `todo` type via
PR #33) the operator ratified deleting the 15 merged and keeping the 6
unmerged; deletion turned out to be 403-blocked for this environment's
credential, so it's recorded as an operator step in the
[issue](/meta/issues/orphaned-remote-branches-cleanup.md), and the first-ever
`type: todo` tracks the kept branches. Second, tooling: the render-contract
flow doc and a contract scenario test joined the flows genre. Third, and most
generative: an operator-driven dialogue on what "the contract" *is* — compiled
from policies, a role decoupled from the `CLAUDE.md` mounting point, the
authority-singleton among the bundle's five rendered aggregations — which
produced a preamble sentence (the contract binds agents, not the operator),
the [contracts-and-rendered-aggregations analysis](/meta/analysis/contracts-and-rendered-aggregations.md),
and the operator-designated top-priority plan to
[compile contract §7 from SKILL.md frontmatter](/meta/plans/compile-skills-registry-from-skill-frontmatter.md)
(build-order step 1, ratified: a session-init priority override — satisfied
the same day by `main`'s integer `priority:` key from PR #45).

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| `git-branch-deletion` policy + `git-workflow` contract section + `git-` filename namespacing guideline | closed | `unrouted` (policy + compiler; path back-links) | - |
| Orphaned-branches audit and cleanup | open | `unrouted` (issue doc) | Operator to delete the 15 merged branches (agent-side 403) and enable "Automatically delete head branches" |
| Six kept unmerged branches | open | `unrouted` (todo doc) | Each needs a final disposition per the [triage todo](/meta/todos/triage-the-six-kept-unmerged-claude-branches.md) |
| `todo` type status | closed | `unrouted` | - |
| Compiled contract — what it is, where defined, persistence | closed | [compiled contract](/glossary/compiled-contract.md) | - |
| render-contract flow doc + contract scenario test | closed | `unrouted` (flow doc + test; path back-links) | - |
| Contract as abstraction: role vs mounting point; "Agent-contract" declined; rendered-aggregation family | closed | `unrouted` (analysis doc; path back-links) | - |
| Skills-compile plan (§7 from SKILL.md frontmatter) + session-init priority override | open | `unrouted` (plan doc) | Q1–Q4 await operator ratification; steps 2–5 unbuilt (step 1 satisfied by `main`'s integer `priority:` from PR #45; plan now carries `priority: 1`) |
| Issue↔todo cross-deferral convention | closed | `unrouted` | Left uncodified until it recurs (operator agreed) |

## User

I want to create a branch deletion policy, saveable as a policy type - namespaced with "git-" at the top of the file. On this note, let's namespace any other existing related policies with "git-" as well. (On that THAT note, should namespacing be added as a guideline/policy in the /policy index.com?

I assume that branches should be deleted on pr merge, is that correct?

## Assistant

Now I have everything. No existing policies are git-related (the only "git"/"PR" mentions are incidental examples), so `git-branch-deletion.md` will be the first in the `git-` namespace — nothing to rename. Creating the policy, wiring a new contract section, updating the index/log, and regenerating.

Done — pushed to `claude/branch-deletion-policy-kvzm25` (commit `b16a56a`). Verifier, route-tags check, contract check, and all 78 tests pass.

**Your two questions:**

<routes ref="meta/policy/git-branch-deletion.md">
1. **Yes, branches should be deleted on PR merge — your assumption is correct and is what the policy now says.** A merged branch is fully contained in the default branch's history, so deleting it loses nothing: the commits stay reachable through the merge, and GitHub can restore a deleted branch anyway. The policy draws the safety line where it actually matters: the default branch and any branch with *unmerged* commits (including PRs closed without merging) are never deleted without your approval. One practical follow-up you'd need to do in the GitHub UI: enable **Settings → General → "Automatically delete head branches"** on the repo, so the deletion happens mechanically at merge time — I can't change repo settings from here.
</routes>

2. **Namespacing as a guideline — yes, and I added it, but as an index guideline rather than a full policy.** It now lives in the intro of `meta/policy/index.md`: the policy directory stays flat, so when several policies govern one domain they share a kebab-case filename prefix (e.g. `git-`), and a single-policy domain adopts the prefix from the start if siblings are plausible. I kept it out of the compiled contract because it's a convention about naming policy *files*, which only matters to someone already editing that directory — if more domain prefixes accumulate, it can graduate to a proper `type: policy` doc later.

**On renaming existing policies:** there was nothing to rename. I searched all 20 existing policies — none are git-related (the only hits for "git"/"PR" were an example path in `directory-hierarchy` and the `/create-pull-request` entry in `skills-registry`, which is a skills policy, not a git one). So `git-branch-deletion.md` is the first occupant of the `git-` namespace.

**What changed:**
- `meta/policy/git-branch-deletion.md` — the new policy (`section: git-workflow`)
- `lib/second_brain/contract.ex` — added the `git-workflow` section (contract §9, "Git workflow"), since sections are a hardcoded ordered list there
- `meta/policy/index.md` — new `## git-workflow` listing + the namespacing guideline
- `CLAUDE.md` — regenerated via `/render-contract`
- `meta/log.md` — dated entry for all of the above

One small thing I noticed but left alone: `.claude/skills/render-contract/SKILL.md` lists the valid sections in its prose and was already stale (missing `verification` and `session-workflow`, now also `git-workflow`). Happy to refresh it if you'd like.

## User

1- create an issue, include cleaning up existing orphaned threads. Note - did we create a "todos" type?

2- sounds good. Elaborate on what a compiled contract is in the context of this repo (and possibly add to glossary)

Refresh render-contract

## Assistant

All three done and pushed (commit `8771fec`). Full gate suite passes.

**1. Issue filed — and your "todos" question has an interesting answer.** The issue is [`meta/issues/orphaned-remote-branches-cleanup.md`](/meta/issues/orphaned-remote-branches-cleanup.md). I fetched with prune and classified every remote branch: **12 are merged-but-undeleted** (safe to delete on sight under the new policy) and **9 hold unmerged commits** that need your triage. On the todos type: **it was created, but never merged.** The branch `claude/meta-todos-skill-j42my8` (3 commits, 2026-07-10) contains a `todo` type addition to the vocabulary, a `meta/todos/` genre, a `/todo` skill, and a gate-suite tutorial — none of it is on `main`, so today the vocabulary has no todos type and `issue`/`plan` are the closest things. That stranded branch is called out in the issue as the headline triage decision (merging it would also mean ratifying the `todo` type). The issue also tracks enabling the "Automatically delete head branches" repo setting, which only you can flip.

<routes ref="em:23f009 lib/elixir_mind/contract.ex">
**2. What a "compiled contract" is here.** `CLAUDE.md` — the file every agent reads on session start — is not authored; it's *build output*. The sources are `meta/preamble.md` (fixed framing) plus the twenty-one `type: policy` documents under `meta/policy/`, each declaring in frontmatter which contract `section` it renders into and its `order` within that section. The compiler, `mix brain.contract` (`lib/second_brain/contract.ex`), groups the policies under a fixed ordered section list, renders each rule with a *Source:* trace link back to its policy file, and writes `CLAUDE.md`. The payoff is that drift is caught **structurally rather than procedurally**: `mix brain.contract --check` re-renders and byte-diffs against the on-disk file in CI, so a hand edit or a forgotten recompile fails the gate instead of silently forking the truth — the rules stay editable as small, individually-versioned documents while agents consume one coherent artifact. One subtlety we hit yesterday: the *section list itself is code* (`@sections` in `contract.ex`), so a new section — like `git-workflow` — is a compiler change, not just a new policy file. The same generated-artifact pattern governs `meta/registry.md` and the route-tagged excerpt logs. The glossary already had a `compiled contract` entry (`em:23f009`) from the backfill, so per update-in-place I extended it with these mechanics rather than creating anything new.
</routes>

**3. render-contract skill refreshed.** Its hardcoded valid-section list was stale even before yesterday (missing `verification` and `session-workflow`). Rather than just patching the list to go stale again, it now names `@sections` in `contract.ex` as the authoritative list (with a dated snapshot for convenience) and documents the new-section-is-a-compiler-change rule.

Everything is on `claude/branch-deletion-policy-kvzm25` — say the word if you want a PR opened (`/create-pull-request` would also capture this session).

## User

Is the compiled contract persisted somewhere, like meta/flows?

## Assistant

Two answers, depending on which sense of "persisted" you mean:

**The compiled artifact itself — yes.** `CLAUDE.md` is not generated on the fly at read time; it's an ordinary committed file at the repo root, versioned in git like everything else. `mix brain.contract --check` in CI and the pre-commit hook just guarantees the committed copy is never stale relative to its sources.

**The flow's documentation — partially, but not in `meta/flows`, and that's a real gap.** Right now `meta/flows/` holds exactly two flow docs — `intake.md` and `session-capture.md` — and nothing for the contract-compilation flow. What exists is scattered across the genre's *other* two artifact slots plus a few fragments:

- **Procedure** → the `/render-contract` skill (`.claude/skills/render-contract/SKILL.md`)
- **Mechanism + proof** → `lib/second_brain/contract.ex` and `test/second_brain/contract_test.exs`
- **Fragments** → the glossary term (`/glossary/compiled-contract.md`), the `meta/policy/index.md` intro, and the contract's own preamble note that it's generated

Per the flows genre's own definition, a flow doc is the third leg of a triad — skill + scenario test + connective "why/touch-sequence" doc. The render-contract flow already has the first two legs, so `meta/flows/render-contract.md` is the natural missing piece, and it's arguably the *easiest* flow to document since it's nearly all deterministic spine (edit policy → recompile → `--check` → commit source and artifact together) with very little editorial judgment. Yesterday's `git-workflow` section addition would even serve as the canonical worked run.

One nuance if we add it: `contract_test.exs` is a unit test of the compiler rather than a scenario test in the genre's strict sense (`*_scenario_test.exs` over a canonical run), so the flow doc would either point at it as-is or we'd add a small scenario alongside.

Want me to write `meta/flows/render-contract.md` (and, optionally, the scenario test)?

## User

Yes both

## Assistant

Both shipped and pushed (commit `cd08701`). The full gate suite passes — now 82 tests, up from 78.

<routes ref="meta/flows/render-contract.md test/elixir_mind/contract_scenario_test.exs">
**The flow doc** — [`meta/flows/render-contract.md`](/meta/flows/render-contract.md) — follows the genre's template from `intake.md`: problem, pipeline diagram, a six-step touch-sequence table (with the sections-are-code compiler edit as step 2a), actor boundaries, data model, invariants, and the verify section. It points at the other two artifact slots rather than restating them, and names yesterday's `git-branch-deletion` change as the canonical worked run, since it exercised every step including opening a new section. One genre note: this flow is the inverse of intake — nearly all deterministic spine, with only the rule's prose, its section/order placement, and the ratification call being editorial.

**The scenario test** — `test/second_brain/contract_scenario_test.exs`, 4 tests — pins the flow's handoffs rather than re-unit-testing the compiler (which `contract_test.exs` already covers):

1. **Canonical run**: compile → `check/1` round-trips, with byte-checked banner, section headings (`## 3.` and `## 9.`, pinning the `@sections` ordering), and a rule with its trace link — then a *source edit without a recompile* reports stale (the forgotten-recompile handoff), and recompiling restores the round-trip.
2. **Hand edit to `CLAUDE.md`** fails the drift gate.
3. **Unregistered section** raises at compile — the sections-are-code invariant.
4. **Supersession**: `status: superseded` drops a rule from the next compile while the doc stays filed.
</routes>

The flows index lists the new doc, the `/render-contract` skill now links to it, and `meta/log.md` records the addition. Everything's on the branch — three commits total now, ready for a PR whenever you want one.

## User

Merge main into branch, note that to dos were built out. in another session.

## Assistant

Main has moved a lot — notably **PR #33 merged the `meta-todos-skill` branch**, so the `todo` type, `meta/todos/`, and `/todo` skill are now real on `main` (my issue's triage list is partly stale). There's also a new ratified merge-strategy policy on main. Merging now — `CLAUDE.md` conflicts I'll resolve by regenerating:

Merge committed. The re-audit shows the landscape changed: **15 merged branches now (was 12)** — `meta-todos-skill`, `merge-commit-tutorial`, and `second-brain-repo-eval` all merged via PRs #33/#36/#34 — and **6 unmerged (was 9)**. Notably, the newest merged PRs (#42–#44) already had their branches deleted, so the policy practice has started. Updating the issue to match reality:

Merged and pushed — the branch is now up to date with `main` (merge commit `ab7b7be`, true merge per the new merge-strategy policy that came in with it), plus a follow-up commit (`cb2a249`) refreshing the issue. All gates pass: 85 tests, contract/registry/verify/route-tags all green.

**The merge itself.** Only `meta/log.md` conflicted — both sides added entries under 2026-07-11 — resolved by keeping both blocks, this branch's on top. `CLAUDE.md` auto-merged, but since it's generated I recompiled it from the merged policy sources as the authoritative resolution; the contract now carries both main's new `merge-strategy` policy (filing section) and this branch's `git-workflow` section.

**The todos landing changed the issue's facts, so I re-audited it.** Main's activity since I filed it this morning:

- **PR #33 merged `meta-todos-skill`** — the `todo` type, `meta/todos/` genre, and `/todo` skill are now real on `main` (the session-init digest even scans `meta/todos/` as a fourth source now). The issue's "stranded work" note is resolved.
- PRs #34 (`second-brain-repo-eval`) and #36 (`merge-commit-tutorial`) also merged.
- The tallies shifted from 12 merged / 9 unmerged to **15 merged / 6 unmerged**; the issue, its index entry, and resolution criteria now reflect that, with a dated update note explaining the shift.
- Encouraging detail: the newest PRs (#42–#44) already had their head branches deleted after merging — so the deletion practice has started for new work, and the issue is now purely the historical backlog of 15 deletable branches, 6 triage decisions, and the auto-delete setting.

## User

Where does this leave us for old branches?

## Assistant

Here's the full picture after the merge — the backlog now splits into three clean buckets:

**1. The 15 merged branches — deletable, awaiting one word.** Everything from `add-to-glossary-skill` through `vector-db-recall-eval`, now including the todos, repo-eval, and merge-tutorial branches. Per the policy these are "delete on sight" — nothing is lost, commits stay reachable through their merges. The one wrinkle: the policy authorizing that is *on this branch*, not yet on `main`. So I'd treat the first bulk deletion as needing your go-ahead rather than doing it silently — say the word and I'll delete all 15 (`git push origin --delete …`), either now or right after this PR merges.

**2. The 6 unmerged branches — these need your triage, and they're not all alike.** I looked at what each actually holds:

- **`code-review-docs-audit`** and **`epistemic-artifact-beliefs`** — both substantial, both worked on *today* in other sessions (an `/elaborate` skill + elaborations genre; the belief-decomposition analysis with primary-source captures). These look like live work heading toward their own PRs, not orphans at all — probably just leave them alone.
- **`git-fetch-merge-skill`** — a `/sync-branch-with-main` skill (2026-07-10). Genuinely useful — it's exactly what I just did by hand. PR-revival candidate.
- **`repo-skills-namespacing`** — a single tutorial on the agent's branch lifecycle across merged PRs. Small; revive or ratify deletion.
- **`ccr-architecture-notes`** — a single Chroma intake from 2026-07-08, the oldest straggler. Small; revive or ratify deletion.
- **`glossary-thread-docs`** — likely a *false* orphan: its commits capture the glossary-backfill thread, which already landed on `main` via PR #37 from a different branch. Needs a content diff to confirm it's fully superseded, then it'd be safe to ratify deleting.

**3. Go-forward hygiene — one operator step left.** New branches are already being cleaned up (PRs #42–#44's branches were deleted post-merge), so once you enable **Settings → General → "Automatically delete head branches"**, the problem stops regenerating and this issue reduces to the one-time cleanup above.

So concretely: the issue resolves with (a) your go-ahead on the 15 deletions, (b) five quick triage calls on the unmerged set (two of which are probably "leave alone — active"), and (c) the settings toggle. Want me to delete the 15 merged ones now?

## User

Yes delete the 15 merged branches

KEEP the unmerged branches, create a todo detailing

## Assistant

Quick appraisal per the session-init note: the top priority is exactly what you've just directed — executing the orphaned-branches cleanup (issue #1) — so I'll do that now; the `/news` Routine gate (issue #2) and the `deprecated/` triage remain the next two, both blocked on operator-side decisions.

Single deletes are also 403 — this environment's GitHub credential can push commits to `claude/*` branches but **cannot delete refs at all**. So branch deletion is an operator-side action (or a session with broader permissions); I'll record the ready-to-run command in the issue. Now creating the todo as you asked, via the newly-merged `/todo` skill:

Everything's recorded and pushed (commit `9386822`), but the headline is: **I couldn't delete the branches — it needs to be you.**

<routes ref="meta/issues/orphaned-remote-branches-cleanup.md">
**The deletion attempt.** I re-verified all 15 branches were still fully merged into `main` immediately before deleting, then tried `git push origin --delete` — bulk and single-branch both return HTTP 403. This remote environment's GitHub credential can push commits to `claude/*` branches but cannot delete refs, and the GitHub MCP toolset has no delete-branch tool either. So the ratified deletion is an operator step. The issue now contains the exact ready-to-paste command for all 15, or you can click through the [branches page](https://github.com/ob6to8/second-brain/branches) — and once you're there, the "Automatically delete head branches" toggle in Settings → General would close out the go-forward half in the same visit.
</routes>

<routes ref="meta/todos/triage-the-six-kept-unmerged-claude-branches.md">
**The todo.** Filed via the newly-landed `/todo` skill — fittingly, it's the very first entry in `meta/todos/`: [`triage-the-six-kept-unmerged-claude-branches.md`](/meta/todos/triage-the-six-kept-unmerged-claude-branches.md). It details each kept branch — what it holds, from the commit audit — and a suggested disposition: the two substantial actively-worked branches (`code-review-docs-audit`, `epistemic-artifact-beliefs`) flagged as likely heading to their own PRs, the `/sync-branch-with-main` skill worth reviving, two small ones needing a revive-or-retire call, and `glossary-thread-docs` flagged as a probable false orphan to diff against `main` before deciding. "Done" means every branch is merged, ratified-deleted, or explicitly kept with a reason.
</routes>

**Issue bookkeeping.** The issue's resolution criteria narrowed accordingly: unmerged-branch disposition moved out to the todo (you ratified keeping them), leaving just two conditions — you run the deletion, and the auto-delete setting goes on. Index and log updated; gates all green.

One small observation from the fetch: `claude/session-init-log-priorities-vuvzo6` reappeared on the remote mid-session — another session is actively re-using it — so I left it untouched rather than treating it as a 16th orphan.

## User

When you say the issue's resolution criteria narrowed accordingly, do you mean the definition of what an issue is, or are you referring to the to do as being an issue? Currently, those are two different types, which may be, ironically, an issue.

## Assistant

Neither — it was sloppier phrasing than the underlying edit. I meant the **`## Resolution criteria` section inside that one issue document** (`meta/issues/orphaned-remote-branches-cleanup.md`). Like the `/news` Routine issue before it, this issue ends with a section saying "resolve this when X, Y, Z." Originally X, Y, Z were: delete the 15, triage the 6, enable auto-delete. When you ratified *keeping* the 6, I removed the triage condition from that section, so the issue now resolves on just two conditions — and the six branches' eventual fate is tracked in the todo instead, cross-linked from both sides. Nothing about the issue *type* changed, and the todo is not an issue; one line-item of work simply moved from one document's done-conditions into a separate document of a different type.

On your ironic point — is the issue/todo overlap itself a problem? I'd argue this exchange is actually evidence the boundary works, though it exposed something the vocabulary doesn't yet say. The contract draws the line as *problem to diagnose* vs. *plain task to complete*, and both documents sit correctly on their sides of it: the issue holds the diagnosed problem (a pre-policy backlog exists; deletion is 403-blocked in this environment; here's the evidence and the fix), while the todo holds a plain follow-through task with a done-condition. What the vocabulary *doesn't* codify is the pattern we just used: work items migrating between the two types as understanding changes, with a cross-link left behind — the issue's resolution criteria explicitly deferring a strand to a todo. That happened naturally here and feels right, but it's convention, not policy.

So the genuine question for you is whether that convention should be written down — e.g., a sentence in the issue/todo type definitions or a small policy noting that issues may spawn/defer to todos (and vice versa: a todo that turns out to be a diagnosable problem graduates to an issue), always by cross-link rather than duplication. My honest recommendation is to leave it alone for now: it's the first instance, the update-in-place and cross-linking policies already carried it without friction, and codifying a pattern off a single occurrence is how contracts bloat. If it recurs a few times, it'll be obvious what the rule should say. But if you'd like it codified now, I can draft it as a small addition to the controlled-type-vocabulary policy.

## User

Okay, agreed to leave this convention for now. When you refer to contracts here, what contracts are you referring to? For instance, you wrote the contract draws the line as problem to diagnose versus plain task to complete. Where is this contract defined, and is it an official type?

## Assistant

One specific document: **the operating contract, `CLAUDE.md`** — the file at the repo root that every agent (including me, right now) is required to read and follow at session start. Its own title is "Operating Contract — Second Brain (OKF)," and when I say "the contract draws the line," I'm citing its §4, the controlled `type` vocabulary, which defines the two types with exactly that contrast: a `todo` is "distinct from an `issue` (a *problem* to diagnose and track) … a todo is a plain *task to complete*."

<routes ref="em:23f009">
But — and this is the layered part we've been circling all session — `CLAUDE.md` is the *compiled* contract. The sentence I paraphrased isn't authored there; it lives in a source document, `meta/policy/controlled-type-vocabulary.md` (the `todo` entry, added when PR #33 merged), and `mix brain.contract` renders it into §4 with a trace link back to that file. So "where is the contract defined" has a two-level answer: authored in the twenty-two policy docs under `meta/policy/` plus `meta/preamble.md`, and materialized as `CLAUDE.md`.

Is it an official type? The contract **as an artifact has no type at all** — deliberately. `CLAUDE.md` carries no frontmatter, just the generated-file banner; it isn't a bundle concept, has no `sb:` id, and sits outside the identity registry (the render-contract flow doc's §6 covers this). What *is* an official type is its source material: `policy` is in the controlled vocabulary — "a governance rule for how the brain operates; the source from which `CLAUDE.md` is compiled." So "contract" is a **role, not a type**: it names the singular compiled artifact that the `type: policy` documents collectively produce. The glossary has both halves filed — [compiled contract](/glossary/compiled-contract.md) (`em:23f009`) for the pattern, and a [policy (type)](/glossary/policy-type.md) entry from another session's work — and the distinction genre-wise is the same one we used for issue vs. todo: policies are the rules, the contract is their rendered aggregation.
</routes>

## User

Have you ever seen any other contracts, i. e, rendered aggregations? Or is the Claude indeed the only one we can imagine having? If it is, contract may be an unnecessary abstraction placed over it that obscures the fact that we're only really dealing with the ClaudMD.

## Assistant

In this repo, the *contract* is indeed a singleton — but it's worth separating two abstractions that the last few exchanges have been using interchangeably, because one of them has many instances and one has exactly one.

<routes ref="em:23f009 meta/analysis/contracts-and-rendered-aggregations.md">
**Rendered aggregations generally: there are several.** The generated-not-hand-kept pattern is all over the tooling: `meta/registry.md` (compiled id→path view, `mix brain.registry`), the `## Thread excerpts — route-tagged log` sections inside concepts (derived from route tags, `mix brain.route_tags --materialize`), the GitHub Pages site (`mix brain.site` renders the whole bundle), and the session-init digest that opened this very session (`mix brain.session_init`, rendered fresh each time rather than committed). Each aggregates scattered sources into one derived view with a drift check. So "compiled artifact" is a genuinely load-bearing abstraction with five-ish instances.

**Contracts specifically: there is one, and I can't honestly imagine a second.** What makes `CLAUDE.md` a *contract* rather than merely another compiled artifact is its authority — it's the only generated file that *binds agent behavior*. The registry indexes, the site presents, the digest orients; only the contract commands. And the design gives no reason to expect another: one brain, one set of operating rules.

So you're partly right — but I'd defend the word on one ground you might find persuasive: **"contract" names the role; `CLAUDE.md` names the mounting point.** The filename isn't ours — it's Claude Code's harness convention for where agents look for instructions. If the harness changed (say, tooling standardizes on `AGENTS.md`), or a second surface needed the rules injected somewhere else, the contract — the compiled aggregation of `meta/policy/` — would be unchanged; only the output path in `contract.ex` moves. Saying "the contract" keeps the brain's concept decoupled from a third party's filename, and the tooling already commits to that vocabulary (`SecondBrain.Contract`, `mix brain.contract`, the `policy` type's own definition). Where I'd concede the point: if we ever caught ourselves designing *for* multiple contracts — abstracting the compiler over hypothetical second instances — that would be speculative generality, and the singleton should stay concrete. We haven't; the abstraction is currently one word and one module name, which is about the right price for harness independence.
</routes>

## User

Should we consider calling it Agent-contract? And would skills be considered a potential compilation target of the same type as Claude.Md?

## Assistant

<routes ref="meta/analysis/contracts-and-rendered-aggregations.md meta/preamble.md">
**On "Agent-contract": I'd advise against, on the same singleton logic as before.** A qualifier earns its place when it disambiguates — "agent-contract" implies an operator-contract or reader-contract that doesn't exist and isn't imaginable in this design, since the operator *ratifies* rules rather than obeying them; agents are the only party a contract here could bind. So the qualifier encodes information already implied by the design. It's also not free: "contract" is load-bearing in `SecondBrain.Contract`, `mix brain.contract`, the `/render-contract` skill, the `policy` type definition, and a dozen policy bodies. If you want the binding party explicit, the cheap fix is one sentence in `meta/preamble.md` ("the contract binds agents; the operator ratifies it") rather than a rename. The existing full name, "operating contract," already does most of that work.
</routes>

<routes ref="meta/analysis/contracts-and-rendered-aggregations.md meta/plans/compile-skills-registry-from-skill-frontmatter.md">
**On skills: they're the same *kind* of file as `CLAUDE.md` in one precise sense, but I'd argue they're the opposite of a compilation target.** The sense in which they match: both are **harness mounting points** — files at paths a third party (Claude Code) dictates, consumed to shape agent behavior, `CLAUDE.md` at session start and `SKILL.md` on invocation. In the role-vs-mounting-point framing, they sit side by side.

But the contract is compiled for a specific reason: its content is an *aggregation* — many individually-versioned rules that must also read as one document, giving two representations of the same truth and hence a drift problem the compiler solves. A skill has no aggregation: one procedure, one file, and the `SKILL.md` *is* the source of truth. Compiling it from some bundle-side `methodology` doc would create the dual-home drift problem the contract compiler exists to kill.

Here's the twist, though — this session hit real drift around skills *twice*, and both times the arrow points the other way. The `/render-contract` skill's hardcoded section list had gone stale, and the `skills-registry` **policy** is a hand-maintained list of skill descriptions that must be updated every time a skill is added — it's duplicating what each `SKILL.md`'s own frontmatter (`name`, `description`) already declares. So if anything deserves compilation, it's that: **skills as *sources*, the contract's §7 as the derived view** — `mix brain.contract` (or a sibling task) rendering the skills-registry section from the `SKILL.md` frontmatter files, with the usual `--check` drift gate. That would make skills participate in the compiled-artifact pattern in the direction that matches where their truth actually lives.
</routes>

That's a real tooling change with a design question or two (what §7 prose survives beyond the frontmatter descriptions), so I'd treat it as a `plan` to ratify rather than something to just do. Want me to draft it?

## User

create a one sentence in meta/preamble.
Draft a plan and mark it as top priority.
Also, it would be great to document what you've presented here regarding rendered aggregations as well as the nature of contracts. Would this be a flow document or an analysis or a policy?

## Assistant

All three shipped and pushed (commit `0a4d0fa`); gates green.

<routes ref="meta/analysis/contracts-and-rendered-aggregations.md">
**To your genre question: it's an `analysis`, and that's what I filed.** The reasoning: a flow doc narrates a *multi-step action* end to end (touch-sequence, actors, scenario test) — this material describes no action. A policy is a *binding rule* — nothing here commands agent behavior; it's an understanding of the system. An `analysis` is by definition "a question investigated against evidence (often the live bundle itself), yielding findings and a recommendation" — which is exactly what our exchange was: your question ("is 'contract' an unnecessary abstraction?"), evidence from the live bundle, findings, recommendations. So: [`meta/analysis/contracts-and-rendered-aggregations.md`](/meta/analysis/contracts-and-rendered-aggregations.md), containing the inventory table of all five rendered aggregations, the authority-singleton finding, the role-vs-mounting-point framing, the declined "Agent-contract" rename with its rationale, and the skills-as-sources conclusion. One piece of it did land as (near-)policy though: the binding-party fact went into the preamble, which compiles into the contract itself.
</routes>

**The preamble sentence** — added after the operator/agent framing: *"The contract binds agents, not the operator: its rules are obligations on agent behavior, which the operator authors and ratifies but is never subject to."* `CLAUDE.md` recompiled, so it's now in the contract every future session reads.

<routes ref="meta/plans/compile-skills-registry-from-skill-frontmatter.md">
**The plan** — [`compile-skills-registry-from-skill-frontmatter.md`](/meta/plans/compile-skills-registry-from-skill-frontmatter.md), `status: proposed` with a `priority: top` frontmatter key and the designation stated in the body and plans index. One honest caveat recorded in the plan itself: the session-init digest's heuristic ranks `proposed` plans low and doesn't read a priority key, so your override lives in the frontmatter and prose rather than the ranking machinery — if that bothers you, teaching `session_init` to respect `priority: top` could be folded into the plan's build order. The plan carries four open questions for your ratification, with leanings: keep the skills-registry policy as a thin wrapper (preserves the per-section trace link), add curated framing via a short preface rather than per-skill annotations, alphabetical ordering, and plugin skills out of scope.
</routes>

## User

Yes. Teach session in it to respect priority. Fold that into the plan's build order.

## Assistant

Done and pushed (commit `a76fad5`). The plan's build order now opens with the ratified step 1: `SecondBrain.SessionInit` learns to read `priority: top` on plans and lifts those items to the head of the heuristic top-3 — an explicit operator override outranking the status-based ranking — with `session_init_test.exs` extended to cover it. I sequenced it first deliberately: it's independent of the scanner work, and building it first means this very plan's designation becomes effective in the digest immediately, rather than waiting for the whole skills-compile to land. The scanner, contract wiring, scenario-test extension, and connective-layer updates follow as steps 2–5. The plan's status note, the plans index, and the log all record the amendment as operator-ratified.

The plan remains `proposed` overall — Q1–Q4 (surviving prose, wrapper vs. native section, ordering, scope) still await your ratification before a session executes it, though step 1 is now pre-ratified and could be built standalone whenever you like.

## User

The ratification needed that's all documented within the plan, correct? I can close out this thread?

## Assistant

Yes — everything a future session needs is in the plan itself: Q1–Q4 each state the question, the options, and my leaning; the status section says the plan awaits your ratification on those before execution; and step 1 (session-init priority support) is marked as already ratified and buildable standalone. The plans index and session-init digest will both surface it, so nothing lives only in this conversation.

One decision *does* remain before this thread is truly closeable, though: **none of this session's work is on `main` yet.** Eight commits sit pushed on `claude/branch-deletion-policy-kvzm25` — the git-branch-deletion policy and its contract section, the orphaned-branches issue, the triage todo, the render-contract flow doc + scenario test, the preamble sentence, the analysis, and the plan. Per the brain's own workflow that lands via a PR (true merge), and per the session-capture policy a closing session gets captured. If you say **`/create-pull-request`**, it will run `/capture` (freezing this thread into `meta/threads/` with its routing ledger), glossary the thread, and open the PR in one motion — that's the clean close-out.

Also for your own checklist, the two operator-side actions that survive this thread (both recorded in the issue, so the digest will keep nagging): deleting the 15 merged branches (command is in the issue) and flipping the auto-delete setting.

## User

*(invoked `/create-pull-request` — this capture, the glossary pass, and the PR are that invocation executing.)*
