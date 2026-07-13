---
id: sb:fbab7f
type: concept
title: greedy layer-wise pretraining
description: An unsupervised training strategy that builds a deep network one layer at a time — each layer trained on the representation produced by the layer below it — before any end-to-end fine-tuning.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, deep-learning, machine-learning, training, unsupervised-learning]
sense: common
timestamp: 2026-07-12
---

# greedy layer-wise pretraining

A strategy for training deep networks introduced with the [deep belief network](/beliefs/glossary/deep-belief-network.md): train the bottom layer on the raw data, freeze it, then use the latent activations it infers as the training data for the next layer up, repeating layer by layer. It is *greedy* because each layer is optimized in isolation rather than jointly, and typically *unsupervised* (no labels), so it can exploit unlabeled data; an optional supervised or generative fine-tuning pass follows. Historically it made very deep networks trainable before better initializations and activation functions removed the need for it.

*Seen in:* [2026-07-12 deep-belief-networks research spike](/meta/threads/2026-07-12-deep-belief-networks-research-spike-and-refile.md)
