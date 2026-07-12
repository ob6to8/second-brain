---
type: reference
title: 2026-07-11-deprecated-directory-triage-and-machinery-deletion
description: Assessed whether deprecated/ can be deleted (not yet), migrated the first legacy source via /intake, deleted the old assertion-graph machinery; then shipped and true-merged PR #43, glossaried strand/ledger, and — after the operator challenged the hand-kept logs' DRY violation — ratified, planned, and executed the retirement of log.md in favor of git history, adding a priority override to the session-init digest along the way.
provenance: "Claude Code session, 2026-07-11; verbatim retained messages parsed from the host session log — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, deprecated, migration, intake]
timestamp: 2026-07-11
pr: 43
---

# 2026-07-11-deprecated-directory-triage-and-machinery-deletion

Verbatim render. Retained operator messages and agent responses are reproduced
**verbatim** (the delivered text); only tool calls, tool results, reasoning, and
short pre-tool narration are stripped. Parsed from the host session log via
`/capture`'s parse-the-log path.

## Where this landed

The operator asked whether the `deprecated/` directory — the pre-OKF
"assertion graph" knowledge base — is safe to delete. The session established
it is **not yet**: the machinery is disposable but the content isn't migrated.
Three things happened. First, the initial migration:
`deprecated/sources/ai-agent-memory-markdown-files.md` was processed via
[`/intake`](/.claude/skills/intake/SKILL.md) into
[AI agent memory management — when markdown files are all you need](/SWE/agentic-coding/context-engineering/ai-agent-memory-management-markdown-files.md)
(`sb:41a1e3`), re-fetched from the live dev.to article rather than copied, so
the capture gained detail the legacy summary lacked. Second, on the operator's
direction, the legacy system's **machinery was deleted** (commit `d1ef400`,
3,423 lines): scripts, schema, templates, publish staging, old skills, the
generated `index.json`, and its `CLAUDE.md`/`README.md` — all recoverable from
git history — while the **content** was kept pending triage: 13 source
captures, 9 assertions, a 604-line raw-URL backlog discovered in
`intake/intake.md`, and the old plans, with a new `deprecated/README.md`
tracking migration state. Third, the remaining work was filed as a task
("Go through rest of deprecated/") carrying the batching order (the six-source
agent-memory cluster first), the assertion-folding approach, and the two
operator decisions still open (URL backlog: triage or discard; old plans:
graduate any to `meta/`?). Work happened on branch
`claude/deprecated-directory-deletion-myusjh`.

