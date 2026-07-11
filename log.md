# Log

Chronological history of the knowledge base. Newest entries first. Dates are ISO 8601.

## 2026-07-11

- **Three primary-source captures filed** (`type: source`), grounding the TMS
  and GSN references in their actual primary documents rather than
  encyclopedic summaries:
  [Doyle 1979](/knowledge-management/knowledge-representation/doyle-1979-a-truth-maintenance-system.md)
  and [de Kleer 1986](/knowledge-management/knowledge-representation/de-kleer-1986-an-assumption-based-tms.md)
  under `knowledge-representation/`, and the
  [GSN Community Standard V1](/knowledge-management/argumentation/gsn-community-standard.md)
  under `argumentation/` — each holding verbatim key passages with the
  official DOI/URL as `resource`. (GSN V3 is current but registration-gated;
  the openly served V1 was captured, with V3 noted.) Both reference docs'
  citations now link the captures.
- **Layered breakdowns for the five prior-art references** — ran
  `/summarize-technical` over the same day's five intakes
  ([TMS](/knowledge-management/knowledge-representation/truth-maintenance-systems.md),
  [Toulmin](/knowledge-management/argumentation/toulmin-model-of-argument.md),
  [assurance cases/GSN](/knowledge-management/argumentation/assurance-cases-and-gsn.md),
  [FOL/OWL](/knowledge-management/knowledge-representation/first-order-logic-and-owl.md),
  [FActScore/SAFE](/SWE/evals/decompose-then-verify-factuality.md)), replacing
  each flat distilled body with the three-part structure (plain-language
  summary → key terms → technical summary) per the update-in-place rule; ids,
  `resource`, and cross-links preserved. TMS mechanics and GSN element detail
  were supplemented from the standard literature (Doyle 1979; de Kleer 1986;
  GSN Community Standard) since the encyclopedic sources were thin there —
  noted in each doc's provenance and citations.
- **Epistemic prior-art intake** (belief-decomposition session) — five `reference`
  captures filed, with two new subdirectories under `knowledge-management/` and
  one under `SWE/`:
  [truth maintenance systems](/knowledge-management/knowledge-representation/truth-maintenance-systems.md)
  and [FOL and OWL](/knowledge-management/knowledge-representation/first-order-logic-and-owl.md)
  in the new [knowledge-representation](/knowledge-management/knowledge-representation/index.md);
  [the Toulmin model](/knowledge-management/argumentation/toulmin-model-of-argument.md)
  and [assurance cases / GSN](/knowledge-management/argumentation/assurance-cases-and-gsn.md)
  in the new [argumentation](/knowledge-management/argumentation/index.md);
  [decompose-then-verify factuality evaluation (FActScore, SAFE)](/SWE/evals/decompose-then-verify-factuality.md)
  in the new [SWE/evals](/SWE/evals/index.md). All fetched from primary/encyclopedic
  sources and distilled; links persisted in `resource`/Citations.
- **Five glossary terms added** from the same session:
  [bipartite graph](/glossary/bipartite-graph.md),
  [blast radius (of a retracted premise)](/glossary/blast-radius.md),
  [consensus core](/glossary/consensus-core.md),
  [minimal inconsistent subset](/glossary/minimal-inconsistent-subset.md),
  [ungrounded inference](/glossary/ungrounded-inference.md).

## 2026-07-10

