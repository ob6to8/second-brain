# Log — meta

Chronological history of the governance namespace. Newest first. ISO 8601 dates.

## 2026-07-09

- `/capture`: froze the testing-methodology / types / Composable-Beliefs session into
  [2026-07-09-testing-methodology-types-and-cb-epistemic-overlay](/meta/threads/2026-07-09-testing-methodology-types-and-cb-epistemic-overlay.md).
  Two regions route-tagged to the testing methodology (`sb:d58da3`) — materializing its
  `## Thread excerpts — route-tagged log` — plus six path back-links to the
  `epistemic-overlay` plan. Routing ledger has six strands (five closed, the plan
  paused on its open questions). `mix brain.route_tags` verifies clean. Listed the
  thread in `meta/threads/index.md`.

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
