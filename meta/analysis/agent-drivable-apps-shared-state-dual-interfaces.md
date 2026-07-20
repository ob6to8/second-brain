---
type: analysis
title: "Agent-drivable applications: is shared-state/dual-interface control the architecture that dissolves the human review bottleneck?"
description: Investigates the emerging pattern in which a human-facing application and an agent-facing structured API are two clients of the same live process state — grounded in a comparative reading of Warp.dev, Claude Code, and hunk, and in two live demonstrations run this session (driving a hunk viewer through its session daemon; discovering and driving the operator's running nvim instances over their auto-created RPC sockets) — and concludes the pattern is the post-chat shape of agent-human collaboration: latent for structural reasons now expiring, threatening to unbundle the AI-IDE, enabled by MCP's N+M collapse, and gated not by capability but by an unbuilt trust model whose security-critical component is a capability-scoped broker — the same shape as this bundle's independently derived write-gatekeeper.
provenance: "Claude Code session (claude-fable-5), 2026-07-17/18, run inside Warp — operator asked to compare Claude Code and Warp.dev diff-review and agent capabilities, then hunk (modem-dev); the session installed hunk v0.17.0 and empirically drove both a live hunk viewer session and the operator's two running nvim instances over their RPC sockets, then the discussion expanded into workflow implications, AI-IDE incentives, MCP as enabling technology, and sandboxed execution (Fly.io Sprites) as a trust-model answer. Warp facts from docs.warp.dev; hunk facts from github.com/modem-dev/hunk and direct CLI use; nvim facts verified live against v0.11.2"
tags: [meta, analysis, agents, architecture, rpc, mcp, nvim, hunk, warp, review-bottleneck, trust-model, ipc, dual-interface]
timestamp: 2026-07-18
attribution:
  when: 2026-07-18T06:15:00Z
  channel: agent-authored
  agent: "Claude Code agent, drivable-apps session"
  why: "persists the session's comparative findings, live demonstrations, and reasoned judgment on the drivable-app architecture before the conversation scrolls off"
  from: [/meta/threads/2026-07-18-agent-drivable-apps-warp-hunk-nvim.md]
---

# Agent-drivable applications: is shared-state/dual-interface control the architecture that dissolves the human review bottleneck?

**Question.** Agents now produce code and knowledge faster than humans can
review it in chat transcripts. A pattern is surfacing across independent tools —
Warp.dev's interactive code review, hunk's agent session API, Neovim's RPC
architecture — in which a human-facing UI and an agent-facing structured API
operate as two clients of the same live application state. Is this pattern the
real successor to chat-window collaboration, why has it been latent so long,
what breaks (and whose business model) if it wins, and what would make it safe?

**Thesis.** Yes — call the pattern **shared state, dual interfaces**: the human
gets pixels, the agent gets JSON, and neither scrapes the other. It is the
cheapest correct answer to agent access (structured process-layer IPC beats both
terminal-layer keystroke injection and pixel-level computer use), it was proven
live on this machine with zero setup because the control planes already exist,
and it re-frames review from *reading transcripts* to *being guided through
your own tools*. It has been latent because its only interesting user — a
competent autonomous agent — is about two years old, because the platforms
spent fifteen years hardening against inter-app control, and because the
vendors best resourced to build it are incented to build its opposite. MCP is
the standardization that collapses the integration cost from N×M to N+M. The
open question is not capability but trust: sandboxed execution (Fly.io
Sprites) solves *who the agent is on your machine* but not *what you have
authorized it to touch*; the security-critical component is a capability-scoped
broker at the boundary — the same architectural shape this bundle independently
derived as its [write-gatekeeper](/meta/analysis/claude-managed-agents-vs-beam-jido.md).

## Three products, one bottleneck

The comparative landscape that opened the session resolves into three positions
on the same problem — the human as review bottleneck for agent output:

- **Warp.dev** (proprietary terminal, "Agentic Development Environment") owns
  the *surface*: a GUI Code Review panel (hunk-level revert, inline diff
  editing) and an Interactive Code Review loop — batch inline comments anchored
  to lines, submitted to the running agent, which returns an updated diff.
  Notably it hosts third-party CLI agents (Claude Code among ~10) and layers
  its review UI over them; they bill through their own subscriptions.
- **Claude Code** owns the *depth*: effort-scaled local review, multi-agent
  verified cloud review, scriptable workflow orchestration, automatic worktree
  isolation — models reviewing changes, rather than a UI for a human to.
- **hunk** (modem-dev, MIT, TypeScript/OpenTUI) is the purpose-built third
  position: a viewer-only TUI, "review-first for agentic coders," whose
  differentiator is a local session daemon (websocket broker on loopback)
  through which *an agent drives the viewer* — navigating the human to hunks,
  attaching line-anchored annotations — and which ships a SKILL.md teaching
  agents its own protocol (`hunk skill path`).

Warp and hunk are the two halves of one loop, inverted: in Warp the human
comments toward the agent; in hunk the agent narrates toward the human. Neither
side owns both halves yet.

## The mechanism, demonstrated

The load-bearing distinction is **terminal-layer vs. process-layer control**.
Terminal-layer driving (tmux/cmux `send-keys` + screen scraping) is the
universal adapter for programs that expose no API: it impersonates a human at
the keyboard, cannot receive return values, and fails silently when mode or
focus is wrong. Process-layer control is a structured API between two processes
over OS-level IPC — the terminal emulator contributes nothing but pixels.

Both were demonstrated live this session, on this machine:

- **hunk**: installed v0.17.0; a backgrounded `hunk show <commit>` registered
  with the session daemon (reporting `terminal: WarpTerminal`); from a second
  process, `hunk session` subcommands listed the session, navigated it by
  file/hunk (returning hunk line-ranges as JSON), and attached a line-anchored
  review comment — whose id came back prefixed `mcp:`, suggesting the protocol
  is MCP-shaped under the hood even though nothing MCP-facing ships yet.
- **nvim**: the operator's two *already-running* instances (v0.11.2) were
  discovered by listing `$TMPDIR/nvim.mark/` — nvim ≥0.10 auto-listens on a
  MessagePack-RPC socket with no configuration — then queried read-only
  (`--remote-expr`: open file, cursor line) and finally driven visibly: a Lua
  snippet executed via `luaeval(dofile(...))` opened a self-dismissing floating
  window inside the operator's live editor. No keystrokes injected, no plugin
  installed, focus untouched, mode-independent.

The nvim case is the sharper evidence because the capability was *ambient*: the
sockets were listening before the session began. Classic vim has no such
server; nvim's API-first architecture (GUIs and embeddings are all RPC clients)
made it agent-ready a decade before agents existed.

## Why latent rather than widespread

Five compounding forces, roughly by weight:

1. **The demand side is two years old.** These control planes were built for
   plugins and GUI embedders; "a program that intelligently drives your
   editor" had no author before capable agents.
2. **Both ends of the stack absorbed the demand.** Agents that change code
   edit files (bypassing the app); agents that must operate a GUI use
   computer-use screenshots and clicks (impersonating the human). The middle —
   structured control of the running app the human is watching — only matters
   when the human's live attention is in the loop, which is precisely the
   review problem now biting.
3. **Platforms hardened against it for fifteen years.** Inter-app control is
   mechanically indistinguishable from malware: Wayland exists substantially to
   stop input injection, macOS wrapped scripting in TCC consent. Loopback
   sockets between same-user processes survived as a loophole, not a sanctioned
   pattern — which is also why they carry no auth.
4. **No standard, so no ecosystem.** msgpack-RPC, CDP, DBus, AppleScript,
   hunk's websocket broker — every drivable app speaks its own dialect: an N×M
   integration cost nobody paid for niche automation.
5. **Vendor incentives point at owning the surface**, not dissolving into the
   user's existing tools (expanded below).

## Workflow implications: the agent as presenter

The corrected shape of review: **"show me" replaces "tell me."** The agent
finishes a change, opens the touched files in *the operator's* editor,
populates a quickfix list with one entry per decision worth reviewing, jumps
hunk to hunk, floats rationale beside each; the reverse channel (buffer
comments fired back over the socket) turns it into a loop at editor speed.
Parallel review becomes tabbing between live sessions over separate worktrees.
The bottleneck stops being rendering-comprehension and becomes pure judgment —
the part that actually needs the human.

The pattern generalizes to every app with an existing automation surface:
Chrome via CDP (demonstrate the fix in the user's live browser), the dormant
AppleScript/COM/DBus estates, OBS/Blender/iTerm2/kitty. The OS becomes an
orchestra of long-running apps, each holding a stateful session with the agent,
each remaining the human's own. This also collapses local-vs-composition Unix
tradition: composition moves from stateless text through pipes to stateful,
bidirectional sessions between long-running programs.

## The economics: unbundling the AI-IDE

Nothing *technically* prevents AI-IDEs from this paradigm — the honest
characterization is architectural omission driven by incentive, plus one real
gap (VS Code has no first-class external RPC surface; no `--listen`
equivalent; drivability must be bolted on per-editor via extensions). The
incentive analysis: the AI-IDE sells a **bundle** — surface + agent harness +
model access — rented monthly and defended by switching costs. The drivable-app
paradigm unbundles all three: the model is a commodity API, the harness is a
CLI process that runs anywhere, and the surface — the only part the IDE owns —
demotes to one client among several, competing against the editor the user
already has twenty years of muscle memory in. Once any agent can drive any
editor over an open protocol, the editor cannot tax the agent, and value
collapses toward whoever owns the intelligence. Both directions of
commoditize-your-complement are visibly in play: model labs push open protocols
(MCP) to commoditize surfaces and sell intelligence; IDE vendors push closed
integration to differentiate surfaces and resell intelligence at markup. Warp's
universal-agent hosting is the hedge position (concede the agent, own the
review surface); Cursor's closedness is the opposite bet; the nvim
demonstration is the existence proof that the surface bet is fragile.

## MCP as the enabling technology

MCP collapses N×M to N+M with design choices that map exactly onto the
pattern: JSON-RPC 2.0 over pluggable transports, crucially **stdio for local
child processes** (a wrapper server spawns, connects to the app's native
socket, translates); **runtime capability discovery** with JSON Schema per tool
(`tools/list`), eliminating the prose-documented-CLI failure mode the session
itself exhibited (flag-guessing against `hunk session`'s help text);
**long-lived stateful sessions** matching long-lived apps; **server→client
notifications** supplying the reverse channel ("user commented on hunk 3");
and **vendor neutrality**, making an app wrapper worth an afternoon instead of
a partnership. What MCP does not yet solve: auth on local transports (file
permissions and hope) and server discovery (nascent registries).

## The unsolved half: trust

The demonstrations double as the threat model: those nvim sockets were
reachable by *any* process running as the operator — including any agent, or
any compromised `npm` postinstall — with file permissions as the entire access
control. Same-user-equals-full-trust breaks when semi-trusted autonomous
processes run as you all day.

Sandboxed execution (Fly.io Sprites: disposable microVMs, persistent
filesystems, checkpointing) addresses exactly half of this. It **removes
ambient authority** (the agent is no longer the same user on the same kernel;
the sockets are simply not addressable), **contains the supply chain**
(postinstall scripts detonate in a disposable VM; note this is strictly
stronger than worktree isolation, which isolates files but not IPC), and
**forces the auth story to exist** (across a machine boundary, every
capability must be an explicit, authenticated, auditable channel — the network
makes implicit reach impossible). But it amputates the presentation channel
the paradigm exists for; restoring it requires a **broker** on the workstation
exposing a narrow API (`open_file`, `annotate_hunk`) rather than raw socket
access — and the trust problem moves into the broker's API design. And
isolation contains *code, not intent*: a prompt-injected agent in a pristine
sandbox faithfully misuses whatever capabilities were granted across the
boundary. The likely end state: agent brain and untrusted execution in the
sandbox, a capability-scoped broker on the workstation for presentation into
live tools — with the broker, not the sandbox, as the security-critical
component.

## Bearing on this bundle

- **The broker convergence is design confirmation.** The capability-scoped
  broker this analysis arrives at from the presentation direction is the same
  shape as the owned **write-gatekeeper** of
  [Claude Managed Agents vs. Jido/BEAM](/meta/analysis/claude-managed-agents-vs-beam-jido.md)
  and the librarian write-broker of the
  [dark-factory analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md)
  — derived there from governing corpus mutation, here from governing reach
  into the operator's live tools. Two independent derivations of
  narrow-owned-choke-point strengthen it as this system's standing answer to
  agent authority.
- **Agent-as-presenter names a mechanism for the orchestrator role.** The
  [alignment analysis](/meta/analysis/alignment-with-the-orchestrator-role.md)
  ranks quality evaluation among the orchestration domains; guided in-editor
  review tours are a concrete mechanism for the operator's judgment pass over
  session PRs, at editor speed rather than transcript speed.
- **The tier-2 MCP tool server gains a second rationale.** The
  [BEAM deployment analysis](/meta/analysis/beam-deployment-and-jido-2-evaluation.md)
  maps an MCP tool server as a future tier; this analysis adds the
  presentation-surface case, and the
  [`defverb`-style macro](/meta/analysis/elixir-ast-macros-for-llm-harnesses.md)
  emits exactly the schema surface MCP tools need.
- **Operational residue.** hunk v0.17.0 is now installed on the operator's
  machine (Homebrew tap). It is a live candidate for the operator's PR-review
  loop over agent-authored diffs — `hunk show`/`hunk diff` before merging
  session PRs, with `--watch` during active sessions.

**Recommendation.** Treat shared-state/dual-interface control as the working
model for how this system's agents should eventually reach the operator's
attention: adopt hunk experimentally in the PR-review loop now; when the
tier-2 MCP tool server is built, design it broker-first (narrow verbs,
capability-scoped, logged) rather than exposing raw internals; and defer any
local-socket integration that lacks an auth story — the pattern's spread is
assured, its trust model is not, and this bundle's leverage is that it already
owns the choke-point architecture the safe version requires.
