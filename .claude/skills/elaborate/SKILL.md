---
name: elaborate
description: Expand a technical phrase, sentence, or short description — define the terms it uses and give a less technical overview of the concepts and actions it describes — and persist the expansion as a type elaboration doc under meta/elaborations/. Use when the operator says "/elaborate", "elaborate on that", "what does that mean", "unpack that", or "explain that in plain terms" about a phrase or passage (from the conversation, a doc, a commit message, or pasted text). For a whole paper/article/spec use /summarize-technical; to persist standalone term definitions into the glossary use /add-to-glossary.
---

# /elaborate — unpack a technical phrase in plain terms

Take a compact piece of technical language — a phrase, a sentence, a short
passage — and expand it so a reader outside the subfield understands both the
**vocabulary** (what each term means) and the **substance** (what is actually
being described or done). This is the phrase-scale sibling of
[`/summarize-technical`](../summarize-technical/SKILL.md): that skill breaks
down a whole document; this one unpacks a mouthful.

The expansion is delivered in chat **and persisted** as a `type: elaboration`
doc under [`meta/elaborations/`](/meta/elaborations/index.md) (governance
namespace — no `em:` id), so the unpacking survives the session and can be
linked like any other doc.

## Input

One phrase or passage per invocation:

- **Pasted text** after `/elaborate` — a sentence from a paper, a commit
  message, a log line, an error, a fragment of documentation.
- **A pointer into the conversation** — "elaborate on that", "what does the
  second bullet mean": resolve to the exact phrase the operator means; quote it
  back so the target is unambiguous.
- **A pointer into the bundle** — a phrase inside a filed concept, thread doc,
  or policy, named by path or quote. Read the surrounding context before
  explaining; the sentence may lean on it.

If the target is ambiguous (several candidate phrases), ask which one rather
than guessing.

## Output structure

Three parts, in this order — scale each to the input (a five-word phrase needs
a few sentences per part; a paragraph may need more):

### 1. In plain terms
One short paragraph restating what the phrase says, using **no jargon at all**
— the register of `/summarize-technical`'s plain-language summary. If a
precise idea needs a technical term, describe the idea plainly here and let
part 2 name it.

### 2. The terms
Each significant technical term in the phrase, defined in one to three
sentences that bridge from what a generalist already knows to the exact term —
the same selection bar and register as
[`/add-to-glossary`](../add-to-glossary/SKILL.md): terms of art, named
methods/metrics/formalisms, and load-bearing concepts; skip plain English used
plainly. In order of appearance in the phrase.

**Check the brain first.** If a term already has a glossary file, link it
inline — `[route tag](/beliefs/glossary/route-tag.md)` — and keep the definition here
consistent with (or briefer than) the filed one; if it is canonically defined
by a filed concept or the operating contract, link that instead. Define from
understanding, never contradicting what the brain has already filed — if the
filed definition looks wrong, say so rather than silently diverging.

### 3. What's actually happening
A less technical walkthrough of the **concepts and actions** the phrase
describes: who/what acts, on what, in what order, and why it matters. For a
descriptive phrase this is the mechanism behind the words; for an
action-describing one (a commit message, a pipeline step, a procedure) walk
the steps in sequence. Concrete analogies are welcome when they genuinely map;
label any simplification that loses precision ("roughly", "in effect").

## Where it writes

```
meta/elaborations/
  index.md           # genre description + contents list
  <kebab-slug>.md    # one doc per elaborated phrase — type: elaboration, no em: id
```

Each doc carries, in order: frontmatter; a `> quote` of the exact target
phrase with a one-line note of where it came from; then the three parts above
as `##` sections. Frontmatter:

- `type: elaboration`
- `title` — the phrase (or a tidy short form of it)
- `description` — one sentence: what the phrase is about
- `provenance` — where the phrase came from (conversation date, doc path,
  commit, URL) and that the expansion is agent-authored
- `tags` — include `elaboration`; add topical tags
- `timestamp` — today
- `attribution` — the ingestion event (resource-attribution policy):
  `when` = now, `channel: agent-authored`, `agent` = "Claude Code agent,
  /elaborate", `why` = what prompted the elaboration. **Do not set `from`
  here** — the back-link points at a *persisted* thread, which doesn't exist
  until `/capture` runs; [`/create-pull-request`](../create-pull-request/SKILL.md)
  appends it once the thread doc is written. On an update to an existing
  elaboration, never touch the existing attribution except that stamping step's
  `from` append.

Filename: kebab-case slug of the title (topical, no date prefix). **Update in
place:** if the same phrase (or a trivial variant) already has an elaboration
doc, merge into it and bump `timestamp` rather than creating a near-duplicate.

## Procedure

1. **Pin the target.** Resolve exactly which phrase is being elaborated; quote
   it at the top of the reply. Read enough surrounding context (the message,
   the doc section, the diff) to know what the terms refer to *here* — many
   terms are overloaded, and the elaboration must match this usage, not the
   most common one.
2. **List the terms** worth defining before writing anything, and grep
   `/beliefs/glossary/` (and the registry/concept tree) for each — existing
   definitions get linked, not re-invented.
3. **Write parts 1–3 in order** and deliver them in chat. Part 1 stays
   jargon-free; part 3 may use a term once part 2 has defined it.
4. **Persist the doc** under `meta/elaborations/<slug>.md` (or merge into the
   existing doc for that phrase), then add/update the entry in
   `meta/elaborations/index.md` (one bulleted link + one-line description).
   The change narrative belongs in the commit message — there is no hand-kept
   `log.md`.
5. **Offer glossary persistence, don't perform it.** If part 2 produced
   definitions the glossary lacks and they seem durably useful, mention that
   `/add-to-glossary` can file them per-term — but only the operator's say-so
   triggers that skill.

## Guardrails

- **Faithful to the source's meaning in context** — elaborate what the phrase
  actually says, not the general topic it gestures at. If the phrase is wrong
  or misleading, explain what it says *and* flag the problem.
- **No jargon in part 1, ever** — the "just this once" parenthetical is how
  plain summaries rot (same rule as `/summarize-technical`).
- **Link, don't duplicate** — a term the brain already defines is cited by
  bundle-absolute link; the citing-terms convention (link first use, not every
  occurrence) applies. The elaboration doc is not a second glossary: its term
  definitions serve *this phrase*; the source-independent home for a term is
  `/beliefs/glossary/`.
- **Governance namespace, not bundle** — elaboration docs carry no `em:` id
  and never a `verified` field; they are agent-authored expansions, like
  tutorials.
- **One phrase, one doc** — dedup before writing; merge instead of creating
  near-duplicates.
- **Never set `attribution.from` yourself** — the back-link points at a
  *persisted* thread, which doesn't exist until `/capture` runs;
  `/create-pull-request` owns that step.
- Match depth to the input: don't inflate a two-term phrase into an essay, and
  don't compress a dense paragraph into a gloss that skips half its terms.
