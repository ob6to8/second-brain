---
id: em:fd9873
type: concept
title: restricted Boltzmann machine
description: A two-layer undirected generative network (visible and hidden units) whose bipartite connectivity — no within-layer edges — makes the hidden units conditionally independent given the visible ones, so it can be trained efficiently.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, deep-learning, neural-networks, generative-models]
sense: common
timestamp: 2026-07-12
attribution:
  when: 2026-07-12T16:43:47+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# restricted Boltzmann machine

A two-layer undirected neural network — one layer of visible units and one of hidden units — that learns a probability distribution over its inputs. The "restricted" part is the bipartite connectivity: units connect only across layers, never within one, which makes each layer conditionally independent given the other and enables efficient training by [contrastive divergence](/beliefs/glossary/contrastive-divergence.md). Stacking RBMs is what builds a [deep belief network](/beliefs/glossary/deep-belief-network.md).

*Seen in:* [2026-07-12 deep-belief-networks research spike](/meta/threads/2026-07-12-deep-belief-networks-research-spike-and-refile.md)