- **Backfilled the glossary from the remaining thread docs** — ran
  `/add-to-glossary` over the eleven previously-unprocessed threads under
  [`/meta/threads/`](/meta/threads/index.md) (only the
  [add-to-glossary thread](/meta/threads/2026-07-10-add-to-glossary-skill-and-pr-wiring.md)
  had been done). Added **46 new term files** and **15 pointer entries** under
  [`/glossary/`](/glossary/index.md), taking the glossary from 7 to 68 terms —
  spanning scheduling/automation (Routine, cron expression,
  fresh-session-per-fire, approval gate), the news inbox (query profile,
  candidate feed, digest, reason tags, featuring), flows & testing (flow /
  touch-sequence, scenario test, deterministic spine, golden test,
  self-consistency check, ExUnit, property-based testing), the site generator
  (static-site generator, dependency-free, markdown renderer, GitHub Pages,
  deploy gating, HTML escaping, XSS, GFM), retrieval (recall, deduplication,
  recall probe, recall@k, vector database, embeddings, semantic search, ANN),
  Composable Beliefs / epistemics (typed edge, epistemic overlay, supersession,
  proto-belief document, route-tag sink), skills (skill namespacing,
  skill-to-skill delegation, plugin), and governance (compiled contract,
  operating contract, provenance, verification grounding, routing ledger,
  session capture, and pointer entries for the `issue`/`analysis`/`methodology`/`plan`/`tutorial`
  types). Appended *Seen in:* citations to the six existing entries the threads
  also touched, refreshed [`meta/registry.md`](/meta/registry.md), and
  re-verified (`mix brain.verify`, `mix brain.route_tags` both green).
- **Glossary restructured to one concept file per term** (operator-directed) —
  the seven entries moved out of the monolithic `glossary.md` into
  [`/glossary/`](/glossary/index.md), each its own `type: concept` file with a
  minted `sb:` id ([concept (OKF)](/glossary/concept-okf.md) `sb:317879`,
  [graduation](/glossary/graduation.md) `sb:0c8532`,
  [pointer entry](/glossary/pointer-entry.md) `sb:393e3d`,
  [route tag](/glossary/route-tag.md) `sb:e142e6`,
  [stable id](/glossary/stable-id.md) `sb:4d71d3`,
  [thread doc](/glossary/thread-doc.md) `sb:089fb2`,
  [verified_by](/glossary/verified-by.md) `sb:c6e78a`), so every definition is
  individually linkable from responses and concepts.
  [`/glossary.md`](/glossary.md) (`sb:0b648f`) stays as the hub doc and keeps
  its route-tagged excerpt log; graduation now means *moving* a term file into
  the domain taxonomy (id travels) leaving a pointer stub. Updated the
  `/add-to-glossary` skill (per-term merge rules, a "citing terms in responses"
  section), the `/create-pull-request` step-2 wording, the skills-registry
  policy (re-rendered `CLAUDE.md`), the root `index.md`, and
  `meta/registry.md`.
- **First `/add-to-glossary` run** — over the thread
  [2026-07-10-add-to-glossary-skill-and-pr-wiring](/meta/threads/2026-07-10-add-to-glossary-skill-and-pr-wiring.md),
  as step 2 of a `/create-pull-request` invocation (the new wiring's first live
  exercise). Seeded the [glossary](/glossary.md) (`sb:0b648f`) with its first
  seven entries: two definitions for terms the session coined (*graduation*,
  *pointer entry*, deferring to the skill doc) and five pointer entries for
  contract machinery the thread used (*concept (OKF)*, *route tag*,
  *stable id*, *thread doc*, *verified_by* — each a one-line gloss plus a link
  to its defining policy).
- **Seeded the bundle-root [glossary](/glossary.md)** — a single cross-domain
  running glossary (`type: concept`), accreted by the new
  [`/add-to-glossary`](/.claude/skills/add-to-glossary/SKILL.md) skill: one
  alphabetical entry per technical term, each citing the threads/papers/posts it
  was seen in; pointer entries defer to filed concepts instead of duplicating
  them. Listed it under a "Cross-domain" heading in the root `index.md`, minted
  its id, and regenerated `meta/registry.md`. No entries yet. See
  [meta/log.md](/meta/log.md) for the skill entry.

## 2026-07-09

