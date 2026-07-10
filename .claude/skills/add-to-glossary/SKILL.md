---
name: add-to-glossary
description: Scan a persisted thread (meta/threads/), a paper, a post, or a filed concept; extract the technical terms and concepts it actually uses; and merge distilled definitions for them into the bundle-root /glossary.md. Use when the operator says "/add-to-glossary", "add this to the glossary", "glossary this thread", or "define the terms in this".
---

# /add-to-glossary — accrete a cross-domain glossary

Extract the significant technical vocabulary from a source and merge it into the
brain's single running glossary at [`/glossary.md`](/glossary.md). Where
[`/summarize-technical`](../summarize-technical/SKILL.md) produces a *per-document*
glossary that lives and dies with its breakdown, this skill maintains the
*persistent, cross-source* one: the same term seen in three threads and a paper has
**one** entry, with four citations.

The glossary is markdown, a bundle concept like any other — so it carries an `sb:`
id and flows through `mix brain.verify`/`registry` and the site renderer. There is
deliberately no parallel `glossary.json`; the entry structure below is regular
enough to parse if tooling ever needs it.

## Input

One source per invocation (or several, processed in sequence):

- **A persisted thread** — a doc under `/meta/threads/`, named by path, date, or
  topic. Read the frozen body; extract terms from the substantive exchanges.
- **A paper or post** — a URL (WebFetch; alphaXiv tools for arXiv papers), pasted
  text, or an attached file (for PDFs, read in page batches).
- **An already-filed bundle concept** — a `reference`/`source`/`concept` named by
  title, path, or `sb:` id.

If nothing was given, ask the operator what to scan.

## Procedure

### 1. Gather and extract
Read the source in full, then list its candidate terms: terms of art, named
methods/metrics/formalisms, coined vocabulary, and load-bearing concepts the
source *relies on* — the same selection bar as `/summarize-technical`'s key-terms
section. Skip terms that don't materially change how a reader would describe the
material; this is a working glossary, not an index of every noun.

### 2. Dedup against what the brain already defines
For each candidate, in order:

- **Already in `/glossary.md`** → merge into the existing entry (step 4). Never
  create a second entry for the same term.
- **Canonically defined elsewhere in the brain** — a filed `concept`, or a term of
  the operating contract itself (e.g. *route tag*, *routing ledger*, defined by
  `meta/policy/`) → the glossary entry is a **pointer**: a one-line gloss plus a
  link to the defining doc. Don't duplicate the definition (update in place;
  don't fragment).
- **New to the brain** → write a fresh entry (step 3).

### 3. Define
Write each definition from understanding, not by transcription:

- **One to three sentences**, plain but precise — the register of
  `/summarize-technical`'s key-terms section: bridge from what a generalist
  already knows to the exact term.
- Definitions are **source-independent**: define what the term means, not what
  the source said about it. The source goes in the citation line.
- If a term carries different senses in different domains, keep **one entry with
  numbered senses**, not two entries.

### 4. Merge into `/glossary.md`
- **Create the file if missing**: bundle-root `glossary.md`, `type: concept`,
  frontmatter per the scaffold already in the repo; mint its id
  (`mix brain.id && mix brain.registry`) and list it in the root `index.md`.
- Entries are `##` headings, sorted **alphabetically, case-insensitive**;
  lowercase unless the term is a proper noun or cased formalism.
- Each entry: the definition paragraph, then a *Seen in:* line of citations —
  bundle-absolute links for threads and filed concepts, plain URLs for external
  papers/posts (a citation is not a parked bookmark; the link-processing policy
  governs filing URLs as *concepts*, not citing them).
- **Existing entry, new source** → reconcile: extend the definition only if the
  new source genuinely adds nuance (or a new sense); always append the citation.
  Never delete or rewrite-from-scratch an entry the operator may have touched.
- Bump the glossary's `timestamp`.

### 5. Maintain and verify
- Append a dated entry to the root `log.md` (which source was scanned, roughly
  how many entries added/updated).
- Run `mix brain.verify` (and `mix brain.id && mix brain.registry` if the
  glossary was just created).

### 6. Report
List the terms added, the terms merged into existing entries, and the pointer
entries that defer to filed concepts — so the operator can spot a wrong
definition at a glance.

## Graduation

The glossary is a staging layer, not a terminal home. When an entry outgrows a
few sentences — it accumulates senses, claims, or citations worth their own
frontmatter — file it as a proper concept via `/intake` (into the taxonomy where
it belongs) and shrink the glossary entry to a pointer at the new doc. The entry
stays; only its weight moves.

## Guardrails

- Distill, don't dump: no copying the source's own definitions verbatim into
  entries (verbatim excerpts belong in `type: source` captures, not here).
- One term, one entry — dedup before writing, merge instead of appending
  near-duplicates.
- Don't glossary the incidental: plain English used plainly is not a term of art.
- Definitions written here are agent statements; the glossary stays
  `verified: false` unless individual claims graduate out and get grounded via
  the normal `verified_by` machinery.
- Never touch `deprecated/`.
