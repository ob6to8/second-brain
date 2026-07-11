# Log — meta

Chronological history of the governance namespace. Newest first. ISO 8601 dates.

## 2026-07-11

- **Captured [`2026-07-11-deprecated-directory-triage-and-machinery-deletion`](/meta/threads/2026-07-11-deprecated-directory-triage-and-machinery-deletion.md)**
  — the session that migrated the first legacy source out of `deprecated/`
  (`sb:41a1e3`) and deleted the old assertion-graph machinery, keeping the
  content pending triage. Route-tagged the intake region to `sb:41a1e3`
  (excerpt log materialized) and the triage/deletion regions to
  `deprecated/README.md` as path back-links. One open matter in the ledger:
  the remaining migration (13 sources, 9 assertions, URL backlog, old plans).
- **Refreshed [`2026-07-11-session-init-digest-and-priorities`](/meta/threads/2026-07-11-session-init-digest-and-priorities.md) in place**
  (second `/create-pull-request` close; update-in-place per the capture skill) —
  appended the post-PR-#39 exchanges verbatim: the squash-merge, the
  commits-as-provenance question (no written policy found), the
  squash-vs-true-merge trade-off analysis, the merge-strategy ratification, and
  the `meta/todos/` digest extension. Four ledger rows added — one dangling:
  operator to disable squash/rebase in the GitHub repo settings. Four new
  regions tagged (path back-links to the policy, tutorial, skill, contract, and
  tooling; no concept sinks). Threads index entry extended. Glossary pass added
  [true merge](/glossary/true-merge.md) and [squash merge](/glossary/squash-merge.md)
  as pointer entries to the
  [reachability tutorial](/meta/tutorials/why-a-true-merge-keeps-cited-commits-reachable.md).
- **Session-init digest now scans `meta/todos/`** — `SecondBrain.SessionInit`
  gained open todos (`status: open`) as a fourth source, sectioned between open
  issues and active plans and ranked between in-progress and accepted plans in
  the heuristic top-3 (an explicitly recorded task outranks work awaiting a
  decision). The [glossary definition](/glossary/session-init-digest.md) was
  reconciled to the four-source list. Tests extended.
- **Ratified the [merge-strategy policy](/meta/policy/merge-strategy.md)**
  (operator-ratified) — PRs land on `main` via a **true merge commit** only;
  squash- and rebase-merges are disallowed because the commit graph is a
  provenance layer (session trailers, SHA citations in durable docs, blame
  granularity). Grounded in the
  [true-merge reachability tutorial](/meta/tutorials/why-a-true-merge-keeps-cited-commits-reachable.md);
  prompted by PR #39 (and earlier #37/#38) having been squash-merged on recent
  precedent. `CLAUDE.md` recompiled (filing §, order 7);
  [`/create-pull-request`](/.claude/skills/create-pull-request/SKILL.md) now
  points at the policy in its merge guidance and guardrails. Squash/rebase
  remain enabled in the GitHub repo settings — disabling them is an operator
  step (Settings → General → Pull Requests).
- **Captured [`2026-07-11-news-digest-intake-and-daily-read`](/meta/threads/2026-07-11-news-digest-intake-and-daily-read.md)**
  — the session that generated the 2026-07-11 inbox digest (two passes), intaked the
  six SWE candidates, and shipped the daily-read synthesis. Route-tagged the intake
  summary region to all six new concepts (`sb:532b22`, `sb:1cac23`, `sb:f02167`,
  `sb:c29a22`, `sb:8b9548`, `sb:49eae4`) and the design region to the
  [daily-read plan](/meta/plans/news-daily-read-synthesis.md) as a path back-link;
  `mix brain.route_tags --materialize` appended each concept's first excerpt block.
  Left one paused matter: whether Codebase-Memory should split into a `source` paper +
  `reference` tool.
- **Added the "daily read" to `/news`** (operator-proposed, ratified same session) —
  a first-class `## The read` cross-domain synthesis lede at the top of every digest:
  a short, `sb:`-id-grounded perspective on the day's selections as a set, saying
  whether they reinforce/contest/extend the brain's standing positions. Wired a new
  §4.5 into [`.claude/skills/news/SKILL.md`](/.claude/skills/news/SKILL.md), updated the
  §5 body template, filed the decision record
  [`meta/plans/news-daily-read-synthesis.md`](/meta/plans/news-daily-read-synthesis.md)
  (`status: done`), and backfilled the [2026-07-11 digest](/inbox/2026-07-11.md) as the
  first worked instance.
- **Captured [`2026-07-11-doctrine-vs-policy-and-glossary-cross-linking`](/meta/threads/2026-07-11-doctrine-vs-policy-and-glossary-cross-linking.md)**
  — the session that filled the missing [policy (type)](/glossary/policy-type.md)
  glossary entry, added [doctrine](/glossary/doctrine.md) on operator direction,
  and ratified the prose-first cross-linking convention (See also fallback; no
  `related:` typed edge) now codified in `/add-to-glossary`. Route-tagged to the
  glossary hub (`sb:0b648f`) and the two new entries (`sb:fa15e7`, `sb:6a9e78`);
  `mix brain.route_tags --materialize` appended their excerpt blocks.
- **Captured [`2026-07-11-session-init-digest-and-priorities`](/meta/threads/2026-07-11-session-init-digest-and-priorities.md)**
  — the session that built the session-init digest (entry below). Ledger: the
  tooling and hook strands closed (`unrouted`; path back-links), one dangling
  note kept — soften the open-every-session agent note if the appraisal proves
  noisy. Route tags are path back-links only (no concept sinks), so no excerpt
  logs materialized. Glossaried the thread per `/create-pull-request`: new
  [session-init digest](/glossary/session-init-digest.md) term; citation and
  context-injection nuance added to [SessionStart hook](/glossary/sessionstart-hook.md).
