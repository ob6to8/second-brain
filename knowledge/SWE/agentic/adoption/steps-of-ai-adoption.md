---
id: em:974060
type: reference
title: "Steps of AI Adoption (Boris Cherny)"
description: Boris Cherny's five-step maturity model for organizational AI-coding adoption — from Gated (step 0) through Assisted, Parallel, and Supervised autonomy to AI-native (step 4) — with per-step agent counts, bottlenecks, enabling products, guardrails, and the unlock that graduates a team to the next step.
resource: https://www.linkedin.com/posts/bcherny_steps-of-ai-adoption-activity-7483695059843043328-LBg_/
provenance: "Boris Cherny, 'Steps of AI Adoption', 2026-07-16; pasted verbatim by the operator"
tags: [ai-adoption, maturity-model, agentic-coding, claude-code, orchestration, autonomy, org-design, guardrails]
timestamp: 2026-07-17
attribution:
  when: 2026-07-17T18:07:58Z
  channel: intake
  agent: "operator via /intake, Claude Code session"
  why: "operator pasted the text of Boris Cherny's 'Steps of AI Adoption' post, to be preserved verbatim"
---

# Steps of AI Adoption (Boris Cherny)

A five-step maturity model for how organizations adopt AI coding agents, by the
creator of Claude Code. Each step is defined by the human's role and the number of
agents they effectively run: **0 Gated** (no agents — access itself is blocked by
legacy approval processes), **1 Assisted** (you + one agent as a supervised pair;
bottleneck is your attention, since low trust means reading everything),
**2 Parallel** (one engineer orchestrates 5–10 agents on isolated worktrees with
self-verification, auto mode, and automated code/security review; bottleneck shifts
to reviewing output), **3 Supervised autonomy** (~100 agents as a manager-of-managers
org tree; Claude writes nearly all code, proactive background work runs continuously;
bottleneck is trust in the loop and decision throughput — the trap is scaling agent
count before the loop has earned trust), and **4 AI-native** (~1,000+ agents, VP
steering by intent; the loop is fully closed and most agents are kicked off by
Claude; bottleneck is identifying and automating work at scale with the right
per-workload guardrails).

Each transition has a named unlock lever: 0→1 executive alignment and secure launch
frameworks; 1→2 parallel sessions plus a trusted self-verification loop (tests +
build + lint + e2e) and auto mode; 2→3 context access for the agent, review speed,
breaking work into loops/routines, and letting Claude kick off Claude; 3→4 scaled
automation of domain-specific use cases (migrations, fuzzing, feature-building,
feedback remediation). The step structure maps directly onto the
[loop-engineering](/knowledge/SWE/agentic/agentic-loop/loop-engineering-went-mainstream.md)
thesis — each graduation is earned by hardening the verification harness around the
agent, not by adding agents first.

# Verbatim capture

The operator-pasted text of the post, preserved verbatim. The source is a
six-column table (Step & your role · Agents · What it looks like · What's the
bottleneck · Products that help with each step · Guardrails); the flattened
column order below is as pasted.

## Steps of AI Adoption

Boris Cherny
Jul 16, 2026

### 0: Gated

**Agents:** 0

**What it looks like:** Only older or lighter/faster models are approved, latency compounds through AI gateways and custom auth, no MCP governance, internal access to AI tools is gated or process-heavy.

No IT infra or approval path for hosting Claude-created code or artifacts; outputs only exist locally.

**What's the bottleneck:** Legacy security and approval processes, focuses on cost-per-token containment vs. outcomes, lack of true technical voices in decisionmaking.

**Products that help with each step:**
Claude.ai chat

**Guardrails:**
SSO/SCIM plus role-based access
Org-level budget caps
Deploy inside existing approvals/IAM
Data governance package

**How to get from step 0 to 1:** Executive/buyer alignment and escalation of blockers; frameworks for launching Claude securely

### 1: Assisted

**Your role:** You + an agent (a pair)

**Agents:** ~1

**What it looks like:** One engineer, one agent, mostly supervised—a fast pair programmer. You run one session at a time and review almost every change before it merges.

Unlock: A change that used to fill an afternoon becomes something you finish between meetings.

**What's the bottleneck:** Your attention and the need to inspect each response and code edit. Due to low trust for the model's output and lack of self-verification, you feel you must read everything, so you never look away.

Work is synchronous: you sit and watch while Claude works, rather than moving on to the next task.

**Products that help with each step:**
Claude Code in the Desktop, CLI, or IDE
Claude Cowork, Claude Design
Usage via Anthropic API, Bedrock, Vertex, or Microsoft Foundry
Claude Code analytics dashboard + Analytics API
Compliance API for Claude Enterprise

**Guardrails:**
Plan mode to review intent before edits
Per-seat spend caps
Centrally managed model/effort settings
Centrally managed policy
OpenTelemetry export into existing SIEM/observability stack

**How to get from step 1 to 2:** Run more than one agent at a time; a self-verification loop you trust (tests + build + lint + e2e testing with a real dev environment); auto mode, to avoid blocking permission prompts; automate code review

