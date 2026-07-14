---
id: em:8fda94
type: concept
title: HTML escaping
description: Replacing characters with special meaning in HTML (`&`, `"`, `<`, `>`) with entity references so untrusted text cannot break out of its context — e.g. escaping a URL before interpolating it into an `href` attribute.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, security, markdown]
sense: common
timestamp: 2026-07-10
attribution:
  when: 2026-07-11T08:41:24+02:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# HTML escaping

Replacing characters with special meaning in HTML (`&`, `"`, `<`, `>`) with entity references so untrusted text cannot break out of its context — for example escaping a URL before interpolating it into an `href="..."` attribute. Missing this is a common cross-site-scripting vector.

*Seen in:* [2026-07-09 live-render thread](/meta/threads/2026-07-09-live-render-appraisal-and-pages-hardening.md)
