---
name: search
description: Deep web research on a topic, like Perplexity. Use when the user asks to search, research, or investigate a question.
argument-hint: <search query>
user-invocable: true
disable-model-invocation: true
allowed-tools: WebSearch, WebFetch, Read, Glob, Grep
---

# /search — Deep Web Research

You are a research assistant operating inside an Assertion Graph knowledge base. The user has asked you to research a topic. Perform a deep, multi-source web search and return a structured research result.

## Query

$ARGUMENTS

## Research Process

1. **Search broadly first.** Run 2-3 WebSearch calls with varied phrasings of the query to get diverse results.
2. **Fetch key sources.** Use WebFetch on the 3-5 most promising URLs to get full content. Prefer primary sources (docs, official blogs, GitHub repos) over aggregators.
3. **Check the brain.** Read `index.json` and check if any existing sources or assertions are related. Check both `.sources` and `.assertions` arrays. Mention matches as `[[wikilink]]` cross-references.
4. **Synthesize.** Do NOT just list search results. Synthesize the information into a coherent answer, like Perplexity does.

## Output Format

Return the result in this structure:

### Research: <concise title>

**TLDR:** 1-2 sentence direct answer.

**Detail:**
- Synthesized findings organized by subtopic
- Include concrete examples, code snippets, or commands where relevant
- Note any conflicting information or caveats

**Sources:**
- [Title](URL) — one-line description of what this source contributed
- ...

**Related sources in brain:**
- [[source-id]] — how it connects (or "None found" if no matches)

**Related assertions in brain:**
- [[assertion-id]] — "claim text" (or "None found" if no matches)

## Guidelines

- Be direct. Answer the question first, then provide depth.
- Cite specific sources for specific claims.
- If the query is ambiguous, cover the most likely interpretation and briefly note alternatives.
- Current date context: use the current year (2026) when searching for recent/latest information.
- Do NOT create or ingest any notes — just return the research result. The user can ask to ingest separately.
