---
id: sb:49eae4
type: reference
title: "State of AI Coding 2026 (New Relic) — the trust-vs-reliability gap"
description: A survey of 200 US technology leaders finding AI now writes most weekly code and is trusted enough to ship without line-by-line review (62%), even as it drives measurable production-incident spikes — the data case for testing features/behavior over reading every line.
resource: https://newrelic.com/blog/ai/state-of-ai-coding-2026
provenance: "Distilled from New Relic's State of AI Coding 2026 (Jim Young; research by Hanover Research), fetched 2026-07-11"
tags: [testing, ai-generated-code, verification, agentic-coding, survey, reliability]
timestamp: 2026-07-11
---

# State of AI Coding 2026 (New Relic) — the trust-vs-reliability gap

A first-party survey (New Relic, pub. 2026-06-10; 200 US manager+ technology
decision-makers, fielded by Hanover Research) documenting how far AI-generated code
has moved into production — and the verification gap that opened behind it.

## The findings

**Adoption is now the default.**

- 67% say AI generates or significantly refactors **51–75% of weekly code**.
- 95% of orgs authorize machine-generated code in production (87.5% formally).

**Trust outran verification.**

- 94% rate AI code as *higher* quality than human code during review, and **62% of
  leaders often/always ship it without line-by-line manual verification**.

**Reliability tells a different story.**

- 78% report **production-incident spikes** tied to AI code; 82% had ≥1 major
  AI-caused production failure in six months.
- AI code introduces **~1.7× more critical runtime issues** than peer-reviewed
  human code; 74% say ≥25% of AI code needs significant post-deployment rework.
- 78% now routinely prompt AI to emit logging/span/metric hooks up front —
  observability compensating for unread code.

## Why it matters for the brain

Hard data under
[test features, not code](/SWE/testing/how-to-test-features-not-code.md): when the
author no longer reads every line, correctness has to be established by exercising
*behavior*, not by line-level review. The survey quantifies the regime that testing
philosophy assumes — high-volume, high-trust, under-verified AI code — and the cost
(runtime incidents, rework) of skipping the behavioral check.

# Citations

New Relic — State of AI Coding 2026 —
<https://newrelic.com/blog/ai/state-of-ai-coding-2026>
