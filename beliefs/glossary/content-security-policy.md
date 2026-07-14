---
id: em:37a60d
type: concept
title: Content Security Policy
description: A browser-enforced security standard that restricts which resources a web page may load or connect to, expressed as a policy the page is served with.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, web, security, csp]
sense: common
timestamp: 2026-07-13
attribution:
  when: 2026-07-13
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-13 artifacts-concept-and-anthropic-node-restructure thread"
---

# Content Security Policy

A browser-enforced security standard (CSP) that constrains what a web page is
allowed to do — which scripts, styles, fonts, images, and network endpoints it may
load or contact — declared in a policy delivered with the page and enforced by the
browser, not by the page's own code. Because the browser is the enforcer, a strict
CSP is a hard guarantee rather than a convention: it is what makes a Claude
[artifact](/beliefs/glossary/artifact.md) a sealed client-side document — no CDN
scripts, remote fonts, `fetch`/XHR, or backend, so every asset must be inlined.

*Seen in:* [2026-07-13 artifacts-concept-and-anthropic-node-restructure thread](/meta/threads/2026-07-13-artifacts-concept-and-anthropic-node-restructure.md)
