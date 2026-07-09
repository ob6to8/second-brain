---
type: reference
title: Thread — adopt session capture, routing ledger, and route tags
description: The session that ported session capture, a routing ledger, and route-tagging (plus the mix brain.route_tags verifier) from the Composable Beliefs repo into this OKF bundle, then refined it — retiring /persist-thread, matching the /capture keep/strip rule to cb exactly, and adding meta/verification-flows/. Landed as PRs #13 and #15. First real /capture invocation.
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-08–2026-07-09; distilled render — substantive responses kept, reasoning/tool calls/short pre-tool narration stripped; operator messages verbatim"
tags: [meta, thread, capture, routing, route-tagging, workflow]
timestamp: 2026-07-09
---

# Thread — adopt session capture, routing ledger, and route tags

Distilled render: substantive exchanges only. Reasoning, tool calls/results, and
short pre-tool narration are stripped; operator messages are kept as said, and
assistant responses are reproduced in distilled form (their delivered substance,
not word-for-word). This is the **first real `/capture` invocation** — it
supersedes the hand-authored worked-example version of this same doc.

## Where this landed

A single long session that first **ported** the session-capture / routing-ledger /
route-tagging workflow from Composable Beliefs (`cb`) into this bundle at the OKF
floor (belief DAG out of scope), then **refined** it over several follow-ups. The
one non-mechanical design call was mapping cb's flat slugs and `cb:bNNN` belief ids
onto this bundle's deep tree and `sb:` ids — resolved by making the **`sb:` id**
the aggregating route-tag ref and a **path** the non-aggregating back-link, with
threads under `meta/threads/` (governance) as tag *sources* and `concept` docs as
sinks. Delivered: `SecondBrain.RouteTags` + `mix brain.route_tags` (five checks +
`--materialize`), the `/capture` skill, three `session-workflow` policies, the
`meta/session-workflow.md` guide, and `meta/verification-flows/`; `/persist-thread`
retired; the `/capture` keep/strip rule aligned exactly to cb's
`transcript_hook.py`. Landed as **PR #13** (the port), **PR #15** (the
refinements), and **PR #17** (the first real `/capture`, the backlog retrofit,
and a git-verification tutorial). The backlog is now clear: the 2026-07-05
verbatim thread was retrofitted with a routing ledger and a route tag over its
frozen body, and this session was itself captured — the skill's first real run.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Non-linear sessions & per-topic routing as a technique | closed | [routing non-linear work sessions](/SWE/agentic-coding/context-engineering/routing-non-linear-work-sessions.md) | - |
| OKF mapping & scope confirmation (`brain.*` not `okf.*`; no `thread` type) | closed | `unrouted` | - |
| Four adoption decisions (tag syntax, sink ref, thread home, ledger location) | closed | `unrouted` | - |
| Port `route_tags.ex` → `mix brain.route_tags` (five checks + `--materialize`) | closed | `unrouted` | Verifier + skill code lives in the repo, not a concept |
| End-to-end documentation (`meta/session-workflow.md`) | closed | `unrouted` | - |
| Merge `main`; PR #13 opened & merged | closed | `unrouted` | - |
| Retire `/persist-thread` in favour of `/capture` | closed | `unrouted` | - |
| Match the `/capture` keep/strip rule to cb `transcript_hook.py` | closed | `unrouted` | - |
| `meta/verification-flows/` namespace + walkthrough | closed | `unrouted` | - |
| Operator-vs-agent execution framing (who runs the flow) | closed | `unrouted` | - |
| PR #15 opened & merged | closed | `unrouted` | - |
| Process the thread backlog via `/capture` | closed | `unrouted` | Each backlog thread is captured from inside its own session (`/capture` renders current context only) |
| First real `/capture` — dogfood this session | closed | `unrouted` | - |
| Retrofit the 2026-07-05 bootstrap thread over its frozen body | closed | `unrouted` | - |
| Git commit verification — author/committer, signatures, "Verified" | closed | `unrouted` | - |
| PR #17 opened | closed | `unrouted` | - |

## User

You are working in my second brain, which is an OKF bundle. Port a capability
from another repo of mine into this bundle, adapting it to OKF vocabulary:
session capture as a skill, a routing ledger, proto-belief documents (as OKF
`concept` docs), and route tags plus an Elixir verifier. The belief graph is out
of scope. Read the reference repo first and report the OKF mapping.

