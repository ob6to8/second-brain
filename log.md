# Log

Chronological history of the knowledge base. Newest entries first. Dates are ISO 8601.

## 2026-07-06

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
