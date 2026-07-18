---
id: em:68279d
type: methodology
title: "Escalating-example exposition"
description: "A presentation playbook distilled from Yos Riady's ECS article: open inside one concrete scenario, escalate that same example until the current design visibly breaks, name the problem only after the reader has felt it, then rebuild with the alternative using the same cast — so complex-domain challenges are experienced through a memorable miniature rather than asserted."
provenance: "Distilled by a Claude Code agent from the communication structure of Yos Riady's 'Entity Component Systems in Elixir' (2016), at the operator's request, 2026-07-18"
tags: [technical-communication, writing, exposition, pedagogy, examples, tone, methodology]
timestamp: 2026-07-18T14:01:55Z
attribution:
  when: 2026-07-18T14:01:55Z
  channel: intake
  agent: "operator via /intake, Claude Code session"
  why: "operator asked whether the ECS article's clear, simply-exampled presentation could be modeled as communication principles and kept as a reference for tone and how to present ideas"
---

# Escalating-example exposition

A repeatable method for presenting a complex technical idea, distilled from
the communication structure of
[Yos Riady's ECS article](/knowledge/SWE/software-design/entity-component-systems-in-elixir.md)
— kept here as the bundle's reference for *tone and how to present ideas*.
The article never announces "inheritance hierarchies are inflexible"; it
builds a bunny, asks for a Killer Bunny, and lets the hierarchy fail in front
of you. The method below is that move, generalized.

## The principles

1. **Open inside a scenario, not with a definition.** Start where the reader
   already has intuition (a game with bunnies and whales; an inventory with
   one product). Definitions come later, attached to something concrete.
2. **Cast one memorable miniature world and reuse it everywhere.** A small,
   slightly playful cast (bunny, whale, killer bunny, carrot, ghost) recurs
   through the whole piece. Memorability is load-bearing: because the reader
   retains the cast, each new concept costs less to introduce.
3. **Escalate the same example until the design breaks.** Don't switch
   examples to show a new problem — *raise the stakes on the current one*.
   The Killer Bunny is one requirement added to a working design; its arrival
   is what exposes rigidity, the diamond problem, and the blob. The
   escalation dramatizes the challenge of the complex domain instead of
   asserting it.
4. **Let the reader feel the failure before you name it.** The pain comes
   first, the vocabulary second ("…this ambiguity is called the diamond
   problem"). A term introduced after its motivating failure is a label for
   an experience; introduced before, it is jargon.
5. **Rebuild with the same cast.** Present the alternative by re-solving the
   *exact* scenario that just failed — the bunny reassembled from
   components. Reusing the cast turns the comparison into a controlled
   experiment: only the architecture changed.
6. **Introduce one term per need, at the moment of need.** Minimal
   vocabulary, defined on first use, never before the design motivates it.
7. **Escalate representation alongside argument.** Diagrams → pseudocode →
   real code, in that order: each rendering of the idea is one notch more
   precise than the last, and none arrives before the prose has earned it.
8. **Keep explanatory sentences short; spend long sentences on
   transitions.** Declarative, conversational tone for the mechanics; the
   longer sentences do the connective work between ideas.
9. **Concede costs and roughness plainly.** Name the challenges of your own
   proposal (communication between components, system ordering, obscurity)
   and the limits of your artifact ("may be a bit rough around the edges").
   The concession buys trust for the claims.
10. **Close by generalizing outward.** End one level above the subject:
    what the reader should now do in *other* domains ("branching out into
    unfamiliar domains is a fruitful source of new ideas") — the essay's
    idea, made portable.

## When to use

Best for introducing an *architecture, pattern, or mental model* to readers
who know the general field but not this idea — especially when the idea's
value only shows under complexity that a definition can't convey. Overkill
for reference material, changelogs, or audiences who already share the
motivating pain (state the conclusion first for them).

## Checklist for a draft

- Does the piece open inside a scenario the reader can picture?
- Is there one cast, and does it appear in every section?
- Does something *break on the page* before the alternative appears?
- Is every term introduced after its motivating failure?
- Is the alternative demonstrated on the same scenario that failed?
- Are costs and limitations conceded explicitly?
- Does the ending generalize beyond the subject?

## Demonstrations in this bundle

- [Is ECS in Elixir viable beyond gaming?](/meta/analysis/ecs-beyond-gaming-in-elixir.md)
  — an analysis deliberately written with this method (inventory → drone
  fleet → trading-firm counter-example), filed in the same intake that
  produced this methodology.

# Citations

- [Yos Riady, "Entity Component Systems in Elixir" (2016)](https://yos.io/2016/09/17/entity-component-systems/)
  — the exemplar; captured as
  [a reference](/knowledge/SWE/software-design/entity-component-systems-in-elixir.md).