## Assistant

I read the reference reading list and this bundle's tooling. The mapping, adapted
to *this* bundle rather than cb's: a cb proto-belief document maps to an OKF
`concept` doc (already in the controlled vocabulary); a cb thread maps to a thread
doc under `meta/threads/`; a route-tag ref maps to a concept's stable `sb:` id or
a code path; and `mix cb.verify.route_tags` maps to a new `mix brain.route_tags`.

Two divergences from the task's assumptions surfaced. First, this bundle has **no
`mix okf.*` tasks** — everything is `mix brain.*`, so the port is
`mix brain.route_tags`, not `mix okf.route_tags`. Second, this bundle has **no
`thread` type**: threads live in `meta/threads/` typed `reference`, in the
governance namespace, outside the knowledge bundle. And where cb resolves refs by
flat slug because all its docs share one directory, this bundle spreads concepts
across a deep tree and gives each a stable `sb:` id — so the idiomatic aggregating
ref here is the `sb:` id, matching the contract's rule that typed edges reference
ids, not paths. I proposed four decisions for you to confirm: tag syntax, the sink
ref kind, the thread home/type, and the ledger location.

## User

All four recommended. (Tag syntax `<routes ref="...">` verbatim; sink ref is the
`sb:` id; threads in `meta/threads/` as `type: reference`; in-doc `## Routing`.)

## Assistant

<routes ref="sb:d479e3 lib/second_brain/route_tags.ex">

The core idea being adopted is worth stating independently of the tooling: a
single working session is non-linear — it opens many matters, pauses some on open
questions, and routes each matter's synthesized content into a durable per-topic
page. Two mechanisms manage that. The **routing ledger** is a per-thread table of
pointers and states — never content — so the session is resumable from the table
instead of from memory; it stays a router, not a digest, precisely because
content is homed in the per-topic pages and only *pointed at* here. **Route tags**
then mark each region of the frozen session with the page(s) it feeds, and those
marks materialize an append-only, dated excerpt log into each page — making the
routing auditable, because what a page left out is now a visible tag boundary
rather than a hidden editorial cut. A verifier re-derives each log from the
current tags and fails on divergence, so the log is structural, not a copy someone
must remember to refresh.

</routes>

Built in the suggested order. `SecondBrain.RouteTags` ports the five checks — tag
wellformedness, ref resolution, sink logs, log fidelity, and the ledger
cross-check (warn) — with `classify_ref/1` reduced to two kinds: `sb:` id (the
aggregating sink, resolved via the identity registry) and path (a back-link that
must exist but accretes no log). `derive_block/3` keeps cb's exact block format so
the log is re-derivable. `mix brain.route_tags` runs the checks (exiting non-zero
on failure, warnings non-fatal), and `--materialize` writes each fed concept's log
section from the tags so it is generated, not hand-kept. I also landed the
`/capture` skill, three `session-workflow` policies, the concept
`routing-non-linear-work-sessions` (`sb:d479e3`) and a worked-example thread, and
wired the task into CI and the pre-commit hook beside `mix brain.verify`. 69 tests
pass; all gates green.

## User

Create documentation for this entire flow and functionality in meta/

## Assistant

Added `meta/session-workflow.md`: an end-to-end guide tying the subsystem together
— the problem, the capture→ledger→sink→tag→log pipeline (with a diagram), the data
model and the two ref kinds, the `mix brain.route_tags` check table and
`--materialize`, the invariants, and the Composable Beliefs port/adaptation. It
complements the terse policies (authoritative rules) and the `/capture` skill
(procedure) with narrative and rationale, and links out rather than restating.
Registered it in `meta/index.md`; all gates stay green.

## User

Fetch/Pull main and merge into branch

## Assistant

Merged `origin/main` (which had advanced with a `tutorial` type ratification, a
`knowledge-management/` domain, and a GitHub Pages builder). Three conflicts, all
additive — resolved by keeping both sides: `ci.yml` (route-tags step + site step),
`log.md` (both dated entries), and `meta/index.md` (both tooling lines). The
generated files (`CLAUDE.md`, `meta/registry.md`) I regenerated rather than
hand-merged. Full merged gate suite green — including main's `mix brain.site` (88
pages) and 69 tests — so my route-tags subsystem and main's site builder coexist
cleanly.

