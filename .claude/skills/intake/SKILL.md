---
name: intake
description: Process pasted content (text, links, notes, clippings) into one or more distilled OKF concept documents, filed into the correct directory of the second brain. Use whenever the operator pastes material after /intake, or asks to "capture", "file", "save this to the brain", or "intake" something.
---

# /intake — capture into the second brain

Turn whatever the operator pasted after the invocation into properly-filed
[OKF](../../../CLAUDE.md) concept document(s). Follow the
[operating contract](../../../CLAUDE.md) — especially the taxonomy-evolution
protocol and the controlled `type` vocabulary.

The pasted material is the **input**. If nothing was pasted, ask the operator what
they want to capture.

## Procedure

### 1. Gather the material
- Read the pasted content.
- **Resolve links.** If the paste contains URLs, fetch them (WebFetch) and use the
  content, not just the bare link.
  - If a fetched resource is **small enough to capture faithfully**, distill it fully.
  - If it is **too large to reasonably copy**, write a faithful **summary** and
    **persist the link** in the `resource` frontmatter field (and under `# Citations`).
    Never drop the source.

### 2. Segment into concepts
- Decide whether the paste is **one concept or several**. If it covers distinct
  things (e.g. three unrelated articles, or a person + a project), split it into
  multiple concept documents. Otherwise, one paste = one concept.

For **each** concept:

### 3. Dedup — search before writing
- Search the bundle (Grep/Glob over `*.md`, excluding `deprecated/`) for an existing
  concept on the same subject (match on title, slug, `resource` URL, key terms).
- **If found → update in place**: merge the new information, refresh/extend the body,
  bump `timestamp`, and note the update in `log.md`. Do **not** create a near-duplicate.
- **If not found → create new** (continue below).

### 4. Distill
- Write a clean concept, not a raw dump:
  - `title`: human-readable name.
  - `description`: one sentence.
  - `type`: pick from the controlled vocabulary in the operating contract. If nothing
    fits, **propose a new type to the operator** and wait for ratification. Use `claim`
    for unverified assertions (e.g. content generated in a chat thread).
  - `tags`: a few useful categorization strings.
  - `timestamp`: today's date/time (ISO 8601).
  - `resource`: the source URI, when there is one.
  - `provenance`: where the content came from (e.g. "Claude Opus 4.8, chat thread"),
    when it isn't the operator's own words.
  - `verified`: `false` for anything not independently fact-checked (default for
    AI-generated statements); `true` once confirmed.
  - Body: distilled prose. Use conventional headings where helpful
    (`# Schema`, `# Examples`, `# Citations`). Keep raw source material under
    `# Citations` or as the `resource` link — not as the whole body.
  - Cross-link related existing concepts with bundle-absolute markdown links (`/…`).

### 5. Choose the directory (taxonomy protocol)
- **Fits an existing directory →** file it there **autonomously**.
- **No existing directory fits →** this is a change to the shape of the brain.
  **Stop and propose** a new directory: its kebab-case name, where it sits in the
  tree, and why the current tree doesn't fit. **Wait for the operator to ratify**
  before creating it. (On a blank brain, expect to propose the first directories —
  that's how the taxonomy bootstraps.)

### 6. Write the file
- Filename: kebab-case slug of the title (`some-concept.md`). Use a `YYYY-MM-DD-`
  prefix **only** for inherently time-ordered/journal entries.
- Write valid frontmatter (mandatory non-empty `type`) + distilled body.
- **Mint a stable id** and refresh the compiled registry:
  `mix brain.id && mix brain.registry` (requires Elixir; the SessionStart hook
  installs it). Then confirm the bundle passes `mix brain.verify`.

### 7. Maintain reserved files
- Update the directory's `index.md` (create it if missing): add a bulleted link to
  the new/updated concept with its one-line description.
- Append a dated entry to `log.md` (nearest one; create/append the root `log.md` if
  no closer one exists), newest-first under an ISO 8601 date heading.
- If a new top-level directory was created, add it to the bundle-root `index.md`.

### 8. Report
Summarize concisely:
- Each concept written or updated, with its path and `type`.
- Any links fetched (and which were summarized vs. captured in full).
- **Anything awaiting operator ratification** (a proposed new directory or type) —
  surface this clearly and don't create it until approved.

## Guardrails
- Distill, don't dump. Update in place, don't fragment.
- Never create a new directory or a new `type` without operator ratification.
- Keep every concept OKF-conformant: parseable frontmatter, non-empty `type`.
- Never touch `deprecated/`.

## See also

[meta/flows/intake.md](/meta/flows/intake.md) — the end-to-end flow (pipeline,
data model, touch-sequence, actor boundaries, gate suite, and the scenario test),
for the *why* behind this procedure.
