<!--
  GENERATED FILE — do not edit by hand.
  Source of truth: meta/preamble.md + meta/policy/*.md
  Regenerate:      mix brain.contract
  Verify (CI):     mix brain.contract --check
-->

# Operating Contract — Second Brain (OKF)

This repository is a personal **second brain** stored as an
[Open Knowledge Format](/knowledge-management/open-knowledge-format.md)
(**OKF v0.1**) bundle. Every agent that operates here — including fresh, sandboxed
agents spun up from the Claude Code app — MUST read and follow this contract. It is
the backbone that keeps the brain consistent as it grows.

The operator is the human. The agent files and organizes;
the operator ratifies changes to the *shape* of the brain.
The contract binds agents, not the operator: its rules are obligations on agent
behavior, which the operator authors and ratifies but is never subject to.

> **This file is a generated artifact.** It is compiled from
> [`meta/preamble.md`](/meta/preamble.md) and the `type: policy` documents under
> [`meta/policy/`](/meta/policy/index.md). Do **not** edit it by hand — edit the
> source policies and run `mix brain.contract` (see the `/render-contract` skill).

---

## 1. What the brain is made of

- **The repo root is the OKF bundle.** Concepts live at the root and in
  subdirectories. `.claude/` (skills), `meta/` (governance), the Elixir tooling
  (`mix.exs`, `lib/`, `test/`), and `deprecated/` (archived legacy content,
  read-only) sit alongside but are **not** part of the knowledge bundle.
- **A concept** is a single UTF-8 markdown file with two parts:
  1. **YAML frontmatter** (required), delimited by `---`.
  2. **Markdown body** (distilled prose; no required sections).
- **Concept ID** = file path minus `.md` (e.g. `areas/health.md` → `areas/health`).

_Source: [`meta/policy/concept-anatomy.md`](/meta/policy/concept-anatomy.md)_

Frontmatter fields:

| Field | Requirement | Notes |
|-------|-------------|-------|
| `id` | **Mandatory** (bundle concepts) | Stable opaque identifier, `sb:` + 6 hex chars. Immutable once minted (`mix brain.id`); see the identity-and-verification section. |
| `type` | **Mandatory** | From the controlled vocabulary (see the type-vocabulary section). Non-empty. |
| `title` | Strongly recommended | Human-readable display name. |
| `description` | Strongly recommended | Single-sentence summary. |
| `resource` | When applicable | URI uniquely identifying the underlying/source asset (e.g. the original URL). |
| `provenance` | When applicable | Where the content came from (e.g. "Claude Opus 4.8, chat thread"). Distinct from `resource`: this is the *origin of the statement*, not a canonical asset URI. |
| `verified` | Only on agent statements | Boolean, and **only for agent-authored statements** (`claim`/`note`/`concept`). `false` = asserted but not checked; `true` = checked and backed by a non-empty `verified_by`. **Omit** on captures — a concept that stores a link (`resource`) is not verifiable. Default `false` for AI-generated statements. |
| `verified_by` | When verified via evidence | Inline YAML list of stable ids (typically `source` captures) that jointly support this statement; targets must **exist** (they need not themselves be `verified`). The only committed representation of evidence edges. |
| `tags` | Recommended | YAML list of categorization strings. |
| `timestamp` | Recommended | ISO 8601 datetime of last meaningful change. |

Arbitrary extra keys are allowed and must be preserved.

_Source: [`meta/policy/frontmatter-schema.md`](/meta/policy/frontmatter-schema.md)_

Reserved filenames (any directory level):

- **`index.md`** — directory listing for progressive disclosure. Markdown sections
  with bulleted links + one-line descriptions. **No frontmatter** — except the
  bundle-root `index.md`, which carries only `okf_version: "0.1"`.
- **`log.md`** — chronological change history, ISO 8601 date headings, newest first.

_Source: [`meta/policy/reserved-filenames.md`](/meta/policy/reserved-filenames.md)_

---

## 2. Directory structure — unix-like, domain-agnostic, evolving

- Organize concepts into a **unix-like hierarchy**: lowercase, kebab-case directory
  names (short, established acronyms like `SWE` may stay uppercase); each directory
  holds a coherent set of related concepts.
- **Create the natural directory path even for a single concept.** Do not flatten to
  avoid nesting — a lone note about git belongs in `SWE/version-control/git/`, not
  dumped at the root. Depth that mirrors the real structure of the knowledge is good.

_Source: [`meta/policy/directory-hierarchy.md`](/meta/policy/directory-hierarchy.md)_

- **The tree *is* the taxonomy.** The directory hierarchy — surfaced through `index.md`
  files at every level (progressive disclosure, rooted at `/index.md`) — is the
  canonical taxonomy. Keep those `index.md` files current; do not maintain a separate
  map that drifts.
- **Policy vs. instance.** `CLAUDE.md` holds the *policy* (this contract — the `type`
  vocabulary and frontmatter schema), compiled from `meta/policy/`. The tree holds the
  *instance*. Governance (`meta/`) is a separate namespace from the knowledge taxonomy.
- The taxonomy is **not fixed**. It **emerges bottom-up** and evolves
  **collaboratively**. There is no pre-imposed schema to satisfy.

_Source: [`meta/policy/tree-is-the-taxonomy.md`](/meta/policy/tree-is-the-taxonomy.md)_

The taxonomy-evolution protocol (important):

- Filing a concept into an **existing** directory, or creating **subdirectories
  under an already-established top-level domain**, → the agent does this
  **autonomously** (create the path and each new directory's `index.md`).
- Creating a **new top-level directory** (or renaming/moving/merging directories) is
  a change to the *shape* of the brain → the agent **proposes it and waits for the
  operator to ratify** before creating it. Explain the proposed name, where it
  sits, and why the existing tree doesn't fit.
- On creation, add each new directory's `index.md`, record it in the nearest
  `log.md`, and list new top-level dirs in the root `index.md`.

_Source: [`meta/policy/taxonomy-evolution-protocol.md`](/meta/policy/taxonomy-evolution-protocol.md)_

---

## 3. Filing conventions

**Distill, don't dump.** Capture the *knowledge*, not the raw noise. A concept has
a clear title, a one-sentence `description`, and a clean body. Keep the original
material as a `resource` URI and/or under a `# Citations` section — not as the
whole document.

_Source: [`meta/policy/distill-dont-dump.md`](/meta/policy/distill-dont-dump.md)_

**Update in place; don't fragment.** Before creating a file, **search the bundle**
for an existing concept on the same subject. If one exists, update it (merge new
info, bump `timestamp`, add a `log.md` entry) instead of creating a near-duplicate.

_Source: [`meta/policy/update-in-place.md`](/meta/policy/update-in-place.md)_

- **Filenames**: kebab-case slug derived from the title
  (`open-knowledge-format.md`). Use a `YYYY-MM-DD-` prefix **only** for inherently
  time-ordered entries (journal/log-style notes); topical concepts stay purely
  topical.
- **Cross-link** related concepts with markdown links. Prefer bundle-absolute paths
  (begin with `/`, e.g. `[OKF](/references/open-knowledge-format.md)`). Links are
  untyped edges; the prose carries the meaning. Broken links are tolerated but avoid
  creating them.

_Source: [`meta/policy/filenames-and-cross-linking.md`](/meta/policy/filenames-and-cross-linking.md)_

- **Links must be processed, not parked.** A web resource enters the brain only once it
  has been **processed into a `reference`** (fetched and summarized/captured). Do not
  file bare, unprocessed URLs as their own concepts — process it now, or don't file it.
  (There is deliberately no lightweight "bookmark" type.)
- **Oversized linked resources**: if a linked source is too large to reasonably copy,
  **write a faithful summary** as the concept body and **persist the link** in the
  `resource` frontmatter field (and/or `# Citations`) so nothing is lost.

_Source: [`meta/policy/link-processing.md`](/meta/policy/link-processing.md)_

**Maintain the reserved files**: after filing, update the directory's `index.md`
(create it if missing) and append a dated entry to `log.md`.

_Source: [`meta/policy/maintain-reserved-files.md`](/meta/policy/maintain-reserved-files.md)_

**Persist plans; don't leave them in the conversation.** A design spec or
implementation plan is a durable record of *decisions and their rationale* — the
shape of a change, the alternatives weighed, and the build order. That record must
survive the session that produced it. Chat scrolls off and the agent scratchpad is
session-isolated and reclaimed, so a plan that lives only there is lost the moment
the session ends.

- **When.** Whenever the operator approves a plan of any substance — a new
  subsystem, a genre or policy change, a multi-step build — persist it before
  acting on it. A throwaway one-liner is not a plan; a design worth a review pass
  is.
- **Where.** As a `type: plan` document under [`meta/plans/`](/meta/plans/index.md)
  (governance namespace — no `sb:` id, outside the identity registry, like
  `tutorials` and `threads`). Filename is a kebab-case slug of the title.
- **What it holds.** The problem, the decisions and their reasoning, the artifact
  shape, and the build order — plus any commissioned design review (e.g. a
  research spike) recorded with its verdict, so the *why-it's-shaped-this-way*
  travels with the plan. Deferred phases (things planned but not yet built) stay in
  the same doc under an explicit "deferred" heading until they graduate into their
  own plan when built.
- **Lifecycle.** A plan carries a `status` (`proposed` · `accepted` · `in-progress`
  · `done` · `superseded`). Done and superseded plans are kept, not deleted — the
  decision history is the point.
- **Reserved files.** After adding or updating a plan, update
  [`meta/plans/index.md`](/meta/plans/index.md) and append a dated entry to the
  nearest `log.md`, same as any filed document.

_Source: [`meta/policy/persist-plans.md`](/meta/policy/persist-plans.md)_

**Merge with a true merge commit; never squash or rebase.** The commit graph is
a **provenance layer**, not an implementation detail: every commit carries the
session trailer linking it to the agent session that produced it, durable docs
(plans, thread docs, logs) cite commits by SHA, and `git blame` is the answer to
"which session changed this and why". A squash-merge lands a brand-new commit
and abandons the originals — severing commit → session traceability and turning
cited SHAs into garbage once the branch is deleted; a rebase-merge rewrites them.
A true merge wires the branch's real history into `main`'s ancestry, so the
cited SHAs stay reachable forever and the branch is safe to delete (see
[why a true merge keeps cited commits reachable](/meta/tutorials/why-a-true-merge-keeps-cited-commits-reachable.md)).

- Agents merging a PR (UI, MCP tools, or API) must use the **merge** method —
  never `squash` or `rebase`, even when they are enabled in repo settings.
- Never rewrite shared history; the usual noise argument for squashing does not
  apply here — agent commits are already atomic and deliberately messaged.
- For a one-line-per-PR reading of `main`, use `git log --first-parent` instead
  of flattening history at the merge boundary.

_Source: [`meta/policy/merge-strategy.md`](/meta/policy/merge-strategy.md)_

---

## 4. Controlled `type` vocabulary

OKF requires a `type` but registers no vocabulary. This bundle uses a **controlled
list** so the brain stays queryable. It **grows deliberately** — an agent may
propose a new type, but the operator ratifies additions (same as directories).

Seed vocabulary:

- `note` — a distilled idea, observation, or thought.
- `claim` — a statement **asserted but not independently verified** (track status with
  the `verified` field; may graduate to `concept` once confirmed).
- `concept` — a definition or mental model (established/accepted).
- `reference` — external material you have **captured and summarized** (article, doc,
  video, thread). A bare URL becomes a `reference` only once processed.
- `source` — a primary source citation (paper, book, dataset).
- `person` — a person.
- `project` — an active, goal-bounded effort.
- `area` — an ongoing responsibility or domain (no end state).
- `snippet` — a reusable command, code fragment, or template.
- `methodology` — a repeatable, prescriptive procedure or playbook: the distilled
  *how-to* for carrying out a recurring task (distinct from a `note`, which merely
  records an idea, and a `concept`, which defines a mental model).
- `policy` — a governance rule for how the brain operates; the source from which
  `CLAUDE.md` is compiled (lives under `meta/policy/`).
- `tutorial` — a long-form explanatory note meant to be read start to finish (the
  "why"/"how" behind the tooling or a topic); distinct from a terse `note` and from
  a `reference` capture of external material (lives under `meta/tutorials/`).
- `issue` — a tracked operational problem, defect, or open concern about how the
  brain or its tooling/automation behaves, recorded for future reference and
  follow-up. Carries a `status` (`open`/`resolved`/`wontfix`); distinct from a
  `policy` (a rule) and a `note` (a distilled idea) — an issue is a *problem to
  track* (lives under `meta/issues/`).
- `plan` — intended work on the brain or its tooling: a design/decision record for a
  proposed change, capturing motivation, the shape of the change, scope boundaries,
  and open questions, so a future session can execute it. Carries a `status`
  (`proposed`/`accepted`/`in-progress`/`done`/`superseded`); distinct from an `issue`
  (a *problem* to track) and a `methodology` (a *repeatable* how-to) — a plan is a
  *one-off intended change* (lives under `meta/plans/`).
- `analysis` — a point-in-time evaluation or decision-support write-up: a question
  investigated against evidence (often the live bundle itself), yielding findings and
  a recommendation, filed so the reasoning and its conclusion persist. Distinct from a
  `plan` (intended *work* to execute), a `tutorial` (explanatory *how/why*), and a
  `note` (a distilled idea) — an analysis is a *reasoned judgment on a question*
  (lives under `meta/analysis/`).
- `todo` — a lightweight actionable task item: a single thing to be done, tracked
  until it is finished. Carries a `status` (`open`/`done`/`cancelled`). Distinct from
  an `issue` (a *problem* to diagnose and track), a `plan` (a *design/decision
  record*), and a `methodology` (a *repeatable* how-to) — a todo is a plain *task to
  complete*, added and listed with the `/todo` skill (lives under `meta/todos/`).

If nothing fits, propose a new type rather than forcing a bad one.

_Source: [`meta/policy/controlled-type-vocabulary.md`](/meta/policy/controlled-type-vocabulary.md)_

---

## 5. Identity & verification

- **Every bundle concept carries a stable `id`** in frontmatter: `sb:` + 6 lowercase
  hex chars (e.g. `sb:4c9e1f`). Ids are **opaque and immutable** — minted once
  (`mix brain.id`), never changed, and never reused, even if the file moves, is
  renamed, or is superseded. Identity survives refactors; paths don't have to.
- **Typed edges reference ids, not paths.** Structured frontmatter references
  (`verified_by`, and future typed edges) point at stable ids as an inline YAML list.
  Prose links in bodies still use ordinary markdown paths.
- **The per-file `id` is canonical; the registry is compiled.**
  [`meta/registry.md`](/meta/registry.md) — the id → path view — is a generated
  artifact (`mix brain.registry`, checked in CI with `--check`), exactly like
  `CLAUDE.md`. Never hand-edit it.

_Source: [`meta/policy/stable-identity.md`](/meta/policy/stable-identity.md)_

- **Provenance and verification are orthogonal.** `provenance` records where a
  statement came from and is **immutable history** — verifying a statement never
  rewrites its provenance.
- **Verification is only for agent-authored statements.** `verified: true` applies
  to a statement the agent distilled from a thread (a `claim`, `note`, or `concept`)
  and asserts it has been **checked against evidence**. A concept that stores a
  link — anything carrying a `resource` — is a **capture**, not a statement:
  verification is **not possible** for it, so a capture never carries `verified`
  (omit the field). `mix brain.verify` rejects `verified: true` on any concept that
  has a `resource`.
- **`verified: true` requires evidence, never its own link.** A verified statement
  must carry a non-empty `verified_by` pointing at the captures (and/or other
  statements) that support it. Storing a `resource` on the statement itself proves
  nothing and is disallowed. `mix brain.verify` enforces both halves.
- **Evidence edges live in `verified_by` only** — an inline list of stable ids whose
  targets must **exist**. Targets are typically `source` captures, which are *not*
  themselves `verified` — they are trusted evidence, not verified statements. Do not
  duplicate the edge list in prose: the verification narrative is **derived on
  demand** (`mix brain.evidence <id>`), never committed, so there is exactly one
  source of truth for what supports a statement.
- **Verify technical claims from primary sources.** Extract the supporting passages
  from authoritative documentation into `type: source` captures (verbatim quotes;
  `resource` = the official URL; provenance = extracted from that resource). The
  capture stores the link and text but is **not** marked `verified`. Aggregate the
  captures via `verified_by` on the claim, which flips the **claim** to
  `verified: true`. A `claim` grounded this way may graduate to `concept`.

_Source: [`meta/policy/verification-grounding.md`](/meta/policy/verification-grounding.md)_

---

## 6. Conformance (keep the bundle valid)

A bundle conforms to OKF v0.1 when:

1. Every non-reserved `.md` file has parseable YAML frontmatter.
2. Every frontmatter block has a non-empty `type`.
3. Reserved files (`index.md`, `log.md`) follow their structures when present.

Be a tolerant **consumer**: never reject the bundle for missing optional fields,
unknown types, extra frontmatter keys, broken links, or absent `index.md` files.

_Source: [`meta/policy/okf-conformance.md`](/meta/policy/okf-conformance.md)_

---

## 7. Skills

- **`/intake`** — process pasted content into one or more filed concepts. See
  `.claude/skills/intake/SKILL.md`. This is the primary way knowledge enters the
  brain.
- **`/render-contract`** — recompile `CLAUDE.md` from `meta/policy/*.md` after editing
  any policy. See `.claude/skills/render-contract/SKILL.md`. `CLAUDE.md` is a
  generated artifact — never hand-edit it.
- **`/capture`** — persist the current session as a **distilled** thread doc under
  `meta/threads/`: substantive exchanges only (tool calls, reasoning, and short
  pre-tool narration stripped), then a routing ledger and route tags over the frozen
  body. This is the session-persistence skill. See `.claude/skills/capture/SKILL.md`.
- **`/summarize-technical`** — produce a three-part layered breakdown of a technical
  paper/article/spec: a plain-language summary, a glossary of its key technical terms,
  then an integrated technical summary reusing those terms. See
  `.claude/skills/summarize-technical/SKILL.md`.
- **`/add-to-glossary`** — scan a persisted thread (`meta/threads/`), a paper, a post,
  or a filed concept; extract the technical terms it actually uses; and merge distilled
  definitions into the glossary — **one concept file per term** under
  [`/glossary/`](/glossary/index.md) (hub: [`/glossary.md`](/glossary.md)), each with
  its own `sb:` id and *Seen in:* citations, so any response or concept can cite a
  term by link (pointer entries defer to filed concepts instead of duplicating them).
  Also invoked automatically by `/create-pull-request` on the thread doc its
  `/capture` step writes. See `.claude/skills/add-to-glossary/SKILL.md`.
- **`/news`** — generate today's **inbox**: a daily candidate feed of news, articles,
  papers, and resources matched against the brain's taxonomy, grouped by category and
  reason-tagged (`recent`/`impactful`/`influential`/`groundbreaking`/`buzz`). Writes to
  the non-bundle `inbox/` namespace (candidates, no `sb:` ids); hand off to `/intake` to
  file one into the brain. See `.claude/skills/news/SKILL.md`.
- **`/create-pull-request`** — run `/capture` to completion, run `/add-to-glossary`
  over the captured thread doc, then commit the current working changes, push the
  branch, and open a pull request — so the frozen thread doc and the glossary updates
  it feeds ship in the same PR. Invoking the skill **is** the authorization to open the PR
  (no separate confirmation gate); PR-template detection and the GitHub MCP tools
  handle the rest. See `.claude/skills/create-pull-request/SKILL.md`.
- **`/todo`** — add and list `type: todo` task items under `meta/todos/`. Dispatches on
  a subcommand argument: `/todo create <title>` files a new open todo (and maintains
  the index + `log.md`); `/todo list` shows the todos grouped by `status`. See
  `.claude/skills/todo/SKILL.md`.

New skills are added under `.claude/skills/<name>/SKILL.md`.

_Source: [`meta/policy/skills-registry.md`](/meta/policy/skills-registry.md)_

---

## 8. Session capture, routing & route tags

A working session (a **thread**) is non-linear: it touches many matters, pauses
some on open questions, and routes each matter's synthesized content into a
durable per-topic page. **`/capture`** freezes that session into a readable
record so it can be resumed from the record instead of from memory.

- **On demand, not a hook.** Capture is an agent-invoked skill you run once, at
  session close (or when you say "capture this") — never a per-turn hook. See
  `.claude/skills/capture/SKILL.md`.
- **Retained text is verbatim; only the noise is stripped.** Keep **every
  exchange** and drop *only*: tool calls and results; reasoning/thinking; and an
  assistant text block that is *both* under ~300 chars *and* followed by a tool
  call (short pre-tool narration). **Everything kept is reproduced verbatim** —
  the delivered text of each operator message and agent response, never summarized
  or paraphrased. Everything else is kept — any longer block, any block *in
  isolation* (nothing after it in the turn calls a tool: a closing reply or
  standalone remark) **even when short**, and all text in a tool-less turn.
  Operator messages are kept as said, minus empty ones and `<…>`-prefixed
  system/slash wrappers. The drop rule is exactly cb `transcript_hook.py`'s
  `len < 300 and followed_by_tool`. "Distilled" here means the *noise* is dropped,
  not that the kept text is condensed; `/capture` strips noise, not substance, and
  is the sole session-persistence skill.
- **The output is a thread doc** at `meta/threads/YYYY-MM-DD-<slug>.md`,
  `type: reference`, in the governance namespace (no `sb:` id). It carries, in
  order: frontmatter, a short narrative section (what the session was, where it
  landed), the **routing ledger** (`## Routing`), then the `## User`/`##
  Assistant` render body. Route tags are applied last, over the now-frozen body.
- **Freeze then tag.** Because capture runs once at close, the body is frozen
  when written; tagging and ledger upkeep are one finalization motion over that
  frozen body, not a per-turn rewrite.

_Source: [`meta/policy/session-capture.md`](/meta/policy/session-capture.md)_

Every captured thread carries a **`## Routing`** section: a per-thread dispatch
table with one row per topic the session touched. It is a **router, never a
digest** — it answers exactly one question: *what would I need to know to reply
to this thread without re-reading it?*

Four columns:

| Column | Holds |
|--------|-------|
| **Topic** | what the strand is about, one line |
| **State** | `open` (live) · `paused` (waiting on a dangling question) · `closed` (resolved; nothing further expected) |
| **Routed to** | a markdown link to the `concept` doc that absorbed the strand's content, or `unrouted` |
| **Dangling** | the open question, when `open`/`paused` (else `-`) |

- **Pointers and states only — never content.** Synthesized content lands in the
  routed-to `concept` doc; if it also lived in the ledger the ledger would become
  a stale shadow copy of that doc. State (the strand) and routed-to (the
  dispatch) are orthogonal: a strand can be routed yet still `open`, or `closed`
  and `unrouted`.
- **Routed-to targets are `concept` docs**, linked by bundle-absolute path
  (e.g. `[foo](/SWE/…/foo.md)`). The route-tagging cross-check reads this column
  to confirm every concept-routed row is covered by a tag (see the route-tagging
  policy).
- **In-doc, maintained at capture time.** The ledger is a section of the thread
  doc itself (not a sibling file), written and updated by `/capture` in the same
  motion that routes content — routing and ledger update are one act, not a
  regeneration step that can be forgotten.

_Source: [`meta/policy/routing-ledger.md`](/meta/policy/routing-ledger.md)_

Mark each region of a finalized thread body with the concept(s) its content
feeds, so a matter's cross-thread discussion aggregates into one place. The tag
is an inline `<routes ref="...">` region, applied over the **frozen** body as
the last motion of `/capture`.

```
<routes ref="sb:4c9e1f lib/second_brain/route_tags.ex">
... one paragraph, feeding a concept and back-linking a code path ...
</routes>
```

Settled properties:

- **Keyed on canonical ids, never free-text topics.** A ref is a concept's
  stable **`sb:` id** (the aggregating sink — it accretes the log) or a **path**
  (a non-aggregating back-link to code or a file — no log). Ids, not phrases, so
  two threads about the same matter emit the same string and the cross-thread
  join is exact. This mirrors the identity rule that typed edges reference ids,
  not paths.
- **Per-paragraph, multi-ref, lifted whole.** A paragraph feeding two matters
  carries both refs on one region (never nested regions). The tag boundary *is*
  the auditable selection — no within-region trimming. A region must not cross a
  `## User`/`## Assistant` turn boundary.

**The doc-side log.** Each referenced concept carries a
**`## Thread excerpts — route-tagged log`** section: an append-only, per-thread,
date-stamped block for every thread that tags it, each block lifting the tagged
regions whole (ATX headers demoted to bold). Each block quotes a *frozen* thread,
so it never goes stale; the section is **generated, not hand-kept** — `mix
brain.route_tags --materialize` writes it from the current tags.

**The verifier owns it.** `mix brain.route_tags` (see `SecondBrain.RouteTags`)
runs beside `mix brain.verify` in CI and the pre-commit hook. It re-derives each
sink's log from the current tags and **fails on divergence**, converting the
log's freshness from procedural to structural, and checks tag wellformedness,
ref resolution, and per-sink block presence. Tag *coverage* — whether every
feeding paragraph was tagged — has no mechanical oracle and stays editorial; a
routing-ledger cross-check lifts it to row granularity and **warns** (never
fails).

**Freeze on matter-resolution.** A concept accepts new excerpt blocks while its
matter is unresolved and freezes acceptance when the matter resolves — per
matter, not on archival.

_Source: [`meta/policy/route-tagging.md`](/meta/policy/route-tagging.md)_

---

## 9. Git workflow

- **Session branches are ephemeral; the default branch is durable.** Work enters
  the repo on a short-lived head branch (e.g. `claude/<slug>`) and lands in the
  default branch via a pull request. The branch is scaffolding, not history — the
  merge is the record.
- **Delete the head branch when its PR merges.** A merged branch is fully contained
  in the default branch's history, so deleting it loses nothing (its commits stay
  reachable through the merge, and GitHub can restore the branch). Deletion is part
  of the merge motion: prefer the repository's **"Automatically delete head
  branches"** setting; failing that, delete the branch manually right after
  merging. A merged branch discovered lingering later is deleted on sight.
- **Never delete without the operator:** the default branch (never), and any branch
  carrying **unmerged** commits — including branches whose PR was closed without
  merging. Those hold work with no other home; propose deletion and wait for the
  operator to ratify, as with any destructive change.

_Source: [`meta/policy/git-branch-deletion.md`](/meta/policy/git-branch-deletion.md)_
