# Log — meta

Chronological history of the governance namespace. Newest first. ISO 8601 dates.

## 2026-07-05

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
