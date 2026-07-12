---
id: sb:e1e447
type: concept
title: contrastive divergence
description: A fast approximate training algorithm for restricted Boltzmann machines that updates weights from a short (often single-step) Gibbs-sampling run instead of the intractable exact maximum-likelihood gradient.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, deep-learning, machine-learning, training]
timestamp: 2026-07-12
---

# contrastive divergence

An approximate learning algorithm, introduced by Hinton, for training [restricted Boltzmann machines](/glossary/restricted-boltzmann-machine.md) and similar energy-based models. Computing the exact maximum-likelihood gradient is intractable, so contrastive divergence estimates it from a short run of Gibbs sampling — often just one step — started at the training data, trading exactness for speed. It is the per-layer learning step inside [greedy layer-wise pretraining](/glossary/greedy-layer-wise-pretraining.md).

*Seen in:* [2026-07-12 deep-belief-networks research spike](/meta/threads/2026-07-12-deep-belief-networks-research-spike-and-refile.md)
