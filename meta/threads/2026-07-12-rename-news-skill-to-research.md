---
type: reference
title: 2026-07-12-rename-news-skill-to-research
description: Renamed the /news skill to /research and scrubbed the "news" feature name to "research" across the live surface (skill, policy, glossary, flows, tutorial, analyses, plans, issues) plus three ratified file renames, protecting URLs, Hacker News, branch names, provenance, and frozen thread/digest prose; closed by opening this PR.
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-12; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, skills, rename, research, news, refactor, provenance]
timestamp: 2026-07-12
pr: 59
---

# 2026-07-12-rename-news-skill-to-research

## Where this landed

The operator asked to rename the `/news` skill to `/research`. The work ran in
two stages across the session. **Stage 1 (command rename):** move
`.claude/skills/news/` → `.claude/skills/research/`, update the `SKILL.md`
frontmatter/heading/self-references, swap the command token in the
`skills-registry` policy, recompile `CLAUDE.md`, and propagate `/news` →
`/research` through the live descriptive surface (glossary, flows, tutorial,
`index.md`/`README.md`) — repointing the moved-file links and the three
`2026-07-09` threads' route-tag and routing-ledger pointers so
`mix brain.verify` and `mix brain.route_tags` stayed green. Frozen conversation
prose and dated digests were kept verbatim. An `AskUserQuestion` about how far
to propagate failed (approval gate), so the middle option shipped first and the
question was restated in chat.

**Stage 2 (feature scrub):** the operator chose maximal consistency — "scrub
news in favor of research" — and ratified three file renames
(`meta/flows/news-inbox.md` → `research-inbox.md`,
`meta/plans/auto-intake-featured-news.md` → `auto-intake-featured-research.md`,
`meta/plans/news-daily-read-synthesis.md` → `research-daily-read-synthesis.md`).
A survey proved a literal string-scrub would be destructive, so the scrub
renamed the *feature* (skill, feed, inbox digest, flow, its plans, the Routine,
tags) while a masked script protected what is not the feature: "Hacker News",
`news.ycombinator`/`insights-news`/`newsletter` URLs, real `claude/*` git branch
names, generated `## Thread excerpts` route-tag log blocks, immutable
`provenance:`/`resource:` fields, frozen thread prose, dated inbox digests, and
the `daily-news-routine-runs-not-landing.md` issue *filename*. Two commits landed
on `claude/rename-news-to-research-ibzs8a` (34 files in the scrub), all three
verifiers green.

