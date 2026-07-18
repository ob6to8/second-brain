---
id: em:f03f9c
type: reference
title: "Entity Component Systems in Elixir (Yos Riady)"
description: "Yos Riady's 2016 walkthrough of the entity–component–system (ECS) pattern — composition over inheritance, taught through a game's class hierarchy breaking on a Killer Bunny — and a proof-of-concept Elixir implementation mapping components to Agents, systems to stateless reducer modules, and discovery to a registry."
resource: https://yos.io/2016/09/17/entity-component-systems/
provenance: "Distilled from Yos Riady's blog post (2016-09-17), fetched 2026-07-18; layered breakdown via /summarize-technical"
tags: [ecs, software-design, composition-over-inheritance, elixir, actor-model, game-development, data-oriented-design]
timestamp: 2026-07-18T14:01:55Z
attribution:
  when: 2026-07-18T14:01:55Z
  channel: intake
  agent: "operator via /intake, Claude Code session"
  why: "operator filed the ECS article asking whether the approach is viable in Elixir beyond gaming, how adopted it is and what the alternatives are, and whether the writer's presentation style can serve as a tone reference"
---

# Entity Component Systems in Elixir (Yos Riady)

## Plain-language summary

Imagine building a game the way object-oriented textbooks teach: a `GameObject`
class at the top, an `Animal` subclass under it, and `Bunny` and `Whale` under
that. Everything works — until the design asks for a **Killer Bunny**, a
creature that both hops like a bunny and kills like a monster. Now the
hierarchy has no good home for it: behavior is welded to classes (you can't
change what a thing *is* at runtime), inheriting from two parents invites the
diamond problem, and pushing shared abilities up the tree bloats the base
class into a blob that every subclass drags around.

The entity–component–system (ECS) pattern dissolves the hierarchy instead of
patching it. A thing in the world is an **entity** — nothing but an ID and a
bag of parts. Each part is a **component** — a small piece of pure data (a
position, a health value, an "edible" tag) with no behavior. All behavior
lives in **systems** — processes that sweep over every component of a given
kind each tick and update it by a rule (gravity moves everything `Placeable`;
time ages everything `Living`). A Killer Bunny is no longer a taxonomy
problem; it is just a bunny's components plus a killing component, composable
at runtime.

Riady's twist is implementing this in Elixir, a language with no inheritance
at all, to show the pattern is really about *organizing state and behavior*,
not about rescuing class hierarchies. He closes by arguing that wandering into
unfamiliar domains — here, game architecture — is a fruitful source of design
ideas for general software.

## Key terms

- **Entity** — a unique ID aggregating a list of components; a pure container
  with no behavior of its own.
- **Component** — a minimal, reusable unit of *data* (attributes, or a bare
  marker/tag) attached to an entity; carries no methods.
- **System** — a stateless holder of *behavior*: enumerates all components of
  the kind(s) it cares about and updates their state by its rule, once per
  tick.
- **Composition over inheritance** — building capability by aggregating parts
  rather than by deriving from ancestor classes; ECS is this principle taken
  to an architectural extreme.
- **Diamond problem** — the multiple-inheritance ambiguity where a class with
  two parents inherits conflicting definitions of the same method.
- **Blob antipattern** — a base class that accretes functionality for every
  descendant's needs, so all subclasses carry weight most never use.
- **Prefab** — a factory (e.g. a `Bunny` module) that assembles a commonly
  used entity from its standard component set.
- **Registry** — the lookup service cataloging live components by type, which
  is how systems find what to iterate over.
- **Tick** — one step of the simulation clock; each tick, every system makes
  one pass over its components.

## Technical summary

The article's argument runs in two halves: a critique and a construction.

**Critique.** Class hierarchies model a game world badly because the world's
categories churn: rigid class-bound functionality blocks runtime change of
what an object can do; cross-cutting abilities force either multiple
inheritance (diamond problem) or lifting into the root (blob antipattern).
The Killer Bunny is the escalating example that breaks each repair in turn.

**Construction.** ECS replaces *is-a* with *has-a* at every level. Entities
are IDs plus component lists; components are pure data (`Physical`,
`Seeing`, `Position`, `Consumable`, `Ethereal`); systems are pure behavior
(`GravitySystem` over `Placeable`, `TimeSystem` over `Living`). Claimed
benefits: single-responsibility decoupling, runtime composability,
testability, parallelizability, and a clean data/behavior separation.
Acknowledged costs: inter-component communication gets awkward, system
execution order matters, and the pattern is obscure outside games.

**The Elixir mapping.** Entities are structs (`build/1`, `add/2`) holding an
ID and component list. Each component is backed by an **Agent** holding its
state dictionary, wrapped by an `ECS.Component` module (`new/2`, `get/1`,
`update/2`); the component's ID is its Agent's PID. Components self-register
into an Agent-backed **registry** keyed by type. Systems are stateless
modules that fetch their component set from the registry and apply a pure
Redux-style reducer — `dispatch(state, action) → new_state` — each tick.
Concurrency falls out of the actor model: Agents serialize access to each
component's state without locks, and systems could fan work out to worker
pools. Riady flags the implementation as deliberately rough ("there are many
flavours of ECS") and publishes the code on GitHub as a starting point.

Note for readers weighing the design today: one Agent process *per component
instance* showcases the actor mapping but is not how later Elixir ECS
frameworks store data — [ECSx](https://hexdocs.pm/ecsx/ECSx.html) keeps
components in ETS tables managed by a single GenServer. See the
[viability analysis](/meta/analysis/ecs-beyond-gaming-in-elixir.md) for
adoption and alternatives, and the
[escalating-example exposition methodology](/knowledge/knowledge-management/technical-communication/escalating-example-exposition.md)
for the article's presentation technique, distilled.

# Citations

- Yos Riady, "Entity Component Systems in Elixir" (2016-09-17):
  <https://yos.io/2016/09/17/entity-component-systems/> — the captured
  resource; follow-up to his conference talk on ECS.
