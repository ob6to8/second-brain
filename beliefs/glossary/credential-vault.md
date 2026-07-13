---
id: sb:aea1cb
type: concept
title: credential vault
description: A store that holds a secret outside the process that uses it and substitutes the real value into outbound requests at egress, so the running (possibly untrusted) code sees only an opaque placeholder — containing the blast radius of prompt injection or code compromise to what the egress boundary allows.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, security, credentials, secrets, egress, agents]
sense: common
timestamp: 2026-07-12
attribution:
  when: 2026-07-12T15:12:24+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# credential vault

A store that keeps a secret *out of* the process that uses it. The running code — an agent's sandbox, a worker container — holds only an opaque placeholder; the real token is substituted into the outbound request at the **egress** boundary, on requests to allowed hosts only. Because the secret never enters the executing environment, code running there cannot read or exfiltrate it even under [prompt injection](/beliefs/glossary/prompt-injection.md) — which directly narrows the injection surface that enables [epistemic poisoning](/beliefs/glossary/epistemic-poisoning.md). [Claude Managed Agents](/beliefs/glossary/claude-managed-agents.md) implements this for both MCP OAuth tokens (auto-refreshed) and environment-variable secrets.

*Seen in:* [Managed Agents vs. Jido/BEAM analysis](/meta/analysis/claude-managed-agents-vs-beam-jido.md)
