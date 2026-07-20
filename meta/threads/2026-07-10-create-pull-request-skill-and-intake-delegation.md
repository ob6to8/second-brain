---
type: reference
title: 2026-07-10-create-pull-request-skill-and-intake-delegation
description: Answered whether repo-specific skills are namespaced (no — bare, plugins aside), wired /intake to delegate to /summarize-technical for technical sources, then built the /create-pull-request skill and iterated it (drop the confirmation gate; run /capture first) — shipping via PR #31 and a follow-up branch.
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-10; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, skills, intake, pull-request, capture, namespacing]
timestamp: 2026-07-10
session: https://claude.ai/code/session_01ULtRSZaxCbFw47DM5doom7
pr: 32
---

# 2026-07-10-create-pull-request-skill-and-intake-delegation

## Where this landed

A tooling session on the brain's skills. It opened with a convention question —
are repo-specific skills namespaced? — resolved to *no, leave them bare* (only
plugin skills get an automatic `plugin:` namespace; hierarchy resolves
collisions), with the note that a shared `sb-` prefix is a viable manual grouping
hack but packaging as a plugin is the sanctioned path if grouping is the goal.
Then two concrete changes: `/intake` now delegates to `/summarize-technical` when
a captured concept is a technical paper/article/spec (the three-part breakdown
*is* the body), mirrored into `meta/flows/intake.md`; and a new
`/create-pull-request` skill was built, then sharpened twice — first dropping its
confirmation gate (invoking it *is* the authorization), then prepending a full
`/capture` run so the frozen thread doc ships in the same PR. The first batch
landed as **PR #31** (merged into `main`); the capture-first revision was
restarted from `main` onto the same branch as a follow-up.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Are repo-specific skills namespaced? (bare vs `sb-` prefix vs plugin) | closed | `unrouted` | - |
| `/intake` → `/summarize-technical` delegation for technical sources | closed | [/.claude/skills/intake/SKILL.md](/.claude/skills/intake/SKILL.md) | - |
| Mirror the delegation branch into the intake flow doc | closed | [/meta/flows/intake.md](/meta/flows/intake.md) | - |
| New `/create-pull-request` skill (commit + push + PR) | closed | [/.claude/skills/create-pull-request/SKILL.md](/.claude/skills/create-pull-request/SKILL.md) | - |
| Drop the PR confirmation gate (invocation = authorization) | closed | [/.claude/skills/create-pull-request/SKILL.md](/.claude/skills/create-pull-request/SKILL.md) | - |
| Run `/create-pull-request` → open + merge PR #31 | closed | `unrouted` | - |
| Prepend `/capture` to `/create-pull-request` | closed | [/.claude/skills/create-pull-request/SKILL.md](/.claude/skills/create-pull-request/SKILL.md) | - |

## User

Is it convention to namespace repo-specific skills?

## Assistant

<routes ref=".claude/skills/intake/SKILL.md">
Short answer: **no — the convention is to leave repo-specific skills bare, not namespace them.**

