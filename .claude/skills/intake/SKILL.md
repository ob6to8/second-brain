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

### 3. Dedup — synonym-expanded search before writing
Vocabulary mismatch, not typos, is what makes dedup miss: a note titled "poisoning"
is invisible to a search for "pollution" (measured — run `mix brain.dedup_probe`).
So don't search only the obvious title words.
- **Generate 3–5 alternate phrasings** of the concept first: title terms **plus**
  synonyms, jargon/plain-language variants, acronyms and their expansions, and the
  words someone who *didn't* write the note would use (e.g. "context pollution" ↔
  "context poisoning"; "stale branch" ↔ "branch doesn't auto-advance on fetch";
  "codebase graph" ↔ "code knowledge graph").
- Search the bundle (Grep/Glob over `*.md`, excluding `deprecated/`) for **each**
  phrasing — title, slug, `resource` URL, and every alternate term — not just one query.
- **If found → update in place**: merge the new information, refresh/extend the body,
  bump `timestamp`. Do **not** create a near-duplicate.
- **If not found → create new** (continue below).

> This is the tier-1 recall fix from the
> [vector-DB recall analysis](/meta/analysis/vector-db-recall-for-the-scaling-bundle.md):
> the model in the loop *is* the semantic-search layer, so expanding the query by hand
> recovers most misses with no new dependency. The gain is quantified offline by the
> `--expanded` mode of the [dedup probe](/meta/evals/dedup-probe.md).

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
  - `attribution`: the **ingestion event** (see the resource-attribution policy) —
    written once at filing, never rewritten by later merges (merges bump
    `timestamp` only):

    ```yaml
    attribution:
      when: <now, ISO 8601>
      channel: intake            # operator-initiated /intake (auto-intake sets its own)
      agent: "operator via /intake, Claude Code session"
      why: "<the operator's ask, one sentence — the same phrasing step 8 harvests>"
    ```

    No `from` here — that sub-key belongs to governance docs only.
  - `verified`: `false` for anything not independently fact-checked (default for
    AI-generated statements); `true` once confirmed.
  - Body: distilled prose. Use conventional headings where helpful
    (`# Schema`, `# Examples`, `# Citations`). Keep raw source material under
    `# Citations` or as the `resource` link — not as the whole body.
  - **Technical sources → layered breakdown.** When the concept captures a
    technical paper, article, or spec substantial enough to warrant it (typically
    a `reference` or `source`), build the body with
    **[`/summarize-technical`](../summarize-technical/SKILL.md)** instead of flat
    prose — its three-part structure (plain-language summary → key terms →
    technical summary) *is* the distilled body. Invoke it as this step's distill
    action, then continue to the directory/write steps below. Skip it for short
    notes, snippets, people, and projects, where plain distilled prose is right.
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
- If a new top-level directory was created, add it to the bundle-root `index.md`.
- No log entries — the commit message records what was filed and why.

### 8. Grow the dedup recall gold set (automatic — no operator action)
This runs on **every** intake; the operator does nothing. See the gold doc's
[Upkeep section](/meta/evals/dedup-probe.md) for the rationale.
- **Harvest a gold row** — if this intake carried a **natural phrasing** for the
  material (the operator's own words: their request text, a subject line, how they
  described it), append one row to the `## Gold set` table in
  [`/meta/evals/dedup-probe.md`](/meta/evals/dedup-probe.md):
  `| <that phrasing> | <filed/merged concept's em: id> | target | <2–3 synonym variants> | harvested at intake YYYY-MM-DD |`.
  Use the operator's **actual** phrasing as the query — never a synthetic paraphrase.
  If the intake was a bare URL/paste with **no natural phrasing to harvest**, skip
  this silently; don't invent a query.
- **Refresh the baseline** — run `mix brain.dedup_probe --update-baseline` (regenerates
  the committed `## Baseline`; the trend lives in git history).
- **Escalate only on regression** — if that run's **plain** recall dropped below the
  previous baseline, flag it in your report (step 9). A sustained drop is the trigger
  to adopt tier-2 embedding dedup — the one call that's the operator's. Otherwise say
  nothing about it. Commit the gold-row + baseline change together with the concept.

### 9. Report
Summarize concisely:
- Each concept written or updated, with its path and `type`.
- Any links fetched (and which were summarized vs. captured in full).
- **Anything awaiting operator ratification** (a proposed new directory or type) —
  surface this clearly and don't create it until approved.
- **A dedup-recall regression**, if step 8 flagged one (else omit).

## Guardrails
- Distill, don't dump. Update in place, don't fragment.
- Never create a new directory or a new `type` without operator ratification.
- Keep every concept OKF-conformant: parseable frontmatter, non-empty `type`.
- Never touch `deprecated/`.

## See also

[meta/flows/intake.md](/meta/flows/intake.md) — the end-to-end flow (pipeline,
data model, touch-sequence, actor boundaries, gate suite, and the scenario test),
for the *why* behind this procedure.
