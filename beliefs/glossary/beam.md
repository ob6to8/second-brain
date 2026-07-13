---
id: sb:b2dc54
type: concept
title: BEAM
description: The virtual machine that runs Erlang and Elixir, built around huge numbers of lightweight, heap-isolated processes with preemptive scheduling and message passing — the substrate whose distinctive affordances (supervision, fault isolation, hot code upgrades) target long-running concurrent services.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, beam, erlang, elixir, runtime]
sense: common
timestamp: 2026-07-12
---

# BEAM

The virtual machine that runs Erlang and Elixir. Its signature design is huge numbers of lightweight processes — each with its own isolated heap, preemptively scheduled, communicating only by message passing (the [actor model](/beliefs/glossary/actor-model.md)) — which makes fault containment, per-process supervision, and hot code upgrades natural properties rather than add-ons. Those affordances pay off for long-running concurrent services; a one-shot batch program uses none of them, which is why this brain's [dependency-free](/beliefs/glossary/dependency-free.md) tooling runs *on* the BEAM without being *a BEAM system*.

*Seen in:* [BEAM/Jido evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md), [dark-factory scenario analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md)
