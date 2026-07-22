<!--
  GENERATED FILE — do not edit by hand.
  Source of truth: meta/preamble.md + meta/policy/*.md
  Regenerate:      mix brain.contract
  Verify (CI):     mix brain.contract --check
-->

# Operating Contract — Elixir Mind (OKF)

This repository is a personal **second brain** stored as an
[Open Knowledge Format](/knowledge/knowledge-management/open-knowledge-format.md)
(**OKF v0.1**) bundle, named **elixir-mind**. Every agent that operates here — including fresh, sandboxed
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

- **The repo root is the OKF bundle.** Documents live at the root and in
  subdirectories. `.claude/` (skills), `meta/` (governance), the Elixir tooling
  (`mix.exs`, `lib/`, `test/`), and `deprecated/` (archived legacy content,
  read-only) sit alongside but are **not** part of the knowledge bundle.
- **A document** is a single UTF-8 markdown file with two parts:
  1. **YAML frontmatter** (required), delimited by `---`.
  2. **Markdown body** (distilled prose; no required sections).
- **Document ID** = file path minus `.md` (e.g. `areas/health.md` → `areas/health`).
- **Terminology: "document", not "concept".** The OKF spec calls this unit a
  *concept document*, but the anatomy above is purely structural — nothing in it
  guarantees concept-like content. This bundle therefore says **document** for
  the unit and reserves **`concept`** for the controlled `type` of that name (a
  definition or mental model). When reading the OKF spec, its "concept" is this
  bundle's "document".

_Source: [`meta/policy/document-anatomy.md`](/meta/policy/document-anatomy.md)_

Frontmatter fields:

| Field | Requirement | Notes |
|-------|-------------|-------|
| `id` | **Mandatory** (bundle documents) | Stable opaque identifier, `em:` + 6 hex chars. Immutable once minted (`mix brain.id`); see the identity-and-verification section. |
| `type` | **Mandatory** | From the controlled vocabulary (see the type-vocabulary section). Non-empty. |
| `title` | Strongly recommended | Human-readable display name. |
| `description` | Strongly recommended | Single-sentence summary. |
| `resource` | When applicable | URI uniquely identifying the underlying/source asset (e.g. the original URL). |
| `provenance` | When applicable | Where the content came from (e.g. "Claude Opus 4.8, chat thread"). Distinct from `resource`: this is the *origin of the statement*, not a canonical asset URI. |
| `verified` | Only on agent statements | Boolean, and **only for agent-authored statements** (`claim`/`note`/`concept`). `false` = asserted but not checked; `true` = checked and backed by a non-empty `verified_by`. **Omit** on captures — a document that stores a link (`resource`) is not verifiable. Default `false` for AI-generated statements. |
| `verified_by` | When verified via evidence | Inline YAML list of stable ids (typically `source` captures) that jointly support this statement; targets must **exist** (they need not themselves be `verified`). The only committed representation of evidence edges. |
| `attribution` | **Mandatory** (bundle documents and governance docs) | Structured map recording the ingestion event — `when`/`channel`/`agent`/`why`, plus append-only `from` on governance docs. Immutable once written (except `from`). See the resource-attribution policy. |
| `tags` | Recommended | YAML list of categorization strings. |
| `timestamp` | Recommended | ISO 8601 datetime of last meaningful change. |

Arbitrary extra keys are allowed and must be preserved.

_Source: [`meta/policy/frontmatter-schema.md`](/meta/policy/frontmatter-schema.md)_

**Attribution — the ingestion event, recorded on the doc.** Every bundle document
(everything with an `em:` id) and every governance doc carries an `attribution`
frontmatter map recording how it entered the brain (see the
[attribution plan](/meta/plans/resource-attribution-property.md) for the design
record):

```yaml
attribution:
  when: 2026-07-13T14:02:00Z
  channel: auto-intake
  agent: "Claude Code agent, /research daily Routine"
  why: "featured in the 2026-07-13 digest under agents/orchestration; reason-tag: impactful"
  from: [/meta/threads/2026-07-13-example.md]   # governance docs only
```

| Sub-key | Holds | Form |
|---------|-------|------|
| `when` | The ingestion instant | ISO 8601 (date minimum; datetime preferred) |
| `channel` | *How* it entered — the pathway | Controlled: `intake` · `auto-intake` · `glossary` · `agent-authored` · `backfill` (grows by operator ratification, like `type`) |
| `agent` | *Who* acted — the operator, or the agent and the automation context it ran in. Names the **pathway, not the model** (the model is in the commit trailer) | Free text, one line |
| `why` | Why it was deemed worth filing | Free text, one sentence (optional when `channel: backfill` — never invented) |
| `from` | **Governance docs only.** The doc(s) this entry was extracted from — the thread it came out of, and/or the document that resulted from that thread | Inline YAML list of refs, route-tag style: an `em:` id (document) or a bundle-absolute path (thread/governance doc); targets must exist |

- **Immutable event, one carve-out.** The event sub-keys
  (`when`/`channel`/`agent`/`why`) are written once at filing and never
  rewritten — update-in-place merges bump `timestamp`, not attribution.
  Governance `from` is **append-only**: later sessions that substantively
  revise a doc add their thread (stamped by `/create-pull-request` after
  `/capture`, when the thread path exists), never remove or rewrite entries.
- **Orthogonal to the neighboring fields.** `resource` = *what asset* (canonical
  URI); `provenance` = *where the content came from* (author/origin, possibly
  predating the brain); `attribution` = *how it got here* (the ingestion event);
  `timestamp` = *when it last changed*. Attribution is not a log: the commit
  graph stays the single change-narrative layer, and this is one write-once
  record, not a maintained history.
- **Scope and exemptions.** Required on all bundle documents and on governance
  docs (`from` required on ratification-flow docs — `plan`, `analysis`,
  `elaboration`, `issue`; permitted absent only where no source doc exists).
  Exempt — and it is an **error** for them to carry `attribution`: thread docs
  (they *are* the session record; `pr:` is their anchor), `inbox/` digests
  (dated and self-describing by construction), and generated artifacts
  (`CLAUDE.md`, `meta/registry.md`, `index.md` listings).
- **Machine-enforced.** `mix brain.verify` checks shape (parseable map, valid
  `when`/`channel`, non-empty `agent`, `why` per the backfill rule), `from` ref
  resolution, exemption placement, and presence.

_Source: [`meta/policy/resource-attribution.md`](/meta/policy/resource-attribution.md)_

Reserved filenames (any directory level):

- **`index.md`** — directory listing for progressive disclosure. Markdown sections
  with bulleted links + one-line descriptions. **No frontmatter** — except the
  bundle-root `index.md`, which carries only `okf_version: "0.1"`.
- **`log.md`** — reserved by OKF (chronological change history; tolerate one when
  consuming a foreign bundle), but **this bundle does not keep hand-written logs**:
  the true-merge commit graph is the single provenance layer (see the
  merge-strategy policy and the
  [retire-hand-kept-logs plan](/meta/plans/retire-hand-kept-logs.md)). Do not
  create `log.md` files or append log entries; the change narrative belongs in
  commit messages. (The generated `## Thread excerpts — route-tagged log`
  sections inside documents are unrelated — they are compiled, CI-verified
  artifacts and stay.)

_Source: [`meta/policy/reserved-filenames.md`](/meta/policy/reserved-filenames.md)_

---

## 2. Directory structure — unix-like, domain-agnostic, evolving

- Organize documents into a **unix-like hierarchy**: lowercase, kebab-case directory
  names (short, established acronyms like `SWE` may stay uppercase); each directory
  holds a coherent set of related documents.
- **Create the natural directory path even for a single document.** Do not flatten to
  avoid nesting — a lone note about git belongs in `knowledge/SWE/version-control/git/`, not
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

- Filing a document into an **existing** directory, or creating **subdirectories
  under an already-established top-level domain**, → the agent does this
  **autonomously** (create the path and each new directory's `index.md`).
- Creating a **new top-level directory** (or renaming/moving/merging directories) is
  a change to the *shape* of the brain → the agent **proposes it and waits for the
  operator to ratify** before creating it. Explain the proposed name, where it
  sits, and why the existing tree doesn't fit.
- On creation, add each new directory's `index.md` and list new top-level dirs
  in the root `index.md`.

_Source: [`meta/policy/taxonomy-evolution-protocol.md`](/meta/policy/taxonomy-evolution-protocol.md)_

---

## 3. Filing conventions

**Capture the knowledge, cite the source.** When you file a knowledge document,
capture the *knowledge*, not the raw noise. A document has a clear title, a
one-sentence `description`, and a clean body. Keep the original material as a
`resource` URI and/or under a `# Citations` section — not as the whole document.

This is the knowledge-layer half of
[fit each layer to its purpose](/meta/doctrine/fit-each-layer-to-its-purpose.md):
a document consulted to *understand a subject* is fit for purpose when it is
concise and queryable, so here you distill hard and relegate the raw source to a
citation. The record-layer half — where fidelity, not concision, is the goal, and
material is kept verbatim-minus-noise — is governed separately by
[session-capture](/meta/policy/session-capture.md); do not apply this filing rule
to thread docs.

_Source: [`meta/policy/capture-knowledge-cite-the-source.md`](/meta/policy/capture-knowledge-cite-the-source.md)_

**Update in place; don't fragment.** Before creating a file, **search the bundle**
for an existing document on the same subject. If one exists, update it (merge new
info, bump `timestamp`) instead of creating a near-duplicate.

_Source: [`meta/policy/update-in-place.md`](/meta/policy/update-in-place.md)_

- **Filenames**: kebab-case slug derived from the title
  (`open-knowledge-format.md`). Use a `YYYY-MM-DD-` prefix **only** for inherently
  time-ordered entries (journal/log-style notes); topical documents stay purely
  topical.
- **Cross-link** related documents with markdown links. Prefer bundle-absolute paths
  (begin with `/`, e.g. `[OKF](/knowledge/knowledge-management/open-knowledge-format.md)`). Links are
  untyped edges; the prose carries the meaning. Broken links are tolerated but avoid
  creating them.

_Source: [`meta/policy/filenames-and-cross-linking.md`](/meta/policy/filenames-and-cross-linking.md)_

**In responses, link resources to the deployed site, not to repo paths.** When an
agent's **delivered response** (chat to the operator, a PR body, an issue comment —
anything read outside a checkout) references a document in the brain, cite it as a
link to that document's page on the **deployed Pages site**, not as a bundle-absolute
(`/knowledge/…md`) or relative repo path. A repo path is not navigable for a reader
in chat; the live URL is a click away.

- **The site.** The bundle is published to GitHub Pages at
  **`https://ob6to8.github.io/elixir-mind/`** (`mix brain.site` → `pages.yml`, one page per document and
  per `index.md`). That base URL lives in config
  (`config/config.exs` → `ElixirMind.SiteConfig.base_url/0`); it is the single
  source of truth, and this contract's copy of it is compiled in from that config —
  a deploy move (e.g. a custom domain) is one config edit, not a doc rewrite.
- **Get the URL from the tool, never by hand. `mix brain.url <path>` prints the
  working URL** for any bundle path — always run it; do **not** construct a URL
  yourself. The correct URL depends on state you have to check (is the doc live on
  `main` yet? see below), not on the path alone, so hand-construction is exactly
  what produces dead links. *Under the hood* the tool maps a live, rendered doc by
  swapping base and extension — `P.md` → `https://ob6to8.github.io/elixir-mind/P.html` (a directory's
  `index.md` → `…/<dir>/index.html`; governance `meta/…` docs render too) — but
  that mapping is **what the site does at build time, not a recipe to apply in a
  response**. Reproducing it by hand is the anti-pattern this policy exists to
  stop.
- **Live only after merge — cite unmerged docs by branch.** Pages deploys **only
  from the default branch** (`pages.yml` → `push: branches: [main]`), so a document
  *created or modified on an unmerged branch has no live page yet*: its Pages URL
  **404s** (new doc) or shows **stale** content (modified doc) until the PR merges
  and Pages rebuilds. Cite such a doc by its GitHub **blob URL at the branch ref**
  (`<repo>/blob/<branch>/<path>.md`), which resolves immediately and shows the
  current content. `mix brain.url` does this automatically — it emits the live
  Pages URL when the doc is rendered *and* unchanged vs `origin/main`, and the
  branch blob URL otherwise (new, modified, or under a non-rendered directory).
  The Pages URL is the canonical form once merged; a branch blob link is fine in
  ephemeral chat (branches are deleted post-merge, so never hardcode a blob URL
  into a durable doc body).
- **Not rendered → no live URL.** Resources under directories the site excludes
  (`deprecated/`, `.claude/`, `lib/`, `test/`) have no page ever; `mix brain.url`
  cites those by their GitHub blob URL instead of fabricating a Pages URL.
- **This is the response-side rule only.** Cross-links *inside* document bodies stay
  bundle-absolute markdown paths per
  [filenames-and-cross-linking](/meta/policy/filenames-and-cross-linking.md) — the
  site rewrites those `.md` links to the right relative `.html` at build time. Do not
  hardcode live URLs into document bodies; use them when speaking to a human outside
  the bundle.

_Source: [`meta/policy/response-resource-links.md`](/meta/policy/response-resource-links.md)_

- **Links must be processed, not parked.** A web resource enters the brain only once it
  has been **processed into a `reference`** (fetched and summarized/captured). Do not
  file bare, unprocessed URLs as their own documents — process it now, or don't file it.
  (There is deliberately no lightweight "bookmark" type.)
- **Oversized linked resources**: if a linked source is too large to reasonably copy,
  **write a faithful summary** as the document body and **persist the link** in the
  `resource` frontmatter field (and/or `# Citations`) so nothing is lost.

_Source: [`meta/policy/link-processing.md`](/meta/policy/link-processing.md)_

**Maintain the reserved files**: after filing, update the directory's `index.md`
(create it if missing). The change itself is recorded by the commit — write the
commit message at the semantic level ("intake X", "ratify Y"); there is no
`log.md` to append to (see the reserved-filenames policy).

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
  (governance namespace — no `em:` id, outside the identity registry, like
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
  [`meta/plans/index.md`](/meta/plans/index.md), same as any filed document.

_Source: [`meta/policy/persist-plans.md`](/meta/policy/persist-plans.md)_

**Two records of a change sit in different tenses.** A `type: plan`
([persist-plans](/meta/policy/persist-plans.md)) is **prospective** — decisions
and their rationale written *before* the work, so a session that lacks the
context can execute it. A thread doc
([session-capture](/meta/policy/session-capture.md)) is **retrospective** — the
frozen record of what a session *actually did*, produced at its close. The
commit graph ([merge-strategy](/meta/policy/merge-strategy.md)) is the third
layer: the durable *what-changed*, cited by SHA. Choosing between "persist a
plan" and "just do it" is choosing whether the work needs the prospective
artifact or whether the retrospective ones suffice.

**Default: execute in-session; the commit and the capture are the record.** When
this session holds the context and can finish the work, a plan doc is a
redundant third copy of decisions the commit message and thread render already
carry. Persisting one then is pure overhead, and worse, it *invites* a future
session to re-derive settled work.

**Escalate to a prospective plan when any of these hold:**

- **Deferred.** The work will not run in this session. Whatever context justified
  it goes cold the moment the session ends, so the decisions must be written down
  to survive — this is the core [persist-plans](/meta/policy/persist-plans.md)
  case.
- **Cold-context handoff.** The work will be executed by a *fresh* agent that
  does not share this session's reasoning. A plan is the context-transfer
  vehicle; without it the fresh agent restarts the thinking (and may re-land on a
  worse answer).
- **Cross-session build order.** The work is large enough to span sessions and
  needs an explicit sequence — a new subsystem, a genre or policy change, a
  multi-step migration — where the *order* itself is a decision worth recording.
- **Substantial standalone design.** The decisions and alternatives are weighty
  enough to deserve a first-class, queryable doc rather than being buried in a
  thread render, *even if* the work also runs now.

**The discriminator is context-transfer, not effort.** A mechanical task is not
plan-worthy merely because it touches many files, once its approach is decided
and validated in-session — hand a fresh agent a fully-solved task and the plan
adds nothing but a re-derivation risk. Conversely, a small but *deferred* or
*cold-handoff* decision is plan-worthy precisely because its context will not
survive. Ask "will the executor share this session's context?" — if yes, execute
and let the commit and capture record it; if no, persist the plan first.

_Source: [`meta/policy/plan-vs-capture.md`](/meta/policy/plan-vs-capture.md)_

**Merge with a true merge commit; never squash or rebase.** The commit graph is
a **provenance layer**, not an implementation detail: session-authored commits
carry the session trailer linking them to the agent session that produced them,
durable docs
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

**The session trailer is harness-injected — protect the setting.** The
`Claude-Session: <url>` git trailer that links a commit to the cloud session
that produced it is added automatically by Claude Code (v2.1.179+) to commits
Claude authors in web sessions, and the PR body gets the session URL on its own
line — no agent action required. Since v2.1.182 the setting
`attribution.sessionUrl: false` disables both. One innocuous-looking line in a
committed settings file would therefore silently sever commit → session
traceability for every future session:

- **Never set `attribution.sessionUrl` to `false`** in any committed settings
  file (`.claude/settings.json` or similar). An agent that finds it set does not
  "clean it up" in either direction silently — it surfaces the finding and
  proposes removal to the operator.

**Known coverage gaps — the trailer is strong evidence, not an invariant.**
Three classes of commit legitimately lack the trailer: commits predating the
feature's arrival in this repo (before 2026-07-07); auto-generated merge
commits (`git merge` default messages, the GitHub merge button) — the harness
injects the trailer only into commit messages Claude authors; and commits from
local-terminal sessions, which are authored under the operator's local git
identity and have no cloud transcript URL. For all of these the **PR is the
fallback anchor**: the PR body carries the session URL, and the thread doc's
`pr:` stamp (see the session-capture policy) links the session record back to
how it landed. Do not treat a missing trailer as evidence a commit bypassed an
agent session.

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
- `elaboration` — a persisted expansion of a technical **phrase or short passage**:
  the quoted target, definitions of the terms it uses, and a less technical overview
  of the concepts and actions it describes — produced by `/elaborate` and back-linked
  to its originating session via `attribution.from` once that session is
  captured (`/create-pull-request` stamps it). Distinct from a glossary `concept` (one
  *term*, source-independent) and a `tutorial` (long-form, standalone subject) — an
  elaboration unpacks *one specific mouthful in context* (lives under
  `meta/elaborations/`).
- `doctrine` — a persisted **intention statement**: a guiding principle or direction
  that shapes how the brain and its agents are designed and prioritized — the "why"
  that informs judgment without prescribing a specific enforceable action. Doctrine
  sits *above* policy: a `policy` implements doctrine as a concrete, machine- or
  operator-enforceable rule, and plans, analyses, and priority rankings may cite a
  doctrine as the direction they serve. Distinct from a `policy` (an enforceable
  *rule*), an `analysis` (a *reasoned judgment on a question*), and a `note` (a
  distilled *idea*) — a doctrine is a *standing direction* (lives under
  `meta/doctrine/`).

If nothing fits, propose a new type rather than forcing a bad one.

_Source: [`meta/policy/controlled-type-vocabulary.md`](/meta/policy/controlled-type-vocabulary.md)_

---

## 5. Identity & verification

- **Every bundle document carries a stable `id`** in frontmatter: the bundle's
  id-namespace prefix + 6 lowercase hex chars — currently `em:` (e.g. `em:4c9e1f`).
  The **6-hex tail is the immutable identity**: minted once (`mix brain.id`), never
  changed, and never reused, even if the file moves, is renamed, or is superseded.
  Identity survives refactors; paths don't have to.
- **The prefix is a namespace token, not part of a document's identity.** It is
  **opaque** — nothing may depend on its letters carrying meaning — and it changes
  only by an **operator-ratified, bundle-wide migration** that rewrites every id in
  one deterministic, tail-preserving pass, never per-id. One such migration has
  occurred: **2026-07, the `sb:` prefix → `em:`** (mirroring the repository rename
  second-brain → elixir-mind), swapping the prefix on every id while preserving each
  6-hex tail verbatim, so a historical `sb:`-prefixed token denotes exactly the `em:`
  id sharing its tail. A future prefix change would follow the same
  ratify-then-migrate path; absent one, the prefix is fixed.
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
  and asserts it has been **checked against evidence**. A document that stores a
  link — anything carrying a `resource` — is a **capture**, not a statement:
  verification is **not possible** for it, so a capture never carries `verified`
  (omit the field). `mix brain.verify` rejects `verified: true` on any document that
  has a `resource`, and rejects a `verified` field (either value) on any type
  outside `claim`/`note`/`concept` — the statement-type restriction is
  machine-enforced, not editorial.
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

- **`/intake`** — process pasted content into one or more filed documents. See
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
- **`/elaborate`** — unpack a technical **phrase or short passage** (from the
  conversation, a doc, a commit message, or pasted text): define the terms it uses and
  give a less technical overview of the concepts and actions it describes, delivered
  in chat **and persisted** as a `type: elaboration` doc under
  [`meta/elaborations/`](/meta/elaborations/index.md) (governance namespace, no `em:`
  id; link glossary terms that already exist; hand off to `/add-to-glossary` to
  persist new ones per-term). The doc's `attribution.from` back-link to its
  originating session is set later by `/create-pull-request`, never by this skill.
  The phrase-scale sibling of `/summarize-technical`. See
  `.claude/skills/elaborate/SKILL.md`.
- **`/add-to-glossary`** — scan a persisted thread (`meta/threads/`), a paper, a post,
  or a filed document; extract the technical terms it actually uses; and merge distilled
  definitions into the glossary — **one `concept` document per term** under
  [`/beliefs/glossary/`](/beliefs/glossary/index.md) (hub: [`/beliefs/glossary.md`](/beliefs/glossary.md)), each with
  its own `em:` id and *Seen in:* citations, so any response or document can cite a
  term by link (pointer entries defer to filed documents instead of duplicating them).
  Also invoked automatically by `/create-pull-request` on the thread doc its
  `/capture` step writes. See `.claude/skills/add-to-glossary/SKILL.md`.
- **`/research`** — generate today's **inbox**: a daily candidate feed of research, articles,
  papers, and resources matched against the brain's taxonomy, grouped by category and
  reason-tagged (`recent`/`impactful`/`influential`/`groundbreaking`/`buzz`) — then
  **auto-intake the featured items** into the bundle via `/intake`. The digest is the
  dated record in the non-bundle `inbox/` namespace (no `em:` ids); its featured items
  graduate into filed documents in the same run, bounded to the known tree (items needing
  a new top-level domain are deferred for operator ratification) and attributed
  `channel: auto-intake` for the operator's post-intake editorial pass. See
  `.claude/skills/research/SKILL.md`.
- **`/create-pull-request`** — run `/capture` to completion, run `/add-to-glossary`
  over the captured thread doc, **stamp the thread into `attribution.from`** (append
  the just-captured thread's path to the `from` list of every governance doc the
  session created or substantively revised — the append-only carve-out of the
  resource-attribution policy), then commit the current working changes, push the
  branch, and open a pull request — so the frozen thread doc, the glossary updates it
  feeds, and each governance doc's trace back to its session all ship in the same
  PR. Invoking the skill **is** the authorization to open the PR (no separate
  confirmation gate); PR-template detection and the GitHub MCP tools handle the
  rest. **Merging is opt-in, off by default:** a bare invocation ends with the PR
  open and handed back to the operator; passing a `merge` argument
  (`/create-pull-request merge`) has the skill drive CI to green and true-merge it.
  See `.claude/skills/create-pull-request/SKILL.md`.
- **`/sync-branch-with-main`** — fetch `origin/main` and merge it into the current
  working branch, keeping a feature branch current so its diff reflects only its own
  changes and a later PR merges cleanly. Refuses to run on `main`; surfaces conflicts
  rather than blindly resolving them; retries only on network errors. See
  `.claude/skills/sync-branch-with-main/SKILL.md`.
- **`/todo`** — add and list `type: todo` task items under `meta/todos/`. Dispatches on
  a subcommand argument: `/todo create <title>` files a new open todo (and maintains
  the index); `/todo list` shows the todos grouped by `status`. See
  `.claude/skills/todo/SKILL.md`.
- **`/priorities`** — list the brain's open work as a prioritized appraisal: runs
  `mix brain.session_init` (open issues, open todos, active plans, dangling ledger
  strands) and closes with a heuristic top-3 the agent refines with judgment — the
  on-demand successor to the old SessionStart digest (no longer auto-injected at
  session start). Read-only. See `.claude/skills/priorities/SKILL.md`.
- **`/issue`** — list `type: issue` tracked problems under `meta/issues/`, grouped by
  `status` (default `open`). The issues-only slice of `/priorities`; read-only
  (filing an issue stays inline per the contract). See `.claude/skills/issue/SKILL.md`.
- **`/plan`** — list `type: plan` design/decision records under `meta/plans/`, grouped
  by `status` (default `active` = proposed/accepted/in-progress). The plans-only slice
  of `/priorities`; read-only (persisting a plan stays inline per the persist-plans
  policy). See `.claude/skills/plan/SKILL.md`.

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
- **Ask the operator in the chat, not the dialog box.** Pose every question to
  the operator as ordinary `## Assistant` chat text — never through the
  dialog-box question UI (`AskUserQuestion`). `/capture` renders only the
  delivered message stream, so a question raised in the dialog box, and the
  answer the operator selects in it, never enter that stream: both are lost from
  the thread doc and every downstream artifact routed from it. Keeping the
  exchange inline is what lets capture retain the question and its answer
  verbatim. (The dialog UI has also proven flaky in these sessions — a second
  reason to keep questions in the chat.)
- **The output is a thread doc** at `meta/threads/YYYY-MM-DD-<slug>.md`,
  `type: reference`, in the governance namespace (no `em:` id). It carries, in
  order: frontmatter, a short narrative section (what the session was, where it
  landed), the **routing ledger** (`## Routing`), then the `## User`/`##
  Assistant` render body. Route tags are applied last, over the now-frozen body.
- **The thread records its PR (`pr:`), not its branch.** Once the session's PR
  is opened, its number is stamped into the thread's frontmatter as `pr: <N>`
  (set by `/create-pull-request`, not `/capture` — the number doesn't exist
  until the PR is opened). The **PR is the durable anchor**: session branches
  are ephemeral and deleted after merge (per the git-branch-deletion policy),
  and the pre-policy squash era left the original branch commits unreachable
  entirely — so the PR number is the only stable link from a thread back to how
  it landed. The branch name is deliberately **not** recorded.
  - **`pr:` is write-once — it records the *origin* PR, and a session that spans
    several PRs keeps that origin.** When a session is captured and PR'd, then
    continues — later turns extend the *same* thread doc in place (per the
    [session-capture](/meta/policy/session-capture.md) update-in-place rule) and
    land in a *follow-up* PR — the thread's `pr:` is **not** rewritten to the new
    number. It stays the PR in which the thread doc was first opened and stamped;
    the follow-up PR(s) are recorded in the thread's **narrative prose**, not in
    frontmatter. The reasoning: the origin `pr:` is already relied upon downstream
    — governance docs cite the thread by its origin landing, cross-links and git
    history reference it — so overwriting it would orphan that linkage and defeat
    the anchor's one job, a stable link back to how the thread first landed.
    Follow-up PRs stay discoverable through the thread doc's own commit history,
    and naming them in prose keeps the human reader oriented without a
    multi-valued frontmatter field. (This refines `/create-pull-request`'s
    "stamp `pr:`" step: stamp on the *first* PR that opens the thread; on a
    later PR that only re-touches an already-stamped thread, record it in prose
    instead.)
- **The thread also records its session (`session:`) — the full-fidelity escape
  hatch.** At capture time, `/capture` stamps the cloud session's transcript URL
  into the thread's frontmatter as `session: <url>`, derived from the
  `CLAUDE_CODE_REMOTE_SESSION_ID` environment variable (the id's `cse_` prefix
  becomes the URL's `session_` prefix:
  `https://claude.ai/code/session_<tail>`). The thread doc is the *distilled*
  record; the session URL points at the *raw* transcript on claude.ai — useful
  precisely when the distillation turns out to have dropped something later
  needed. It is deliberately the **weaker anchor**: account-bound (viewable only
  by the operator logged into claude.ai, unreadable by agents), and deletable —
  it complements `pr:`, never substitutes for it. Write-once at capture, never
  rewritten. When the variable is unset (local-terminal sessions have no cloud
  transcript), the key is **omitted** — never invented, never guessed.
  Threads captured before this rule were backfilled **only from recorded
  evidence** — a thread's own capture commit carries the `Claude-Session:`
  trailer, and a squash-era thread whose trailer was lost recovers the URL from
  its PR body (found via the thread's `pr:` anchor). A thread predating the
  trailer feature entirely, or produced by a local-terminal session, has no
  recorded URL and correctly stays bare. Backfill from recorded evidence only;
  never infer or guess a URL for a thread that lacks one.
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
| **Routed to** | a markdown link to the document that absorbed the strand's content, or `unrouted` |
| **Dangling** | the open question, when `open`/`paused` (else `-`) |

- **Pointers and states only — never content.** Synthesized content lands in the
  routed-to document; if it also lived in the ledger the ledger would become
  a stale shadow copy of that doc. State (the strand) and routed-to (the
  dispatch) are orthogonal: a strand can be routed yet still `open`, or `closed`
  and `unrouted`.
- **Routed-to targets are documents** — bundle or governance, of any `type` —
  linked by bundle-absolute path (e.g. `[foo](/knowledge/SWE/…/foo.md)`). The
  route-tagging cross-check reads this column to confirm every row routed to a
  **bundle** document (one carrying a stable `em:` id) is covered by a tag;
  governance targets carry no id and drop out of that check (see the
  route-tagging policy).
- **In-doc, maintained at capture time.** The ledger is a section of the thread
  doc itself (not a sibling file), written and updated by `/capture` in the same
  motion that routes content — routing and ledger update are one act, not a
  regeneration step that can be forgotten.

_Source: [`meta/policy/routing-ledger.md`](/meta/policy/routing-ledger.md)_

Mark each region of a finalized thread body with the document(s) its content
feeds, so a matter's cross-thread discussion aggregates into one place. The tag
is an inline `<routes ref="...">` region, applied over the **frozen** body as
the last motion of `/capture`.

```
<routes ref="em:4c9e1f lib/elixir_mind/route_tags.ex">
... one paragraph, feeding a document and back-linking a code path ...
</routes>
```

Settled properties:

- **Keyed on canonical ids, never free-text topics.** A ref is a document's
  stable **`em:` id** (the aggregating sink — it accretes the log) or a **path**
  (a non-aggregating back-link to code or a file — no log). Ids, not phrases, so
  two threads about the same matter emit the same string and the cross-thread
  join is exact. This mirrors the identity rule that typed edges reference ids,
  not paths.
- **Per-paragraph, multi-ref, lifted whole.** A paragraph feeding two matters
  carries both refs on one region (never nested regions). The tag boundary *is*
  the auditable selection — no within-region trimming. A region must not cross a
  `## User`/`## Assistant` turn boundary.

**The doc-side log.** Each referenced document carries a
**`## Thread excerpts — route-tagged log`** section: an append-only, per-thread,
date-stamped block for every thread that tags it, each block lifting the tagged
regions whole (ATX headers demoted to bold). Each block quotes a *frozen* thread,
so it never goes stale; the section is **generated, not hand-kept** — `mix
brain.route_tags --materialize` writes it from the current tags.

**The verifier owns it.** `mix brain.route_tags` (see `ElixirMind.RouteTags`)
runs beside `mix brain.verify` in CI and the pre-commit hook. It re-derives each
sink's log from the current tags and **fails on divergence**, converting the
log's freshness from procedural to structural, and checks tag wellformedness,
ref resolution, and per-sink block presence. Tag *coverage* — whether every
feeding paragraph was tagged — has no mechanical oracle and stays editorial; a
routing-ledger cross-check lifts it to row granularity and **warns** (never
fails).

**Freeze on matter-resolution.** A document accepts new excerpt blocks while its
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
