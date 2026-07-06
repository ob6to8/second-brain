# Log

Chronological history of the knowledge base. Newest entries first. Dates are ISO 8601.

## 2026-07-06

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
