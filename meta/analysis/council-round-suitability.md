---
type: analysis
title: "Should the council-round protocol be integrated into this repo? Yes — as a skill, after four bindings"
description: An adversarial multi-agent PR-review protocol ("council round") is evaluated against the bundle's operating contract; verdict is integrate-as-skill — it fills the undefined drafted→merged gate and leans on machinery this repo already has (true-merge provenance, persist-plans, distill-don't-dump) — but its no-transcripts rule collides with session-capture and four bindings must be ratified first.
provenance: "Claude Code session (Claude Fable), 2026-07-13 — operator pasted the council-round prompt and asked for a suitability evaluation against this repo; evaluated against the live policy set under meta/policy/ and the existing skills"
tags: [meta, analysis, council, review, adversarial, pr-workflow, skills, governance, provenance]
timestamp: 2026-07-13
attribution:
  when: 2026-07-13T20:16:15+00:00
  channel: agent-authored
  agent: "Claude Code agent, operator-commissioned suitability evaluation"
  why: "operator pasted the council-round protocol and asked for a suitability evaluation against this repo's operating contract"
  from: [/meta/threads/2026-07-13-council-round-suitability-evaluation.md]
---

# Should the council-round protocol be integrated into this repo?

**Question.** The operator supplied a prompt defining a **council round**: a
structured, adversarial, multi-agent review of drafted work, run as comments on
a draft PR, driven through four motions (open → review → respond → close), gated
on every finding having a disposition, and distilled into a curated document.
Is it suitable for integration into this bundle, and in what form?

