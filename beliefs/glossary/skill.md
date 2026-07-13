---
id: sb:aa0003
type: concept
title: skill
description: A named, invocable capability packaged as a SKILL.md under .claude/skills/ (or shipped in a plugin), giving the agent a specialized procedure it runs on request.
provenance: "Agent-distilled glossary definition, pointer to the defining policy"
verified: false
tags: [glossary, claude-code, skills]
sense: common
timestamp: 2026-07-12
---

# skill

A named, invocable capability packaged as a `SKILL.md` under `.claude/skills/`
(or shipped in a [plugin](/beliefs/glossary/plugin.md)), giving the agent a specialized
procedure — an intake, a capture, a render — that it runs on request. In this
brain the roster is enumerated by the [skills-registry policy](/meta/policy/skills-registry.md)
(compiled into `CLAUDE.md` §7); an individual command's canonical link is its
own `SKILL.md`, and the *concept* a skill enacts (e.g. [session capture](/beliefs/glossary/session-capture.md))
is what earns a glossary entry — not its bare `/command` handle.

*Seen in:* [2026-07-11 glossary-backfill thread](/meta/threads/2026-07-11-glossary-backfill-from-thread-docs.md), [2026-07-12 priorities-skill thread](/meta/threads/2026-07-12-priorities-skill-and-persistence-listers.md)
