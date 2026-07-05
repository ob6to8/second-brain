# Assertion File Spec

Assertions are atomic claims in the knowledge base. They form a directed acyclic graph (DAG) where primitives are leaf nodes backed by evidence, and compounds compose primitives with explicit implications.

## Tiers

- **primitive** — a single atomic claim backed by evidence (sources or reasoning)
- **compound** — a compositional claim that depends on other assertions

## Required Fields

| Field | Type | Description |
|---|---|---|
| `type` | string | Always `assertion` |
| `tier` | string | `primitive` or `compound` |
| `claim` | string | Single declarative sentence stating the belief |
| `tags` | string[] | Lowercase, hyphenated taxonomy tags |
| `date_asserted` | string | ISO 8601 date when claim was made |

## Optional Fields

| Field | Type | Description |
|---|---|---|
| `confidence` | string | `high`, `medium`, `low`, or `contested` |
| `evidence` | object[] | Array of evidence objects (see below) |
| `supersedes` | string | Wikilink to an older assertion this replaces |
| `related` | string[] | Wikilinks to related assertions or sources |

## Compound-Only Fields

| Field | Type | Description |
|---|---|---|
| `deps` | string[] | Wikilinks to prerequisite assertions |
| `implication` | string | What the combination of deps produces |

## Evidence Object

Each entry in the `evidence` array. The `source` field can be either:
- A **wikilink** (`[[source-id]]`) — creates an edge in the DAG index
- An **inline context string** (`"Reasoning: ..."`) — for axioms or reasoning that don't reference a file. These do NOT create edges.

| Field | Type | Description |
|---|---|---|
| `source` | string | Wikilink to a source, or inline context string |
| `type` | string | `citation`, `supporting`, `reasoning`, or `axiom` |

## Examples

### Primitive

```yaml
---
type: assertion
tier: primitive
claim: "Auto-compaction fires at arbitrary points, often mid-task, causing context loss"
confidence: high
evidence:
  - source: "[[longform-guide-everything-claude-code]]"
    type: citation
  - source: "[[state-of-agentic-coding-ep3-armin-ben]]"
    type: supporting
tags: [context-engineering, agent-memory]
date_asserted: "2026-03-03"
related: []
---
```

### Compound

```yaml
---
type: assertion
tier: compound
claim: "Persistent agent memory requires structural persistence, not reactive summarization"
confidence: high
deps:
  - "[[auto-compaction-causes-context-loss]]"
  - "[[context-window-is-viewport-not-memory]]"
implication: "If the context window is a lossy viewport and compaction is destructive, memory must be persisted structurally before compaction occurs"
evidence:
  - source: "[[context-engineering-and-persistent-agent-memory]]"
    type: reasoning
tags: [context-engineering, agent-memory, llm-architecture]
date_asserted: "2026-03-03"
related: []
---
```

## Body

Optional elaboration, reasoning, or context beyond the claim. Not required — the claim field should be self-contained.
