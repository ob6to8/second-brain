---
type: reference
title: 2026-07-13-glossary-single-overview-dedup-and-check
description: Rewrote all 148 glossary entry bodies to expansion-only under a single canonical overview per term (the description, shown verbatim as the entry lede and the index gloss), built the enforcing mix brain.glossary verifier (materialized index + calibrated containment heuristic), and documented the whole flow in meta/flows/.
provenance: "Claude Code session, 2026-07-13; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, glossary, dedup, verification, flows]
timestamp: 2026-07-13
---

# 2026-07-13-glossary-single-overview-dedup-and-check

## Where this landed

The operator, from two phone screenshots of the published site, asked for one
canonical overview per glossary term (the Terms-list gloss = the entry page's
first paragraph, verbatim) with bodies that only expand, never restate — and
for an *enforceable* check rather than prose guidance. The session shipped all
of it on `claude/glossary-dedup-check-kuvgpg`: a
[plan](/meta/plans/glossary-single-overview-and-dedup-check.md); the
`mix brain.glossary` verifier (`--materialize` regenerates the index `## Terms`
from each term's `description`; a content-word containment heuristic fails
near-restating body sentences at ≥72% and warns at 55–72%); all 148 entry
bodies rewritten to expansion-only via eight parallel subagents plus hand
fixes; the convention codified in the `/add-to-glossary` skill and glossary
hub; wiring into CI, the Pages deploy gate, and the pre-commit hook; 12 new
scenario tests (suite 116 → 128); and a
[flow doc](/meta/flows/glossary-single-overview-check.md) narrating the
pipeline, the calibration stats (88 flagged sentences across ~80 files before;
0 fails, 0 warns after), and the semantic limitations.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Single-overview convention + rewrite of all 148 glossary bodies | closed | [glossary hub](/beliefs/glossary.md) | - |
| The `mix brain.glossary` verifier (materialized index + containment heuristic) | closed | [glossary hub](/beliefs/glossary.md) | - |
| Flow doc for the check (`meta/flows/glossary-single-overview-check.md`) | closed | `unrouted` | - |
| Lineage back-fill of the flow doc (`thread:`/`pr:` after this PR opens) | open | `unrouted` | Set `lineage.thread` + `lineage.pr` in the flow doc and re-run `mix brain.lineage` once the PR number exists |

## User

Rewrite all glossary entries so that the overviews (seen here in the terms section) are the first overview/summary paragraph verbatim from each entry page (also attached). Also, the rest of each entry (ie the paragraphs below) should not repeat aspects that were presented in the first paragraph - only expansion and new information. Let me know if this makes sense

Would there be a way to run an automated check? Obviously this is not deterministically checkable as it relates to subjective semantic meaning, but I'm looking for something more enforceable than prose guidance

*(Two screenshots attached: the published glossary Terms list, and the actor-model entry page showing its stacked near-identical definition paragraphs.)*

## Assistant

Yes, this makes sense — let me restate to confirm, then dig in: the Terms list on the glossary page and the lead paragraph of each entry page should be the *same text* (one canonical overview paragraph per term), and each entry's body below that should only add new material, never re-define the term. The actor-model screenshot shows the current failure mode: the description and the body's first paragraph are two near-identical definitions.

Let me look at how the glossary is stored and rendered before rewriting anything.

The structure is now clear: each entry's `description` frontmatter renders as the lead paragraph on its page, the body follows it (currently often a near-duplicate definition), and the Terms list in `beliefs/glossary/index.md` carries a third, hand-written gloss. Let me check the tooling and site renderer before planning the rewrite and the check.

Confirmed how it renders: the entry page's first paragraph *is* the `description` frontmatter (rendered as a lede by `lib/second_brain/site.ex`), and the Terms list comes from hand-written glosses in `beliefs/glossary/index.md`. So the concrete work is: (1) make each index bullet the entry's `description` verbatim, (2) rewrite each body to drop anything the description already says, (3) build an enforceable check. Let me gather the remaining context — pointer entries, CI/pre-commit wiring, and the add-to-glossary skill.

I have the full picture now. Plan: (1) persist a plan doc, (2) build a `mix brain.glossary` verifier with a `--materialize` mode that regenerates the index Terms section from each entry's `description` (making the "verbatim" half structural, like `route_tags`), plus a content-word-overlap heuristic that flags body sentences restating the description, (3) rewrite all 148 entry bodies to expansion-only, (4) wire the check into CI and the deploy gate, codify the convention in the `/add-to-glossary` skill, run all gates, and push.

Let me set up the branch and look at a few more entry shapes to calibrate the rewrite.

All the tooling and wiring is in place; the eight body-rewrite agents are still working through the 148 entries. I'll pick this up as they finish — remaining steps are: verify their edits with the new checker, materialize the index, run the full gate suite, and push.

## Assistant

Four of eight batches complete. Still waiting on the remaining four rewrite agents before running the verifier and committing the content pass.

## Assistant

<routes ref="sb:0b648f lib/second_brain/glossary.ex">

