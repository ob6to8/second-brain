---
id: sb:e19e32
type: concept
title: wake-sleep algorithm
description: An unsupervised training procedure for layered generative networks that alternates a "wake" phase (adjust generative weights from data-driven recognition) with a "sleep" phase (adjust recognition weights from the model's own generated samples).
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, deep-learning, machine-learning, training, unsupervised-learning]
timestamp: 2026-07-12
---

# wake-sleep algorithm

The recognition weights run bottom-up, the generative weights top-down. Waking, inputs are passed up through the recognition weights and the generative weights are nudged to better reconstruct them; sleeping, the network dreams up samples from its generative model and the recognition weights are nudged to better infer their hidden causes. A contrastive variant is used to fine-tune a [deep belief network](/beliefs/glossary/deep-belief-network.md) after [greedy layer-wise pretraining](/beliefs/glossary/greedy-layer-wise-pretraining.md).

*Seen in:* [2026-07-12 deep-belief-networks research spike](/meta/threads/2026-07-12-deep-belief-networks-research-spike-and-refile.md)
