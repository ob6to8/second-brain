---
id: sb:eb67ce
type: concept
title: reducer
description: A pure function that folds a current state and an action into a new state (and, in effectful variants, a list of declared side effects), making state transitions total, unit-testable without their environment, and replayable from an action log — the Redux/Elm pattern.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, functional-programming, state, redux, elm, architecture]
sense: common
timestamp: 2026-07-12
---

# reducer

A pure function of the form `(state, action) → new_state` — the core of the Redux and Elm architectures. Because it is pure and total, every transition is unit-testable with no network or environment, and the current state is reconstructable as a fold over the action log (replayability). In *effectful* variants the reducer returns `(new_state, directives)` — side effects are **declared as data** the runtime interprets, not performed as hidden byproducts, which lets invariants over the effect stream be checked structurally (e.g. "no commit directive without a preceding verification action"). [Jido](/beliefs/glossary/jido.md)'s `cmd/2` is this pattern applied to an agent runtime; its purity ends where a model call begins, giving a deterministic, auditable harness around a stochastic core.

*Seen in:* [Managed Agents vs. Jido/BEAM analysis](/meta/analysis/claude-managed-agents-vs-beam-jido.md)
