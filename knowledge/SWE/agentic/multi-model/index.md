# Multi-model

Working across multiple model providers in coding-agent workflows — escaping
single-provider lock-in while preserving the dev ergonomics (sandbox, mobile,
persisted threads, PR-review GUI) that a single-vendor app bundles.

## Notes

- [Escaping single-provider lock-in in agentic coding tooling](/knowledge/SWE/agentic/multi-model/provider-agnostic-coding-agent-tooling.md) — the landscape (chat-first, agent-first, PR-review workflows), the tool-calling seam that leaks quality across providers, and the decision to go PR-based first. _(note)_

## Snippets

- [Cross-model PR review GitHub Action](/knowledge/SWE/agentic/multi-model/cross-model-pr-review-github-action.md) — drop-in workflow so a different model reviews each PR than the one that authored it, posting inline diff-anchored comments. _(snippet)_