The session then continued past its first capture. **PR #43** shipped the
above and was **true-merged** (`a8ed48c`) after resolving append-collision
conflicts with four parallel-session PRs — the squash attempt was rejected by
the repo, which had just ratified the merge-strategy policy. A glossary pass
added [strand](/glossary/strand.md) and folded *ledger* into the existing
routing-ledger entry, and the operator's question "is the log the best place
to find that hierarchy?" exposed that an agent had cited a **stale log entry**
as the source for the session-init ranking. That grew into the session's
second major outcome: the operator challenged the hand-kept logs as a DRY
violation with no discrete irreplaceable use case ("the only true guarantee is
one source of truth… why is git history not enough?"), the enumeration
conceded the point, and
[retire-hand-kept-logs](/meta/plans/retire-hand-kept-logs.md) was filed
(`accepted`, `priority: 1`), then executed the same day (`62d9327`): the three
`log.md` files deleted, seven policies and seven skills stripped of log-entry
mandates, the contract recompiled — git's commit graph is now the single
provenance layer. Supporting that, `SecondBrain.SessionInit` gained an integer
`priority:` frontmatter override that pins a flagged item above every
heuristic class in the digest's top-3.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Migrating `ai-agent-memory-markdown-files` from `deprecated/sources/` into the bundle | closed | [ai-agent-memory-management-markdown-files](/SWE/agentic-coding/context-engineering/ai-agent-memory-management-markdown-files.md) | - |
| Is `deprecated/` safe to delete? — triage of what remains | open | `unrouted` | 13 sources + 9 assertions to migrate; operator to decide fate of the raw-URL backlog and the old plans |
| Deleting the legacy assertion-graph machinery | closed | `unrouted` | - |
| PR #43 lifecycle — opened, conflicted with four parallel-session PRs, true-merged `a8ed48c` under the new merge-strategy policy | closed | `unrouted` | - |
| Harness tasks vs. repo todos — why the session-init digest can't see Task #1 | closed | `unrouted` | - |
| Glossary: *strand* filed, *ledger* folded into routing-ledger; session-init ranking order documented in prose with a pointer at `@weights` | closed | [strand](/glossary/strand.md) | - |
| Retiring the hand-kept logs — challenged as a DRY liability, enumerated, ratified, planned, executed (`62d9327`) | closed | `unrouted` | - |
| Digest `priority:` frontmatter override (operator-flagged items pin above heuristic classes) | closed | `unrouted` | - |
| Plan lifecycle — where done plans go (nowhere; status + index section) | closed | `unrouted` | - |

## User

Are we clear to delete deprecated directory?

*(This and the next two operator prompts each received only a harness
rate-limit banner — "You've hit your session limit · resets 11:20am (UTC)" —
with no agent response; the work began on the fourth prompt.)*

## User

Continue from where you left off.

## User

/intake ai-agent-memory-markdown-files.md

## User

Continue from where you left off.

## Assistant

The intake is filed, verified, and pushed. Here's where things stand:

<routes ref="sb:41a1e3">
**Intake result.** `deprecated/sources/ai-agent-memory-markdown-files.md` is now migrated into the bundle as [`SWE/agentic-coding/context-engineering/ai-agent-memory-management-markdown-files.md`](/SWE/agentic-coding/context-engineering/ai-agent-memory-management-markdown-files.md) (`sb:41a1e3`, `type: reference`). I re-fetched the dev.to article rather than just copying the legacy capture, which added detail the old summary lacked (the author's name, Manus's `task_plan.md`/`notes.md`/deliverables pattern, and OpenClaw's 70:30 vector-to-BM25 weighting at 89% recall). It's cross-linked to the Anthropic memory-tool reference and the context-engineering essay, and the provenance records the migration from the legacy bundle. Directory `index.md`, root `log.md`, and `meta/registry.md` are updated; `mix brain.verify`, `brain.route_tags`, and `brain.contract --check` all pass. Committed and pushed to `claude/deprecated-directory-deletion-myusjh` (no PR opened — say the word or run `/create-pull-request` when you want one).
</routes>

<routes ref="deprecated/README.md">
**Are we clear to delete `deprecated/`? Not yet.** This was the *first* migration — after it, `deprecated/` still holds **13 unmigrated sources and 9 assertions** whose content exists nowhere else in the bundle. The rest of the directory (scripts, schema, templates, plans, publish tooling for the old assertion-DAG system) is legacy machinery I'd consider safe to drop, but the knowledge content needs triage first. Roughly:

- **Worth migrating** — the agent-memory cluster this intake belongs to (`openclaw-memory-architecture`, `basic-memory-mcp-knowledge-graph`, `context-engineering-and-persistent-agent-memory`, `design-patterns-long-term-memory-llm-architectures`, `persistent-memory-for-openclaw-mem0-plugin`, `logseq-markdown-vs-sqlite-discussion`), the Claude Code pair (`everything-claude-code-config-repo`, `longform-guide-everything-claude-code`), and probably `mcp-is-dead-long-live-the-cli` and `state-of-agentic-coding-ep3-armin-ben`.
- **Judgment calls** — `llm-cli-logging-to-sqlite`, `cli-mcp-conversation`, `macos-system-data-disk-cleanup` (the last looks like one-off ops trivia, likely not worth a concept).
- **The 9 assertions** — legacy atomic claims (e.g. "industry converged on markdown canonical, sqlite derived", "hybrid search outperforms pure vector or keyword"). These map naturally onto the `claim` type, or can be folded into the concepts their evidence migrates into rather than kept as standalone files.
</routes>

So the path to deletion is: keep draining via `/intake` (one command per file, or I can batch the whole cluster in one session), then delete once the triage list is empty. Want me to continue with the rest of the agent-memory cluster next?

## User

What about deleting the artifacts you deem safe to remove, old code etc?

## Assistant

Done — the legacy machinery is deleted and pushed (commit `d1ef400`, 3,423 lines removed, all verification suites green).

<routes ref="deprecated/README.md">
**Deleted** (all recoverable from git history): `scripts/` (the whole shell toolchain and its tests), `schema/`, `templates/`, `publish/` staging, the old `.claude/skills/` (`search`, `conclude`, `publish` — this also stops them auto-loading into sessions), the generated `index.json`, and the old system's `CLAUDE.md` and `README.md`, which only described the machinery that's now gone. I also removed `sources/ai-agent-memory-markdown-files.md`, since its content now lives in the bundle as `sb:41a1e3`.

**Kept — it's content, not code**: `sources/` (13 captures), `assertions/` (9 claims), `plans/` (the old system's architecture decision records), and one thing worth flagging: `intake/intake.md` turned out to be a **604-line backlog of raw collected URLs** — a reading list you gathered in March that was never processed. That's real material, so it stayed. I replaced the README with a short one that states what remains, why, and tracks migration status, and logged the deletion in root `log.md`.
</routes>

So `deprecated/` is now exactly the pending-migration set. The remaining path to full deletion: intake the 13 sources (I'd batch the agent-memory cluster first), fold the 9 assertions into the concepts their evidence migrates into (or file them as `claim`s), decide whether the URL backlog gets triaged or discarded, and decide if any of the old plans deserve a home in `meta/` as historical decision records. Want me to keep going with the agent-memory source cluster?

## User

What does "Want me to keep going with the agent-memory source cluster?" mean?

Thinking to pause for now

Add to todos: "go through rest of deprecated"

## Assistant

It was shorthand for: of the 13 legacy sources left in `deprecated/sources/`, six are all about the same topic — file-based memory for AI agents (`openclaw-memory-architecture`, `basic-memory-mcp-knowledge-graph`, `context-engineering-and-persistent-agent-memory`, `design-patterns-long-term-memory-llm-architectures`, `persistent-memory-for-openclaw-mem0-plugin`, `logseq-markdown-vs-sqlite-discussion`). Since they cover one subject and cross-reference each other, migrating them together in one pass (rather than one `/intake` per file across separate sessions) lets me dedup them properly, cross-link them, and file them as a coherent set next to the article we just migrated. I was offering to do that batch next.

Pausing is fine — let me add the todo.

Todo added — **Task #1: "Go through rest of deprecated/"** — with the full remaining inventory baked into its description (the source batching order, the 9 assertions, the URL backlog and old plans that need your call, and the branch/commit references), so a future session can pick it up without re-deriving any of this.

Pausing here. Current state: branch `claude/deprecated-directory-deletion-myusjh` is pushed with two commits — the first migration (`sb:41a1e3`) and the machinery deletion — and `deprecated/` now contains only content pending triage. No PR has been opened; when you're ready to resume, "continue with deprecated" (or just pointing at the task) is enough.

## User

/create-pull-request

## Assistant

`/create-pull-request` complete, end to end:

- **PR opened:** https://github.com/ob6to8/second-brain/pull/43 — three commits on `claude/deprecated-directory-deletion-myusjh` into `main`: the first migration out of `deprecated/` (`sb:41a1e3`), the machinery deletion (3,423 lines), and the capture + glossary commit.
- **Captured thread doc:** `meta/threads/2026-07-11-deprecated-directory-triage-and-machinery-deletion.md` — parsed verbatim from the host session log (the three early prompts that hit the session-limit banner are noted honestly as harness errors, not rendered as dialogue). Its routing ledger has one open row: the remaining `deprecated/` migration, which stays tracked in Task #1.
- **Glossary:** four new terms from this session — [agent memory](/glossary/agent-memory.md), [assertion graph](/glossary/assertion-graph.md), [BM25](/glossary/bm25.md), and [hybrid search](/glossary/hybrid-search.md) — taking the glossary from 69 to 73 terms.
- **Gates:** format, contract, registry, verify, route-tags, and all 78 tests green before the commit.

Want me to watch the PR? I can subscribe to its activity and respond to CI failures or review comments until it merges — just say so.

## User

Merge pr

## Assistant

PR #43 is merged — https://github.com/ob6to8/second-brain/pull/43, merge commit `a8ed48c` on `main`.

Two things came up along the way, both resolved:

1. **Squash was rejected by the repo** — it turns out a parallel session today ratified a new merge-strategy policy (`meta/policy/merge-strategy.md`: true merge commits only, since the commit graph is a provenance layer) and squash/rebase are now disabled in the repo settings. I merged with a true merge commit instead, which is exactly what the policy wants.

2. **The PR had conflicts** — `main` had absorbed four other PRs from today's parallel sessions (session-init digest, news digest + six intakes, doctrine/policy glossary work, the merge-strategy policy). The conflicts were the usual append-collision suspects: `log.md`, `meta/log.md`, `meta/threads/index.md`, `glossary/index.md` (resolved as a union of both sides' entries — nothing dropped), and `meta/registry.md` (regenerated with `mix brain.registry`, never hand-merged). I also corrected my log entry's glossary count, since the parallel sessions had added terms concurrently: the glossary now stands at **85 terms**. Full gate suite passed before the merge (format, contract, registry, verify, route-tags, and 81 tests).

So `main` now has the first `deprecated/` migration (`sb:41a1e3`), the machinery deletion, the captured thread doc, and the four glossary terms. The remaining migration work stays tracked in Task #1 ("Go through rest of deprecated/") — and I noticed the repo also gained a `/todo` skill today, so a future session could mirror that task into `meta/todos/` where the new session-init digest would surface it automatically. Want me to do that now, or leave it for the next session?

## User

The todo is created, why does it need to be "mirrored" to be picked up by the digest?

## Assistant

Because they're two different storage layers, and the digest only reads one of them.

The todo I created earlier (Task #1) lives in the **Claude Code harness task system** — session state managed by the app, not files in your repository. It's great for tracking work while a session (or its continuations) is alive, but it isn't a repo artifact: nothing under version control changed when I created it, and `mix brain.session_init` — which is plain Elixir tooling that scans the repo — has no access to it. The digest's four sources are all files: open issues under `meta/issues/`, open todos under `meta/todos/`, active plans under `meta/plans/`, and dangling routing-ledger strands in `meta/threads/`. A harness task is invisible to all four.

That said, "mirrored" was overstating the gap, because the work is *already* partially visible to the digest through a different door: the captured thread doc's routing ledger has an **open row** ("Is `deprecated/` safe to delete? — triage of what remains") with a dangling question listing the 13 sources, 9 assertions, URL backlog, and old plans. Open strands are one of the digest's four sources, so a fresh session's session-init digest will surface the deprecated work from that row even if nothing else is done.

The practical difference a `meta/todos/` entry would make: in the digest's priority heuristic, an explicitly recorded todo ranks *above* open strands (the ranking is issues > in-progress plans > todos > open strands > proposed plans, per the log), and it's a durable, self-contained statement of the task rather than a question hanging off a thread. The harness task also dies with this session's environment, while a filed todo survives anywhere the repo goes.

So: nothing is broken — the next session will see the work either way via the ledger strand. Filing a `/todo` would just promote it in the ranking and make the inventory self-contained. Happy to file it if you want that.

## User

/add-to-glossary strand, ledger

Is the log the best place to find that hierarchy?

## Assistant

Done — committed and pushed (`ccaf6a0`; the branch was restarted from the latest `main` first, since PR #43 had merged).

<routes ref="sb:bb2968">
**Glossary results:**
- **Added** [strand](/glossary/strand.md) (`sb:bb2968`) — one topic's line of work through a session: the unit the routing ledger tracks one row per, with a state (`open`/`paused`/`closed`) orthogonal to where its content routed, and "dangling strand" defined as the form the session-init digest harvests.
- **Merged, not duplicated:** *ledger* is the same concept as the existing [routing ledger](/glossary/routing-ledger.md) entry, so per the one-term-one-file rule that entry got the short-form note ("often shortened to just 'the ledger'") and a prose cross-link to *strand*, rather than a second file.
- All gates green; registry refreshed; root `log.md` updated. Glossary at 86 terms.
</routes>

<routes ref="lib/second_brain/session_init.ex glossary/session-init-digest.md">
**Is the log the best place to find that hierarchy? No** — and your question caught a real weakness. The log entry I quoted was just a change record, and it was already stale: it described the ranking *before* todos were added as a source. The canonical definition is the `@weights` map in `lib/second_brain/session_init.ex:35` (with the moduledoc stating it in prose at line 17): **issues → in-progress plans → todos → accepted plans → open strands → paused strands → leftover dangling questions → proposed plans**, newer first within a class. Since code isn't where you'd naturally look it up, I also stated the full order in the [session-init digest](/glossary/session-init-digest.md) glossary definition with a pointer to the module — so the glossary is now the best *prose* place to find it, and it cites where the truth lives.
</routes>

One aside since this session just resumed with a fresh digest: my appraisal matches the heuristic's top two — the `/news` Routine issue needs an operator action (checking the approval gate), while the `deprecated/` triage is the item I can drive end-to-end whenever you say go; the epistemic-overlay execution path is a solid third but is a bigger lift.

## User

Is it worth considering documenting something like the weights map canonical definition in code in a doc, or some sort of place in meta that is prose description? it seems like if we are going to document policy as comments in code and have that be the primary reference, it needs to be at least part of some sort of a manifest or register that points to that place for that reference.

As for the log, in this case it seems to have been a liability, you scanned it for information regarding policy and it turns out that information was outdated. It seems in a way that the log is hard to justify what is the upside to having it?

## Assistant

Both questions are governance calls for you to ratify, so here's my assessment rather than action.

**On a prose home / register for code-canonical definitions: yes, worth doing — and the brain already has the pattern to do it right.** The uncomfortable thing about the ranking order isn't that it lives in code — code is the one place it *can't* drift from reality, since it's the thing that executes. The problem is discoverability and authority: nothing tells a reader (or an agent grepping for "priority") that `session_init.ex` is where the truth is, so they land on whatever prose mentions it — yesterday that was a stale log entry. Two-tier fix, matching what the repo already does elsewhere:

1. **For terms, the glossary already is the register.** Pointer entries exist precisely to say "canonically defined over there" — the [session-init digest](/glossary/session-init-digest.md) entry now does this for the ranking (states the order, points at `@weights`). That's the lightweight manifest you're describing, and it costs nothing new.
2. **For rules that encode judgment, promote to policy + a drift check.** The ranking isn't really an implementation detail — "tracked problems outrank new work" is a *judgment about how the operator's attention should be spent*, which is policy-shaped. The principled move is a `meta/policy/` doc stating the order (ratified by you, compiled into the contract like everything else), with the code as enforcement and a cheap test asserting `@weights` matches the policy's stated order — the same structural-not-procedural trick as `mix brain.contract --check` and the route-tags fidelity check. Prose that *can't* silently diverge from code, because CI fails when it does.

I'd reserve tier 2 for things that are genuinely judgments (the ranking qualifies); pure mechanism (how ledger rows are parsed) should stay moduledoc-only, or a general register grows into a stale shadow of the codebase — the exact disease it's meant to cure.

**On the log: your criticism is fair, but the failure was mine more than the log's.** A log entry is a timestamped statement — "as of this morning, the ranking was X" — and it was *true when written*. It became a liability because I read a history record as a statement of current state. That's a category error a policy line can prevent; it isn't intrinsic to keeping history. The honest cost/benefit:

- **Real upsides:** it's the only *curated, prose, linkable* history — one entry per meaningful change with bundle-absolute links, readable on the rendered site where git history doesn't exist, and genuinely useful for catching up on parallel sessions (I leaned on it while resolving today's merge conflicts). It's also part of the OKF reserved-file structure, so dropping it is a format change, not just tidying.
- **Real costs:** it's a second, hand-maintained provenance layer next to git — and the merge-strategy policy just declared the commit graph the provenance layer. It hand-conflicts on nearly every parallel-session merge (today: `log.md` *and* `meta/log.md`), and as demonstrated, it tempts agents into citing it as current truth.

My recommendation: keep it, but demote its epistemic status explicitly — a line in the reserved-filenames policy along the lines of "logs are append-only history; never cite them as current state — current state lives in policy, code, and the glossary." Longer-term, if the conflict overhead keeps stinging, the interesting option is *generating* the log from `git log --first-parent` commit messages (the compiled-artifact pattern again), which would delete both the hand-maintenance and the conflicts — but that's a bigger change and today's commit messages are terser than today's log entries.

If you want, I can file this as a small `analysis` doc (so the reasoning persists) and/or draft the two policy changes for your ratification — say which.

## User

Regarding logs, I am still not seeing the compelling use case. Okay. It's a part of the o k f spec, but that does not require that we use it. I also don't know that it's fully justified in that it is certainly violating d r y. Don't repeat yourself. it's clearly creating An avenue for failure, as we just saw, you can suggest a fix, but you can't guarantee that fix can work. The only true guarantee is one source of truth. I guess the question I have is, why is get history not enough? especially given the attempts we're making at documenting intention and design across the repo, what is it that you might expect to get from a log that you couldn't get from anywhere else? If we can't define this discreetly, better to remove the liability, in my opinion.

## Assistant

<routes ref="meta/plans/retire-hand-kept-logs.md">
You've convinced me. I tried to enumerate what the log provides that nothing else in this repo does, and every candidate collapses under inspection — so by your own test (if we can't define it discretely, remove it), removal is the right call.

Here's the enumeration, honestly scored:

- **"What changed, when, and why."** Git history covers this *better* — and by your own ratified merge-strategy policy, the commit graph *is* the provenance layer: true merges keep every SHA reachable, session trailers link commits to the sessions that made them, and this repo's commit messages are deliberately written at the semantic level ("intake X", "ratify Y"), not "fix stuff". `git log --first-parent main` even gives the curated one-entry-per-PR reading that the log hand-maintains.
- **"Narrative catch-up for agents and the operator."** That job just got taken by the session-init digest, which compiles *current* open work from structured sources (issues, todos, plans, ledger strands) — a strictly better catch-up because it can't be stale prose.
- **"Decision context."** That's what plans, analyses, issues, and thread docs are for — the "documenting intention and design" effort you named. Every log entry I've written today was a paraphrase of either a commit message or a thread doc. Pure DRY violation; today's event was recorded in up to four places.
- **"OKF requires it."** It doesn't — the spec reserves the filename and defines its structure *when present*. A bundle with no `log.md` is fully conformant.
- **The one real gap: the rendered site doesn't show git history.** This is the only discrete thing left, and it doesn't justify a hand-maintained file — if it ever matters, a changelog page can be *generated* from `git log --first-parent` at site build, the same compiled-artifact pattern as `CLAUDE.md` and the registry: readable history with zero second source of truth.

And your structural point is correct: my proposed "never cite logs as current state" line is a behavioral patch, not a guarantee. Agents retrieve by grep; stale-but-greppable prose *will* eventually be retrieved and trusted again. One source of truth is the only fix that can't regress.

One important scoping distinction, because the repo has two things called "log": this verdict covers the **hand-kept chronological logs** — root `log.md`, `meta/log.md`, `inbox/log.md`. It does *not* cover the `## Thread excerpts — route-tagged log` sections inside concepts: those are generated from route tags and CI-verified for fidelity (`mix brain.route_tags`), so they're already one-source-of-truth artifacts, not a drift liability.

Executing this is a genuine shape change with tentacles: the reserved-filenames and maintain-reserved-files policies, the taxonomy-evolution and persist-plans policies (both mandate log entries), four-plus skills (`/intake`, `/capture`, `/add-to-glossary`, `/todo`), the flows docs and possibly their scenario tests, then a contract recompile and deleting the three files (git history keeps everything recoverable). Per the persist-plans policy I'd write this up as `meta/plans/retire-hand-kept-logs.md` first — problem, rationale (this conversation is essentially the design review), scope boundary (excerpt logs stay), and the execution checklist — for your ratification before I touch anything.
</routes>

Want me to draft that plan now?

## User

Yes, draft that plan, and are you able to set a priority flag or something that would indicate it should be surfaced into the top three of the digests? I would almost recommend that this be surfaced to number one.

## Assistant

I'll draft the plan, and for the priority flag — no such mechanism exists in the digest today, but it's a small addition to `SecondBrain.SessionInit` (an explicit `priority:` frontmatter key that pins an item above the heuristic classes). I'll build both. First, the relevant parts of the ranking code:

Both pieces are done, tested, and pushed (`c6e3f9a`).

**The plan:** [`meta/plans/retire-hand-kept-logs.md`](/meta/plans/retire-hand-kept-logs.md), `status: accepted` (this conversation is recorded as the design review and ratification). It carries the problem statement, the failed enumeration as a table (each claimed log benefit and what already covers it), the decision, a hard scope boundary — the generated, CI-verified route-tagged excerpt logs stay — a concrete execution checklist built from a grep of everything that references `log.md` (7 policies, 7 skills, the intake flow, tests, plus a contract recompile), and the deferred option of a generated `git log --first-parent` changelog for the rendered site if that gap ever matters.

<routes ref="lib/second_brain/session_init.ex">
**The priority flag:** there was no such mechanism, so I built it. Any issue, todo, or plan can now carry an integer `priority:` frontmatter key (1 = most urgent); `SecondBrain.SessionInit` pins flagged items above every heuristic class, ordered by the integer, with a "why" line that says so. Strands can't be flagged (ledger rows have no frontmatter). It's documented in the moduledoc and the [session-init digest](/glossary/session-init-digest.md) glossary entry — updated in the same commit so the prose can't be stale about the very ranking it describes — and covered by a new test (82 pass, all gates green).
</routes>

Live proof from `mix brain.session_init` just now:

```
1. Retire the hand-kept chronological logs (log.md) in favor of git history
   — operator-flagged `priority: 1` — pinned above the heuristic classes
2. Daily /news Routine: automated runs not landing on main
3. Is `deprecated/` safe to delete? — triage of what remains
```

So the next session — this one or a fresh one — opens with the log retirement at #1. One small irony worth savoring: per still-active policy, filing this plan required appending a `meta/log.md` entry, which I noted in the entry itself is expected to be one of the last of its kind. Say the word when you want the plan executed, or `/create-pull-request` to ship what's on the branch.

## User

Ok. Can we delete the log then as well?

## Assistant

<routes ref="meta/plans/retire-hand-kept-logs.md meta/policy/reserved-filenames.md">
Done — the logs are gone. Commit `62d9327` pushed: 23 files, 1,181 lines deleted, all gates green (82 tests).

What the execution touched, per the plan's checklist:

- **Deleted** root `log.md`, `meta/log.md`, and `inbox/log.md`. Their entire history stays reachable in git — nothing was lost, there's just no longer a hand-kept copy to drift.
- **Policies** (7): `reserved-filenames` now says `log.md` is reserved by OKF for tolerant consumption but *this bundle does not keep logs* — commit messages are the change record; `maintain-reserved-files` is index-upkeep only; the log-entry mandates came out of `taxonomy-evolution-protocol`, `update-in-place`, `persist-plans`, and `skills-registry`; the `okf-conformance` tolerant-consumer clause stays by design. `CLAUDE.md` recompiled from the sources.
- **Skills** (7): `/intake`, `/capture`, `/create-pull-request`, `/add-to-glossary`, `/news`, `/summarize-technical`, and `/todo` no longer instruct log entries — several now explicitly say the commit message carries the narrative.
- **Flows/docs**: the intake flow's diagram, touch-sequence, actor table, and gate notes updated; the bundle-scope tutorial's link to the now-deleted `inbox/log.md` removed; root `index.md`'s reserved-files section now states there are no logs and why.
- **Deliberately kept**: the `log.md` exclusions in `registry.ex`/`site.ex`/`session_init.ex` (tolerant-consumer behavior toward bundles that do keep logs), and the generated route-tagged excerpt logs, which were always out of scope.
- **The plan** is flipped to `done` and moved in the plans index — it dropped out of the session-init digest exactly as it should, and the digest now leads with the `/news` Routine issue and the `deprecated/` triage again.

One source of truth now: current state lives in policy, code, and the glossary; history lives in git alone. Fittingly, this is the first change in the repo's life recorded *only* by its commit message.
</routes>

## User

Where do plans go when they're done?

## Assistant

Nowhere — they stay exactly where they are. A finished plan keeps its file under `meta/plans/`; only two things change:

1. **Its `status` flips to `done`** (or `superseded` if replaced by a newer plan). That's the lifecycle from the persist-plans policy: `proposed → accepted → in-progress → done/superseded`, and the policy is explicit that done and superseded plans are *kept, not deleted* — "the decision history is the point." A plan is a decision record, so its value survives its execution: six months from now, "why don't we have log files?" is answered by `meta/plans/retire-hand-kept-logs.md`, which carries the rationale, the enumeration that justified it, and the scope boundary.
2. **Its entry moves sections in `meta/plans/index.md`** — from *Proposed* or *Accepted / In progress* down to *Done / Superseded*, so the index reads as live work up top, settled decisions below.

The practical effect of `done` is that the plan drops out of circulation: `mix brain.session_init` only scans active statuses (`proposed`/`accepted`/`in-progress`), so a done plan disappears from the digest and its top-3 ranking — which you can see happened just now, with the log-retirement plan gone from the digest and the `/news` issue back at #1.

If you're wondering whether a completed plan should eventually leave `meta/plans/` for somewhere more archival — there's deliberately no such move. Moving files breaks nothing identity-wise elsewhere in the bundle, but plans are governance docs with no `sb:` ids, and the status field plus the index sections already give you the live/settled split without relocating anything.

## User

/create-pull-request
