---
id: sb:b53ee1
type: concept
title: complementary priors
description: A construction, introduced by Hinton, Osindero & Teh, that cancels the "explaining-away" correlations between hidden causes in a directed belief net, making a deep model's hidden layers conditionally independent and so tractable to learn one layer at a time.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, deep-learning, machine-learning, graphical-models]
sense: common
timestamp: 2026-07-12
attribution:
  when: 2026-07-12T16:43:47+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# complementary priors

The technical device at the heart of the 2006 [deep belief network](/beliefs/glossary/deep-belief-network.md) result. In a directed [belief network](/beliefs/glossary/belief-network.md), observing data makes a node's hidden parents compete to explain it ("explaining away"), which correlates them and makes inference intractable. A complementary prior is an extra distribution deliberately shaped to exactly cancel those correlations, restoring conditional independence among the hidden units — which is what lets each layer be learned greedily and independently as a [restricted Boltzmann machine](/beliefs/glossary/restricted-boltzmann-machine.md).

*Seen in:* [2026-07-12 deep-belief-networks research spike](/meta/threads/2026-07-12-deep-belief-networks-research-spike-and-refile.md)
