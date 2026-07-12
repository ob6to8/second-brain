---
type: analysis
title: "Should the brain add a wiki, and where do its docs fall short? No wiki — the Pages site already is one; the docs need spot-fixes, not a new surface"
description: A full-surface audit of the repo's documentation (contract, README, indexes, tutorials, flows, glossary, policies) run against the live bundle with all CI gates green, concluding that a GitHub wiki would duplicate the single source of truth and bypass the enforcement stack while the existing mix brain.site Pages deployment already serves the wiki role; the real gaps are a stale README, two index omissions, one broken policy link, and named tutorial/flow coverage holes.
provenance: "Claude Code session (Claude Fable), 2026-07-12 — operator asked to evaluate the repo and all of its docs, consider creating a wiki, and levy an analysis before beginning work"
tags: [meta, analysis, documentation, wiki, github-pages, static-site, indexes, readme, tutorials, coverage]
timestamp: 2026-07-12
---

# Should the brain add a wiki, and where do its docs fall short?

**Question.** Evaluate the repo and all of its documentation. Should we create a
wiki? How could the docs be made more comprehensive, and where are they stale?

**Method.** Inventory every documentation surface; run the full gate suite
(`mix brain.verify`, `brain.contract --check`, `brain.registry --check`,
`brain.route_tags`) against the live bundle; mechanically scan for
missing-`index.md` directories, index drift (files present but unlisted), and
broken internal links; then judge the wiki question against the bundle's own
standing policies.

## 1. The documentation surface — inventory and health

The brain's documentation is not one document but **nine surfaces**, most of
them mechanically enforced:

| Surface | Role | Health |
|---------|------|--------|
| `CLAUDE.md` | compiled operating contract | ✅ current (`--check` green) |
| `meta/policy/` (22 docs) | source of the contract | ✅ current |
| `index.md` tree | the taxonomy itself, one per directory | ✅ complete — no directory with concepts lacks an index; near-zero drift (two omissions, §3) |
| `meta/registry.md` | generated id → path view | ✅ current (`--check` green) |
| `meta/tutorials/` (7 docs) | long-form "why" behind the tooling | ✅ good; coverage holes named in §3 |
| `meta/flows/` (2 docs) | end-to-end touch-sequence per flow | ✅ accurate; one stale genre name, limited coverage |
| `glossary/` (80+ terms) + `glossary.md` hub | per-term definitions with citations | ✅ healthy, verifier-covered |
| `meta/threads/` (21 docs) + routing ledgers | frozen session archives | ✅ route-tag verifier fully green (75 regions, 19 sink logs, fidelity checked) |
| `README.md` | GitHub landing page for humans | ⚠️ **stale** (§3) |

All eight CI gates pass on the current tree. The striking property — confirmed
by the mechanical scan — is that the surfaces the toolchain *enforces*
(contract, registry, route-tag logs, verified edges) are exactly the ones with
zero drift, and the surfaces maintained *by hand and convention* (README, a
couple of index entries, an example link inside a policy) are where the
staleness lives. That is the failure-mode split the
[field-comparison analysis](/meta/analysis/comparison-with-the-2026-second-brain-field.md)
predicted: advisory surfaces drift; enforced surfaces don't.

## 2. The wiki question — no, and the reasons are already policy

**Recommendation: do not create a wiki.** Three grounds, each anchored in a
standing policy rather than taste:

1. **A wiki is a second content store, and the brain's core invariant is a
   single one.** A GitHub wiki lives in a separate `*.wiki.git` repository with
   its own history — no YAML frontmatter, no `sb:` ids, no `verified_by` edges,
   no session trailers, and none of the eight CI gates. Every page written there
   would be invisible to `mix brain.verify`, the registry, route tags, and the
   dedup search that [update-in-place](/meta/policy/update-in-place.md)
   requires. It would be the textbook "separate map that drifts" that
   [the tree is the taxonomy](/meta/policy/tree-is-the-taxonomy.md) forbids.
   The enforcement stack is what the field comparison found distinctive about
   this bundle; a wiki is a surface the stack cannot reach.

2. **The wiki role is already filled.** `mix brain.site` renders the entire
   bundle into a static, navigable knowledge site — sidebar mirroring the
   directory taxonomy, per-concept metadata panels (type, tags, verification
   status, evidence edges with reverse backlinks), client-side search — deployed
   to GitHub Pages on every push to `main`, and
   [gated on a verified bundle](/meta/tutorials/gating-the-pages-deploy-on-a-verified-bundle.md).
   That is a wiki in every sense that matters, except that its content has
   exactly one canonical home: the bundle. Anything a wiki would offer that the
   site lacks is a *site feature request*, not a case for a second store.

