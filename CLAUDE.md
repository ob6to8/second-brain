# Operating Contract — Second Brain (OKF)

This repository is a personal **second brain** stored as an
[Open Knowledge Format](https://github.com/GoogleCloudPlatform/knowledge-catalog)
(**OKF v0.1**) bundle. Every agent that operates here — including fresh, sandboxed
agents spun up from the Claude Code app — MUST read and follow this contract. It is
the backbone that keeps the brain consistent as it grows.

The operator is the human (mreveley@gmail.com). The agent files and organizes;
the operator ratifies changes to the *shape* of the brain.

---

## 1. What the brain is made of

- **The repo root is the OKF bundle.** Concepts live at the root and in
  subdirectories. `.claude/` (skills) and `deprecated/` (archived legacy content,
  read-only) sit alongside but are **not** part of the knowledge bundle.
- **A concept** is a single UTF-8 markdown file with two parts:
  1. **YAML frontmatter** (required), delimited by `---`.
  2. **Markdown body** (distilled prose; no required sections).
- **Concept ID** = file path minus `.md` (e.g. `areas/health.md` → `areas/health`).

### Frontmatter fields

| Field | Requirement | Notes |
|-------|-------------|-------|
| `type` | **Mandatory** | From the controlled vocabulary in §4. Non-empty. |
| `title` | Strongly recommended | Human-readable display name. |
| `description` | Strongly recommended | Single-sentence summary. |
| `resource` | When applicable | URI uniquely identifying the underlying/source asset (e.g. the original URL). |
| `provenance` | When applicable | Where the content came from (e.g. "Claude Opus 4.8, chat thread"). Distinct from `resource`: this is the *origin of the statement*, not a canonical asset URI. |
| `verified` | Recommended for claims | Boolean. `false` = asserted but not independently fact-checked; `true` = confirmed. Default `false` for AI-generated statements. |
| `tags` | Recommended | YAML list of categorization strings. |
| `timestamp` | Recommended | ISO 8601 datetime of last meaningful change. |

Arbitrary extra keys are allowed and must be preserved.

### Reserved filenames (any directory level)

- **`index.md`** — directory listing for progressive disclosure. Markdown sections
  with bulleted links + one-line descriptions. **No frontmatter** — except the
  bundle-root `index.md`, which carries only `okf_version: "0.1"`.
- **`log.md`** — chronological change history, ISO 8601 date headings, newest first.

---

## 2. Directory structure — unix-like, domain-agnostic, evolving

- Organize concepts into a **unix-like hierarchy**: lowercase, kebab-case directory
  names; each directory holds a coherent set of related concepts.
- **Create the natural directory path even for a single concept.** Do not flatten to
  avoid nesting — a lone note about git belongs in `SWE/version-control/git/`, not
  dumped at the root. Depth that mirrors the real structure of the knowledge is good.
- **The tree *is* the taxonomy.** The directory hierarchy — surfaced through `index.md`
  files at every level (progressive disclosure, rooted at `/index.md`) — is the
  canonical taxonomy. Keep those `index.md` files current; do not maintain a separate
  map that drifts. This file (`CLAUDE.md`) holds the *policy* (the `type` vocabulary
  and frontmatter schema); the tree holds the *instance*.
- The taxonomy is **not fixed**. It **emerges bottom-up** and evolves
  **collaboratively**. There is no pre-imposed schema to satisfy.
- **The taxonomy-evolution protocol (important):**
  - Filing a concept into an **existing** directory, or creating **subdirectories
    under an already-established top-level domain**, → the agent does this
    **autonomously** (create the path and each new directory's `index.md`).
  - Creating a **new top-level directory** (or renaming/moving/merging directories) is
    a change to the *shape* of the brain → the agent **proposes it and waits for the
    operator to ratify** before creating it. Explain the proposed name, where it
    sits, and why the existing tree doesn't fit.
  - On creation, add each new directory's `index.md`, record it in the nearest
    `log.md`, and list new top-level dirs in the root `index.md`.

---

## 3. Filing conventions

- **Distill, don't dump.** Capture the *knowledge*, not the raw noise. A concept has
  a clear title, a one-sentence `description`, and a clean body. Keep the original
  material as a `resource` URI and/or under a `# Citations` section — not as the
  whole document.
- **Update in place; don't fragment.** Before creating a file, **search the bundle**
  for an existing concept on the same subject. If one exists, update it (merge new
  info, bump `timestamp`, add a `log.md` entry) instead of creating a near-duplicate.
- **Filenames**: kebab-case slug derived from the title
  (`open-knowledge-format.md`). Use a `YYYY-MM-DD-` prefix **only** for inherently
  time-ordered entries (journal/log-style notes); topical concepts stay purely
  topical.
- **Cross-link** related concepts with markdown links. Prefer bundle-absolute paths
  (begin with `/`, e.g. `[OKF](/references/open-knowledge-format.md)`). Links are
  untyped edges; the prose carries the meaning. Broken links are tolerated but avoid
  creating them.
- **Links must be processed, not parked.** A web resource enters the brain only once it
  has been **processed into a `reference`** (fetched and summarized/captured). Do not
  file bare, unprocessed URLs as their own concepts — process it now, or don't file it.
  (There is deliberately no lightweight "bookmark" type.)
- **Oversized linked resources**: if a linked source is too large to reasonably copy,
  **write a faithful summary** as the concept body and **persist the link** in the
  `resource` frontmatter field (and/or `# Citations`) so nothing is lost.
- **Maintain the reserved files**: after filing, update the directory's `index.md`
  (create it if missing) and append a dated entry to `log.md`.

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
  video, thread). A bare URL becomes a `reference` only once processed — see §3.
- `source` — a primary source citation (paper, book, dataset).
- `person` — a person.
- `project` — an active, goal-bounded effort.
- `area` — an ongoing responsibility or domain (no end state).
- `snippet` — a reusable command, code fragment, or template.

If nothing fits, propose a new type rather than forcing a bad one.

---

## 5. Conformance (keep the bundle valid)

A bundle conforms to OKF v0.1 when:

1. Every non-reserved `.md` file has parseable YAML frontmatter.
2. Every frontmatter block has a non-empty `type`.
3. Reserved files (`index.md`, `log.md`) follow their structures when present.

Be a tolerant **consumer**: never reject the bundle for missing optional fields,
unknown types, extra frontmatter keys, broken links, or absent `index.md` files.

---

## 6. Skills

- **`/intake`** — process pasted content into one or more filed concepts. See
  `.claude/skills/intake/SKILL.md`. This is the primary way knowledge enters the
  brain.

New skills are added under `.claude/skills/<name>/SKILL.md`.
