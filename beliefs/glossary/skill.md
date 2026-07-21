---
id: em:aa0003
type: concept
title: skill
description: A named, invocable capability packaged as a SKILL.md under .claude/skills/ (or shipped in a plugin), giving the agent a specialized procedure it runs on request.
provenance: "Agent-distilled glossary definition, pointer to the defining policy"
verified: false
tags: [glossary, claude-code, skills]
sense: common
timestamp: 2026-07-17
attribution:
  when: 2026-07-11T11:24:25+02:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# skill

In this brain the roster is enumerated by the [skills-registry policy](/meta/policy/skills-registry.md)
(compiled into `CLAUDE.md` §7); an individual command's canonical link is its
own `SKILL.md` (or, when shipped in a [plugin](/beliefs/glossary/plugin.md), the
plugin's), and the *concept* a skill enacts (e.g. [session capture](/beliefs/glossary/session-capture.md))
is what earns a glossary entry — not its bare `/command` handle. The SKILL.md
packaging has become a cross-vendor convention: skills distribute via registries
like skills.sh and install into agent frameworks (Vercel
[eve](/beliefs/glossary/vercel-eve.md) among them) as well as Claude Code, so a
skill written here is portable beyond this harness.

*Seen in:* [2026-07-11 glossary-backfill thread](/meta/threads/2026-07-11-glossary-backfill-from-thread-docs.md), [2026-07-12 priorities-skill thread](/meta/threads/2026-07-12-priorities-skill-and-persistence-listers.md), [2026-07-17 vercel-eve comparison thread](/meta/threads/2026-07-17-vercel-eve-comparison-and-jido-host-plan.md) (eve's contextual per-agent skill loading and copy-by-install distribution)
