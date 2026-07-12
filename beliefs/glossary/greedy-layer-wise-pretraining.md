---
id: sb:fbab7f
type: concept
title: greedy layer-wise pretraining
description: An unsupervised training strategy that builds a deep network one layer at a time — each layer trained on the representation produced by the layer below it — before any end-to-end fine-tuning.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, deep-learning, machine-learning, training, unsupervised-learning]
timestamp: 2026-07-12
---

# greedy layer-wise pretraining

Introduced with the [deep belief network](/beliefs/glossary/deep-belief-network.md): train the bottom layer on the raw data, freeze it, then use the latent activations it infers as the training data for the next layer up. It is *greedy* because each layer is optimized in isolation rather than jointly, and the absence of labels means it can exploit unlabeled data; the optional fine-tuning pass that follows may be supervised or generative. Historically it made very deep networks trainable before better initializations and activation functions removed the need for it.

*Seen in:* [2026-07-12 deep-belief-networks research spike](/meta/threads/2026-07-12-deep-belief-networks-research-spike-and-refile.md)
