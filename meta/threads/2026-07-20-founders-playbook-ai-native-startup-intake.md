---
type: reference
title: 2026-07-20-founders-playbook-ai-native-startup-intake
description: Intake of Anthropic's "The Founder's Playbook: Building an AI-Native Startup" PDF into a new knowledge/startups/ top-level domain, committed and pushed.
provenance: "Claude Code session, 2026-07-20; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, intake, startups, anthropic, founders-playbook]
timestamp: 2026-07-20
pr: 116
---

# 2026-07-20-founders-playbook-ai-native-startup-intake

## Where this landed

The operator asked to intake "the anthropic pdf - the founders playbook -
building an ai native startup" with no content pasted. After the operator
had nothing to attach, they asked me to search online instead; I found and
fetched the PDF and blog post, extracted the full 36-page text, and
distilled it into a single `type: methodology` document. It didn't fit any
existing top-level domain, so I proposed a new one (`knowledge/startups/`),
the operator ratified it, and I filed the document, created the directory,
minted an id, updated the reserved indexes, harvested a dedup gold-set row,
and verified the bundle. The operator then flagged that this should go
through `/create-pull-request` properly; a stop hook also required the
working changes to be committed and pushed, which I did directly to the
session's designated branch before this capture.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Founder's Playbook intake | closed | [founders-playbook-ai-native-startup](/knowledge/startups/founders-playbook-ai-native-startup.md) | - |
| New `knowledge/startups/` domain ratification | closed | [knowledge/startups/index.md](/knowledge/startups/index.md) | - |
| Commit/push/PR of the intake | open | unrouted | PR not yet opened as of this capture |

## User

/intake the anthropic pdf - "the founders playbook - building an ai native startup"

## Assistant

<routes ref="em:54cf3c">
No PDF matching this is present in the environment, and no content was actually pasted after the `/intake` invocation — only a reference to "the anthropic pdf." I can't fetch it from memory since I don't have reliable access to Anthropic's actual "Founder's Playbook" content or a verified URL for it.
</routes>

## User

Continue from where you left off.

## Assistant

<routes ref="em:54cf3c">
I don't have the PDF content — nothing was attached or pasted, and I don't have a reliable way to fetch "The Founder's Playbook: Building an AI-Native Startup" from memory alone. To intake it properly, could you either:

1. **Paste the text** of the PDF directly, or
2. **Share a URL** to it so I can fetch it, or
3. **Attach the file** to this session

Once I have the actual content, I'll dedup-check the bundle, distill it, and file it per the intake procedure.
</routes>

## User

Search online

## Assistant

<routes ref="em:54cf3c em:d042c5 em:e24e40">
I have the full playbook content now. This is a single coherent document (Anthropic's founder-methodology playbook), so it's one concept, not several.

**Dedup check**: I searched the bundle for "founder," "startup," "product-market fit," "AI-native," etc. Nothing existing captures this — the closest neighbors are `knowledge/SWE/agentic/anthropic/` (Anthropic's *products*: Claude, Claude Code, Agent SDK) and `knowledge/ai-industry/` (market/competitive analysis of the AI industry). Neither fits: this playbook isn't product documentation, and it isn't market analysis — it's a founder-facing methodology for building a company, with AI tooling woven in as the means.

**This doesn't fit any existing top-level domain**, so per the taxonomy-evolution protocol I need to stop and propose one rather than create it myself:

**Proposed new top-level directory: `knowledge/startups/`**
- Sits alongside `SWE`, `ai-industry`, `machine-learning`, `knowledge-management`.
- Scope: startup-building methodology and founder playbooks — the lifecycle of building and growing a company (idea validation, MVP, launch, scale), as distinct from `SWE` (the craft of building software) and `ai-industry` (market/economic analysis of the AI sector).
- First document: `knowledge/startups/founders-playbook-ai-native-startup.md`, `type: methodology` (a repeatable, prescriptive playbook — matches the controlled-vocabulary definition exactly), `resource` linking the source PDF and blog post.

Want me to go ahead and create `knowledge/startups/` for this, or does it belong somewhere else (e.g., folded into an existing domain, or a different name like `entrepreneurship`)?
</routes>

## User

Thats good, proceed

## Assistant

<routes ref="em:54cf3c">
Intake complete. Summary:

**Filed:** [`knowledge/startups/founders-playbook-ai-native-startup.md`](https://ob6to8.github.io/elixir-mind/knowledge/startups/founders-playbook-ai-native-startup.html) — `em:54cf3c`, `type: methodology`. Distilled the full 36-page PDF (fetched, converted, read end-to-end) into a body covering the core thesis and all four stages (Idea, MVP, Launch, Scale), each with goal / exit criteria / failure modes / AI-powered exercises, plus the closing framing. Source PDF and blog announcement kept under `resource` and `# Citations`.

**New top-level directory created** (per your ratification): `knowledge/startups/` — added its `index.md` and listed it in both `index.md` (root) and `knowledge/index.md`.

**Dedup gold set:** harvested your literal query phrasing ("the founders playbook - building an ai native startup") into `meta/evals/dedup-probe.md`, refreshed the baseline. No recall regression.

Bundle verifies clean. Nothing else is pending operator action — let me know if you'd like this captured/PR'd (`/create-pull-request`).
</routes>

## User

Stop hook feedback:
[~/.claude/stop-hook-git-check.sh]: There are uncommitted changes in the repository. Please commit and push these changes to the remote branch.

## Assistant

<routes ref="/knowledge/startups/founders-playbook-ai-native-startup.md">
Committed and pushed to `claude/anthropic-pdf-intake-8kg50d`. Note this bypassed the normal `/create-pull-request` flow (which also runs `/capture` and `/add-to-glossary`, and opens the actual PR) — let me know if you'd like me to run that now to finish the session properly, or if a plain push was sufficient.
</routes>

