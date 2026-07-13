---
id: sb:54ea6d
type: concept
title: artifact
description: A self-contained, hosted, client-side document (HTML/Markdown/SVG/React) Claude generates alongside a chat reply, rendered as a live page and shareable by URL; canonically defined in the filed concept.
provenance: "Agent-distilled glossary pointer entry"
verified: false
tags: [glossary, anthropic, claude, artifacts, pointer]
sense: common
timestamp: 2026-07-13
attribution:
  when: 2026-07-13
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-13 artifacts-concept-and-anthropic-node-restructure thread"
---

# artifact

In the Claude ecosystem, a standalone renderable output — a single HTML / Markdown
/ SVG / React file rendered as a live page (document, dashboard, diagram, small
app) — that Claude produces *alongside* a chat reply rather than as inline text,
gets its own default-private URL, and can be iterated in place (same file path →
same URL) and shared. It is sandboxed under a strict [Content Security Policy](/beliefs/glossary/content-security-policy.md)
(no external requests, everything inlined).

Canonically defined in [Artifacts (Claude)](/knowledge/SWE/agentic/anthropic/claude/artifacts.md).

*Seen in:* [2026-07-13 artifacts-concept-and-anthropic-node-restructure thread](/meta/threads/2026-07-13-artifacts-concept-and-anthropic-node-restructure.md)