### 2: Parallel

**Your role:** Orchestrator

**Agents:** ~10

**What it looks like:** One engineer orchestrates 5–10 agents at once, each on its own worktree or git checkout, jumping between them. Claude checks its own work—tests, build, lint, security scan—before you see it. Auto mode is always on. Automated code review and security review are on by default. Output multiplies, you review final diffs rather than keystrokes, and your backlog of maintenance work starts shrinking. Claude writes most of the code.

Unlock: A backlog that used to take the team weeks becomes one engineer's afternoon of orchestration.

**What's the bottleneck:** Reviewing output. You're hand-writing less code and instead checking six streams of it, and this takes up more of your time.

Prompting and steering the model as you juggle sessions.

**Products that help with each step:**
Auto mode
Agent view
Claude Code Review
Claude Security Review
Claude Code on Mobile, cloud execution in Desktop
Usage via Claude Teams or Claude Enterprise
Claude Tag (do a single task)
Worktree isolation in CLI and Desktop
Remote control, so you can monitor your agents from your phone
Analytics to monitor team usage

**Guardrails:**
Automatic code quality enforcement: lint, automated tests, typecheck
Claude powered end-to-end verification (eg. using the Claude Chrome extension or iOS/Android simulator MCP)
Manual code review, code merge, and security review. Hold the same quality bar for human and agent-generated code
Pre-approve common safe bash and MCP commands in settings.json

**How to get from step 2 to 3:** Give Claude a way to pull in context (let Claude read code, wikis, discussions); agency and code review speed (agents may touch code owned by other teams); break up your work into loops and routines; let Claude kick off Claude

### 3: Supervised autonomy

**Your role:** Manager of managers (an org tree)

**Agents:** ~100

**What it looks like:** Claude writes all or nearly all of the code. "Did you read the code?" becomes "what context was the model missing and how do we solve it for next time?"

Unlock: Claude proactively does work that you would have had to kick off manually before. Maintenance and cleanup that used to wait for someone to find the time now runs continuously in the background.

**What's the bottleneck:** Trust in the loop and your team's decision throughput. The agent tree is too deep to babysit and your trap is scaling agent count before the loop has earned widespread trust.

Ensuring tokens are used efficiently as usage increases. Requires monitoring (via OTel or Analytics) and a culture that encourages experimentation while controlling costs once internal use cases find PMF. Ask yourself: is this something an engineer would have done?

**Products that help with each step:**
Subagents with worktree isolation (so parallel agents don't collide)
Routines, /loop, /batch, and /goal to fan out repetitive work
Dynamic workflows
Claude Tag (have it monitor a channel or data source and kick off tasks proactively)

**Guardrails:**
Automatic code review
Automatic security review
Agent sandboxing
CLAUDE.md and Skills to encode standards
Tune Auto mode classifier based on your team's usage
Manage token use with model selection, advisors, LSPs, breaking up CLAUDE.md into lazy Skills

**How to get from step 3 to 4:** Scaled automation of domain-specific use cases (eg. code migration, fuzzing, feature-building, feedback remediation)

### 4: AI-native

**Your role:** VP steering by intent

**Agents:** ~1,000+

**What it looks like:** The loop is fully closed and most agents are kicked off by Claude. Hundreds to thousands of agents run; you steer by intent and monitor by exception.

Unlock: The quarter-long migration becomes a workflow you kick off and check on.

**What's the bottleneck:** Identifying and automating work at scale, and enforcing the right guardrails for each type of work.

**Products that help with each step:**
Claude Agent SDK to programmatically build and schedule agents
Claude Tag (active in most Slack channels, auto-responding to posts)

**Guardrails:**
Cost controls for automation
Model selection for automation

# Citations

- Boris Cherny, "Steps of AI Adoption", 2026-07-16 —
  <https://www.linkedin.com/posts/bcherny_steps-of-ai-adoption-activity-7483695059843043328-LBg_/>
- Rendered artifact of the table:
  <https://claude.ai/code/artifact/bfdfaef9-bc62-4dfe-ba9e-c58a26c9accf>

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:974060">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-17-tier-3-4-interface-and-trust-with-adoption-intake (2026-07-17)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:974060`]**

**The model itself**

The most useful thing about Cherny's ladder is that **every rung is gated by verification trust, not by agent count**. The step 1→2 lever is "a self-verification loop you trust"; the step 3 trap is explicitly "scaling agent count before the loop has earned widespread trust." Agents are the dependent variable; the harness is the independent one. That's the same thesis as the loop-engineering capture already in the brain, now expressed as an org maturity model. The other sharp observation is that the human bottleneck *migrates* — attention (1), review throughput (2), decision throughput and trust (3), work-identification (4) — which means each tier's tooling is obsolete at the next tier. It is also, worth remembering, a vendor's map drawn by the vendor: the products column is a Claude catalog, and the tiers double as a sales funnel. The bottleneck/guardrail analysis stands on its own; the product mapping should be read as one vendor's instantiation.