- **Added the session-init digest** — new tooling (`SecondBrain.SessionInit`,
  `mix brain.session_init`) that scans open issues (`meta/issues/`), active
  plans (`meta/plans/`), and dangling routing-ledger strands (`meta/threads/`)
  into a markdown digest ending in a heuristic top-3 priority ranking (issues >
  in-flight plans > open strands > paused/dangling strands > proposed plans;
  strands deduped against docs they routed to). The SessionStart hook
  (`.claude/hooks/session-start.sh`) now echoes the digest into each fresh
  session's context, with an agent note to open the thread with a judged
  priority appraisal. Covered by `test/second_brain/session_init_test.exs`.
- **Captured [`2026-07-11-glossary-backfill-from-thread-docs`](/meta/threads/2026-07-11-glossary-backfill-from-thread-docs.md)**
  — the session that ran `/add-to-glossary` over the eleven previously-unprocessed
  thread docs, growing the [glossary](/glossary.md) from 7 to 68 terms (46 new
  term files + 15 pointer entries) and merging it as PR #37. Route-tagged the
  backfill region to the glossary hub (`sb:0b648f`); `mix brain.route_tags
  --materialize` appended its excerpt block. Left one paused matter: whether bare
  skill-command names deserve glossary pointer entries.
- **Resolved that paused matter** — skill commands stay out of the glossary
  (terminology, not invocables). Added a new "terminology, not invocables"
  guardrail to [`.claude/skills/add-to-glossary/SKILL.md`](/.claude/skills/add-to-glossary/SKILL.md),
  filed the [skill](/glossary/skill.md) (`sb:aa0003`) category pointer entry, and
  flipped the thread's ledger row to `closed`.

## 2026-07-10

- **`/capture` of the merge-tutorial session** → thread
  [2026-07-10-merge-commit-reachability-tutorial](/meta/threads/2026-07-10-merge-commit-reachability-tutorial.md)
  (render-from-context; single-exchange session — the operator's quote-seeded
  request and the closing reply retained verbatim, pre-tool narration/tool noise
  stripped). Three-row routing ledger, all closed — the tutorial strand
  path-routed to the new tutorial (governance namespace, no `sb:` sinks, so no
  excerpt logs materialized); quote provenance and the PR motion `unrouted`.
  Listed in the threads index. Captured as step 1 of a `/create-pull-request`
  run so the thread doc ships in the same PR.
- **New tutorial: [Why a true merge (not a squash) keeps cited commits
  reachable](/meta/tutorials/why-a-true-merge-keeps-cited-commits-reachable.md).**
  Written from a session quote about deliberately true-merging a port branch
  because `PLAN.md` cites its commits (`0fdee9e..e6ae1f9`) by SHA. Unpacks git
  reachability (branch deletion removes a ref, never commits), contrasts what
  true merge / squash / rebase each do to a branch's original SHAs, and lands
  the rule: SHA citations in durable docs make history load-bearing, so
  true-merge (or tag the tip) before deleting the branch. Listed in the
  tutorials index.
- **`/capture` of the field-comparison / evals / CB-overlay session** → thread
  [2026-07-10-field-comparison-evals-and-cb-overlay-execution-path](/meta/threads/2026-07-10-field-comparison-evals-and-cb-overlay-execution-path.md)
  (render-from-context; retained operator messages and substantive responses
  verbatim, tool noise and short pre-tool narration stripped). Six-row routing
  ledger — four closed (the two field/failure-chain strands, eval suitability,
  the CB stabilizer), one paused (dedup-recall-probe plan awaiting ratification),
  one open (the two-thread execution path, to be launched from the plan's
  addendum). All route tags are path back-links to governance docs (analyses and
  plans — no `sb:` sinks), so no concept excerpt logs materialized. Listed in the
  threads index. Captured as the first step of a `/create-pull-request` run.
- **Execution-path addendum on the [epistemic overlay plan](/meta/plans/epistemic-overlay.md).**
  Ratified the two-thread path for executing the plan: Thread A imports CB's
  usable content as freshness-vetted `source`/`reference` captures under
  `knowledge-management/composable-beliefs/` (tiered: guide/glossary/code
  authoritative; cb-tut secondary; thesis quarantined; old type names treated as
  a staleness flag during vetting, not filed), with an eight-item capture
  manifest; Thread B sketches the architecture reading *only* the bundle, decides
  Q1/Q4, specifies supersession-for-statements and `mix brain.graph` v1, and
  revises the plan to `accepted` with `verified_by` edges into the Thread A
  captures. Each thread launches by pointing the agent at the addendum.
