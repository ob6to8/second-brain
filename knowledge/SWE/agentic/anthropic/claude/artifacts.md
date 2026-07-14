---
id: em:a142be
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

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:a142be">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-13-artifacts-concept-and-anthropic-node-restructure (2026-07-13)

7 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:a142be`]**

Artifacts are standalone, renderable outputs Claude can generate alongside a chat reply — a single HTML/Markdown/SVG/React file that gets rendered as a live webpage (or document, diagram, etc.) rather than just printed as text or code in the conversation. Each one gets its own private URL the user can view, iterate on, and optionally share.

A few things that distinguish them:
- **Self-contained**: no external network calls (no CDN, fonts, or APIs) — everything inline, so they render deterministically and securely.
- **Interactive**: can include JS, forms, charts, small apps — not just static slides.
- **Iterative**: you (or I) can edit the same artifact in place and it redeploys to the same URL, versioned.
- **Privacy-first**: private by default; the user chooses if/when to share.

Is it "the new PowerPoint"? Partially, but that undersells it. It overlaps with slide decks for visual reports/dashboards, but it's a more general-purpose canvas — it can just as easily be a working prototype, a data viz, a small tool/calculator, or a diagram. PowerPoint is a fixed authoring format; an artifact is closer to "a webpage Claude can build and revise on demand," of which a slide-deck-style report is just one use case.

---

**[`em:a142be`]**

Yes, that's exactly the intended usage pattern.

**Live, progressive display**: An artifact is meant to sit alongside the chat as a persistent side panel. As the conversation continues — you ask for a change, add data, request a different chart type — the same artifact gets updated in place (same file path → same URL, just redeployed) rather than a new one spawned each turn. So it behaves like a live document/dashboard that evolves turn-by-turn instead of a one-shot export.

**What people typically present**:
- **Data visualizations / dashboards** — charts, tables, KPI tiles that get refreshed as new data or framing comes in
- **Working prototypes** — a small UI, calculator, form, or interactive tool being iterated on live
- **Structured documents** — reports, comparison tables, diagrams (Mermaid, SVG) that are easier to scan visually than as chat text
- **Code/output previews** — rendered HTML, small games, visual proofs-of-concept

**Text response + visual asset together**: Yes, that's the normal split. The chat reply carries the conversational thread — brief explanation, what changed, next steps — while the artifact carries the "thing itself": the visual, the interactive surface, the document. The idea is division of labor: chat = narration and reasoning, artifact = the persistent visual/work product you're iterating on. You wouldn't typically duplicate long prose into the artifact; the artifact holds what's better seen than read (a chart, a layout, a live UI), and the chat holds the discussion around it.

---

**[`em:a142be`]**

Yes — a DAG is a natural fit for an artifact. You'd render it as an interactive/visual graph rather than describing it in prose, using something like:

- **Mermaid** (`graph TD` / `flowchart`) — simplest option, declarative, renders directed edges, good for dependency graphs, pipelines, task graphs
- **SVG or D3/Cytoscape.js** — if you need custom layout, zoom/pan, click-to-expand nodes, or force-directed positioning
- **A styled HTML/CSS node-and-arrow layout** — for simpler, mostly-static structures

And it fits the progressive-update pattern well: e.g. if you're mapping out a build pipeline, a workflow's task dependencies, or a knowledge graph of concepts (relevant here, given this repo's OKF concept-linking), the DAG artifact could start as a rough skeleton and get refined turn-by-turn — add a node, re-route an edge, highlight a critical path — while the chat carries the reasoning about *why* it changed.

Is there a specific DAG you want visualized — something from this second-brain repo (e.g. concept cross-links, or thread routing), or a different one?

---

**[`em:a142be`]**

The core difference is scope, constraints, and lifecycle — they're solving different problems:

**Artifact**
- **Sandboxed, self-contained**: strict CSP — no external network calls, no CDN, no fetch/XHR, no backend. Everything (CSS, JS, even images) must be inlined into one file. It's a single static/client-side document, not a real application.
- **Instantly hosted**: I publish it and it gets a URL immediately — no server setup, no build step, no deployment pipeline. Private by default; the user decides whether to share.
- **Lightweight iteration loop**: same file path → same URL, redeployed on each edit. Meant to be refined within the conversation, not maintained as a long-lived codebase.
- **Purpose**: a communication/visualization aid — the "show" to the chat's "tell." It's coupled to this conversation, not meant to be *the* deliverable that outlives it.

**Building a real website as a dev project**
- **Full access**: real backend, databases, npm packages, a build system (webpack/vite), routing, server-side rendering, actual deployment (Vercel, your own infra, DNS).
- **Persistent, versioned properly**: lives in a git repo, gets commits/PRs/CI, gets tested (this repo's CLAUDE.md, for instance, requires actually running the dev server and testing in a browser for UI changes) — it has a lifecycle independent of any one chat session.
- **Multi-file, arbitrarily complex**: not limited to one inlined file; can be a whole app with its own architecture.
- **Purpose**: the actual product — meant to be run, deployed, and maintained long-term, viewable by anyone visiting its real URL, not gated behind a chat session.

Rule of thumb: if what you want is a quick, disposable visual (a chart, a mockup, a diagram, a one-off dashboard) that rides along with the conversation, artifact is the right tool — near-zero setup cost. If you want something that needs a real backend, persists outside this chat, gets deployed to production, and evolves as an actual piece of software, that's a dev project in the repo — which is the mode this session is normally in for the second-brain codebase itself (e.g. the Elixir site generator that publishes to GitHub Pages).

---

**[`em:a142be`]**

Technically, yes — a local dev server with hot module reload (Vite, webpack-dev-server, even a dumb file-watcher + browser-sync) gets you the same "edit → see it update instantly" loop. That's a legitimate DIY equivalent for a developer at their own machine.

The coupling that's different isn't the reload mechanism, it's who has to run the infrastructure and where it lives:

- **No viewer-side setup**: an artifact needs nothing from you — no node, no dev server, no port, no localhost. This matters concretely *in this session*: I'm running in an ephemeral cloud container. If I spun up `localhost:3000` here, you couldn't reach it — there's no tunnel, no port exposed to you. A local hot-reload site only works if the dev server and the viewer are on the same machine (or you deliberately expose it). Artifact sidesteps that entirely by hosting it on Claude's infra instead of a process in this container.
- **Lifecycle independence**: this container gets reclaimed when the session ends. A localhost dev server dies with it. The artifact's URL persists after the container is gone — it's decoupled from any running process.
- **Sandboxing is enforced, not just conventional**: the CSP (no external fetches, no CDN, no backend) isn't a stylistic choice you'd have to self-impose on a real website — it's the platform guaranteeing the artifact can't do anything beyond render a static/client-side page, which is part of why it needs no review or hosting decision from you.

So the honest tradeoff: if you're a developer, at your own machine, and want full capability (real backend, packages, persistence as an actual project) — build the website yourself, hot reload included. Artifact exists for the case where you (or someone viewing on their phone, or in a non-dev surface) want a live visual with zero setup and zero infrastructure to maintain, at the cost of being sandboxed and single-file.

---

**[`em:a142be`]**

Yes, once published, the artifact persists independently of this session — it's hosted on Claude's infrastructure with a stable URL, not stored in this container. Even after this session ends and the container is reclaimed, the artifact link keeps working.

Two things worth distinguishing:
- **The URL persists**, and can be reshared, revisited, and re-shared anytime.
- **A fresh session doesn't automatically "know about" it** — a new conversation has no memory of what a prior session published. If you want to *update* an artifact from an earlier session (rather than mint a new one), I'd need either the URL you paste in, or I can call an action to list your previously published artifacts and find it that way.

So it outlives the session, but continuity across sessions is manual — you (or I, via that lookup) have to reconnect to the specific link, it isn't auto-resumed.

---

**[`em:a142be`]**

The new session doesn't have local access to the original file at all — the container that wrote it is long gone. It has to reconstruct the code from the published page itself:

1. **Fetch the live content**: call `WebFetch` on the artifact URL — this pulls down the actual rendered HTML that's currently hosted, which is effectively the source (artifacts are plain HTML/CSS/JS, not compiled/obfuscated).
2. **Write it locally**: save that fetched content into a file in the new session's own scratchpad/workspace, since publishing requires a local file path — you can't publish directly from a URL.
3. **Strip the wrapper**: the fetched page includes the `<!doctype>/<html>/<head>/<body>` skeleton that gets added automatically at publish time. That needs to be peeled back off before editing, since republishing re-wraps the file content into that skeleton — otherwise you'd get a nested double-wrap.
4. **Edit** the now-local file with whatever changes are requested.
5. **Republish to the same URL**: call the Artifact tool again, passing the *original URL* explicitly (not just the file path) — that's what tells the system "update this existing artifact in place" rather than mint a brand-new link.

So the round-trip is: hosted HTML → fetched → reconstructed locally → edited → republished to the same address. The "source of truth" effectively lives at the URL itself, not in any session's filesystem — each session that wants to touch it has to pull it down fresh.