## User

Ready to open pr?

## Assistant

Opened PR #13 (base `main` ← head `claude/okf-capture-ledger-tags-4hicil`): 3
commits, +1917 lines across 21 files (net of the merge). No PR template in the
repo, so I wrote a standard body covering what's included, the cb→bundle
adaptation, governance changes, the worked example, and the green verification run.

## User

Merge pr

## Assistant

Merged PR #13 into `main` (CI `verify` green, mergeable state clean). The
subsystem — the `/capture` skill, three policies, `SecondBrain.RouteTags` +
`mix brain.route_tags`, the guide, and the worked example — is now on `main`.

## User

Keep for now. I have some existing threads I would like to close, persist, and
have processed via the new workflow you've built. Once I have merged main into
them, how should I call skills to enact the processing flow, and what should i
then check to verify correct execution?

## Assistant

I gave a runbook: `/capture` is the skill (not `/persist-thread`); resume each
thread's session, invoke `/capture`, route each topic to a concept, tag the frozen
body, then `mix brain.route_tags --materialize` and verify. For verification, run
the gate suite (or `./.githooks/pre-commit`) and read the five `mix
brain.route_tags` checks, plus three editorial spot-checks the machine can't judge
(ledger is pointers-only; each concept picked up its block; tag coverage). *(This
runbook's routing step wrongly framed agent work as operator to-dos — corrected
two turns later.)*

## User

Ok lets take this one by one. First, lets remove /persist-thread in favor of
capture. Second; capture, according to the workflow this was borrowed from in the
cb repo, should capture all thread exchanges except tool calls, statements less
than 300 characters UNLESS its in isolation, thinking, etc

## Assistant

**Task 1 — retired `/persist-thread`:** deleted the skill, dropped it from the
skills-registry policy, and cleared the contrast references in the
`session-capture` policy, the `/capture` skill, and `meta/session-workflow.md`;
recompiled `CLAUDE.md`. Left the frozen historical mentions (this log, the
2026-07-05 thread) untouched.

**Task 2 — the keep/strip rule:** I re-verified against cb `transcript_hook.py`
(lines 110–129): a text block is dropped **iff `len(strip) < 300 AND
followed_by_tool`**. Your phrasing matches that exactly — drop short statements
*unless in isolation* (plus tool calls and thinking). My old wording ("keep only
the substantive response") was the misleading part, so I reframed it everywhere as
an **inclusion** rule: keep every exchange; drop only tool calls/results,
reasoning, and a short pre-tool block (both `<~300` chars *and* followed by a tool
call). A short block *in isolation* is kept, as are longer blocks and all text in
tool-less turns. A wording/fidelity fix, not a behaviour change. Committed the two
tasks separately.

## User

Commit, then lets continue. In orocessing flow item 2, you describe things that
should be done by an agent as if i the operator should do them. Is this a mistake?
What does the skill say? Regarding verification, once we settle the above, we
should create a folder in meta/verification-flows for walkthroughs exactly like
you just specified, and place what you just wrote (corrected if necessary) there

## Assistant

Yes — it was a framing mistake. The `/capture` skill is entirely agent-directed:
every step (render, ledger, routing into concepts, tagging, `--materialize`,
gates) is the agent's. The operator's role is narrow: **invoke** `/capture` (and
`/intake` if needed), **ratify** shape changes (a new top-level dir or a new
`type` need sign-off per the contract), and **review**. The one gap is that the
skill assumes the concept sink exists; creating a *new* concept to route into is
also agent work — autonomous inside an existing domain, but a new top-level dir or
type must be proposed to you first.

Then I created `meta/verification-flows/` — a governance namespace for hands-on
*did-it-work?* walkthroughs, distinct from `meta/tutorials/` (the why) and the
policies (the rules). First entry `session-capture-routing-route-tags.md` carries
the corrected who-does-what division, the flow steps (agent-attributed), the gate
suite, the check-by-check pass/fail table, and the editorial spot-checks — and it
flags the earlier mis-framing. Registered in `meta/index.md`; logged in
`meta/log.md`. All gates green (site now 90 pages).

## User

Open a PR for these three commits

## Assistant

Opened PR #15 (retire `/persist-thread`; clarify the `/capture` rule; add
`meta/verification-flows/`) — base `main`, three commits, body grouped
commit-by-commit with the verification run.