**Bottom line.** Yes — integrate it, as a skill (`/council`) plus a
skills-registry policy edit, after operator ratification. The protocol is
unusually well matched to this bundle: its distillation rule is a restatement of
[distill-don't-dump](/meta/policy/distill-dont-dump.md), its hand-off artifact is
exactly a [persisted plan](/meta/policy/persist-plans.md), and its
cite-by-SHA provenance rule *depends on* the
[merge-strategy policy](/meta/policy/merge-strategy.md) this repo already
enforces structurally. It also fills a real gap: the bundle currently has no
defined gate between *drafted* and *merged* — PRs land on operator say-so with
no structured review record. But it cannot be adopted verbatim: its
"transcripts are never committed" rule collides head-on with the
[session-capture policy](/meta/policy/session-capture.md), and three other
seams need explicit bindings. All four are enumerated below.

## What the protocol is (distilled)

A council round runs at the gate between work committed to a branch and work
merged. Its load-bearing rules:

1. **The medium is a draft PR; reviews are comments, never committed files.**
   Only the distilled plan and the code land in the tree.
2. **The durable record is distilled, not dumped** — settled decisions go into
   a curated *distillation target*; rejected alternatives fold into a dated
   "rejected: X because Y" block there; the raw exchange is cited by PR link
   and commit SHA only.
3. **Close is a gate** — the round cannot converge while any finding lacks a
   disposition (agree / refute-with-evidence / defer-with-destination).

Four motions: **open** (ensure a draft PR; dispatch adversarial reviewer
subagents; post findings as ID-prefixed review comments), **review** (one fresh
context-free reviewer makes an independent pass), **respond** (the author
replies to every finding thread with exactly one disposition), **close**
(verify every finding is dispositioned — refuse to close otherwise — then
distill into the target, post a tally comment, hand the plan to the
implementer). The PR is the shared state, so independent sessions can resume at
any motion. Hand-run rounds must be labelled as such. The full evaluated text is
in the appendix.

## Where it aligns (strong)

- **Distillation rule ≙ existing policy.** Ground rule 2 is
  [distill-don't-dump](/meta/policy/distill-dont-dump.md) applied to review
  exchanges, and "the distilled plan — not this conversation — is what the
  implementer receives" is the exact motivation of
  [persist-plans](/meta/policy/persist-plans.md). The protocol's "rejected: X
  because Y" block is a natural sibling of that policy's explicit-deferred
  heading — decision history as the point.
- **Its provenance model requires machinery this repo already has.** Citing the
  raw exchange "by PR link and commit SHA only" is safe *only* where cited SHAs
  stay reachable after branch deletion — which is precisely what the
  [true-merge policy](/meta/policy/merge-strategy.md) guarantees, and which the
  operator has since enforced structurally by disabling squash/rebase in the
  repo settings. The council round is arguably the first workflow that
  *consumes* that guarantee rather than merely preserving it.
- **The close gate matches the verifier culture.** The bundle's signature move
  is converting rules from advisory to structural (`mix brain.verify`,
  `mix brain.route_tags` failing on divergence). The disposition gate is the
  same move, and — unlike route-tag *coverage*, which has no mechanical
  oracle — it is mechanizable: finding IDs are enumerable and "every finding
  thread has exactly one disposition reply" is checkable. A future
  `mix brain.council` verifier is a natural extension, though not required for
  a hand-run v1.
- **Resume-from-the-PR suits this environment.** Sessions here are ephemeral
  remote containers; a protocol whose shared state is the PR itself (any
  session can pick up at whichever motion the round has reached) is a better
  fit than one whose state lives in a conversation.
- **Mechanically feasible today.** The GitHub MCP toolset in these sessions
  supports draft PRs, pending reviews with line-anchored comments, and
  threaded replies; the Agent tool supplies independent context-free reviewer
  subagents. Nothing new needs building.
- **No type-vocabulary pressure.** The round's outputs map onto existing types:
  the distillation target is a `plan` (or updates one), deferrals file as
  `issue` or `todo`. No new type, hence no vocabulary ratification.

## Where it collides, and the required bindings

**Binding 1 — the no-transcripts rule vs. session-capture (the deep one).**
The protocol's provenance section says "session notes, transcripts, and review
dumps do not get committed." This bundle's
[session-capture policy](/meta/policy/session-capture.md) says the opposite:
substantive sessions are frozen verbatim into thread docs under
`meta/threads/`, and the sanctioned PR path —
[`/create-pull-request`](/.claude/skills/create-pull-request/SKILL.md) — runs
`/capture` *unconditionally* before committing. A council round run inside a
session that later ships via that skill would have its exchange frozen into a
thread doc, which the protocol forbids. The collision is smaller than it looks:
thread docs are noise-stripped distilled records, not dumps, and subagent
findings arrive as tool results, which `/capture` drops anyway — only the main
session's narration around the round would be captured. The right
reconciliation is to amend the council rule at adoption, not the capture
policy: read "no transcripts" as "no *review dumps as pseudo-plans*" — the
failure it actually targets — and let thread docs remain first-class. The
routing ledger then points the round's strand at the distillation target, which
is exactly the router-not-digest discipline the
[routing-ledger policy](/meta/policy/routing-ledger.md) already imposes.

**Binding 2 — the distillation target must be bound to this tree.** The prompt
leaves it `<FILL IN>`. Here it should default to a `type: plan` doc under
[`meta/plans/`](/meta/plans/index.md) (created or updated by the close motion,
with the dated rejected-alternatives block), with deferrals filed under
[`meta/issues/`](/meta/issues/index.md) or `meta/todos/` per their types. Note
the protocol's "only the distilled plan and the code land in the tree" must be
read as "no *round* artifacts beyond those" — filing the plan still triggers
the ordinary [reserved-file upkeep](/meta/policy/maintain-reserved-files.md)
(`index.md`, `log.md`), which is filing overhead, not a round artifact.

**Binding 3 — relationship to the existing PR machinery.** The open motion
creates a *draft* PR before any capture, while `/create-pull-request` is
currently the one sanctioned no-further-ask path to a PR. The skill needs the
same authorization clause ("invoking `/council` is the authorization to open
the draft PR / post the review comments") and a stated hand-off: the council
chamber PR is the same PR that later ships — close the round, then run the
ordinary ship path (capture, glossary, mark ready), then merge with a true
merge. Separately, `/council` must be positioned against the built-in
`/code-review` and `/review` to avoid skill sprawl: council is the heavy,
converging gate for *shape-of-brain* changes (policy edits, new machinery,
plans, genre changes); routine content diffs keep the lightweight reviews.

**Binding 4 — ratification path.** Integration means a new
`.claude/skills/council/SKILL.md`, an edit to
[skills-registry](/meta/policy/skills-registry.md), possibly a short
`type: policy` doc for the round's ground rules, and a `/render-contract`
recompile. Policy edits change the contract — the operator ratifies before the
skill exists, per the same propose-and-ratify posture as the
[taxonomy-evolution protocol](/meta/policy/taxonomy-evolution-protocol.md).
This analysis is the proposal's evidence base, not its ratification.

## Verdict

**Integrate, as a skill, after the four bindings are ratified.** The protocol
is not merely compatible with this bundle — it composes with it: the
merge-strategy policy supplies the reachability its citations need, persist-plans
supplies its hand-off artifact, and the verifier culture gives its close gate a
credible path to mechanical enforcement. The one genuine conflict (Binding 1)
resolves in the bundle's favour by narrowing the protocol's no-transcripts rule
rather than weakening session capture. The prompt itself is well-formed for the
skills genre — trigger, ordered motions, an explicit gate, honesty guardrails
("do not manufacture receipts") that match this repo's norms — and would need
only the bindings above written into it, not restructuring.

Suggested build order if ratified: (1) write the SKILL.md with the four
bindings baked in; (2) skills-registry edit + `/render-contract`; (3) run one
hand-run round, labelled as such, on a real branch as the founding example;
(4) only then consider `mix brain.council` for the disposition gate.

## Appendix — the evaluated prompt (verbatim)

Preserved as the evaluand; provenance: pasted by the operator in this session,
2026-07-13.

> # Council: an adversarial review round on a draft PR
>
> You are running a **council round**: a structured, adversarial, multi-agent
> review of drafted work, driven to convergence and distilled into a plan.
> The round runs at the gate between *work drafted* (committed to a branch,
> not yet merged) and *work merged*.
>
> **Distillation target:** \<FILL IN — the document that receives the round's
> settled outcome: a design doc, ADR, issue, or plan file. The target is a
> curated document, not a transcript.\>
>
> ## Ground rules (load-bearing — do not weaken these)
>
> 1. **The medium is a draft PR; reviews are comments, never committed files.**
>    All findings, responses, and dispositions live as PR review comments.
>    The only artifacts that ever land in the tree are the distilled plan and
>    the code itself. Never run a round against main, and never replay a round
>    that already happened elsewhere.
> 2. **The durable record is distilled, not dumped.** Settled decisions are
>    written into the distillation target; rejected alternatives fold into a
>    dated "rejected: X because Y" block in that same document; the raw
>    exchange stays referenced by commit SHA / PR link and is never copied
>    into the document.
> 3. **Close is a gate, not a dump.** The round cannot converge while any
>    finding lacks a disposition. Silent omission is the failure mode the
>    review exists to catch — never commit it yourself.
>
> ## The four motions
>
> Run these in order (or resume at whichever motion the round has reached —
> the PR itself is the shared state, so independent sessions can take turns).
>
> ### 1. open
> - Ensure a **draft PR** exists for the branch under review; create one if
>   needed. This PR is the chamber for the whole round.
> - Dispatch one or more reviewer subagents. Each receives: the full diff,
>   and this fixed adversarial brief:
>   > You are an adversarial reviewer. Your job is to find what is wrong,
>   > missing, unjustified, or fragile in this change — correctness bugs,
>   > unstated assumptions, design flaws, gaps between the stated intent and
>   > the code. Do not praise. Do not soften. Return a structured findings
>   > report: each finding gets an ID (F1, F2, ...), a severity, the file/line
>   > it anchors to, and a concrete failure scenario or reasoned objection.
> - Post each reviewer's findings as PR review comments (line-anchored where
>   possible, top-level otherwise), prefixed with their finding IDs.
>
> ### 2. review
> - A fresh reviewer (new subagent, no context from motion 1) makes one
>   independent pass over the diff with the same adversarial brief, and posts
>   its findings the same way, continuing the finding-ID sequence.
>
> ### 3. respond
> - Acting as the author, read every open finding and reply to each — in the
>   finding's own comment thread — with exactly one disposition:
>   - **agree** — the finding stands; state what will change.
>   - **refute** — the finding is wrong; give evidence (code, tests, docs),
>     not assertion.
>   - **defer** — real but out of scope for this round; state where it goes
>     (issue, follow-up plan) and file it there.
> - Nothing is silently dropped. Every finding gets a reply.
>
> ### 4. close
> - **The gate:** enumerate every finding from motions 1–2 and verify each
>   has a disposition (agree / refute-with-evidence / defer-with-destination).
>   If any finding is undispositioned, **refuse to close** — report which
>   findings are open and stop. Do not summarize around them.
> - Once the gate passes, distill:
>   - Settled decisions (agreed findings and their resolutions) become
>     concrete items in the distillation target.
>   - Rejected alternatives become a dated "rejected: X because Y" block in
>     the same document.
>   - Cite the raw exchange by PR link and commit SHA only. Do not paste the
>     transcript.
> - Post a closing PR comment: the disposition tally (N agreed / N refuted /
>   N deferred), a link to the updated distillation target, and the statement
>   that the round is converged.
> - Hand off: the distilled plan — not this conversation — is what the
>   implementer receives.
>
> ## Provenance
> - A council round is a dev-dev exchange: it leaves no artifact in the tree
>   beyond the distilled plan and the code. Session notes, transcripts, and
>   review dumps do not get committed.
> - If this round is being run by hand (no tooling support yet), label it as
>   hand-run in the closing comment. A hand-run round is a legitimate founding
>   example only when labelled as such — do not manufacture receipts for
>   machinery that was not in force.