- **Route-tagged excerpt logs materialized** into the two `SWE/testing` references
  [ExUnit dependency-free fixtures and diffs](/SWE/testing/exunit-dependency-free-fixtures-and-diffs.md)
  (`sb:f6e843`) and
  [Elixir snapshot/approval-testing libraries require a dependency](/SWE/testing/elixir-snapshot-libraries-require-a-dependency.md)
  (`sb:b1ba4b`) by the `/capture` of the flows-genre session (thread
  `2026-07-09-flows-genre-and-scenario-testing`) — the research-spike verdict
  region feeds both. See [meta/log.md](/meta/log.md) for the capture entry.
- [Open Knowledge Format (OKF)](/knowledge-management/open-knowledge-format.md)
  (`sb:24bd1e`) gained a thread-excerpt log section from the `/capture` of the
  GitHub Pages / OKF-node session (route-tagged; materialized by
  `mix brain.route_tags`). Content-only; no frontmatter change.
- **Intook the outside references that informed the flows-spec harness design**
  (operator-directed), into `SWE/testing/`:
  [ExUnit ships dependency-free fixtures and diffs](/SWE/testing/exunit-dependency-free-fixtures-and-diffs.md)
  (`sb:f6e843`) and
  [Elixir snapshot/approval-testing libraries require a dependency](/SWE/testing/elixir-snapshot-libraries-require-a-dependency.md)
  (`sb:b1ba4b`) — two `reference` captures distilled from the ExUnit docs, the
  Elixir issue tracker, and the mneme/snapshy/assert_value repos during the
  test-harness research spike. Each carries an `# Influence` back-link to the spec
  ([flows-genre-and-scenario-testing](/meta/plans/flows-genre-and-scenario-testing.md)),
  and the spike section of that spec now links forward to both — bidirectional
  traceability from a design decision to the resources that drove it. Minted ids
  and regenerated `meta/registry.md`.
- **Ratified a new `plan` type** (operator-approved) and a `meta/plans/` namespace —
  intended work on the brain/tooling as design/decision records, each carrying a
  `status` (`proposed`/`accepted`/`in-progress`/`done`/`superseded`); distinct from an
  `issue` (a problem) and a `methodology` (a repeatable how-to). Added it to the
  controlled vocabulary, seeded `meta/plans/index.md`, registered it in `meta/index.md`,
  and recompiled `CLAUDE.md`. Filed the first plan,
  [epistemic overlay](/meta/plans/epistemic-overlay.md) (`status: proposed`) — a
  frontmatter-native overlay promoting the latent attestation/aggregation/inference/
  prescription structure to a first-class, queryable layer over existing concepts, with
  an integrity-checking `mix brain.graph`, explicitly bounding out atomization and
  strength-as-count. Derived from a deep comparison against the Composable Beliefs repo
  (the diagnosis: CB is well-engineered but carries three uncommitted purposes on one
  substrate; its four-type epistemic layer is the one genuinely universal piece this
  brain is already using implicitly).

- Ratified a new top-level **`inbox/`** namespace (operator-approved) — a daily
  candidate feed of news, articles, papers, and resources matched against the
  taxonomy, grouped by category and reason-tagged
  (`recent`/`impactful`/`influential`/`groundbreaking`/`buzz`). It is a **non-bundle**
  namespace like `meta/`: candidates carry no `sb:` ids and are never verified, so
  `inbox` was added to `SecondBrain.Registry`'s excluded dirs (keeping it out of
  `mix brain.verify`/`registry`/`route_tags`); the static-site generator still renders
  it. Added the **`/news`** skill (`.claude/skills/news/`), registered it in the skills
  registry, and recompiled `CLAUDE.md`. Seeded the namespace with `inbox/index.md`,
  `inbox/log.md`, and the first digest
  [2026-07-09](/inbox/2026-07-09.md) (7 items across ai-industry, SWE, and
  knowledge-management). Intake stays the sole path into the bundle: `/news` proposes,
  `/intake` files.

## 2026-07-08

