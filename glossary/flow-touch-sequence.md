---
id: sb:950a55
type: concept
title: flow (touch-sequence)
description: A documentation artifact that traces a single canonical run of a workflow as an ordered sequence of every file it touches, tagging each step with its actor — distinct from a rules doc, a why-tutorial, or a pass/fail checklist.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, flows, testing, documentation]
timestamp: 2026-07-10
---

# flow (touch-sequence)

A documentation artifact that traces a single canonical run of a workflow as an ordered sequence of every file it touches, describing what happens at each point and tagging each step with its actor. It is distinct from a rules doc (the "what"), a why-tutorial, and a pass/fail verification checklist; in this brain flows live under `meta/flows/` and are backed by scenario tests over the flow's deterministic spine.

*Seen in:* [2026-07-09 flows-genre thread](/meta/threads/2026-07-09-flows-genre-and-scenario-testing.md)
