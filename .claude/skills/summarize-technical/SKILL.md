---
name: summarize-technical
description: Produce a three-part layered breakdown of a technical paper, article, or spec — a lightly technical plain-language summary, a glossary of the source's key technical terms, then an integrated technical summary that reuses those terms. Use when the operator asks to "break down", "go in depth on", or "explain the terminology of" a paper or technical document, or explicitly invokes /summarize-technical.
---

# /summarize-technical — layered technical breakdown

Turn a technical source into three ordered sections that build on each other, so
a reader with no background in the subfield can follow the plain-language version
and come out the other side able to read the technical one fluently.

The pasted material, attached file, or referenced concept is the **input**. If
nothing was given, ask the operator which paper/article/concept to break down.

## The three-part structure

Every breakdown has exactly these sections, in this order:

### 1. Summary
A plain-language account of the source: the problem it addresses, the approach
it takes, and what it found or argues. Lightly technical — assume an intelligent
generalist reader, not a specialist in the field. Avoid the source's jargon and
named formalisms entirely at this stage; if a concept needs a technical term to
be precise, describe it in plain terms instead and let section 2 name it.
Target roughly 150–300 words: enough to convey the actual shape of the argument,
not a one-line blurb.

### 2. Key terms
A glossary of the source's significant technical vocabulary — terms of art,
named methods/metrics, formalisms, or notation the source introduces or relies
on. For each term:
- Give a short, precise definition **grounded in the plain-language summary**
  above (bridge from what the reader already understands to the precise term).
- Order terms by when they matter for re-reading the summary — roughly the
  sequence in which a technical reader would need them, or grouped by theme if
  that reads more naturally. Don't just mirror the source's table of contents.
- Skip terms that don't materially change how a reader would describe the work —
  this is a working glossary, not an index of every noun in the paper.

### 3. Technical summary
Cover the **same ground** as section 1 — same scope, same claims, same
conclusions — but now written using the vocabulary from section 2 fluently and
precisely. This is not new information; it's the same account made more
compressed and exact because the reader is now equipped with the right words for
it. A reader who skipped straight to section 3 without sections 1–2 should find
it precise but possibly opaque in places — that gap is exactly what sections 1–2
exist to close.

## Procedure

1. **Gather the material.** Read the pasted text, fetch the URL, or read the
   attached file (for PDFs, use the `pages` parameter in batches — see the
   `/intake` skill for the same pattern). If the operator points at an
   already-filed OKF concept (by title, path, or `resource` URL), read that
   concept file as the source of truth for what's already been distilled.
2. **Identify the source's real technical vocabulary** before writing section 1
   — skim for named methods, metrics, coined terms, and notation. This list
   becomes the candidate glossary; only draft section 1's plain-language account
   once you know which terms you're building toward, so the two sections
   actually connect.
3. **Write sections 1–3 in order.** Don't write the technical summary first and
   backfill a plain-language version — that produces a plain summary that's
   secretly just as jargon-dependent, defeating the point.
4. **Where this output goes:**
   - If the source is an **already-filed bundle reference/source/concept**,
     integrate the three-part structure into that concept's body — this
     supersedes (don't append alongside) whatever distilled prose was there
     before, per the [operating contract](../../../CLAUDE.md)'s update-in-place
     rule. Keep the frontmatter (`id`, `type`, `resource`, etc.) unchanged except
     bumping `timestamp`; keep any existing `# Citations` section at the end, and
     preserve cross-links to other concepts if they're still relevant to the new
     prose. The commit message records what changed and why.
   - If the source is **not yet in the bundle**, this skill's output is fine as
     plain chat output — nothing requires filing it. If the operator wants it
     captured afterward, that's a separate `/intake` invocation (the three-part
     structure travels naturally into a `reference`'s body).
5. **Verify before committing** (only applies when a bundle concept was
   touched): `mix brain.verify`, and if ids/registry are affected,
   `mix brain.id && mix brain.registry`.

## Guardrails

- Don't let section 1 sneak in jargon "just this once" — if a term needs
  defining, it belongs in section 2, not a parenthetical in section 1.
- Don't let section 3 just repeat section 1 with terms swapped in as synonyms —
  it should read like someone who *knows* the vocabulary explaining the same
  material, more precisely and more densely.
- Distill, don't dump: this is not a transcription of the source's abstract and
  conclusion sections back-to-back. Write all three sections from understanding,
  the same way `/intake` distills rather than copies.
- When updating an existing bundle concept, don't fragment — this replaces that
  concept's distilled body, it doesn't create a sibling "breakdown" file for the
  same source.