- **Adopted a session-capture / routing-ledger / route-tagging workflow** from the
  Composable Beliefs repo, at the OKF floor (the belief DAG was out of scope).
  Added three `type: policy` docs under a new `session-workflow` contract section
  (`session-capture`, `routing-ledger`, `route-tagging`), the **`/capture`** skill
  (`.claude/skills/capture/`), and registered `/capture` in the skills registry;
  recompiled `CLAUDE.md`. Ported cb's `route_tags.ex` verifier to
  `SecondBrain.RouteTags` + **`mix brain.route_tags`** (wired into CI and the
  pre-commit hook beside `mix brain.verify`), adapting cb's flat slugs / `cb:bNNN`
  belief ids to this bundle: a route-tag ref is now a concept's **`sb:` id** (the
  aggregating sink) or a **path** (a non-aggregating back-link); threads under
  `meta/threads/` are tag *sources*. Filed the transferable concept
  [routing non-linear work sessions](/SWE/agentic-coding/context-engineering/routing-non-linear-work-sessions.md)
  (`sb:d479e3`) and the first worked-example thread
  [2026-07-08-adopt-session-capture-routing-and-route-tags](/meta/threads/2026-07-08-adopt-session-capture-routing-and-route-tags.md),
  whose route tag materialized the concept's `## Thread excerpts — route-tagged log`
  section. Documented the full flow in [meta/session-workflow.md](/meta/session-workflow.md).
  All gates green.
- Ratified a new top-level domain **`knowledge-management/`** (operator-approved) —
  knowledge representation, PKM, and knowledge formats. Filed its first concept,
  [Open Knowledge Format (OKF)](/knowledge-management/open-knowledge-format.md)
  (`sb:24bd1e`, `type: reference`), which now holds the canonical OKF spec URL.
  Repointed every internal "Open Knowledge Format" mention — the root `index.md`,
  `README.md`, and `meta/preamble.md` (→ recompiled `CLAUDE.md`) — from the raw
  external URL to this node, so the link is processed once and referenced everywhere.
  Listed the new domain in the root `index.md`; regenerated `meta/registry.md`.

- **Ratified a new `methodology` type** (operator-approved) and added it to the
  controlled vocabulary in `meta/policy/controlled-type-vocabulary.md` — a
  repeatable, prescriptive procedure/playbook, distinct from `note` (an idea) and
  `concept` (a mental model). Recompiled `CLAUDE.md`. Retyped
  `SWE/testing/elixir-second-brain-testing-methodology.md` (`sb:d58da3`)
  `note` → `methodology`; aligned its tags (`test-strategy` → `test-design`,
  dropped the now-redundant `methodology` tag). Added reciprocal "Applied in"
  back-links from both matklad references (`sb:a5ea86`, `sb:73115b`) to the
  methodology, and relabeled the `SWE/testing/index.md` section
  Notes → Methodologies. Left `verified: false` (grounding it via `verified_by`
  the two references remains an open option). Regenerated `meta/registry.md`.

- Synthesized the two matklad testing references already filed under `SWE/testing/`
  ("How to Test" `sb:a5ea86` and "Purity and Extent" `sb:73115b`) into an
  agent-facing **testing methodology** for this repo's dependency-free Elixir
  tooling: `SWE/testing/elixir-second-brain-testing-methodology.md` (`sb:d58da3`,
  `type: methodology`). Maps each essay principle onto the actual modules — purity ladder →
  `async: true` for `Frontmatter`/`Policy` vs. `async: false` + `@moduletag :tmp_dir`
  for the IO-touching `Registry`/`Contract`/`Verifier`; test-features-not-code →
  assert on error strings / rendered output and inject `root` rather than mocking
  `File`; the `check` chokepoint → the existing `write_concept`/`write_policy`
  builders (promote to `test/support/` when shared); golden/snapshot tests → the
  `write`/`check` round-trip on the generated `CLAUDE.md` and `meta/registry.md`;
  and a generative-testing ladder (properties for `mint`/frontmatter round-trip,
  exhaustive enumeration for the `type` vocab), noting StreamData would be a new dep
  to ratify. Updated `SWE/testing/index.md` and regenerated `meta/registry.md`.