Done — all pushed to `claude/glossary-dedup-check-kuvgpg` (three commits, no PR opened since you didn't ask for one).

**Yes, the request made sense**, with one clarification of how your site actually renders: the entry page's first paragraph *is* the `description` frontmatter (the site renders it as a lede), while the Terms list came from a third, hand-written paraphrase in `beliefs/glossary/index.md`. So "first paragraph verbatim in the Terms list" means: the `description` is now the single canonical overview, and the index gloss is derived from it rather than written by hand.

**What changed:**
- **All 148 entry bodies rewritten to expansion-only.** Anything the description already said was cut (your actor-model screenshot's stacked second definition is gone — its body is now just the write-governance idiom and the BEAM note); links that lived in removed sentences were rewoven, and a body with nothing genuinely new to add is now empty rather than padded. Descriptions, *Seen in:*/*See also:* lines, and the generated route-tag excerpt logs were left untouched.
- **The index Terms section is now a generated artifact**: one bullet per term, title-sorted, gloss = description verbatim (this also fixed pre-existing ordering drift like `webhook` sorting before `verification grounding`).

**The automated check** — your instinct about enforceability was right, and the trick is splitting it by what has a mechanical oracle, the same pattern as `mix brain.route_tags`:

1. **The verbatim half is fully deterministic.** `mix brain.glossary --materialize` regenerates the Terms section from the term files; the plain check fails if the committed index diverges from that re-derivation (or if any entry lacks a description). Sync stops being discipline and becomes structure.
2. **The no-repetition half gets a calibrated heuristic with a fail/warn split.** For each body sentence (citations and generated sections excluded): lowercase, strip punctuation and link URLs, drop stopwords, naive plural stemming, then measure what fraction of the sentence's content words appear in the description. ≥72% containment **fails** — that's a near-restatement; 55–72% **warns** without failing, leaving genuine judgment editorial. Calibration bears it out: the pre-rewrite corpus trips 88 failing sentences across ~80 files, and the rewritten corpus passes with zero failures *and* zero warnings, so there's real separation between restatement and legitimate expansion prose.
3. **Honest limit:** a restatement that shares meaning but little vocabulary will slip past — semantic equivalence has no offline oracle here. What the check makes impossible is the failure mode you actually had: re-defining the term in nearby words. That's documented in the plan doc (`meta/plans/glossary-single-overview-and-dedup-check.md`).

The check is wired into CI, the Pages deploy gate, and the pre-commit hook; the authoring convention is codified in the `/add-to-glossary` skill (which now runs `--materialize` as part of its verify step). 12 new tests cover it; the full gate suite is green (128 tests, verify, route_tags, contract/registry/lineage checks, site build).

One judgment call to flag for your review: several entries (`embeddings`, `cron-expression`, `digest`, `deploy-gating`, a few others) now have very thin or empty bodies because their description genuinely said everything — I chose honest emptiness over filler, per the convention.

</routes>

## User

Create a flow that documents this deduplication and Automatic check. include links to this thread's name, which will need to be retroactively applied after the create pull request skill is run. Include Link to the plan outline both the verbatim half's deterministic flow as well as the no repetition half with the calibrated heuristic. describe the process progressively that the system undergoes to engage this check and also improve the stats that you mentioned regarding improvements that were notes here as a result of implementation. Also also note semantic limitations.

## Assistant

<routes ref="sb:0b648f meta/flows/glossary-single-overview-check.md">

The flow doc is written, wired in, and pushed (`b5334bd`): [`meta/flows/glossary-single-overview-check.md`](/meta/flows/glossary-single-overview-check.md), registered in the flows index with the lineage views rematerialized, full gate suite green (128 tests, all verifiers, site builds).

How it covers each of your asks:

- **Thread link, retroactively applied** — the doc's `lineage:` frontmatter carries the plan hop now, and a visible **"Pending back-fill"** note right under the generated lineage blockquote states that `lineage.thread` (and `lineage.pr`) must be set after `/create-pull-request` runs `/capture` — the thread doc's name doesn't exist until then — followed by a `mix brain.lineage` re-run and removal of the note. So the instruction to back-fill travels with the doc itself, not just this conversation.
- **Plan link** — the lineage blockquote and the "artifacts" table both point at `meta/plans/glossary-single-overview-and-dedup-check.md`.
- **Both halves outlined** — §3 gives the **verbatim half** (index `## Terms` as a materialized artifact, checked by re-derive-and-compare, same discipline as `CLAUDE.md`/the registry) and the **no-repetition half** as a numbered 4-step heuristic: extract definition prose (excerpt logs and citation lines exempt) → sentence split with an 8-content-word floor → normalize (lowercase, punctuation, stopwords, plural stemming) → containment scored against the description, ≥72% fails, 55–72% warns.
- **Progressive engagement** — §2 is an ASCII pipeline walking authoring time → the three checks in order → the three enforcement surfaces (pre-commit blocks the commit, CI fails the PR, the Pages gate keeps a drifted glossary from ever rendering live).
- **The improvement stats** — §6 records the worked calibration: 88 failing sentences across ~80 of 148 files before the rewrite; all 148 bodies rewritten and the index's hand-kept ordering drift fixed; 0 failures *and* 0 warnings after (with a note on why a clean warn channel matters); 12 new scenario tests taking the suite 116 → 128.
- **Semantic limitations** — §7 names four honestly: paraphrase evades vocabulary containment; vocabulary-dense legitimate expansion can false-positive into the warn band (which is why it warns, not fails); "repeated aspects" is broader than the per-sentence unit the check measures; and sub-8-content-word sentences go unmeasured by design.

One heads-up for when you run `/create-pull-request`: the back-fill is a two-line frontmatter edit in this flow doc plus `mix brain.lineage` — if the skill run doesn't do it automatically (it currently only back-links elaboration docs), the pending note in the doc will keep it from being forgotten.

</routes>
