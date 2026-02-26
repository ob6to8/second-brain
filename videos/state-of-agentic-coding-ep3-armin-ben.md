---
title: "State Of Agentic Coding #3 with Armin and Ben"
url: "https://www.youtube.com/watch?v=b0SYAChbOlc"
aliases: ["agentic coding ep3", "armin ronacher ben agentic coding"]
tags: [ai, agentic-coding, claude-code, opus-4-6, coding-agents, harnesses, personal-agents, ide-vs-cli]
channel: "Armin Ronacher"
date_published: "2026-02-16"
date_captured: "2026-02-25"
summary: >
  Armin Ronacher and Ben discuss the state of agentic coding in Feb 2026:
  Opus 4.6 and fast mode impressions, the explosion of harnesses (Codex, Pi,
  Toad), OpenClaw/personal agents going mainstream, the IDE-to-CLI shift,
  code quality concerns, and whether the job becomes requirements engineering.
duration: "59:01"
content_type: video
word_count: 11517
related:
  - "[[persistent-memory-for-openclaw-mem0-plugin]]"
  - "[[context-engineering-and-persistent-agent-memory]]"
---

## Participants

- **Armin Ronacher** — creator of Flask, founder of Arendelle (stealth), self-described agentic coding addict
- **Ben** — career JS developer, ex-Disqus/Sentry, building Modem

## Monthly Predictions Review (from Ep 2, Jan 8th)

**Cursor responding to Claude Code's momentum?** — Unclear. Cursor launched a CLI (possibly a relaunch of a summer beta). Armin: Cursor is now targeting enterprises, no longer selling to individual devs on Twitter. Ben: "Inside Cursor they're like, we just added a billion dollars."

**More or fewer harnesses?** — Definitely more. Codex relaunched desktop app with work tree support. Pi (minimal coding agent) gained visibility — endorsed by Toby Lutke, officially blessed by OpenAI. Toad (by Will McGugan). People running Claude Code in VMs on phones.

**Personal agents bigger deal?** — Yes, massively. OpenClaw (formerly Claudebot/Moldbot by Peter Steinberger) went viral. Drove Mac Mini sales. It's a coding agent connected to Slack/Telegram/WhatsApp with persistent memory and skill-based self-programming.

## OpenClaw / Personal Agents

- Peter Steinberger's personal agent, originally WhatsApp-based, extended to Discord
- Anecdote: left running overnight on Discord, people went wild with it, didn't completely screw up
- Runs on Mac because: Apple ecosystem access (iMessage, iCloud), and residential IPs avoid captchas that plague cloud IPs
- Fun tangent: Armin's son's cheap Chinese projector was secretly a VPN residential IP exit node
- Consensus: personal agents are interesting for exploration but not the best form factor for serious software building — Codex/Claude web agents are better for that
- Key limitation: hard to review diffs on the go

## Work Trees vs Checkouts

- Codex is first major harness with work tree support baked in (though Claude desktop app had it for 6 months, undiscoverable)
- Armin: "I can't figure work trees out. I moved to multiple checkouts. I am a caveman."
- Ben: uses work trees via Conductor
- Boris and Peter also use plain checkouts
- Work trees sticking around in discourse but not universally adopted

## Opus 4.6 Impressions

- Ben: merged ~80 PRs over a weekend. "I feel like I can operate at a slightly higher level." Compaction feels noticeably better — sessions go longer without degrading.
- Armin: no strong opinion on base Opus. "Does it work? Does it not work?"
- Both: it's maybe 10% better on benchmarks, but 10% compounds into dramatic workflow improvements

## Fast Mode

- 2.5x throughput for 6x the cost
- Ben burned through $50 in a single session
- Armin: "I'm not ready to pay money for that"
- Ben: "I have no interest in going faster. It feels really fast." Bottlenecked by human review, not model speed
- Useful for: large autonomous projects (browser, compiler) with machine-verifiable win conditions — not for human-in-the-loop work

## Big Agentic Projects

- Cursor built a browser from scratch (using GPT 5.2, now deprecated for 5.3)
- Anthropic built a C compiler with Opus 4.6 that compiles the Linux kernel
- Both used custom harnesses: ticket-cranking outer loop + file-system task delegation
- Cloud Code shipped experimental multi-agent mode (team members/teammates)
- Simon Willison predicted "someone will build a browser from scratch this year" on Oxide and Friends podcast

## Code Quality Concerns

- Armin: "They write terrible code. There's no denying it."
- Ben: "I can objectively say my codebase is not good quality standard... but it's good enough for what I'm trying to do right now"
- Armin on the danger: "You can build yourself into a codebase where nobody in the company actually knows what it does internally"
- Armin is on a "detox" — pulling back from pure requirements-engineering mode, doing more actual engineering
- Question: "Can you just vibe your way through until a better model comes and cleans up the mess?" Armin: "Not yet."

## The IDE is Dying

- AMP killed their IDE extension
- Cursor now shows agent view, not IDE, on their website
- Armin predicts: discourse will shift to "death of the IDE" within a month or two
- Cursor's branding challenge: known as "the best editor" but the future is chat-based agent interaction
- Parallel to Sentry's challenge moving from "error monitoring" to broader platform
- Annual prediction: after the CLI comes the chat app — OpenClaw is a year early on this

## Is This Healthy?

- Both admit to unhealthy levels of engagement
- Armin: "My fancy bed tells me I don't sleep enough"
- Ben: "To truly stay on top of this is madness"
- Armin: feels like 2004-2009 again — early days of the industry, everything feels possible
- Both acknowledge the FOMO pressure to ship faster is real but counterproductive

## Predictions (Next Month)

**Armin:** More sandbox solutions and more productized versions of "Gas Town" (multi-agent orchestration). Either harnesses ship it natively or a wave of third-party orchestrators appears.

**Ben:** Will Google make a bigger play in agent coding? They have great models, TPUs, Gemini — but aren't resonating with developers the way Anthropic is.

**Armin:** Not this month. Both Google and Microsoft are "deeply dysfunctional" at shipping end-user products that resonate, despite massive resources. Will eventually have to build up the chain to something users pay for.
