---
name: add-to-glossary
description: Scan a persisted thread (meta/threads/), a paper, a post, or a filed concept; extract the technical terms and concepts it actually uses; and merge distilled definitions into the glossary — one concept file per term under /beliefs/glossary/. Use when the operator says "/add-to-glossary", "add this to the glossary", "glossary this thread", "define the terms in this", or asks for glossary links.
---

# /add-to-glossary — accrete a cross-domain glossary

Extract the significant technical vocabulary from a source and merge it into the
brain's glossary: **one concept file per term under
[`/beliefs/glossary/`](/beliefs/glossary/index.md)**, with [`/beliefs/glossary.md`](/beliefs/glossary.md) as the
hub doc describing the system. Where
[`/summarize-technical`](../summarize-technical/SKILL.md) produces a *per-document*
glossary that lives and dies with its breakdown, this skill maintains the
*persistent, cross-source* one: the same term seen in three threads and a paper has
**one** file, with four citations.

Each term file is a bundle concept like any other — its own `sb:` id, frontmatter,
and place in `mix brain.verify`/`registry` and the site renderer. That per-term
granularity is the point: **every definition is individually linkable**, so a term
can be cited anywhere as a bundle-absolute link (`[route tag](/beliefs/glossary/route-tag.md)`)
that lands on its definition. There is deliberately no `glossary.json`; the file
structure below is regular enough to parse if tooling ever needs it.

## Input

One source per invocation (or several, processed in sequence):

- **A persisted thread** — a doc under `/meta/threads/`, named by path, date, or
  topic. Read the frozen body; extract terms from the substantive exchanges.
- **A paper or post** — a URL (WebFetch; alphaXiv tools for arXiv papers), pasted
  text, or an attached file (for PDFs, read in page batches).
- **An already-filed bundle concept** — a `reference`/`source`/`concept` named by
  title, path, or `sb:` id.

If nothing was given, ask the operator what to scan.

**[`/create-pull-request`](../create-pull-request/SKILL.md) invokes this skill
automatically** on the thread doc its `/capture` step just wrote, so every
captured session's terminology lands in the glossary in the same PR as the
thread itself.

## Procedure

### 1. Gather and extract
Read the source in full, then list its candidate terms: terms of art, named
methods/metrics/formalisms, coined vocabulary, and load-bearing concepts the
source *relies on* — the same selection bar as `/summarize-technical`'s key-terms
section. Skip terms that don't materially change how a reader would describe the
material; this is a working glossary, not an index of every noun.

### 2. Dedup against what the brain already defines
For each candidate, in order:

- **Already has a file under `/beliefs/glossary/`** → merge into that file (step 4).
  Never create a second file for the same term.
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
- **The `description` is the canonical overview.** It is rendered as the entry
  page's lede paragraph *and* shown verbatim as the term's gloss in the index
  `## Terms` section — one overview, three surfaces. Write it to stand alone.
- Definitions are **source-independent**: define what the term means, not what
  the source said about it. The source goes in the citation line.
- If a term carries different senses in different domains, keep **one entry with
  numbered senses**, not two entries.

### 4. Merge into `/beliefs/glossary/`
- **One file per term**: `/beliefs/glossary/<kebab-slug>.md`, slug derived from the term
  (`route-tag.md`, `verified-by.md`). `type: concept`; `title` = the term
  (lowercase unless a proper noun or cased formalism); `description` = the
  definition in one sentence; `provenance` noting it's an agent-distilled
  glossary definition; `verified: false`; `timestamp`.
- Body: an `# <term>` heading, **expansion-only prose**, then a *Seen in:* line
  of citations — bundle-absolute links for threads and filed concepts, plain
  URLs for external papers/posts (a citation is not a parked bookmark; the
  link-processing policy governs filing URLs as *concepts*, not citing them).
- **The body never restates the description.** The site renders the
  description as the lede directly above the body, so body prose that
  re-defines the term stacks two definitions on one page. Body paragraphs add
  only what the description doesn't carry: mechanism, consequences, examples,
  senses, distinctions, cross-links. A body with nothing non-redundant to add
  is left empty (heading, then *Seen in:*). `mix brain.glossary` enforces this
  mechanically: a body sentence whose content-word vocabulary is largely
  contained in the description **fails**; moderate overlap warns.
- **Cross-link related terms, prose first.** When the relationship between two
  terms can be *stated*, weave the link into the definition prose itself
  ("distinct from a [plan](/beliefs/glossary/plan-type.md)…") — the prose carries the
  meaning. Only when terms are genuinely adjacent but no defining sentence
  connects them, add a `*See also:*` line after *Seen in:* with at most 3–4
  bundle-absolute term links. These are ordinary untyped prose links per the
  cross-linking policy — never a frontmatter field.
- **Existing file, new source** → reconcile: extend the definition only if the
  new source genuinely adds nuance (or a new sense); always append the citation;
  bump that file's `timestamp`. Never delete or rewrite-from-scratch a file the
  operator may have touched.
- The index `## Terms` section is a **generated artifact**: one bulleted link
  per term, title-sorted case-insensitively, gloss = the term's `description`
  verbatim. Never hand-edit it — run `mix brain.glossary --materialize` after
  adding or changing entries.

### 5. Maintain and verify
- Mint ids for the new term files and refresh the registry:
  `mix brain.id && mix brain.registry`.
- Regenerate the index and check the glossary layer:
  `mix brain.glossary --materialize` (index `## Terms` sync, descriptions,
  body-dedup — see the
  [glossary plan](/meta/plans/glossary-single-overview-and-dedup-check.md)).
- Run `mix brain.verify`. (No log entry — the commit message records which
  source was scanned and which terms were added/updated.)

### 6. Report
List the terms added, the terms merged into existing entries, and the pointer
entries that defer to filed concepts — so the operator can spot a wrong
definition at a glance.

## Citing terms in responses

The per-term files exist so definitions can be *cited*. When the operator asks
for glossary links (or when a response leans on a term the glossary defines),
link the term inline by bundle-absolute path —
`[route tag](/beliefs/glossary/route-tag.md)` — so clicking it lands on the definition.
Link a term's first use in a response, not every occurrence.

## Graduation

The glossary is a staging layer, not a terminal home. When a term's file
outgrows a glossary definition — it accumulates senses, claims, or citations
that belong in the domain tree — **move the file into the taxonomy** where it
belongs (its `sb:` id travels with it; identity survives moves) and leave a
pointer stub at `/beliefs/glossary/<slug>.md` linking to the new home, so glossary
links keep landing somewhere useful. Update both `index.md` files and the
registry (`mix brain.registry`).

## Guardrails

- Distill, don't dump: no copying the source's own definitions verbatim into
  entries (verbatim excerpts belong in `type: source` captures, not here).
- One term, one file — dedup before writing, merge instead of creating
  near-duplicates.
- Don't glossary the incidental: plain English used plainly is not a term of art.
- **Terminology, not invocables.** The glossary holds *concepts*, not command
  handles. A bare skill command (`/intake`, `/capture`, `/research`) does not get its
  own entry — its canonical link is its own `SKILL.md`, and the *concept it enacts*
  (e.g. [session capture](/beliefs/glossary/session-capture.md)) is what earns a glossary
  file. The [skill](/beliefs/glossary/skill.md) *category* has one pointer entry; the
  individual commands live in the [skills-registry policy](/meta/policy/skills-registry.md).
- Definitions written here are agent statements; term files stay
  `verified: false` unless a claim gets grounded via the normal `verified_by`
  machinery.
- Never touch `deprecated/`.