## 2026-07-06

- `/intake`: re-fetched Anthropic's "Effective context engineering for AI agents"
  (`sb:c0961a`, already filed) and researched its currency as requested — no new
  concept created (dedup), but **updated it in place** with a "2026 currency check"
  section: verdict is still accurate and reinforced rather than superseded. Found
  that Anthropic shipped a Context Editing API + Memory Tool the *same day* as the
  essay, productizing its "compaction" and "structured note-taking" techniques into
  literal API primitives (29%/39% performance gains, 84% token reduction per
  Anthropic's own benchmarks); that Chroma's independent "context rot" research
  empirically corroborates the essay's attention-budget thesis; and that
  just-in-time retrieval guidance has been refined toward hybrid preload+JIT
  strategies rather than reversed. No direct critique of the essay's core framing
  found. Filed the two grounding sources as new references:
  `SWE/agentic-coding/context-engineering/claude-context-editing-and-memory-tool.md`
  (`sb:bf8a85`) and `SWE/agentic-coding/context-engineering/context-rot-chroma-research.md`
  (`sb:77d68a`), both cross-linked to `sb:c0961a` and to each other.

## 2026-07-06

- Applied the new `/summarize-technical` skill to the two just-filed
  context-engineering references, updating each in place (per update-in-place —
  no new files): `SWE/agentic-coding/context-engineering/conversation-tree-architecture.md`
  (`sb:784985`) and `SWE/agentic-coding/context-engineering/granularity-aware-evaluation-for-dialogue-topic-segmentation.md`
  (`sb:649457`) now each carry a plain-language summary, a glossary of the
  paper's key technical terms, and an integrated technical summary reusing that
  vocabulary, replacing their prior single-pass distilled bodies. Frontmatter,
  ids, and citations unchanged. See [meta/log.md](/meta/log.md) for the new
  skill itself.

- `/intake`: filed `SWE/agentic-coding/context-engineering/granularity-aware-evaluation-for-dialogue-topic-segmentation.md`
  (`sb:649457`, type `reference`) — Michael Coen's paper (arXiv:2512.17083v3)
  separating boundary *scoring* from boundary *selection* in dialogue topic
  segmentation, showing that sweeping boundary density (BOR) changes W-F1 more
  than switching segmentation methods does, and introducing purity/coverage
  diagnostics to distinguish granularity mismatch from genuine detection failure.
  Summarized (dense empirical paper with many tables); full text linked as
  `resource`. Read from an uploaded PDF (installed `poppler-utils` after a stale-apt
  failure, fixed with `--allow-releaseinfo-change` per the known issue in `sb:52aefa`).
  Filed alongside and cross-linked with the existing Conversation Tree Architecture
  reference in `SWE/agentic-coding/context-engineering/`.

- `/intake`: filed `SWE/agentic-coding/context-engineering/conversation-tree-architecture.md`
  (`sb:784985`, type `reference`) — Hemanth & Saha's Conversation Tree Architecture
  proposal (arXiv:2603.21278v1): structuring LLM conversations as branching trees with
  selective downstream/upstream context flow to avoid "logical context poisoning".
  Summarized (an academic paper; full text linked as `resource`) — flagged as a
  framework proposal with a working prototype, not yet empirically validated. Created
  the `SWE/agentic-coding/context-engineering/` subtree (autonomous — under the
  established `agentic-coding` domain) with its `index.md`; cross-linked the existing
  Anthropic context-engineering reference in `agentic-loop/`.

- **Operator-ratified new top-level domain**: `ai-industry/` — market, economic, and
  competitive analysis of the AI industry, distinct from `SWE/` (building software
  with/for AI). Filed the two sources this domain was proposed for:
  `ai-industry/ai-roi-runway-outside-tech-sector.md` (`sb:2867ac`, Torsten Slok/Apollo
  on AI valuations outpacing non-tech margin reality, with HN counterpoints folded in)
  and `ai-industry/ai-margin-collapse-glm-5-2.md` (`sb:07610c`, Martin Alderson on
  frontier-lab inference margins exposed by open-weight competition, cross-linked to
  the KV-cache compression history for the MLA lineage). Added the directory `index.md`
  and listed the new top-level domain in the bundle-root `index.md`.
- `/intake`: filed two LLM-engineering references — `SWE/llm-engineering/rag-context-pruning-with-a-small-llm.md`
  (`sb:41be22`, Kapa.ai's cheap-LLM RAG chunk pruning) and
  `SWE/llm-engineering/kv-cache-compression-history.md` (`sb:266c5e`, Martin Alderson's
  MQA→GQA→MLA→quantization history) — and one agent-framework reference,
  `SWE/agentic-coding/frameworks/sagents-elixir-agent-orchestration.md` (`sb:eeb2bb`,
  an Elixir agent-orchestration library on LangChain). Created two new autonomous
  subtrees: `SWE/llm-engineering/` (new sibling under `SWE/`) and
  `SWE/agentic-coding/frameworks/` (subdir under the established `agentic-coding`
  domain). Two economics-of-AI sources from the same intake batch (Apollo/Slok "AI
  ROI runway" + HN discussion; Alderson "AI margin collapse"/GLM-5.2 + HN discussion)
  do not fit any existing directory and await operator ratification of a new
  top-level domain before filing.
- `/intake`: filed `SWE/agentic-coding/code-context/gitnexus.md` (`sb:b89ea1`, type
  `reference`) — GitNexus, a client-side code knowledge-graph tool that serves codebase
  context (calls, imports, clusters, execution flows) to coding agents over MCP. Created
  the `SWE/agentic-coding/code-context/` subtree (autonomous — under the established
  `SWE/` domain) with its `index.md`; cross-linked to the context-engineering reference.
- Research spike into **agentic "looping"**: filed 16 primary sources as `reference`
  captures under the new `SWE/agentic-coding/agentic-loop/` subtree (autonomous — under
  the established `SWE/` domain), spanning foundations (ReAct `sb:f63910`), canonical
  framing (Anthropic `sb:06d95d`, OpenAI `sb:a030d9`, Thorsten Ball `sb:8e885f`,
  smolagents `sb:f948df`), loop anatomy (Kinney `sb:97d2a8`, Dibia `sb:3fd44a`, Oracle
  `sb:592342`, Willison `sb:a832e0`), the "loop engineering" lexicon (Willison `sb:3384ba`,
  LangChain `sb:1aefe2`, Dubois `sb:01bb9a`, Ronacher `sb:d580ce`), and control-flow/
  autonomy/context (12-factor `sb:b6353e`, Ralph `sb:276c61`, Anthropic context
  engineering `sb:c0961a`). Each distilled with a verbatim thesis quote; sources
  gathered via parallel research subagents. Added the directory `index.md` (defining
  intro + categorized listing) and linked it from the agentic-coding index.
- Reframed the verification model: verification is **only for agent-authored
  statements**; link-storing captures (`source`/`reference`) can never be
  `verified: true`, and `verified: true` now requires `verified_by` (not a `resource`)
  with targets that need only exist. Dropped `verified` from all 9 captures and updated
  the verifier + tests. See [meta/log.md](/meta/log.md).
- `/intake`: filed `SWE/testing/how-to-test-features-not-code.md` (`sb:a5ea86`, type
  `reference`, `verified: false`) — matklad's "test features, not code" methodology
  (the `check` chokepoint, sans-IO logic, data-driven and expect tests, generative
  testing). Filed alongside and cross-linked with the purity/extent reference in the
  existing `SWE/testing/`.
- `/intake`: filed `SWE/testing/unit-vs-integration-purity-and-extent.md` (`sb:73115b`,
  type `reference`, `verified: false`) — matklad's argument to replace the unit/integration
  dichotomy with two axes, purity and extent. Created the `SWE/testing/` subtree
  (autonomous — under the established `SWE/` domain) with its `index.md`; added it to
  `SWE/index.md`.
- Grounded the CCR architecture note (`sb:52aefa`) against the official "Use Claude
  Code on the web" docs: captured five verbatim `type: source` excerpts under
  `SWE/agentic-coding/claude-code/sources/` (`sb:863b32`, `sb:eb418b`, `sb:3420c8`,
  `sb:564b8e`, `sb:3f35e1`, all `verified: true`), promoted several items from
  forensic-only to documented, resolved the per-environment-snapshot / ~7-day
  cache-expiry inference questions, and surfaced the fresh-clone-vs-baked-clone
  divergence (reconciled via environment caching). Note stays `verified: false`
  (retains session-specific forensic anecdotes); documented backbone now cross-links
  the source excerpts.

## 2026-07-05

- Filed `SWE/agentic-coding/claude-code/cloud-environment-architecture.md` (`sb:52aefa`,
  type `note`, `verified: false`): Claude Code cloud (CCR) environment/orchestration
  architecture notes from in-container forensics, with per-item E/D/I confidence
  markers. Created the `SWE/agentic-coding/claude-code/` subtree (autonomous — under
  the established `SWE/` domain) with its `index.md` files; cross-linked the existing
  git remote-tracking-refs concept (`sb:4c9e1f`).
- Verified the git fetch claim from primary sources: extracted verbatim passages from
  Pro Git §3.5 (`sb:a3d27b`) and gitglossary (`sb:f08c54`) into
  `SWE/version-control/git/sources/`, wired them as `verified_by` edges, and graduated
  `sb:4c9e1f` from `claim` to `concept` (`verified: true`; provenance unchanged).
- Added the stable-identity layer: immutable `sb:xxxxxx` ids on every bundle concept,
  compiled `meta/registry.md`, and `mix brain.id` / `brain.registry` / `brain.verify` /
  `brain.evidence` tasks. Evidence edges live only in `verified_by`; verification prose
  is derived, never committed. See [meta/log.md](/meta/log.md).
- Introduced the `meta/` governance namespace and made `CLAUDE.md` a **compiled
  artifact**: the operating contract was backfilled into 14 `type: policy` documents
  under `meta/policy/`, and an Elixir compiler (`mix brain.contract`) now renders
  `CLAUDE.md` from `meta/preamble.md` + those policies, with a trace link per rule.
  Added the `/render-contract` skill, the `policy` type, and the mix project
  (`mix.exs`, `lib/`, `test/`). See [meta/log.md](/meta/log.md).
- Dropped the `link` type: a web resource enters the brain only once processed into a
  `reference`; bare URLs are not filed. Removed the `link`/`reference` distinction.
- Policy update to the operating contract: create the natural directory path even for a
  single concept; new top-level dirs still ratified, subdirs autonomous. Added `claim`
  and `link` types and `provenance` / `verified` frontmatter fields.
- First `/intake`: filed `SWE/version-control/git/git-local-branches-dont-auto-advance-on-fetch.md`
  (type `claim`, `verified: false`, provenance Claude Opus 4.8). Created operator-ratified
  top-level `SWE/` domain with the `version-control/git/` subtree and their `index.md` files.
- Initialized the Open Knowledge Format (OKF v0.1) bundle: bundle-root `index.md`,
  this `log.md`, the operating contract (`CLAUDE.md`), and the `/intake` skill.
- Taxonomy starts blank; directories are created collaboratively as content arrives.
- Prior tooling and content archived under `deprecated/` (read-only).