## User

Merge pr

## Assistant

Merged PR #15 into `main` (CI `verify` green). All three follow-ups landed.

## User

Start working the thread backlog through /capture - would this mean calling
/capture here and doing the tagging etc?

## Assistant

Yes and no, depending on which thread. `/capture` renders from the **current**
session's context, so calling it here captures *this* conversation (and yes — I do
the render, ledger, routing, tagging, `--materialize`, gates; you invoke, ratify,
review). It does **not** reach your other backlog threads: those are separate
conversations on separate branches, so each must be captured from inside its own
session. The only exception is the parse-the-log path, if a host `.jsonl` session
log is available. I offered two paths: (A) dogfood by capturing this session now,
or (B) set up the per-session backlog pass.

## User

How and when were these two backlog threads created, was it the now deprecated
/persist-thread?

## Assistant

Checked the git history. `2026-07-05-greenfield-okf-bootstrap-and-verification-layer.md`
was created and maintained by `/persist-thread` (commits: "Archive bootstrap
thread", "Make thread archive verbatim; add /persist-thread skill", two
"/persist-thread" extensions) — a verbatim archive with no ledger or route tags,
so it's the genuine backlog thread the new workflow would retrofit.
`2026-07-08-adopt-session-capture-routing-and-route-tags.md` was **hand-authored**
by me (single commit) as the worked example — already in the new format, so not
really backlog. The honest wrinkle: `/capture` had **never actually been run**;
whatever we did next would be its first real invocation.

## User

*(Invoked `/capture` — this render is the result: the first real run of the skill,
capturing this session and superseding the hand-authored worked-example version of
this doc in place.)*

## Assistant

*(The commit for the capture above was flagged by a git stop-hook as unverified;
re-authored it to `noreply@anthropic.com`.)*

## User

Push

## Assistant

Pushed `b4c6c67` (the first `/capture`) — a fast-forward, one commit ahead of
`main`, verified-clean.

## User

Retrofit
Then - create a tutorial explaining what's occurring with "The tip commit is now
b4c6c67 with both author and committer set to noreply@anthropic.com, so GitHub
will show it as verified"

## Assistant

**Retrofit:** added a `## Routing` ledger and a route tag over the *frozen body*
of the 2026-07-05 verbatim thread — no re-render. That session mostly built
governance/tooling homed in `meta/` (not concept sinks), so 11 of 12 rows are
`unrouted`; turn 2's definition of *what an OKF bundle is* is route-tagged to the
OKF concept (`sb:24bd1e`), whose excerpt log I materialized. All five checks
green.

<routes ref="sb:d479e3">

A refinement the retrofit surfaced: not every thread routes richly to concepts. A
session that mostly builds governance or tooling homes its content in policies,
code, and the contract — none of which are concept sinks — so its routing ledger
is legitimately almost all `unrouted` and its route tags are sparse. Routing
density tracks how much *durable knowledge* (versus process) a session produced; a
thin ledger is a signal about the session, not a failure of tagging.

</routes>

**Tutorial:** wrote `meta/tutorials/what-makes-a-commit-verified-on-github.md`,
and deliberately corrected my own shorthand: GitHub's "Verified" is a
cryptographic **signature** check bound to the committer email, not the email
itself. Re-authoring to `noreply@anthropic.com` doesn't *make* a commit verified —
it puts it on the identity this environment signs for. Plus the golden rule: only
rewrite unpushed commits.

*(The stop-hook then flagged the two follow-up commits as unsigned; I re-created
the still-unpushed commits via `git rebase --exec … origin/<branch>`, leaving the
already-pushed `b4c6c67` untouched, then pushed — a live demonstration of the
tutorial's own rule.)*

## User

Open a PR for these three commits

## Assistant

Opened PR #17 — the first real `/capture`, the 2026-07-05 retrofit, and the
git-verification tutorial; base `main`, three commits, body grouped
commit-by-commit with the green verification run.

## User

Actually i believe we need to run /capture again to now capture the recent
exchanges

## Assistant

*(Ran `/capture` again — extended this same thread doc in place with the exchanges
since the first capture: the push, the retrofit, the tutorial, the two
commit-signing fixes, and PR #17. Ledger and narrative refreshed; the `sb:d479e3`
excerpt log re-materialized to pick up the new routing-density insight above.)*