The operator also asked to **delete the daily feed Routine** (they'll run it
manually and re-instigate later); nothing durable is lost because its prompt and
troubleshooting trail already live in the repo. The `claude-code-remote` trigger
tools are hard-blocked by the environment approval gate (the same gate behind the
"runs not landing" issue), so the deletion is left to the operator — the
correct location is [claude.ai/code/routines](https://claude.ai/code/routines)
(click the routine → detail page → delete/trash icon, or pause via the
"Repeats" toggle). The session closed via `/create-pull-request`.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Rename `/news` → `/research` (skill dir, SKILL.md, policy, CLAUDE.md) | closed | unrouted (operational; back-linked to [`/research` skill](/.claude/skills/research/SKILL.md)) | - |
| Scope decision — how far the rename propagates (chose full scrub) | closed | unrouted | - |
| Scrub "news" → "research" across the live feature-surface | closed | unrouted | - |
| Ratified file renames (flow + two plans) | closed | unrouted | - |
| Delete the daily feed Routine | paused | `unrouted` (operational; relates to [the runs-not-landing issue](/meta/issues/daily-news-routine-runs-not-landing.md)) | Operator deletes it at claude.ai/code/routines (agent-side approval gate); re-instigate later pointed at `/research` |
| Open the PR for the rename branch | closed | unrouted | - |

## User

Change the name of the /news skill to /research.

## Assistant

I'll start by giving you the priority appraisal the session-init asked for, then get to your request.

**Top-3 appraisal:** The heuristic ranking (skills-compile plan #1, then the two open issues) is reasonable, but I'd note the skills-compile plan is directly relevant to *this* request — if we eventually compile §7 from SKILL.md frontmatter, renames like this get cheaper. For right now, your `/news` → `/research` rename is the priority since you've asked for it directly. Let me scope it.

Let me explore what references `news` across the bundle.

Scope is clear. The rename should touch only **live/forward-looking** references — the skill itself, the policy it's compiled from, and the two other active docs that point at it as a command. Historical provenance (thread docs, inbox digests, done plans, open issues, glossary citations) stays untouched — those sessions really did run `/news`.

Let me start with the directory move, then the edits.

The route-tag refs are path back-links to the moved file — the verifier requires them to resolve, so updating the `ref=` pointer (metadata over the frozen body, not the prose itself) is the correct reconciliation, exactly as any file-move breaks path back-links. Let me fix all three, plus the 8 broken markdown links in live docs (glossary, inbox index, flow, tutorial — none are frozen threads/digests):

All occurrences are the same relocated-file pointer: 3 are route-tag `ref=` attributes (metadata over frozen bodies, not conversation prose) and 7 are ordinary cross-links in live docs. Pointing them at the file's new location is pointer maintenance, not history rewriting — the file is the same, just moved. I'll replace the exact path token globally across these files:

That last hit is frozen conversation prose inside a thread doc (a past `## Assistant` turn describing which files a branch touched at the time) — inline code, not a live link or route ref, and the verifier doesn't flag it. Rewriting it would falsify what was said, so it correctly stays as provenance.

Let me review the complete diff before committing:

I over-reached. The global replace correctly updated the structural pointers (route `ref=` attributes and routing-ledger "Routed to" column links, which the verifier reads and requires to resolve), but it also rewrote **frozen conversation prose** — verbatim `## Assistant` turns and a quoted Routine prompt that *said* `/news`/`.claude/skills/news/SKILL.md` at the time. Those must stay verbatim per the capture-freeze rule (they're inline-code/plain-text, not links, so reverting them triggers no broken-link warning and the route checker doesn't touch them).

Let me revert only the frozen-prose occurrences, keeping the structural pointers pointed at the new path:

The link *targets* in the live glossary/flow/tutorial docs now point at `research/SKILL.md`, but their visible prose still says `/news` — producing an inconsistent `[`/news`](…research…)`. Since the command no longer exists as `/news`, these live descriptive docs should say `/research`. Let me map the full live-command-token surface (excluding frozen threads, dated digests, and deprecated) to decide scope precisely:

This is a much larger and more opinionated surface than the skill rename itself — **~35 live files** still reference `/news` as a command token, including point-in-time analyses, durable plan/issue records, and SWE concept captures. The functional rename is done and CI-green; how far the *command-name* propagates into descriptive prose is a genuine judgment call with real tradeoffs (accuracy of live docs vs. not rewriting durable/dated records). That's yours to decide.

Current state (done + verified): the skill is now invocable as `/research` — directory renamed, `SKILL.md` frontmatter/body updated, `skills-registry` policy + `CLAUDE.md` recompiled, and the moved-file links + route-tag/ledger pointers fixed so `mix brain.verify` and `mix brain.route_tags` pass. Frozen thread prose and dated digests were kept verbatim.

## User

Continue from where you left off.

## Assistant

The AskUserQuestion tool failed (permission stream closed), and you've asked me to continue. I'll proceed with the recommended default — **live descriptive docs** — and report the boundaries clearly so you can extend the scope if you want. But first let me confirm these mentions are body prose, not immutable `provenance:` fields (which must stay verbatim per the contract):

None of these `/news` tokens sit inside immutable `provenance:` fields — they're body prose, descriptions, and glossary-index entries. The `tags: [..., news, ...]`, "news inbox" nouns, and "Seen in:" citation titles are the *noun*/frozen-doc references and stay. But I must check one hazard: `/news` inside a generated `## Thread excerpts — route-tagged log` block (lifted from a frozen thread) must NOT be edited, or log-fidelity breaks. Let me check:

None of my target files carry a route-tag log section, so editing their definition prose is safe. Also important: the command token is always slash-prefixed `` `/news` `` while the *noun* is bare "news" (e.g. "news inbox", the path `/meta/flows/news-inbox.md`) — so a blind `/news` replace would corrupt paths. I'll replace only the backticked command form globally, then fix the two plain-text command tokens individually:

Clean change set — exactly the intended scope: the skill, its policy/contract, and live descriptive docs (glossary, flows, tutorial, index/README), plus the three threads' structural route/ledger pointers (frozen prose preserved). No analyses, plans, issues, SWE captures, or dated digests touched. Committing and pushing to the designated branch:

Done. The `/news` skill is renamed to `/research`, committed and pushed to `claude/rename-news-to-research-ibzs8a`.

## What changed

<routes ref=".claude/skills/research/SKILL.md">
**The skill itself** — `.claude/skills/news/` → `.claude/skills/research/`, with the `SKILL.md` frontmatter `name`, heading, and command self-references updated. It's now invocable as `/research`.
</routes>

<routes ref="meta/policy/skills-registry.md">
**Policy + contract** — swapped the command token in `meta/policy/skills-registry.md` and recompiled `CLAUDE.md` (`mix brain.contract`; drift check passes).
</routes>

**Live descriptive docs** — propagated the command rename into docs that describe the current system: 7 glossary bodies, the news-inbox flow + flows index, the bundle-scope tutorial, and the root `index.md`/`README.md`. The moved-file links were repointed too, and the three `2026-07-09` thread docs' route-tag `ref=` attributes and routing-ledger links were updated so `mix brain.verify` and `mix brain.route_tags` both stay green.

**Deliberately left verbatim** — frozen thread *conversation prose* and dated inbox digests (provenance), durable/point-in-time records (analyses, plans, issues), SWE concept captures, all filenames, and the "news"/"inbox" *nouns*. Only the invocable command was renamed, not the feature's subject matter.

## Two things worth flagging

1. **Scope was a judgment call.** I tried to ask you how far to propagate (skill-only vs. live-docs vs. everything including the ~15 durable analysis/plan/issue records), but the question tool failed with a permission error. I went with the middle option — **live descriptive docs** — since it produces accurate, consistent docs without rewriting dated/durable records. If you'd rather I also sweep `/news` → `/research` through

## User

Restate those questions here in the thread?

## Assistant

Here's the question I tried to ask, restated:

**How far should the `/news` → `/research` rename propagate through the rest of the brain's docs?** (The skill, its policy, `CLAUDE.md`, and the mandatory link/route-pointer fixes are already done and pushed. This is only about descriptive prose mentions of the command elsewhere.)

1. **Live descriptive docs** *(what I went with)* — swap the `/news` command token → `/research` in docs that describe the current system: glossary term bodies, `meta/flows`, the bundle-scope tutorial, and `index.md`/`README.md`. Leave durable/point-in-time records (analyses, plans, issues) and SWE concept captures verbatim, since they reference the tool by its then-name. Keep all filenames and the "news"/"inbox" nouns.

2. **Skill + registry only** — stop at the functional rename. Leave every prose mention of `/news` as-is (some live docs would then read `/news` while linking to `research/SKILL.md`, and the moved-file links would be broken). Most conservative; fewest files touched.

3. **Everything non-frozen** — also swap `/news` → `/research` across analyses, plans, issues, and SWE concept captures (~35 files total). Most consistent, but rewrites durable decision/problem records — including the open issue about the daily `/news` Routine, which is named around the old command.

Two related notes that fell outside all three options:

- **Filenames unchanged.** `meta/flows/news-inbox.md` and the plans `auto-intake-featured-news.md` / `news-daily-read-synthesis.md` still carry "news" in their paths. Renaming files is a shape change I'd want you to ratify, and it'd churn every link to them — so I left them regardless of scope.
- **The external Routine.** Your daily scheduled Routine fires `/news` as its prompt; that lives outside the repo, so this rename doesn't touch it. It'll keep invoking the now-nonexistent `/news` until you repoint it to `/research` in the scheduled-triggers UI.

Want me to extend to option 3, or adjust anything in what's already pushed?

## User

I lean toward 3, Priority prioritizing consistency (#3) unless there's a reason I should consider otherwise. what is the cost? Is it time and effort, or does it introduce Other issues?

Ratify file name changes

Can you clarify what you're talking about with the external routine? Not exactly sure what the action you're looking for from me is.

## Assistant

That trigger-list call hit the same approval gate that's noted in your open issue — so I can't read the Routine's current state directly. I'll explain it conceptually. Here are all three:

## 1. Cost of option 3 (full consistency)

**Mostly effort/churn, not architectural risk — but two real, manageable hazards:**

- **It lightly rewrites point-in-time records.** Analyses, plans, and issues are dated write-ups describing the system *as it was when written*. Swapping `/news` → `/research` in their bodies makes them read as if it was always `/research` — a minor historical-fidelity smudge. It's *allowed* (those bodies aren't formally frozen the way thread conversation prose, dated digests, `sb:` ids, and `provenance:` frontmatter are — I won't touch those in any option), but it does blur "what did we call it back then." For most it's harmless; the one that gives me pause is the open issue `daily-news-routine-runs-not-landing.md`, whose whole subject is a Routine that literally fires `/news`.

- **A technical trap: generated route-tag log blocks.** Several of those ~35 files carry `## Thread excerpts — route-tagged log` sections that `mix brain.route_tags` regenerates from frozen thread tags. Those frozen threads still say `/news`, so the log blocks must *stay* `/news` — if I edit `/news` inside one, the fidelity check fails CI. It's handleable (edit only the prose around the blocks), just requires per-file care rather than a blind sweep.

Net: reversible via git, no design consequences. **My recommendation is to proceed with #3** — the consistency win outweighs the smudge, and I'll keep the frozen/generated regions intact.

## 2. Filenames

Worth a precise distinction before I rename anything: the three files I flagged use "news" as a **noun** (the content), not as the `/news` **command**:
- `meta/flows/news-inbox.md` — "the inbox of news"
- `meta/plans/auto-intake-featured-news.md` — "featured news items"
- `meta/plans/news-daily-read-synthesis.md` — "the daily read of news"

The feed still surfaces *news* — I'm only renaming the command that invokes it. So strictly these could stay. If your goal is **zero "news" residue anywhere**, I'll rename them to `research-inbox.md`, `auto-intake-featured-research.md`, `research-daily-read-synthesis.md` (and fix every link). I'd **not** rename the dated thread docs (`2026-07-09-daily-news-inbox-routine.md`, etc.) — those are frozen provenance and renaming breaks their "Seen in" citations and PR anchors.

Quick check: do you want the command renamed (keep "news" the noun, files stay) — or "news" scrubbed entirely (files rename too)? Your "ratify filename changes" reads like the latter; I just want to confirm before churning links, since the noun is arguably still accurate.

## 3. The external Routine — what it is and what I need from you

In an earlier session, a **scheduled Routine** was set up (via the Claude Code web scheduling UI / the `claude-code-remote` trigger system) to run the feed automatically once a day. It's a saved job stored **server-side, outside this git repo** — its saved prompt literally starts with `/news …`. Because it lives outside the repo, nothing I commit can change it.

So after this rename: the daily automated fire will still invoke `/news`, which no longer resolves to a skill → that run will do nothing useful.

**The action:** edit that Routine's saved prompt to say `/research` instead of `/news`. Two ways:
- **You, in the UI** — open the scheduled-triggers view at claude.ai/code and edit the daily feed Routine's prompt. (This is also where the separate "runs not landing" approval-gate issue lives.)
- **Me** — I *can* do it via the trigger tools, but it requires deleting and recreating the Routine (the update tool can't edit a saved prompt), and the trigger tools are behind the same approval gate that just blocked my `list_triggers` call. If you approve those calls, I'll recreate it pointed at `/research`.

Want me to take the Routine, or will you? And confirm the filename question above and I'll execute #3 in the same pass.

## User

Scrubb News in favor of Research.
The routine is having problems. Just go ahead and delete it, and I will run news selectively daily manually. Then troubleshoot and reinstigate the automated hook later. Unless you feel like there's enough developmental progress within that hook and routine to save.

## Assistant

Clear instructions. Let me handle the Routine first (it needs your approval to delete), then do the full scrub.

**On saving the Routine:** nothing durable is lost by deleting it. The Routine is just a saved cron+prompt trigger living server-side — and its saved prompt and the entire troubleshooting history are *already* preserved in the repo (the `daily-news-routine-runs-not-landing.md` issue and the two `2026-07-09` thread docs, which quote the exact prompt). So there's no "developmental progress" trapped in the trigger itself; recreating it later is a two-minute job from those records. Deleting is safe. Let me find and delete it:

## User

Continue from where you left off.

## Assistant

The trigger tools keep hitting the approval gate (the same failure your open issue documents) — so I can't delete the Routine programmatically right now. I'll flag that for you at the end and move on to the scrub, which is the main work.

Before any blind replace, I need to see how "news" actually appears in the lower-value files — I must not turn ordinary-English "news" into "research" where it'd mangle meaning, and I must protect immutable regions. Let me survey:

The survey is decisive: a literal string-scrub would be destructive. "news" appears as **"Hacker News"** (the website), in **URLs** (`news.ycombinator.com`, `insights-news`, `newsletter.…`), as **real git branch names** (`claude/daily-news-inbox-routine-uj0ipu`), inside **generated route-tag log blocks** in the SWE docs, and in **immutable `provenance:`/`resource:` fields**. None of those are the feature. So "scrub news → research" means renaming *this feature* (the skill, feed, inbox digest, flow, its plans), not the substring.

That means **SWE/**, **ai-industry/**, and the **orphaned-branches issue** get zero changes (all their "news" is website/URL/branch/frozen-block). Let me first do the ratified file renames, then run a carefully-masked scrub over the live feature-surface and review the full diff.

Two problems from the renames: a **hard route-tag failure** (a `<routes ref>` points at a renamed file) and a **broken Seen-in link** in `glossary/run.md` (I skip Seen-in lines to preserve citation labels, but links to *renamed* files still need their path updated). Let me find all references to the three renamed files that still use the old paths:

Clear now. The renames left stale references in three categories. Let me get the complete list of broken-link warnings, then fix precisely: the **route ref** and **ledger pointers** (structural, must resolve) and **live-doc link paths** (glossary), while leaving frozen conversation *prose* verbatim (tolerated broken links):

## User

Continue from where you left off.

Continue from where you left off.

## Assistant

The trigger tools are firmly behind the same approval gate your open issue documents — three attempts, all "permission stream closed." I can't delete the Routine programmatically from here. That one action is left to you.

## Done and pushed (branch `claude/rename-news-to-research-ibzs8a`, 2 commits)

**Commit 1 — command rename** `/news` → `/research`: skill directory + `SKILL.md`, `skills-registry` policy, recompiled `CLAUDE.md`.

**Commit 2 — feature scrub** "news" → "research" across the live surface, plus three ratified file renames:
- `meta/flows/news-inbox.md` → `research-inbox.md`
- `meta/plans/auto-intake-featured-news.md` → `auto-intake-featured-research.md`
- `meta/plans/news-daily-read-synthesis.md` → `research-daily-read-synthesis.md`

34 files touched. All three verifiers green: `mix brain.contract --check`, `mix brain.verify`, `mix brain.route_tags`.

**Deliberately left as-is** (these "news" aren't the feature): "Hacker News" + `news.ycombinator`/`newsletter` URLs, real git branch names, the SWE/ai-industry captures, generic phrases like "news, customer messages", immutable `provenance:`/`resource:` fields, frozen thread conversation prose + dated inbox digests, and the `daily-news-routine-runs-not-landing.md` issue *filename* (its body/title did scrub to `/research`).

## Two things need you

1. **Delete the Routine (blocked on my end).** It's at **claude.ai/code → scheduled triggers**; delete the daily feed Routine there. Nothing durable is lost — its prompt and the whole troubleshooting trail live in the repo (the issue + the two `2026-07-09` thread docs), so re-instigating later is trivial. Same approval gate is the root of the "runs not landing" issue, so you'll be in the right place to tackle both.

2. **A PR?** You haven't asked for one and I haven't opened it. Say the word (or `/create-pull-request`) and I'll capture the session and open it.

One note for transparency: the scrub rewrote feature references inside the durable analysis/plan/issue records too (your "everything, prioritize consistency" call). That's the maximal-consistency result you asked for — but if you'd rather those point-in-time records kept their original "news" wording as historical fact, I can pare commit 2 back to just the live descriptive surface. Easy to adjust either way.

## User

Continue

## Assistant

The work is complete and fully landed — clean working tree, both commits pushed, local `HEAD` and remote at the same SHA (`12e1c87`), all three verifiers green.

There's nothing further I can do autonomously. The two open items both need an action outside my reach:

1. **Delete the Routine** — needs you, in claude.ai/code → scheduled triggers. The trigger tools are hard-blocked by the environment approval gate here (four failed attempts), which is the same gate behind your "runs not landing" issue.

2. **A PR** — I'll only open one on your explicit say-so. Reply with `/create-pull-request` (or "open the PR") and I'll capture the session and open it; otherwise the branch is ready whenever you want to merge it yourself.

I held off on the PR because "Continue" isn't an explicit request for one. Which of those would you like — or is there something else on the rename you want adjusted (e.g. paring commit 2 back to only the live descriptive docs, leaving the durable analysis/plan/issue records with their original "news" wording)?

## User

"claude.ai/code → scheduled triggers" - Not seeing this at this location.

## Assistant

That's my error — the correct location is **`claude.ai/code/routines`** (a dedicated Routines page), not "claude.ai/code → scheduled triggers." Here's the accurate path from the docs:

## To delete the Routine

1. Go to **[claude.ai/code/routines](https://claude.ai/code/routines)** — this lists all your routines.
2. **Click the routine** (the daily feed one — it'll be the one whose prompt starts with `/news …`) to open its **detail page**.
3. Click the **delete icon (trash)** to remove it. Per the docs: *"Past sessions created by the routine remain in your session list"* — so your history stays, only the schedule goes.

If you'd rather not delete outright, the detail page also has a **toggle in the "Repeats" section to pause** it — same effect (it stops firing) but keeps the config so you can flip it back on when you re-instigate later.

A couple of related notes:
- **The CLI `/schedule` won't help you here.** The docs explicitly say: *"You are inside a Claude Code on the web session. Manage routines from the web UI instead."* That's also why my trigger tools are gated in this session. So the web page is the way.
- **When you re-instigate later**, update the prompt to `/research` (not `/news`) — the saved prompt is the only place the old command name still lives, since it's server-side and outside the repo.

That page is also where you'll see whether runs are actually landing, which ties into your "runs not landing" issue.

Want me to do anything else — open the PR for the rename branch, or pare back commit 2 as I mentioned?

## User

Done pr merged?

## Assistant

No — nothing is merged, and there's **no PR yet**. Here's the exact state:

- **No PR exists** for `claude/rename-news-to-research-ibzs8a` (I never opened one — the contract says I only open a PR on your explicit request).
- The branch is **pushed** with both commits (`2a9ecd8` rename, `12e1c87` scrub), all verifiers green.
- Those two commits are **not in `origin/main`** — the branch is unmerged.

So the work is done and safely on the branch, but it still needs a PR opened and merged to land on `main`.

Want me to open the PR now? If so I'll run `/create-pull-request` (captures this session as a thread doc, runs the glossary pass, then opens the PR). Just confirm and I'll go.
