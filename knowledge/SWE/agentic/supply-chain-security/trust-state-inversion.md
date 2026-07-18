---
id: em:f3beb0
type: reference
title: "Trust-state inversion: when clean code doesn't mean a safe dependency"
description: "A component can become unsafe to depend on because the trust relationships around it collapsed, not because its code changed — illustrated by the 2026 GSD framework governance incident."
resource: https://www.linkedin.com/pulse/when-code-stays-clean-trust-collapses-anyway-opennovations-sdmof
provenance: "Hans de Raad (OpenNovations), LinkedIn article, 2026-05-27"
tags: [supply-chain-security, open-source-governance, agentic-ai, trust, dependency-risk]
timestamp: 2026-07-14T00:00:00Z
attribution:
  when: 2026-07-14T00:00:00Z
  channel: intake
  agent: "operator via /intake, Claude Code session"
  why: "operator pasted a LinkedIn article on AI-agent supply-chain trust risk to file into the brain"
---

# Trust-state inversion

Hans de Raad (OpenNovations) coins **trust-state inversion**: an open source
component becomes unsafe to keep depending on not because its code changed,
but because *the trust relationships around it collapsed* to the point that
continuing to depend on it is no longer safe. Standard security scanning
looks for known vulnerabilities in code; it has no signal for a governance
failure, so this class of risk is invisible to it.

# The GSD incident

The article's case study is "GSD" (Get Shit Done), a popular AI coding
framework, which suffered a governance collapse in May 2026: the maintainer
disappeared and allegedly executed a token rug-pull worth roughly $500,000.
No malicious code was ever found in the package — the technical audit was
clean throughout.

The highest-risk fact was structural, not technical: **the previous
developer still controlled the package's publishing channel on npm.** That
single point of control meant one person retained unilateral power over
every future update to a privileged development tool, independent of
whether the current code was trustworthy.

The Open GSD community fork is cited as the recovery model that worked:
public audits, independent review, honest acknowledgment of the fork's own
limits, and visible disagreement among reviewers (rather than a false
consensus) restored enough trust to keep the tool viable.

# A seven-dimension maturity framework

De Raad proposes extending open-source project maturity models to cover the
agentic-AI era, across seven dimensions:

1. **Registry governance** — who controls the publishing key.
2. **Release authority distribution** — separation of duties across releases.
3. **Succession and bus factor** — documented handover processes.
4. **Financial entanglement** — undisclosed incentive structures behind maintainers.
5. **Build and package provenance** — reproducibility and signing.
6. **Agent privilege transparency** — honest documentation of what guardrails an agent actually has.
7. **Dependency autonomy controls** — requiring human approval before an agent can add/upgrade dependencies.

# Operational response

Three continuous loops are recommended for teams depending on agentic
tooling: an **adoption review** loop (vetting before pulling a component
in), a **runtime monitoring** loop (dependency pinning, sandboxing AI
tools), and a **rehearsed incident-response playbook** for when a
governance collapse like GSD's happens anyway.

# Citations

- Hans de Raad, "When the Code Stays Clean and the Trust Collapses Anyway,"
  LinkedIn Pulse, 2026-05-27 —
  https://www.linkedin.com/pulse/when-code-stays-clean-trust-collapses-anyway-opennovations-sdmof
