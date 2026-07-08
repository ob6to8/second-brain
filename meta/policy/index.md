# Policy

Governance rules as first-class OKF documents (`type: policy`). These are the
**source of truth** for the operating contract: `/CLAUDE.md` is compiled from them via
`mix brain.contract`. Edit policy here — never hand-edit `CLAUDE.md`.

Each policy declares the contract `section` it renders into and its `order` within
that section.

## composition
- [concept-anatomy](/meta/policy/concept-anatomy.md) — the repo root is the bundle; a concept is frontmatter + body; ID is path minus `.md`
- [frontmatter-schema](/meta/policy/frontmatter-schema.md) — the controlled frontmatter fields and their requirement levels
- [reserved-filenames](/meta/policy/reserved-filenames.md) — `index.md` and `log.md` structures

## directory-structure
- [directory-hierarchy](/meta/policy/directory-hierarchy.md) — unix-like, kebab-case; create the natural path even for one concept
- [tree-is-the-taxonomy](/meta/policy/tree-is-the-taxonomy.md) — the tree + `index.md` files are the canonical taxonomy
- [taxonomy-evolution-protocol](/meta/policy/taxonomy-evolution-protocol.md) — subdirs autonomous; new top-level dirs ratified

## filing
- [distill-dont-dump](/meta/policy/distill-dont-dump.md) — capture the knowledge, not the raw noise
- [update-in-place](/meta/policy/update-in-place.md) — search first; update rather than fragment
- [filenames-and-cross-linking](/meta/policy/filenames-and-cross-linking.md) — kebab-case slugs; bundle-absolute links
- [link-processing](/meta/policy/link-processing.md) — links enter only once processed; summarize oversized sources
- [maintain-reserved-files](/meta/policy/maintain-reserved-files.md) — update `index.md` and `log.md` after filing

## type-vocabulary
- [controlled-type-vocabulary](/meta/policy/controlled-type-vocabulary.md) — the controlled, deliberately-growing list of concept types

## verification
- [stable-identity](/meta/policy/stable-identity.md) — immutable `sb:xxxxxx` ids; edges reference ids; `meta/registry.md` is compiled
- [verification-grounding](/meta/policy/verification-grounding.md) — provenance immutable; `verified` requires grounding; evidence edges live only in `verified_by`

## conformance
- [okf-conformance](/meta/policy/okf-conformance.md) — the OKF v0.1 conformance conditions

## skills
- [skills-registry](/meta/policy/skills-registry.md) — available skills and where new ones go

## session-workflow
- [session-capture](/meta/policy/session-capture.md) — `/capture` renders a session into a distilled thread doc, on demand
- [routing-ledger](/meta/policy/routing-ledger.md) — the per-thread `## Routing` dispatch table (pointers and states only)
- [route-tagging](/meta/policy/route-tagging.md) — `<routes ref="sb:…">` tags materialize a re-derivable excerpt log into each concept
