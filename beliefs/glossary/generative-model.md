---
id: sb:10e9cb
type: concept
title: generative model
description: A model that learns the joint distribution of its data so it can generate new samples resembling the training set, as opposed to a discriminative model that only learns to map inputs to labels.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, machine-learning, generative-models]
timestamp: 2026-07-12
---

# generative model

A model that captures how the data itself is distributed — the joint distribution over inputs (and, when present, labels) — so it can synthesize new samples that resemble the training data, and fill in or denoise partial inputs. This contrasts with a *discriminative* model, which learns only the conditional mapping from input to label. A [deep belief network](/beliefs/glossary/deep-belief-network.md) is a generative model; so are VAEs, GANs, and diffusion and autoregressive models.

*Seen in:* [2026-07-12 deep-belief-networks research spike](/meta/threads/2026-07-12-deep-belief-networks-research-spike-and-refile.md)
