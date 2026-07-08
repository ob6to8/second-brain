<!--
  GENERATED FILE — do not edit by hand.
  Source of truth: meta/preamble.md + meta/policy/*.md
  Regenerate:      mix brain.contract
  Verify (CI):     mix brain.contract --check
-->

# Operating Contract — Second Brain (OKF)

This repository is a personal **second brain** stored as an
[Open Knowledge Format](https://github.com/GoogleCloudPlatform/knowledge-catalog)
(**OKF v0.1**) bundle. Every agent that operates here — including fresh, sandboxed
agents spun up from the Claude Code app — MUST read and follow this contract. It is
the backbone that keeps the brain consistent as it grows.

The operator is the human (mreveley@gmail.com). The agent files and organizes;
the operator ratifies changes to the *shape* of the brain.

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
- `policy` — a governance rule for how the brain operates; the source from which
  `CLAUDE.md` is compiled (lives under `meta/policy/`).

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
- **`/persist-thread`** — archive the current conversation into `meta/threads/` as a
  date-prefixed record: exchanges only, operator and agent text **verbatim**, no tool
  calls, numbered turn headings. See `.claude/skills/persist-thread/SKILL.md`.
- **`/capture`** — render the current session into a **distilled** thread doc under
  `meta/threads/` (substantive responses only), then a routing ledger and route tags
  over the frozen body. Differs from `/persist-thread`: capture distills and routes,
  persist-thread keeps everything verbatim. See `.claude/skills/capture/SKILL.md`.
- **`/summarize-technical`** — produce a three-part layered breakdown of a technical
  paper/article/spec: a plain-language summary, a glossary of its key technical terms,
  then an integrated technical summary reusing those terms. See
  `.claude/skills/summarize-technical/SKILL.md`.

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
- **A distilled render, not a verbatim archive.** For each assistant turn keep
  **only the substantive response** and drop the noise: reasoning, tool calls
  and results, and the short "let me check X" narration that precedes a tool
  batch (a text block under ~300 chars that is followed by a tool call). Longer
  blocks, and any block not followed by a tool (the turn's closing response),
  are kept; turns with no tool calls keep all their text. Drop system reminders
  and slash-command wrappers. (`/persist-thread`, by contrast, keeps everything
  **verbatim** — the two are different tools for different needs.)
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
