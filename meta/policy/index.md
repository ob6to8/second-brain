# Policy

Governance rules as first-class OKF documents (`type: policy`). These are the
**source of truth** for the operating contract: `/CLAUDE.md` is compiled from them via
`mix brain.contract`. Edit policy here — never hand-edit `CLAUDE.md`.

Each policy declares the contract `section` it renders into and its `order` within
that section.

This directory stays flat, so filenames carry the grouping: when several policies
govern one domain, they share a kebab-case filename prefix (e.g. `git-`) so the
domain reads as a group in listings. Single-policy domains adopt the prefix from
the start if siblings are plausible.

## composition
- [document-anatomy](/meta/policy/document-anatomy.md) — the repo root is the bundle; a document is frontmatter + body; ID is path minus `.md`
- [frontmatter-schema](/meta/policy/frontmatter-schema.md) — the controlled frontmatter fields and their requirement levels
- [resource-attribution](/meta/policy/resource-attribution.md) — the `attribution` map: the ingestion event (when/channel/agent/why, plus governance `from`) recorded on every doc
- [reserved-filenames](/meta/policy/reserved-filenames.md) — `index.md` structure; `log.md` reserved by OKF but not kept in this bundle

## directory-structure
- [directory-hierarchy](/meta/policy/directory-hierarchy.md) — unix-like, kebab-case; create the natural path even for one document
- [tree-is-the-taxonomy](/meta/policy/tree-is-the-taxonomy.md) — the tree + `index.md` files are the canonical taxonomy
- [taxonomy-evolution-protocol](/meta/policy/taxonomy-evolution-protocol.md) — subdirs autonomous; new top-level dirs ratified

## filing
- [capture-knowledge-cite-the-source](/meta/policy/capture-knowledge-cite-the-source.md) — capture the distilled knowledge, keep the raw source as a citation (the knowledge-layer half of [fit each layer to its purpose](/meta/doctrine/fit-each-layer-to-its-purpose.md))
- [update-in-place](/meta/policy/update-in-place.md) — search first; update rather than fragment
- [filenames-and-cross-linking](/meta/policy/filenames-and-cross-linking.md) — kebab-case slugs; bundle-absolute links
- [response-resource-links](/meta/policy/response-resource-links.md) — in delivered responses, cite resources by their deployed Pages URL, not repo paths
- [link-processing](/meta/policy/link-processing.md) — links enter only once processed; summarize oversized sources
- [maintain-reserved-files](/meta/policy/maintain-reserved-files.md) — update `index.md` after filing; the commit carries the change narrative
- [persist-plans](/meta/policy/persist-plans.md) — approved plans are persisted as `type: plan` docs under `meta/plans/`, not left in chat
- [plan-vs-capture](/meta/policy/plan-vs-capture.md) — persist a prospective plan only for deferred/cold-handoff/cross-session work; in-session work is recorded by its commit and thread capture
- [merge-strategy](/meta/policy/merge-strategy.md) — PRs land via a true merge commit only; squash/rebase disallowed because commit history is provenance

## type-vocabulary
- [controlled-type-vocabulary](/meta/policy/controlled-type-vocabulary.md) — the controlled, deliberately-growing list of document `type` values

## verification
- [stable-identity](/meta/policy/stable-identity.md) — immutable `em:xxxxxx` ids; edges reference ids; `meta/registry.md` is compiled
- [verification-grounding](/meta/policy/verification-grounding.md) — provenance immutable; `verified` requires grounding; evidence edges live only in `verified_by`

## conformance
- [okf-conformance](/meta/policy/okf-conformance.md) — the OKF v0.1 conformance conditions

## skills
- [skills-registry](/meta/policy/skills-registry.md) — available skills and where new ones go

## session-workflow
- [session-capture](/meta/policy/session-capture.md) — `/capture` renders a session into a distilled thread doc, on demand
- [routing-ledger](/meta/policy/routing-ledger.md) — the per-thread `## Routing` dispatch table (pointers and states only)
- [route-tagging](/meta/policy/route-tagging.md) — `<routes ref="em:…">` tags materialize a re-derivable excerpt log into each referenced document

## git-workflow
- [git-branch-deletion](/meta/policy/git-branch-deletion.md) — head branches are deleted on PR merge; the default branch and unmerged branches need operator approval