Per the official Claude Code docs ([code.claude.com/docs/en/skills](https://code.claude.com/docs/en/skills.md)):

- **Project skills** under `.claude/skills/<name>/SKILL.md` are invoked by their **bare directory name** — `.claude/skills/intake/` → `/intake`. No prefix. That's exactly what this repo does (`/intake`, `/capture`, `/render-contract`, `/news`, `/summarize-technical`).
- **Only plugin skills are namespaced**, and that's automatic: they get a `plugin-name:skill-name` form (e.g. `/my-plugin:review`) so they can't collide with anyone else's.
- **Collisions are resolved by hierarchy, not prefixes**: enterprise > personal > project > bundled. So if your project's `/intake` clashes with a personal `/intake`, the personal one wins — you don't disambiguate by renaming.
- **The directory name is canonical** for the command. The `name:` field in SKILL.md frontmatter is just a display label for listings; it doesn't change what you type after `/`. (The lone exception is a plugin-root `SKILL.md`, where frontmatter `name` forms the `/plugin:name` command.)

So for a repo like this second brain, the idiomatic thing is what it already does: unprefixed `/intake`, `/capture`, etc. You'd only reach for namespacing if you packaged these as a **plugin**, in which case the `plugin:` prefix is handled for you — hand-prefixing (`/sb-intake`, `brain:intake`) isn't a recognized convention and buys you nothing the hierarchy doesn't already handle.

Was there a specific change you were considering here — e.g. turning these skills into a distributable plugin? The branch name suggests you're weighing a namespacing move.
</routes>

## User

With a namespace i could type /sb- and it would list all repo skills

## Assistant

You're right — that's a genuine benefit, and it's the strongest argument for prefixing. Bare names scatter your five repo skills among every other skill in the `/` picker; a shared `sb-` prefix makes them autocomplete as a group. Nothing stops you from doing it — the directory name *is* the command, so renaming `.claude/skills/intake/` → `.claude/skills/sb-intake/` gives you `/sb-intake` and the grouped-filter behavior immediately.

The honest tradeoff:

- **The prefix-hack works but isn't the blessed path.** It's just a naming convention you're enforcing by hand. Costs: a few extra keystrokes, and if you ever package these as a plugin you'd get *real* namespacing on top, leaving you with `/brain:sb-intake` — a doubled prefix you'd then want to strip.
- **The mechanism Claude Code actually provides for exactly this is plugins.** A plugin gives every skill a `plugin-name:` namespace for free, so typing `/brain:` lists all of them grouped — the same UX you're after — but it's the intended collision-proof mechanism rather than a string convention. It also isolates them from personal/enterprise skills of the same name.

So the decision is really: **do you want the grouping via a manual prefix, or via packaging these as a plugin?** For a personal second brain where the skills only ever run in this one repo, the manual `sb-` prefix is the lighter-weight move and perfectly reasonable — plugins add a manifest and indirection you don't need until you're sharing them.

Want me to rename the five skills to an `sb-` prefix (and update the CLAUDE.md / skills-registry policy references that mention `/intake`, `/capture`, etc.)? It's a mechanical change I can do on your branch.

## User

Have /intake calll /summarize-technical when appropriate. Add to /intake

## Assistant

<routes ref=".claude/skills/intake/SKILL.md .claude/skills/summarize-technical/SKILL.md">
Done. Added to `/intake` step 4 (Distill), pushed to `claude/repo-skills-namespacing-htu3lc`.

The new bullet tells `/intake` to hand off to `/summarize-technical` when — and only when — the concept is a technical paper/article/spec worth a layered breakdown (typically a `reference` or `source`). In that case the three-part structure (plain-language summary → key terms → technical summary) *becomes* the distilled body, then intake resumes at the directory/write/reserved-files steps. It explicitly excludes short notes, snippets, people, and projects, where flat prose is still correct.

This composes cleanly with the existing skill: `/summarize-technical`'s own procedure already knows how to write into a bundle concept's body and preserve frontmatter/`# Citations`, so intake just uses it as the distill action rather than duplicating that logic.

One thing I left alone: `meta/flows/intake.md` (the "why" doc linked at the bottom of the skill) still describes the old flat-distill pipeline. I scoped this to the skill as you asked — want me to update the flow doc to mention the `/summarize-technical` branch too, so they don't drift?
</routes>

## User

Yes

## Assistant

<routes ref="meta/flows/intake.md">
Done. The flow doc now stays in sync with the skill. Both are pushed to `claude/repo-skills-namespacing-htu3lc`.

What I changed in `meta/flows/intake.md`:
- **§3 touch-sequence, step 5** — noted that for a technical paper/article/spec the distill action delegates to `/summarize-technical`, whose breakdown *is* the body.
- **§4 moving parts** — added the same branch to the "distill, don't dump" bullet, pointing at the skill (kept to the doc's "point, don't restate" ethos).
- Bumped `timestamp` to 2026-07-10 and appended a dated entry to `meta/log.md`.

`mix brain.verify` passes clean. Reserved-file upkeep was minimal here — `meta/flows/index.md`'s one-line description of the intake flow still holds, so I left it untouched.
</routes>

## User

Create a skill that commits and asks to creat a pull request called /create-pull-request

## Assistant

<routes ref=".claude/skills/create-pull-request/SKILL.md">
Done. Created `/create-pull-request` and pushed to `claude/repo-skills-namespacing-htu3lc`.

**What the skill does** (`.claude/skills/create-pull-request/SKILL.md`):
1. Surveys the change (`git status`/`diff`) and refuses to commit to a default branch.
2. **Commits** with a clear message and **pushes** (with the repo's network-retry backoff) — this part is autonomous.
3. **Asks** the operator whether to open a PR, showing branch, base, and a proposed title/summary — and stops there if they decline.
4. Only on an explicit yes: detects a PR template, opens the PR via the GitHub MCP tools (no `gh` CLI here), reports the URL, and offers to watch it.

The commit/push-autonomous-but-PR-gated split matches this environment's rule that PRs are only opened on explicit request.

**Registry upkeep** (so it doesn't drift): added the skill to `meta/policy/skills-registry.md`, bumped its timestamp, and re-rendered `CLAUDE.md` with `mix brain.contract` — §7 now lists it. Logged the change in `meta/log.md`; `mix brain.verify` and `mix brain.contract --check` both pass clean.

One naming note tying back to our earlier thread: I filed it as the bare `/create-pull-request` (matching the repo's existing unprefixed convention). If you decide to go with the `sb-` prefix or a plugin later, this one comes along with the rest.
</routes>

## User

Calling this skill IS the permission to create - no gate needed

## Assistant

<routes ref=".claude/skills/create-pull-request/SKILL.md">
Done, pushed to `claude/repo-skills-namespacing-htu3lc`.

`/create-pull-request` now runs straight through: **survey → commit → push → open the PR** (with template detection), no confirmation step. The frontmatter, procedure, and guardrails all state that invoking the skill *is* the authorization — and I added a guardrail note not to reintroduce a gate. It also flags itself as the one sanctioned path that opens a PR without a further ask, so it doesn't read as contradicting the default-off PR rule elsewhere.

Registry stayed in sync: updated `skills-registry.md`, re-rendered `CLAUDE.md` (`--check` clean), and logged the revision. `mix brain.verify` passes.
</routes>

## User

_(operator invoked `/create-pull-request`)_

## Assistant

Pull request opened: **https://github.com/ob6to8/second-brain/pull/31**

- **Branch:** `claude/repo-skills-namespacing-htu3lc` → `main`
- **Commits:** all 4 on the branch (the `/intake` → `/summarize-technical` delegation + its flow-doc sync, and the new `/create-pull-request` skill + its later gate removal)
- Working tree was already clean and pushed, so there was nothing to commit — I went straight to opening the PR on the existing commits. No PR template in the repo, so I wrote a standard summary.

Want me to watch the PR for CI failures and review comments? I can subscribe to its activity and autofix/respond as things come in — just say the word.

## User

Merge into main

## Assistant

Merged. **PR #31 is now in `main`** (merge commit `740a34b`).

- Both changes are live on `main`: the `/intake` → `/summarize-technical` delegation (+ flow-doc sync) and the new `/create-pull-request` skill, along with the re-rendered `CLAUDE.md` and registry/log upkeep.
- No CI checks were configured on the repo, so there was nothing gating the merge; `mergeable_state` was `clean`.

Note for any follow-up work: `claude/repo-skills-namespacing-htu3lc` is now merged, so per the branching rules I'd treat further changes as a fresh start — restart the branch from the updated `main` rather than stacking new commits on the merged history. Want me to delete the merged branch, or leave it?

## User

Can we add /capture to /create-pull-request ? So that you run capture completely, then commit, then open a pr?

## Assistant

<routes ref=".claude/skills/create-pull-request/SKILL.md">
Done. `/create-pull-request` now runs `/capture` end-to-end as its first step, then commits, pushes, and opens the PR — so the frozen thread doc ships in the same PR.

**New procedure order:** capture (full skill: thread doc → routing ledger → route tags → `mix brain.route_tags --materialize`/verify) → survey → commit → push → open PR. I also added a guardrail ("capture before committing") and noted the one sensible escape hatch: if the session has nothing substantive to capture, it says so and skips rather than writing an empty thread doc.

Registry stayed in sync: updated `skills-registry.md`, re-rendered `CLAUDE.md` (`--check` clean), logged it; `mix brain.verify` passes.

Process note: since PR #31 had already merged, I restarted `claude/repo-skills-namespacing-htu3lc` from the updated `main` and put this follow-up there (commit `60c8cc3`, pushed) rather than stacking on merged history — per the branching rules. It's a fresh line of work, so opening a PR for it would be a **new** PR, not a reopen of #31.

Want me to open that PR now (via the freshly-updated `/create-pull-request` flow, which would capture this session first), or leave the branch as-is?
</routes>

## User

Yes

## Assistant

_(this capture — freezing the session into this thread doc — is the first step of that `/create-pull-request` run, followed by the commit, push, and new PR.)_