3. **Wiki edits would bypass provenance.** The commit graph is the provenance
   layer ([merge-strategy](/meta/policy/merge-strategy.md), the retired-logs
   plan). Wiki edits made through GitHub's wiki UI produce commits in the
   sibling repo with none of the session trailers or gate checks — re-opening
   the exact hand-kept-history problem the brain just closed.

**If more "wiki-ness" is wanted, invest in the site.** Candidate enhancements,
in rough value order (each is a `plan`-sized proposal, not committed work):
backlinks computed from *prose* links (the site currently reverses only
`verified_by` edges); a recently-changed page derived from `git log`; per-tag
listing pages. All three stay inside the single-store model.

## 3. Findings — staleness and gaps, tiered by action

### Tier 1 — factual staleness, fix now (mechanical, no shape change)

- **`README.md` is the worst offender.** It still lists ``log.md` —
  chronological change history`` in the layout, retired in commit `62d9327`
  (2026-07-11). It also predates most of the system: no mention of the `meta/`
  governance namespace, the glossary, the gate suite, the daily `/research` inbox,
  or the session-init digest. As the GitHub landing page it is the first thing
  a human reads, and it describes the repo of ~ five days ago.
- **`meta/index.md` omissions.** The tooling list omits
  `mix brain.session_init` (the newest task, shipped 2026-07-11), and
  [`future-beliefs.md`](/meta/future-beliefs.md) is filed in `meta/` but absent
  from the index — the only index-drift hits in the whole bundle.
- **One genuinely broken policy link.**
  [`filenames-and-cross-linking.md`](/meta/policy/filenames-and-cross-linking.md)
  uses `[OKF](/references/open-knowledge-format.md)` as its example — a path
  that has never existed in this bundle (the concept lives at
  `/knowledge-management/open-knowledge-format.md`). Because policies compile
  into the contract, the broken example is reproduced in `CLAUDE.md`.
- **`meta/flows/index.md` names a retired genre.** Its genre-contrast paragraph
  says "`specs` is the plan for a change not yet fully built" — the genre is
  `plans` and has been since the `plan` type was ratified.

The remaining scanner hits are non-actionable by design: `…` ellipsis
placeholders in policy examples, and missing-slash links inside frozen thread
quotes (reproduced verbatim into materialized excerpt logs — the
[route-tagging policy](/meta/policy/route-tagging.md) freezes them, and
[OKF conformance](/meta/policy/okf-conformance.md) tolerates broken links).

### Tier 2 — comprehensiveness gaps, propose as follow-ups

- **No tutorial for the session-init digest.** `SecondBrain.SessionInit` is the
  newest subsystem (open-work digest + heuristic priorities at session start)
  and the only `mix brain.*` task without tutorial or flow coverage.
- **Flow-doc coverage is 2 of 8 skills.** `capture` and `intake` have flow
  docs; `research`, `add-to-glossary`, `create-pull-request`, and `todo` do not.
  The flows plan scoped the initial two deliberately, so this is a *decision to
  revisit*, not drift — the next candidates are `research` (it has a live
  operational issue) and `create-pull-request` (it composes three other
  skills).
- **A link-freshness check is worth considering.** The scan that found the
  `/references/` break took seconds and is deterministic. A warn-only pass
  (bundle-absolute prose links resolve on disk, thread quotes exempt) would fit
  the gate suite's style — warn, never fail, per OKF tolerance. Needs operator
  ratification as a tooling change.

### Tier 3 — explicitly not recommended

- A GitHub wiki (§2). Also **no hand-written architecture overview**: the
  contract + tutorials + flows already cover it, and a standalone overview
  would be a second map that drifts. The README should stay a thin, current
  pointer into the enforced surfaces, not become that overview.

## Outcome (2026-07-12 addendum)

The operator ratified the full Tier-2 list the same day. Shipped in this
branch: the [session-init digest tutorial](/meta/tutorials/the-session-init-digest.md)
and the warn-only docs-freshness pass (`SecondBrain.Links`, printed by
`mix brain.verify`, also surfaced in the session-init digest) — which caught
its first real case (a quoted broken path in this very analysis) during its
own build-out, resolved by teaching it that code spans are literal text. The
third Tier-2 item — flow docs for `/research` and `/create-pull-request` — was
overtaken by a concurrent session that landed a broader
[flows 2→7 set](/meta/flows/index.md) (including
[research-inbox](/meta/flows/research-inbox.md) and
[create-pull-request](/meta/flows/create-pull-request.md)); this branch's
duplicate drafts were dropped at merge in favor of that set, itself an
instance of the very same-matter dedup the audit argues for.

## Verdict

The documentation is in unusually good structural health — every enforced
surface is green and index coverage is effectively total. The weaknesses are
concentrated precisely where no verifier looks: the human-facing README, two
index entries, and one example link. Fix those now (Tier 1); propose the
session-init tutorial, two more flow docs, and a warn-only link check as
follow-ups (Tier 2); and decline the wiki — the Pages site already is one, with
the enforcement stack behind it.
