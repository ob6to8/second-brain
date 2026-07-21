---
type: analysis
title: "Is ECS in Elixir viable beyond gaming — how adopted is it, and what are the alternatives?"
description: "Viable but narrowly: ECS earns its keep in Elixir only for tick-driven worlds of many heterogeneous entities whose capability sets churn at runtime (simulation, digital twins, IoT fleets) — its gaming-native performance rationale (cache-local memory layout) does not survive the trip to the BEAM, adoption is a handful of pre-1.0 libraries (ECSx, ECSpanse) against a mainstream that lives in Rust/C++/Unity, and for everything else idiomatic OTP processes, a functional core, or relational modeling do the same decoupling with less machinery; deliberately written in the escalating-example style of the source article it evaluates."
provenance: "Claude Code session, 2026-07-18 — operator intook Yos Riady's ECS-in-Elixir article and asked whether the approach is viable for domains other than gaming, how widely it is adopted, and what the alternatives are. Adoption facts checked 2026-07-18 against hexdocs/GitHub (ECSx, ECSpanse), the DockYard ECSx announcement, a 2023 Hacker News practitioner thread on non-game ECS, and published non-game ECS systems (Vico, AtomECS, Gazebo)."
tags: [meta, analysis, ecs, elixir, software-design, architecture, otp, adoption, alternatives, simulation]
timestamp: 2026-07-21T00:01:43Z
attribution:
  when: 2026-07-18T14:01:55Z
  channel: agent-authored
  agent: "Claude Code session, operator-directed /intake follow-up"
  why: "operator asked for an analysis of whether ECS in Elixir is viable outside gaming, its adoption, and its alternatives, filed alongside the article capture"
  from: [/meta/threads/2026-07-21-ecs-intake-and-agent-entity-substitution.md]
---

# Is ECS in Elixir viable beyond gaming — how adopted is it, and what are the alternatives?

> Written deliberately in the source article's own presentation style —
> escalating a single concrete example until each design breaks — as the
> demonstration half of the
> [escalating-example exposition methodology](/knowledge/knowledge-management/technical-communication/escalating-example-exposition.md).
> Evaluates the capture
> [Entity Component Systems in Elixir](/knowledge/SWE/software-design/entity-component-systems-in-elixir.md).

**Question.** [Riady's article](/knowledge/SWE/software-design/entity-component-systems-in-elixir.md)
ports the entity–component–system pattern from game engines to Elixir. Is that
approach viable for domains other than gaming? How widely has it been adopted?
And when it isn't the right tool, what is?

**Thesis.** Viable, but narrowly — and for a different reason than in games.
ECS pays for itself in Elixir only when a domain looks like a game world with
the graphics removed: *many* heterogeneous entities, whose capability sets
change at runtime, updated by uniform rules on a clock. Outside that shape,
the pattern's costs arrive without its benefits, adoption reflects this (a
few pre-1.0 libraries in a community whose default is OTP), and Elixir
already ships the alternatives that solve the problems most applications
actually have.

## Where the pattern travels — and where it doesn't

Start with an inventory system, since every business domain has one. A
`Product` has a price and a stock count. Model it as a struct; done. No one
reaches for ECS here, and no one should: there is one kind of thing, its
shape is known, and it changes through a handful of well-named operations.

