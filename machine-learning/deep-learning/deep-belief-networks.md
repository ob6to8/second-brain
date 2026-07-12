---
id: sb:1370e8
type: concept
title: "Deep belief network"
description: A generative neural network built as a stack of restricted Boltzmann machines, trained greedily one layer at a time, whose 2006 layer-wise learning algorithm helped reignite deep learning.
resource: "https://www.cs.toronto.edu/~hinton/absps/fastnc.pdf"
tags: [machine-learning, deep-learning, neural-networks, generative-models, graphical-models, restricted-boltzmann-machine, unsupervised-learning, hinton]
timestamp: 2026-07-12
---

# Deep belief network

A **deep belief network (DBN)** is a generative neural network that models a
probability distribution over its inputs by stacking several layers of latent
(hidden) variables. It was introduced by Hinton, Osindero, and Teh in 2006, whose
fast layer-wise training algorithm made deep architectures practical to learn for
the first time and is widely credited with helping reignite the modern deep-learning
era.

## "Belief network" — the term

A **belief network** (equivalently a *Bayesian network*) is a directed acyclic graph
of stochastic variables in which each variable's distribution is conditioned on its
parents. A DBN is a *deep* one: many stacked layers of hidden variables, where the
higher layers are meant to capture increasingly abstract features of the data. The
word "belief" is the graphical-models sense — a probabilistic dependency structure —
and carries no connotation of confidence or opinion.

## Architecture

A trained DBN is a hybrid graphical model:

- The **top two layers form a restricted Boltzmann machine (RBM)** — an *undirected*
  associative memory whose two layers are fully connected to each other but have no
  within-layer connections.
- **Every layer below is directed**, with **top-down generative connections** (a
  sigmoid belief net). To generate data, the model settles the top RBM into a state,
  then propagates downward through the directed layers to the visible units.

Equivalently, a DBN is a **stack of RBMs**: the hidden layer of one RBM serves as the
visible layer of the next.

## Training: greedy layer-wise learning

The 2006 contribution was a fast, **greedy, layer-wise** learning procedure that
sidestepped the *explaining-away* problem (spurious correlations between hidden causes
that had made deep directed belief nets intractable to train), using a construction
Hinton called **complementary priors**:

1. Train the bottom RBM on the raw data using **contrastive divergence** (an
   approximate, fast alternative to exact maximum-likelihood learning).
2. Freeze it, and use the latent activations it infers from the data as the *training
   data* for the next RBM up.
3. Repeat, stacking layer on layer. Each added layer provably improves a variational
   bound on the model's likelihood of the data.
4. Optionally **fine-tune** the whole stack afterward — generatively with a contrastive
   version of the **wake-sleep** algorithm, or discriminatively with backpropagation
   once a label layer is attached.

Because the layer-wise phase is **unsupervised**, a DBN can learn useful hierarchical
feature representations from unlabeled data, which can then initialize a supervised
network — the "unsupervised pre-training" idea that made very deep networks trainable
before better initializations and activation functions existed.

## What it is used for

- A **generative model** — it can sample new data resembling the training set, and
  fill in or denoise partial inputs.
- **Unsupervised representation learning** — the stacked hidden layers yield a
  hierarchy of distributed feature detectors used to initialize classifiers.

## Significance and status

DBNs were a landmark: they demonstrated that deep networks *could* be trained
effectively and drove the resurgence of neural-network research after 2006. They have
since been largely **superseded** in practice — rectified-linear activations, dropout,
better weight initialization, and large labeled datasets made greedy RBM pre-training
unnecessary for most tasks, and other generative families (VAEs, GANs, autoregressive
and diffusion models) overtook them. The DBN is now studied mostly for its historical
and conceptual importance.

# Citations

- Hinton, G. E., Osindero, S., & Teh, Y.-W. (2006). *A Fast Learning Algorithm for
  Deep Belief Nets.* Neural Computation 18(7): 1527–1554.
  <https://www.cs.toronto.edu/~hinton/absps/fastnc.pdf>
- Hinton, G. E. *Deep belief networks.* Scholarpedia.
  <http://www.scholarpedia.org/article/Deep_belief_networks>

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="sb:1370e8">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-12-deep-belief-networks-research-spike-and-refile (2026-07-12)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`sb:1370e8`]**

Done. Here's the spike.

**What Hinton's deep belief networks are**

A **deep belief network (DBN)** — from Hinton, Osindero & Teh's 2006 *A Fast Learning Algorithm for Deep Belief Nets* — is a generative machine-learning model built as a **stack of Restricted Boltzmann Machines**. After training, the top two layers form an undirected associative memory (an RBM) and every layer below is directed with top-down generative connections. It's *learned, not authored*: a greedy **layer-wise** algorithm trains one RBM at a time via contrastive divergence, using each layer's inferred latent values as the next layer's data, then optionally fine-tunes the whole stack. Its purpose is learning **hierarchical, distributed latent feature representations** of data without labels. Historically it ignited the 2006 deep-learning revival; it's since been largely superseded and is now mostly of historical interest.

Note the term: "belief net" is **Pearl's** — a directed acyclic graph of *stochastic* variables where edges are conditional-probability dependencies.
