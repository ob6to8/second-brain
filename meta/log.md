# Log — meta

Chronological history of the governance namespace. Newest first. ISO 8601 dates.

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
