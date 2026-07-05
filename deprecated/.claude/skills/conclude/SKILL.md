---
name: conclude
description: Extract assertions from conversation context. Decomposes findings into primitive claims, identifies compounds, creates/updates assertion files, and links evidence to sources.
argument-hint: [optional focus area or claim to extract]
user-invocable: true
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
---

# /conclude — Extract Assertions from Conversation

You are operating inside an Assertion Graph knowledge base built on an assertion DAG architecture. The user has had a conversation (research, discussion, investigation) and wants to extract the findings as structured assertions.

## Optional Focus

$ARGUMENTS

If arguments are provided, focus extraction on that area. Otherwise, extract all distinct claims from the conversation.

## Process

### 1. Identify claims

Review the conversation context. List every distinct, falsifiable claim or finding. Each claim should be:
- A single declarative sentence
- Atomic (not combining multiple ideas)
- Specific enough to be agreed with or contested

### 2. Check existing assertions

Read `index.json` and check the `assertions` array for existing assertions that overlap with the identified claims.
- If an existing assertion covers the same claim: update its evidence (add new sources), adjust confidence if warranted
- If genuinely new: create a new primitive assertion file

### 3. Create primitive assertions

For each new claim, create a file in `assertions/` using this frontmatter structure:

```yaml
---
type: assertion
tier: primitive
claim: "The single-sentence claim"
confidence: high|medium|low|contested
evidence:
  - source: "[[source-id]]"
    type: citation|supporting|reasoning|axiom
tags: [lowercase, hyphenated-tags]
date_asserted: "YYYY-MM-DD"
supersedes: ""
related: []
---

Optional body with elaboration or context.
```

Filename: kebab-case derived from the claim. Keep it short but descriptive.

### 4. Identify compounds

Look for cases where multiple primitives together imply something larger — a compositional insight that none of them state individually. For each compound:

```yaml
---
type: assertion
tier: compound
claim: "The compositional insight"
confidence: high|medium|low
deps:
  - "[[primitive-1-id]]"
  - "[[primitive-2-id]]"
implication: "What the combination of deps produces — the 'so what'"
evidence:
  - source: "[[source-or-reasoning]]"
    type: reasoning
tags: [lowercase, hyphenated-tags]
date_asserted: "YYYY-MM-DD"
related: []
---
```

### 5. Ingest referenced sources

If the conversation references URLs that aren't already in `sources/`, ingest them as **full verbatim content**. A source worthy of inclusion must have its original content, not just a summary.

**Extraction cascade — try each method in order until one produces full content:**
1. `./scripts/ingest.sh <url>` — works for YouTube, Reddit, arxiv, simple articles
2. `WebFetch <url>` — works for most non-JS-rendered pages
3. Ask the user to paste the content — last resort for JS-walled or paywalled pages

**Source fidelity rules:**
- Sources must contain the original extracted text, not a summary or synopsis
- If no method produces full content, do NOT create a thin placeholder source. Ask the user to provide the content manually.
- It is better to have no source file than a stub that only contains metadata

Create source files in `sources/` with `type: source` frontmatter and link them as evidence in the relevant assertions.

### 6. Rebuild index and commit

```bash
./scripts/build-index.sh
```

Then commit all changes with a descriptive message.

## Output

After completing all steps, report:

1. **New assertions created** — list each with ID and claim
2. **Updated assertions** — list each with what changed
3. **New sources ingested** — list each with ID and title
4. **New edges** — list the DAG connections created
5. **Compounds** — highlight any compositional insights discovered

## Guidelines

- Prefer fewer, higher-quality assertions over many weak ones
- A claim that's already well-covered by an existing assertion doesn't need a duplicate — update evidence instead
- Confidence levels: `high` = multiple sources agree, `medium` = single credible source, `low` = speculative/anecdotal, `contested` = sources disagree
- Every assertion should have at least one evidence link (to a source or as `type: reasoning` with inline justification)
- Tag assertions with the same taxonomy as sources for cross-referencing
- Use today's date for `date_asserted`