- **New analysis: [Would CB's four-typed DAG, as an overlay, stabilize this knowledge base against the failure chain?](/meta/analysis/cb-epistemic-overlay-as-failure-chain-stabilizer.md)**
  Evaluates Composable Beliefs' epistemic layer as an add-on overlay against the
  five-stage failure chain: a genuine mechanical stabilizer for stage 3 (drift →
  bounded traversal of dependents on supersession) and stage 5 (trust → per-statement
  epistemic state), no help for stage 2 (dedup stays the unguarded gate), portable
  as a format but host-native in enforcement and edge-authoring. Includes a
  source-staleness check prompted by the operator (CB's thesis doc used deprecated
  type names): two claims corrected against the current glossary — CB *does* have
  per-type dep rules, and *does* position itself as an "opt-in ceiling" over OKF —
  and CB's dep-repoint primitive surfaced as the top import candidate. Appended a
  stabilization-reframing addendum to the [epistemic overlay plan](/meta/plans/epistemic-overlay.md)
  (motivation upgrade; Q2 answered — one `deps` edge kind, typing on nodes; Q3
  flipped — supersession is load-bearing). Listed in the analysis index.
- **New plan: [Dedup recall probe](/meta/plans/dedup-recall-probe.md)** (`status:
  proposed`). Commissioned by the operator following the eval-suitability
  analysis; executes recommendation 1 of the vector-DB recall analysis. Specifies
  `mix brain.dedup_probe` — zero-dependency, offline, deterministic — scoring the
  lexical search layer against an id-keyed gold set at `meta/evals/dedup-probe.md`
  (acceptable-id sets, adjudication notes, `target`/`negative`/`quarantine` bands
  encoding the ground-truth fuzz sources, gold pairs harvested from real operator
  phrasing at intake, an `--expanded` mode measuring the synonym-expansion fix,
  non-gating CI report with committed baselines). Proposes ratifying a new
  `meta/evals/` genre. Listed in the plans index.
- **New analysis: [Is the corpus-maintenance failure space rich content for evals?](/meta/analysis/eval-suitability-of-the-corpus-maintenance-failure-space.md)**
  Follow-up to the field-comparison analysis: the operator asked whether the
  500+ failure chain is rich eval content. Answer: yes — ground truth is
  constructible (the operator owns the corpus), each chain stage maps to a
  measurable task, and "corpus health under agent maintenance" is an unoccupied
  benchmark niche. The session response is preserved verbatim at operator request,
  with the "is this a duplicate" ground-truth fuzziness expanded into seven named
  sources (spectrum, taxonomy-relativity, type-relativity, time-relativity,
  query-relativity, judge drift, synthetic-vocabulary bias), each dictating a
  gold-set property. Listed in the analysis index.
- **New analysis: [How does this bundle compare to the 2026 second-brain field?](/meta/analysis/comparison-with-the-2026-second-brain-field.md)**
  Operator asked for an evaluation of the repo against the AI-influencer-verse
  second-brain landscape; a same-day web survey (Forte's "AI Second Brain" pivot,
  LYT/ACE, the Obsidian + Claude Code wave, Karpathy's LLM-wiki gist and its
  implementations, Tana/Notion/Capacities, vault-ld, TheKnowledge) found no public
  system combining this bundle's enforcement stack. The write-up also records a new
  observation: the five-stage failure chain (context saturation → dedup
  fragmentation → cross-reference drift → taxonomy entropy → trust collapse) that
  kills advisory systems past ~500 concepts, and that this bundle's exposure to it
  runs through intake dedup recall — reinforcing the vector-DB analysis's
  recommendation as the highest-leverage unshipped work. Listed in the analysis
  index.
- **Capture refresh (pre-merge)** — the session continued past its first
  `/capture` (the per-term glossary restructure and the PR-readiness check), so
  the thread doc
  [2026-07-10-add-to-glossary-skill-and-pr-wiring](/meta/threads/2026-07-10-add-to-glossary-skill-and-pr-wiring.md)
  was refreshed **in place** per the capture skill's update-in-place rule: the
  restructure exchange appended verbatim, two ledger rows added (the restructure
  routed to the [glossary hub](/glossary.md), the readiness check `unrouted`),
  one new region tagged to `sb:0b648f` (hub excerpt log re-materialized), and
  the narrative/description extended. No new glossary terms cleared the
  selection bar (*hub* is plain English used plainly).
- **`/capture` of this session** → thread
  [2026-07-10-add-to-glossary-skill-and-pr-wiring](/meta/threads/2026-07-10-add-to-glossary-skill-and-pr-wiring.md)
  (render-from-context; retained operator messages and closing replies verbatim,
  tool noise and short pre-tool narration stripped). Four-row routing ledger, all
  closed — one `unrouted` (running `/create-pull-request` itself), the rest routed
  to the two skill files and the [glossary](/glossary.md). One region tagged to
  `sb:0b648f`, materializing the glossary's first excerpt-log block; listed in the
  threads index. Ran as step 1 of a `/create-pull-request` invocation, whose new
  step 2 (`/add-to-glossary` over this thread doc) then executed for the first
  time — see the root `log.md` for the seeded entries.
- **`/create-pull-request` now glossaries the captured thread.** Inserted a step
  between capture and commit: run
  [`/add-to-glossary`](/.claude/skills/add-to-glossary/SKILL.md) over the thread
  doc `/capture` just wrote, so every captured session's terminology merges into
  the [glossary](/glossary.md) and ships in the same PR as the thread itself
  (skipped when capture was skipped; a term-free thread is a legitimate no-op).
  Renumbered the procedure (capture → glossary → survey → commit → push → open
  PR), extended the capture-first guardrail, cross-referenced the invocation from
  the `/add-to-glossary` skill, updated both bullets in
  [skills-registry](/meta/policy/skills-registry.md), and re-rendered `CLAUDE.md`.
- **New skill `/add-to-glossary`.** Scans a persisted thread (`meta/threads/`), a
  paper, a post, or a filed concept; extracts the technical terms it actually
  uses (same selection bar as `/summarize-technical`'s key-terms section); and
  merges distilled one-to-three-sentence definitions into the bundle-root
  [glossary](/glossary.md) — one entry per term, alphabetical, with a *Seen in:*
  citation line, dedup/merge on existing entries, pointer entries for terms
  canonically defined by filed concepts or the operating contract, and a
  graduation path (`/intake`) for entries that outgrow the glossary. Markdown
  only, deliberately no `glossary.json` — the glossary is a bundle concept and
  flows through verify/registry/site tooling. Registered it in
  [skills-registry](/meta/policy/skills-registry.md) and re-rendered `CLAUDE.md`
  via `mix brain.contract`; seeded the empty `/glossary.md` scaffold (id minted,
  registry regenerated).
- **`/capture` of this session** → thread
  [2026-07-10-todo-skill-and-gate-suite-tutorial](/meta/threads/2026-07-10-todo-skill-and-gate-suite-tutorial.md)
  (render-from-context; retained operator messages and closing replies verbatim,
  short pre-tool narration/tool noise stripped). Six-row routing ledger, all closed —
  one `unrouted` (the `/create-pull-request` run), the rest path-routed to the touched
  skill/policy/tutorial files (governance namespace, no `sb:` sinks, so no concept
  excerpt logs materialized). Listed in the threads index. `mix brain.route_tags`
  verifies clean. Captured as the first step of a `/create-pull-request` run.
- **New tutorial: [the gate suite — what the checks prove and where they run](/meta/tutorials/the-gate-suite-and-where-it-runs.md).**
  Explains the repository's integrity gates as an enforcement surface: the eight
  CI checks grouped into four kinds (build; generated-artifact freshness via
  `--check`; bundle validation via `mix brain.verify` / `mix brain.route_tags`; the
  `mix brain.site` render), what turns each red and its fix, and the three widening
  scopes they run at (an agent's scoped manual pass — the "all three gates pass"
  subset — the opt-in pre-commit hook, and the authoritative CI job). Complements
  [the three bundle scanners](/meta/tutorials/the-three-bundle-scanners.md) (which
  covers the scanner *architecture*) by cross-linking to it rather than duplicating.
  Listed in the tutorials index.
- **New `todo` type + `meta/todos/` genre + `/todo` skill.** Added `todo` to the
  [controlled type vocabulary](/meta/policy/controlled-type-vocabulary.md) — a
  lightweight actionable task item carrying a `status` (`open`/`done`/`cancelled`),
  distinct from an `issue` (a problem) and a `plan` (a design record). Created the
  governance-namespace directory [`meta/todos/`](/meta/todos/index.md) (no `sb:` ids,
  like `issues`/`plans`/`threads`) with its index, and listed it in
  [`meta/index.md`](/meta/index.md). Authored the [`/todo`](/.claude/skills/todo/SKILL.md)
  skill — dispatches on a subcommand: `create <title>` files a new open todo (and
  maintains the index + `log.md`), `list` shows todos grouped by `status`. Registered
  it in [skills-registry](/meta/policy/skills-registry.md) and re-rendered `CLAUDE.md`
  via `mix brain.contract`. Requested by the operator (which ratifies the new type and
  top-level-of-`meta` directory). `mix brain.verify` passes.
- **`/capture` of this session** → thread
  [2026-07-10-create-pull-request-skill-and-intake-delegation](/meta/threads/2026-07-10-create-pull-request-skill-and-intake-delegation.md)
  (render-from-context; retained operator messages and closing replies verbatim,
  short pre-tool narration/tool noise stripped). Seven-row routing ledger, all
  closed — two `unrouted` (the namespacing Q&A and the PR-#31 open/merge), the rest
  path-routed to the touched skill/policy/flow files (governance namespace, no `sb:`
  sinks, so no concept excerpt logs materialized). Listed in the threads index.
  `mix brain.route_tags` verifies clean. Captured as the first step of a
  `/create-pull-request` run.
- **`/create-pull-request` now runs `/capture` first.** Prepended a full `/capture`
  step (render the frozen thread doc, routing ledger, route tags, then
  `mix brain.route_tags --materialize`/verify) ahead of the commit, so the session
  record ships *in the same PR* rather than trailing in a later one. Renumbered the
  procedure (capture → survey → commit → push → open PR), updated the guardrail, and
  re-rendered `CLAUDE.md` from [skills-registry](/meta/policy/skills-registry.md).
  (Follow-up after PR #31 merged; branch restarted from `main`.)
- **New skill `/create-pull-request`.** Commits the current working changes, pushes
  the branch, and opens a pull request — invoking the skill **is** the authorization,
  so there's no separate confirmation gate (PR-template detection and the GitHub MCP
  tools handle the rest, since there's no `gh` CLI here). Registered it in
  [skills-registry](/meta/policy/skills-registry.md) and re-rendered `CLAUDE.md` via
  `mix brain.contract`. (Initially drafted with a confirmation gate, then simplified
  the same day once we settled that the invocation itself is the yes.)
- **`/intake` now delegates to `/summarize-technical` for technical sources.**
  Added a branch to the [`/intake` skill](/.claude/skills/intake/SKILL.md)'s
  distill step: a technical paper/article/spec substantial enough to warrant it
  gets `/summarize-technical`'s three-part layered breakdown as its body instead
  of flat prose (short notes, snippets, people, projects stay plain prose).
  Mirrored the branch in the [intake flow](/meta/flows/intake.md) (§3 touch-sequence
  step 5, §4 moving parts) so the connective doc doesn't drift from the skill.

## 2026-07-09

- `/capture`: froze the testing-methodology / types / Composable-Beliefs session into
  [2026-07-09-testing-methodology-types-and-cb-epistemic-overlay](/meta/threads/2026-07-09-testing-methodology-types-and-cb-epistemic-overlay.md).
  Two regions route-tagged to the testing methodology (`sb:d58da3`) — materializing its
  `## Thread excerpts — route-tagged log` — plus six path back-links to the
  `epistemic-overlay` plan. Routing ledger has six strands (five closed, the plan
  paused on its open questions). `mix brain.route_tags` verifies clean. Listed the
  thread in `meta/threads/index.md`.

- Captured the session thread
  [2026-07-09 — live-render appraisal and Pages-site hardening](/meta/threads/2026-07-09-live-render-appraisal-and-pages-hardening.md)
  (`/capture`, parse-the-log render): the session that produced PR #16. Built a
  parallel `mix brain.render` generator, then abandoned it on finding the shipped
  `mix brain.site`; appraised both, ported two safety fixes (deploy-gating on
  `verify`, link-href escaping) + table alignment + Pages auto-enable, and wrote
  the deploy-gating tutorial. Routing ledger: all strands closed (two routed to
  the gating tutorial, the rest thread-specific/unrouted); path-ref route tags
  back-link the gating and href-escaping regions to the tutorial, `pages.yml`, and
  `markdown.ex` (no `sb:` sinks, so no concept excerpt logs materialized). Listed
  it in the threads index. Dropped the Fable-5 usage-limit notice and the
  mid-session model switch to Opus 4.8 as an italic editorial note.
- **`/capture` of this session** → thread
  [2026-07-09 — the flows genre, scenario testing, and the plan-genre collapse](/meta/threads/2026-07-09-flows-genre-and-scenario-testing.md)
  (parse-the-log render from the host `.jsonl`, so all 18 operator messages and 22
  agent turns are verbatim). Eight-row routing ledger — mostly `unrouted` (the
  session was overwhelmingly governance/tooling homed in `meta/`), with the
  dependency-free-testing strand routed to the ExUnit reference and one route-tag
  region (the research-spike verdict) feeding both `SWE/testing` captures
  (`sb:f6e843`, `sb:b1ba4b`), whose excerpt logs were materialized. Listed in the
  threads index. (Captured post-merge on the branch restarted from `main`.) Title
  later aligned to the filename-stem convention adopted in PR #25.
- Captured the session thread
  [vector-DB recall evaluation and the `analysis` type](/meta/threads/2026-07-09-vector-db-recall-evaluation-and-analysis-type.md)
  (`/capture`, parse-the-log render): stress-tested a prior "not yet" call on adding
  a vector DB via a dedup-recall probe over the live corpus (grep already misses
  existing concepts *semantically*), landing on fix-intake-first (no vector DB), then
  ratified the `analysis` type and filed the finding. Routing ledger has two closed
  strands (the evaluation → the analysis doc; the `analysis` type → the vocabulary),
  with one dangling follow-up (Tier-1: synonym-expansion `/intake` dedup +
  `mix brain.dedup_probe`); path-ref route tags back-link the analysis answer and the
  type-ratification region to their sinks. Listed it in the threads index. Also
  adopted the filename-stem thread-title convention (no "Thread", em-dashes, or
  spaces) in the `/capture` skill.
- `/capture` — froze the GitHub Pages / OKF-node session into
  [2026-07-09 — GitHub Pages knowledge-base site, offline-toolchain tutorial, and the OKF node](/meta/threads/2026-07-09-github-pages-knowledge-base-site.md)
  (parse-the-log render of the host session jsonl, so retained text is exact).
  Routing ledger has six closed strands (the site generator, the offline
  tutorial, the `tutorial` type, the OKF node, the Pages-enable fix, and the
  stop-hook false alarm); route tags back-link the tooling/tutorial/vocabulary
  regions and materialize two excerpts into the OKF node (`sb:24bd1e`). Listed it
  in the threads index; all gates green (`mix brain.route_tags`). The site work
  itself shipped earlier as PRs #11/#12 — this is its session record.
- **Ratified the `analysis` type** (operator directive) and created the
  `meta/analysis/` namespace with its `index.md`. An `analysis` is a point-in-time
  evaluation / decision-support write-up — a question investigated against evidence,
  yielding findings and a recommendation — distinct from a `plan` (intended work),
  `tutorial` (explanatory), and `note` (an idea). Added the type to
  `meta/policy/controlled-type-vocabulary.md` and recompiled `CLAUDE.md`.
- Filed the first analysis,
  [Would a vector DB improve recall as this bundle scales?](/meta/analysis/vector-db-recall-for-the-scaling-bundle.md)
  (`type: analysis`): a reproducible dedup-recall probe over the live 39-concept
  corpus shows grep already misses existing concepts on natural-phrasing queries
  (~6 of 14) — a *semantic* (synonym/jargon) failure, not typographic. Concludes the
  right first move is synonym-expanded intake dedup + a repeatable recall probe
  (both zero-dependency), with cached brute-force embedding dedup as a later Tier 2,
  and a standalone vector DB rejected at this corpus's scale.
- **Collapsed the `spec` genre into `plan`** (operator-directed) — the `spec` type
  / `meta/specs/` namespace this branch added and the `plan` type / `meta/plans/`
  namespace from `main` were near-duplicates (both "a design/decision record for a
  proposed change to the brain/tooling"). Unified on **`plan`/`meta/plans/`** as the
  survivor: moved the flows design doc to
  [meta/plans/flows-genre-and-scenario-testing.md](/meta/plans/flows-genre-and-scenario-testing.md)
  (retyped `spec`→`plan`, `status: approved`→`done`), removed the `spec` type from
  the controlled vocabulary and the `meta/specs/` namespace, renamed the
  `persist-specs` policy → [persist-plans](/meta/policy/persist-plans.md) (retargeted
  to `type: plan` / `meta/plans/`), repointed all links, and recompiled `CLAUDE.md`.
  Earlier 2026-07-09 log entries that describe creating `meta/specs/` are frozen
  history (their narrative is left as-is; the moved doc's link now resolves to
  `meta/plans/`).
- **Added the second flow: `/intake`** (per the flows plan, completing its planned
  scope). Filed [meta/flows/intake.md](/meta/flows/intake.md) — the file-by-file
  touch-sequence of an `/intake` run (paste → distill + dedup → file by taxonomy →
  mint id → compile registry → verify → reserved files), with the judgment/spine
  split, actor boundaries, gate suite, and invariants. Added the scenario test
  `test/second_brain/intake_scenario_test.exs`: an in-code fixture (a `source`
  capture + a grounded `claim`) that compiles the registry and asserts the render
  **byte-exact** plus `verify` clean, with two red guardrails (a concept missing an
  id is flagged; a capture marked `verified: true` is rejected). Added a See-also
  from the `/intake` skill and updated the spec status (both flows now built).
- **Built the `flows` genre and collapsed the capture docs into it** (per the
  approved [flows spec](/meta/plans/flows-genre-and-scenario-testing.md), build
  order §9). Created `meta/flows/` with its `index.md` and the first flow doc
  [session-capture](/meta/flows/session-capture.md) — the file-by-file
  touch-sequence of a `/capture` run, plus pipeline, data model, actor
  boundaries, gate suite, and invariants. Added the scenario test
  `test/second_brain/capture_scenario_test.exs`: plain ExUnit over a `:tmp_dir`
  fixture that drives `RouteTags.materialize/1` and asserts the materialized log
  section **byte-exact** (co-feed lift, ATX→bold demotion, ordering) — pinning the
  transform against a wrong-but-self-consistent change the `log fidelity`
  self-check can't catch. **Collapsed** `meta/session-workflow.md` and
  `meta/verification-flows/` into the flow doc (both removed), repointed
  `meta/index.md`, added a See-also from the `/capture` skill, and updated the
  spec's status. Flow docs live in the governance namespace (`type: note`, no
  `sb:` id), so no registry/contract change; all gates green including the new
  scenario.
- **Established the `meta/specs/` genre + a persist-specs policy** (operator-directed):
  design specs and implementation plans the operator approves are now persisted as
  `type: spec` docs under `meta/specs/` (governance namespace, no `sb:` id) rather
  than left in chat or the reclaimed scratchpad. Ratified a new `spec` type in
  `controlled-type-vocabulary`, added `persist-specs` under the *filing* contract
  section (order 6), created `meta/specs/index.md`, and recompiled `CLAUDE.md`.
  First spec filed: [The flows genre + formal scenario testing](/meta/plans/flows-genre-and-scenario-testing.md)
  (`status: approved`) — the collapse of the capture flow's three prose docs into
  one `meta/flows/` doc backed by an ExUnit scenario, with the commissioned harness
  research spike folded in (it *adjusted* the plan: in-code fixtures + structured
  assertions over on-disk whole-tree golden). Build not yet started.
- Added the tutorial
  [The three bundle scanners — Registry, Verifier, and RouteTags](/meta/tutorials/the-three-bundle-scanners.md)
  (operator-requested): how `Registry.scan/1` is the one crawler (wildcard +
  directory-exclusion + frontmatter parse), the Verifier layers rules over the same
  corpus, and RouteTags adds a second surface over `meta/threads` and rejoins the
  governance and knowledge namespaces by stable id — and why everything under an
  excluded directory (e.g. `test/` fixtures) is invisible to all three. Listed in
  `meta/tutorials/index.md`.
- Filed the tutorial
  [How the Pages deploy is gated on a verified bundle](/meta/tutorials/gating-the-pages-deploy-on-a-verified-bundle.md)
  (`type: tutorial`) explaining the mechanics of the `pages.yml` deploy gate:
  GitHub Actions runs each workflow in isolation, so a `needs:` can't reach from
  `pages.yml` into `ci.yml`'s `verify` job; the fix repeats the bundle-integrity
  checks (`brain.contract --check`, `brain.registry --check`, `brain.verify`,
  `brain.route_tags`) inside the Pages build job before `mix brain.site`, and a
  non-zero exit fails `build` so `deploy` (which `needs` it) is skipped — making
  the live site reachable only for a verified bundle. Listed it in
  `meta/tutorials/index.md`. Accompanies the deploy-gating change in PR #16.
- Captured the session thread
  [2026-07-09 — remove operator email from operating contract](/meta/threads/2026-07-09-remove-operator-email-from-contract.md)
  (`/capture`, parse-the-log render): the short session that removed the operator's
  email from `meta/preamble.md`/`CLAUDE.md`, then found the change had already
  merged to `main` via PR #14 (branch fast-forwarded to equal `main`, nothing new
  to commit or PR). All three strands closed and `unrouted` — a purely
  operational/governance session with no `concept` sinks, so no route tags. Listed
  it in the threads index.
- Captured the session thread
  [2026-07-09 — news Routine verification, issue tracking, and /news featuring docs](/meta/threads/2026-07-09-news-routine-issue-and-featuring.md)
  (`/capture`, parse-the-log render): verified the daily Routine, found its automated
  fires land nothing on `main` (suspected env-wide approval gate), then the governance
  work below. Routing ledger has one open strand (the non-firing Routine, routed to the
  new issue) and two closed (the `issue` type/namespace, the `/news` featuring docs);
  path-ref route tags back-link the finding and summary regions to the issue,
  vocabulary, and skill. Listed it in the threads index.
- Added the `issue` type to the [controlled type vocabulary](/meta/policy/controlled-type-vocabulary.md)
  and created the [`meta/issues/`](/meta/issues/index.md) namespace (operator-ratified).
  Filed the first issue,
  [Daily /news Routine: automated runs not landing on `main`](/meta/issues/daily-news-routine-runs-not-landing.md)
  (`status: open`): the scheduled Routine `trig_01PAiKWrWgVs4djSkhELoLYw` produces no
  commit/push on its fresh-session fires; an environment-wide tool-approval gate is the
  suspected cause. Workaround: run `/news` manually. Recompiled `/CLAUDE.md`
  (`mix brain.contract`) to carry the new type; listed `issues` in the meta index. Also
  documented the featuring/selection decision explicitly in the
  [`/news` skill](/.claude/skills/news/SKILL.md).
- Captured the session thread
  [2026-07-09 — daily news-inbox Routine](/meta/threads/2026-07-09-daily-news-inbox-routine.md)
  (`/capture`): a short session that created the claude-code-remote Routine
  `trig_01PAiKWrWgVs4djSkhELoLYw` (fresh session daily at 13:00 UTC, cron `0 13 * * *`)
  to run `/news` and push the day's inbox digest to `main`. This is the standing
  automation for the daily feed the prior thread's Routing left paused. No repo code
  changed; one closed, unrouted strand with a path-ref back-link to `news/SKILL.md`.
  Listed it in the threads index.
- Captured the session thread
  [2026-07-09 — home-page news-filter inbox](/meta/threads/2026-07-09-home-page-news-filter-inbox.md)
  (`/capture`, parse-the-log render): verbatim retained exchanges, a routing ledger
  (feature + tutorial closed; daily Routine paused, PR open), and path-ref route tags
  back-linking the finding regions to the tutorial/`registry.ex` and the skill-purpose
  answer to `news/SKILL.md`. Listed it in the threads index.
- Filed the tutorial
  [Bundle scope and non-bundle namespaces](/meta/tutorials/bundle-scope-and-non-bundle-namespaces.md)
  (`type: tutorial`) — how the four independent scanners (identity/verify,
  route-tags, contract, site) each define their own scope, why
  `SecondBrain.Registry.@excluded_dirs` *is* the definition of "bundle concept"
  (so adding `inbox` there is what keeps the candidate feed's id-less digests from
  failing `mix brain.verify`), how the verifier and route-tags checker inherit that
  scope by delegation, and why the site generator deliberately renders `meta/` and
  `inbox/` while the registry ignores them. Added it to the tutorials index.

- **Fixed a capture-semantics bug: retained responses are verbatim.** The
  `session-capture` policy, the `/capture` skill, `meta/session-workflow.md`, and
  the verification-flow all wrongly implied the kept agent responses could be
  *summarized* ("distilled render… delivered substance, not word-for-word").
  Corrected everywhere: "distilled" means the **noise** is dropped; everything
  kept is reproduced **verbatim**. Made **parse-the-log** the preferred, most
  faithful render path. Recompiled `CLAUDE.md`. Then **recaptured** the adopt
  thread from the host session log (parse-the-log): all 21 exchanges now verbatim,
  and the `sb:d479e3` route tag re-pointed at the operator's own verbatim
  definition of the technique (replacing an earlier composed paragraph), so the
  concept's excerpt log lifts real conversation text. All gates green.
- **Third `/capture` (extend the verbatim render).** Re-ran capture to fold in the
  capture-semantics fix, the reconcile, and the push — parsed straight from the
  host session log, so the tail is verbatim too. Confirmed the parser correctly
  drops the `isMeta` stop-hook feedback and the `<`-prefixed `/capture` invocation
  as noise, merging the surrounding responses. Ledger + narrative extended; the
  `sb:d479e3` tag region is unchanged, so the concept logs were untouched.

- **Retired `/persist-thread`** in favour of `/capture`. The two overlapped
  (both persist a session into `meta/threads/`); `/capture` supersedes it —
  same home, but distilled + routed + route-tagged instead of raw verbatim.
  Deleted `.claude/skills/persist-thread/`, removed it from the skills-registry
  policy, and cleared the contrast references in `session-capture`,
  `route-tagging`'s guide (`meta/session-workflow.md`), and the `/capture`
  skill; recompiled `CLAUDE.md`. Historical mentions in this log and the
  2026-07-05 thread are left as-is (frozen records).
- **Clarified the `/capture` keep/strip rule** to match cb `transcript_hook.py`
  exactly and read as an *inclusion* rule: keep **every** exchange, dropping only
  tool calls/results, reasoning/thinking, and short pre-tool narration (a block
  *both* `< ~300` chars *and* followed by a tool call). A short block **in
  isolation** — not followed by a tool — is kept, as are longer blocks and all
  text in tool-less turns. Fixed the misleading "keep only the substantive
  response" framing in the `session-capture` policy, the `/capture` skill, and
  `meta/session-workflow.md`; recompiled `CLAUDE.md`. No behaviour change — the
  rule was already correct in the verifier's sense; this removes an ambiguous
  reading that could have over-dropped short standalone replies.
- Created the **`meta/verification-flows/`** namespace (operator-directed):
  hands-on *did-it-work?* walkthroughs for each multi-step flow — who does what
  (operator invokes/ratifies; the agent executes), how to invoke, and exactly
  what to check. First entry: `session-capture-routing-route-tags.md`, which
  corrects an earlier chat framing that cast agent steps (routing, tagging,
  minting, materializing) as operator to-dos. Listed in `meta/index.md`.
- **First real `/capture`** (dogfood): regenerated
  [2026-07-08-adopt-session-capture-routing-and-route-tags](/meta/threads/2026-07-08-adopt-session-capture-routing-and-route-tags.md)
  in place from this session's live context — superseding the hand-authored
  worked-example version with a genuine distilled render of the whole session
  (the port through all the refinements), an expanded routing ledger, and the
  same `sb:d479e3` route tag re-materialized (log block unchanged). Until now the
  skill had never been run; this is its first invocation.
- **Retrofitted the 2026-07-05 bootstrap thread** (the only backlog thread — a
  verbatim `/persist-thread` archive) with a `## Routing` ledger and route tags
  over its **frozen body** (no re-render). Twelve ledger rows: the session mostly
  built governance/tooling homed in `meta/` (not `concept` sinks), so those are
  `unrouted`; the one knowledge feed — turn 2's definition of *what an OKF bundle
  is* — is route-tagged to [open knowledge format](/knowledge-management/open-knowledge-format.md)
  (`sb:24bd1e`), whose excerpt log was materialized. All five `mix
  brain.route_tags` checks green.
- Added the tutorial
  [What makes a commit show as "Verified" on GitHub](/meta/tutorials/what-makes-a-commit-verified-on-github.md)
  (operator-requested): author vs committer identities, the fact that "Verified"
  is a signature check bound to the committer email (not the email alone), why
  re-authoring an agent commit to `noreply@anthropic.com` lets this environment's
  signature attach, and the only-rewrite-unpushed-commits rule. Corrects an
  earlier chat shorthand that implied the email itself makes a commit verified.
  Listed in `meta/tutorials/index.md`.
- **Second `/capture` (extend-in-place)**: re-ran capture on the adopt thread to
  cover the exchanges since the first run (the push, the retrofit, the tutorial,
  the two commit-signing fixes, PR #17). Refreshed the ledger (backlog row now
  `closed`; five new rows) and narrative, and added one route tag carrying a new
  routing-technique insight — *routing density tracks durable knowledge vs
  process; a thin ledger is a signal, not a tagging failure* — to `sb:d479e3`,
  whose excerpt log now lifts two regions. Confirms `/capture` extends a session's
  existing thread doc in place rather than forking a new one.

## 2026-07-08

- **Removed the operator's email address** from the operating contract
  (operator-directed, privacy): dropped the parenthetical from
  `meta/preamble.md` and recompiled `CLAUDE.md` (`mix brain.contract`). The
  operator is now identified simply as "the human"; no other published
  reference to the address existed in the bundle.
- Added the **GitHub Pages site generator**: a dependency-free static-site build
  (`mix brain.site`, in `SecondBrain.Site` / `SecondBrain.Markdown`) that renders
  the bundle into a navigable knowledge base, deployed by
  `.github/workflows/pages.yml`. Added a `mix brain.site` smoke-check step to
  `ci.yml`, gitignored `_site/`, and documented it in the README.
- Created the **`meta/tutorials/`** namespace (operator-directed) with its
  `index.md`, and filed the first tutorial —
  [Why the brain's toolchain runs offline in CI and any sandbox](/meta/tutorials/why-the-toolchain-runs-offline.md).
  Long-form explanatory notes about the tooling/governance, distinct from `policy`
  (contract rules) and `threads` (verbatim archives). Listed both under
  `meta/index.md`.
- **Ratified a new `tutorial` type** (operator-directed): added it to
  `meta/policy/controlled-type-vocabulary.md` and recompiled `CLAUDE.md`
  (`mix brain.contract`); re-typed the tutorial above from `note` to `tutorial`
  and gave the type a badge color in the site generator.

## 2026-07-06

- Added the **`/summarize-technical`** skill (`.claude/skills/summarize-technical/SKILL.md`):
  produces a three-part layered breakdown of a technical source — a plain-language
  summary, a glossary of its key technical terms, then an integrated technical
  summary reusing that vocabulary. Registered in `meta/policy/skills-registry.md`
  and recompiled into `CLAUDE.md`.

- **Reframed the verification model** (operator directive): verification applies
  **only to agent-authored statements**; a concept that stores a link (`resource`)
  is a *capture* and can never be `verified: true`. Rewrote
  `meta/policy/verification-grounding.md` and the `verified`/`verified_by` rows of
  `meta/policy/frontmatter-schema.md`; `verified: true` now requires a non-empty
  `verified_by` (never its own `resource`), and `verified_by` targets need only
  **exist** (they are no longer required to be themselves verified). Updated
  `SecondBrain.Verifier` and its tests accordingly, dropped the `verified` field
  from all 9 `source`/`reference` captures (2 git + 5 CCR sources, 2 matklad
  references), and recompiled `CLAUDE.md` + `meta/registry.md`. The git concept
  `sb:4c9e1f` stays `verified: true` (agent statement grounded via `verified_by`);
  its source targets are now unverified captures, which the new rules permit.

- Final `/persist-thread` for the bootstrap session: extended the archive through
  exchange 25 (commit-identity hook exchanges, PR #3, filename question) and closed
  the thread. The record is complete.
- First `/persist-thread` invocation: extended the bootstrap thread archive in place
  through the PR #2 merge (exchanges 16–18; turn 16 upgraded to verbatim).
- Regenerated the bootstrap thread archive with **verbatim** agent responses
  (previously condensed) and added the `/persist-thread` skill encoding the
  archival flow (exchanges only, verbatim, no tool calls, numbered turn
  headings); registered it in the skills-registry policy and recompiled
  `CLAUDE.md`.

- Created `meta/threads/` and archived the bootstrap conversation:
  [2026-07-05 — greenfield OKF bootstrap and verification layer](/meta/threads/2026-07-05-greenfield-okf-bootstrap-and-verification-layer.md).
- Added the **identity & verification** contract section with two policies:
  [stable-identity](/meta/policy/stable-identity.md) (immutable `sb:` ids, id-based
  edges, compiled registry) and
  [verification-grounding](/meta/policy/verification-grounding.md) (immutable
  provenance; `verified` requires grounding; `verified_by` is the only committed
  evidence representation; prose derived via `mix brain.evidence`). Extended the
  frontmatter schema with `id` and `verified_by`. New tooling: `SecondBrain.Registry`,
  `SecondBrain.Verifier`, and the `brain.id` / `brain.registry` / `brain.verify` /
  `brain.evidence` mix tasks; CI and the pre-commit hook now run the registry check
  and verifier.
- Established the `meta/` governance namespace and backfilled the operating contract
  into fourteen `type: policy` documents under `meta/policy/`, grouped into six
  contract sections (composition, directory-structure, filing, type-vocabulary,
  conformance, skills).
- Added the Elixir contract compiler (`mix brain.contract`) that renders `/CLAUDE.md`
  from `meta/preamble.md` + `meta/policy/*.md`, with a trace link under each rule.
  `CLAUDE.md` is now a **generated artifact**.
- Added the `/render-contract` skill and the `policy` type to the vocabulary.