Now make it a *fleet*. Ten thousand delivery drones: some carry packages,
some carry sensors, some are charging, some are mid-firmware-update — and
which of those descriptions applies to a given drone changes hour by hour. A
fixed schema starts to pinch exactly the way Riady's class hierarchy pinched
when the Killer Bunny arrived: capability is welded to category, and the
categories churn. This is the shape ECS was built for — entity = drone ID,
components = `Carrying`, `Charging`, `Updating`, systems = the rules that
sweep each component set on a tick. The non-game systems that genuinely
adopted ECS all have this shape: the [Vico co-simulation
framework](https://www.sciencedirect.com/science/article/pii/S1569190X20301726)
(JVM), the [AtomECS laser-cooling physics
simulator](https://arxiv.org/pdf/2105.06447) (Rust), the Gazebo robotics
simulator, AR/VR scene management. All are *simulations*: many entities,
composition churn, a clock.

Now try the counter-example, because practitioners have run it for us. In a
[2023 Hacker News thread](https://news.ycombinator.com/item?id=36573945) on
ECS outside games, one commenter reports a London financial company happily
managing complexity with it — and another reports abandoning it for
algorithmic trading because they "hadn't enough entities to justify the
approach." The same thread carries the sharpest caution: ECS was invented for
*general-purpose game engines* that cannot know in advance what entities a
game will need; "if you have a specific thing in mind then use the
data-oriented principles on that and skip building something general
purpose." A domain with three kinds of thing does not need an architecture
for a thousand kinds.

There is one more thing that falls off the truck on the way to Elixir. In
C++, Rust, and Unity's DOTS, half the point of ECS is *memory layout*:
packing components of one type into contiguous arrays so the CPU cache
streams through them. The BEAM offers no such control — ECSx stores
components in ETS tables, which are fast but not cache-coherent arrays. So in
Elixir the performance half of the ECS sales pitch is mostly gone; what
remains is the *organizational* half (composition over inheritance,
data/behavior separation). That half is real, but note the irony: Elixir has
no inheritance, so the villain the pattern was invented to defeat — the
rigid class hierarchy, the diamond problem — does not exist here. What ECS
fixes in Elixir is not inheritance but *fixed-schema thinking*, and only when
schemas genuinely churn.

## Adoption: a niche within a niche

The mainstream of ECS lives where games live: Unity DOTS, Unreal's Mass,
[Bevy](https://bevyengine.org/) (Rust), EnTT and flecs (C++). In Elixir the
ecosystem is small and young:

- **[ECSx](https://github.com/ecsx-framework/ECSx)** — the most visible
  framework ([DockYard-promoted,
  2023](https://dockyard.com/blog/2023/07/06/ecsx-a-new-approach-to-game-development-in-elixir)),
  aimed at "real-time games and simulations." Pre-1.0 (v0.5.x), ETS-backed
  components under a single serializing GenServer, tick-scheduled systems,
  active as of early 2025.
- **[ECSpanse](https://elixirforum.com/t/ecspanse-an-entity-component-system-framework-for-elixir/57650)** —
  the second framework, solving the same problem with different trade-offs
  (more structure, steeper start).
- **ecstatic** and Riady's own proof-of-concept — unmaintained explorations.

That is the whole field: two live pre-1.0 libraries, framed by their own
authors as being for games and simulations, in a community whose default
answer to "many stateful things" has been OTP processes for twenty years.
Non-game ECS adoption in Elixir specifically is anecdotal at best. The
pattern is *proven* on the BEAM in the small, and *unproven* as a
general-purpose architecture there — consistent with the cross-language
picture, where non-game ECS is an acknowledged but minority practice.

## The alternatives, by the problem you actually have

ECS bundles three separable ideas: composition instead of taxonomy,
data/behavior separation, and clocked bulk updates. Elixir offers each à la
carte:

1. **A process per entity (idiomatic OTP).** Each drone is a `GenServer`
   holding its own state, supervised, addressable, crash-isolated — the
   digital-twin shape. This is the community default and the right first
   answer when entities are *independent actors* that react to messages,
   rather than rows swept by global rules. (Riady's Agent-per-component
   design rediscovers this, one level too far down.)
2. **A functional core.** One immutable state structure, pure reducer
   functions over it, a thin process shell around the whole thing. Systems
   without the registry: when entity count is modest, `Enum.map` over a list
   of structs *is* your GravitySystem. The trading-firm lesson applies —
   below some entity-count and churn threshold, this is strictly simpler.
3. **Relational modeling (Ecto).** An under-appreciated equivalence: an ECS
   is an in-memory relational database — components are tables, entity IDs
   are join keys, systems are queries plus updates. A domain tempted by ECS
   for *flexibility* (sparse, optional capabilities) but not for tick-rate
   can often just be… tables with foreign keys, transactions included.
4. **Protocols and behaviours.** If the itch is only "polymorphism without
   inheritance," Elixir's protocols dispatch on data shape directly — no
   architecture required.
5. **Event sourcing (Commanded).** If the real requirement is auditable
   state evolution over time rather than bulk per-tick updates, CQRS/ES is
   the established Elixir pattern, with mature tooling.

**Recommendation.** Treat ECS in Elixir as a *simulation architecture*, not
a general design style. Reach for it (via ECSx) when all three of its
signature conditions hold — high entity count, runtime composition churn,
clocked uniform updates. When only flexibility is needed, model relationally
or with protocols; when entities are autonomous, give them processes; when
the domain is small, keep a functional core and resist the machinery. And
keep Riady's closing point, which survives even where his implementation
doesn't: raiding unfamiliar domains for architectural ideas is exactly how a
pattern like this earns a fair trial.

*Amended by a follow-up: the operator's agent-for-entity substitution
surfaced one domain this draft didn't consider — an agent fleet's control
plane, where the orchestrator's record of an agent is authentically an
entity. See
[Does substituting "agent" for "entity" open an ECS domain in Elixir?](/meta/analysis/agent-for-entity-ecs-as-agent-fleet-control-plane.md).*

# Citations

- [Yos Riady, "Entity Component Systems in Elixir" (2016)](https://yos.io/2016/09/17/entity-component-systems/) — the source article, captured [here](/knowledge/SWE/software-design/entity-component-systems-in-elixir.md).
- [ECSx on GitHub](https://github.com/ecsx-framework/ECSx) · [hexdocs](https://hexdocs.pm/ecsx/ECSx.html) · [DockYard announcement (2023)](https://dockyard.com/blog/2023/07/06/ecsx-a-new-approach-to-game-development-in-elixir).
- [ECSpanse announcement, Elixir Forum](https://elixirforum.com/t/ecspanse-an-entity-component-system-framework-for-elixir/57650).
- [Hacker News: ECS for non-game applications (2023)](https://news.ycombinator.com/item?id=36573945) — practitioner reports for and against.
- [Vico: an entity-component-system based co-simulation framework](https://www.sciencedirect.com/science/article/pii/S1569190X20301726); [AtomECS](https://arxiv.org/pdf/2105.06447) — non-game ECS in the wild.
