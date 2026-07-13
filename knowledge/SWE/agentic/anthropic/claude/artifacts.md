---
id: sb:a142be
type: concept
title: Artifacts (Claude)
description: Self-contained, hosted, client-side documents Claude generates alongside a chat reply — rendered as a live page, iterated in place, and shareable by URL.
verified: false
provenance: "Claude Code agent, interactive session on 2026-07-13 (artifact-design discussion with the operator)"
attribution:
  when: 2026-07-13
  channel: agent-authored
  agent: "Claude Code agent, interactive session"
  why: "operator asked to summarize Claude Artifacts — a feature of the vended Anthropic Claude service — into the knowledge base"
tags: [anthropic, claude, artifacts, ui, rendering]
timestamp: 2026-07-13
---

# Artifacts (Claude)

An **artifact** is a standalone, renderable output Claude produces *alongside* a
chat reply: a single HTML / Markdown / SVG / React file rendered as a live web
page (or document, diagram, small app) rather than printed as text or a code
block in the conversation. Each artifact gets its own default-private URL that
the user can view, iterate on, and choose to share. It is the "show" to the
chat's "tell" — the persistent visual or work product, while the chat carries
the narration and reasoning.

## Defining properties

- **Self-contained.** A strict Content-Security-Policy blocks every external
  request — no CDN scripts, remote fonts, `fetch`/XHR, or backend. All CSS, JS,
  and assets must be inlined (assets as `data:` URIs). An artifact is a static or
  client-side document, not a networked application. The sandbox is *enforced by
  the platform*, not merely a convention the author self-imposes.
- **Interactive.** Within that sandbox it can still run JS — forms, charts,
  small tools, games, prototypes — so it is more than a static slide.
- **Iterative and versioned.** Re-publishing the *same* file path redeploys to
  the *same* URL, keeping a version history. This is what lets an artifact behave
  as a live document that evolves turn-by-turn instead of a one-shot export.
- **Private by default.** It starts private on Anthropic's infrastructure; the
  user decides if and when to share the link.
- **Responsive and theme-aware** by design guidance — it renders in the viewer's
  light or dark theme and on any screen.

## How it's used in a session

An artifact is meant to sit in a persistent side panel next to the chat and be
updated *in place* as the conversation continues — ask for a different chart, add
data, refine a layout, and the same artifact redeploys rather than a new one
spawning each turn. The normal division of labor: **chat = discussion and
reasoning; artifact = the thing itself.** Long prose is not duplicated into the
artifact — it holds what is better seen than read.

Common contents: data visualizations and dashboards; working UI prototypes and
small tools; structured documents, comparison tables, and diagrams (Mermaid /
SVG — including DAGs like dependency graphs, pipelines, or concept maps); and
rendered code / output previews.

## Persistence and cross-session editing

Once published, an artifact **outlives the session and the container that made
it** — it is hosted on Anthropic's infrastructure, so the URL keeps working after
the ephemeral session ends. Continuity across sessions is *manual*, though: a
fresh conversation has no memory of what a prior one published. To update an
existing artifact, a later session must reconnect via the pasted URL (or a
list-my-artifacts lookup), then round-trip the code: **fetch the live HTML → save
it to a local file → strip the auto-added `<!doctype>/<html>/<head>/<body>`
wrapper → edit → re-publish to the same URL.** The source of truth effectively
lives *at the URL*, not in any session's filesystem.

## Contrast: artifact vs. building a real website

A developer can reproduce the fast edit→see loop locally (Vite/webpack hot
reload). What an artifact adds is not the reload mechanism but the removal of
infrastructure:

- **Zero viewer-side setup** — no Node, dev server, port, or localhost. This
  matters when Claude runs in an ephemeral cloud container with no port exposed
  to the user, or when the viewer is on a phone or a non-dev surface.
- **Lifecycle independence** — a localhost server dies with its process/container;
  the hosted artifact URL persists.
- **Enforced sandboxing** — the no-backend / no-external-fetch guarantee removes
  any hosting or review decision from the user.

The trade-off: an artifact is a sandboxed, single, client-side file. When the
goal is a real product — backend, packages, a build system, production
deployment, and a lifecycle independent of any chat — that is a proper
development project (e.g. this brain's own Elixir site generator), not an
artifact.

## Related

- Design fundamentals live in the `artifact-design` skill, consulted before an
  artifact's HTML is written to calibrate how much design investment a request
  warrants.
- The [Claude Code](/knowledge/SWE/agentic/anthropic/claude-code/index.md) agent
  can emit artifacts via its `Artifact` tool, but artifacts are a Claude *product*
  feature spanning claude.ai web, desktop, and mobile — hence filed under
  [claude](/knowledge/SWE/agentic/anthropic/claude/index.md), not under the CLI
  agent's node.
