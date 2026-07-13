---
type: tutorial
title: Bundle scope and non-bundle namespaces — which scanner sees what, and why inbox/ needs no stable id
description: The brain runs several independent scanners (identity/verify, route-tags, the contract compiler, the site generator), and each defines its own scope rather than sharing one list. This note explains why a new top-level namespace like inbox/ would break CI unless it is added to the registry's exclusion list, how the verifier and route-tags checker inherit that scope for free, and why the site generator deliberately renders namespaces the registry ignores.
tags: [meta, tooling, okf, registry, verification, namespaces, ci, site]
timestamp: 2026-07-09
attribution:
  when: 2026-07-09T12:08:06+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
  from: [/meta/threads/2026-07-09-home-page-news-filter-inbox.md]
---

# Bundle scope and non-bundle namespaces

This note exists because of a finding made while adding the `inbox/` feed:

> Registry (used by the verifier) scans all top-level dirs **except** an excluded
> list — and `inbox` isn't on it. So `inbox/*.md` would be required to carry `sb:`
> ids and would break CI. I need to add `inbox` to that exclusion list. Let me
> check the route-tags scanner and the site generator too.

That one sentence hides the whole scoping model of the brain's toolchain. Getting
it right is the difference between a green CI and a red one whenever you introduce
a new kind of file. This note unpacks it.

## The brain is not scanned by one thing — it is scanned by four

There is no single "what counts as a file in the brain" list. There are **four
independent scanners**, each answering a *different* question, each with its **own**
notion of scope:

| Scanner | Code | Question it answers | Scope source |
|---------|------|---------------------|--------------|
| **Identity / verify** | `SecondBrain.Registry` → `SecondBrain.Verifier` | Does every *bundle concept* carry a valid, unique `sb:` id, and are its evidence edges sound? | `Registry`'s `@excluded_dirs` / `@excluded_files` |
| **Route tags** | `SecondBrain.RouteTags` | Are `<routes>` tags wellformed, and do the sink logs match? | `meta/threads/` (sources) + `Registry` concepts (sinks) |
| **Contract** | `SecondBrain.Contract` ← `SecondBrain.Policy` | Is `CLAUDE.md` a faithful compile of the policies? | `meta/policy/*.md` with `type: policy` |
| **Site** | `SecondBrain.Site` | Which pages get rendered into the published HTML? | `Site`'s *own* `@excluded_dirs` |

The trap is assuming these share a boundary. They do not. A file can be **in scope
for one and out of scope for another** — and that asymmetry is exactly what makes
non-bundle namespaces like `meta/` and `inbox/` possible.

## The registry is the definition of "bundle concept"

The identity layer is where "is this a real concept?" is actually decided.
`SecondBrain.Registry.concept_paths/1` globs `**/*.md` and then rejects anything
excluded:

```elixir
@excluded_dirs ~w(.git .github .githooks .claude _build deps tmp lib test meta deprecated inbox)
@excluded_files ~w(index.md log.md README.md CLAUDE.md)

defp excluded?(rel_path) do
  [top | _] = Path.split(rel_path)
  top in @excluded_dirs or Path.basename(rel_path) in @excluded_files
end
```

Everything that survives this filter is a **bundle concept**, and the verifier
holds every survivor to the full identity contract. `SecondBrain.Verifier.run/1`
does not re-scan the tree — it calls `Registry.scan/1` and applies its rules to
whatever comes back:

- **rule 2** — every concept carries a stable `id` matching `sb:[0-9a-f]{6}`,
  unique across the bundle;
- **rules 3–5** — `verified_by` edges resolve, captures (`resource`) are never
  `verified: true`, and `verified: true` requires non-empty evidence.

This delegation is the key structural fact: **the verifier inherits its scope from
the registry.** So the reach of *both* `mix brain.registry` and `mix brain.verify`
is governed by that single `@excluded_dirs` list.

## Why a bare new namespace breaks CI

`inbox/` digests are, by design, **candidates, not concepts**: dated feed pages
with `type: reference` and *no* `sb:` id (see the [`/research`](/.claude/skills/research/SKILL.md)
skill). But `inbox` is a *new top-level
directory*, and until it is named in `@excluded_dirs` the glob happily picks up
`inbox/2026-07-09.md` as a bundle concept. The verifier then fires **rule 2** on
it:

```
inbox/2026-07-09.md: missing stable `id` — mint one with `mix brain.id`
```

CI runs `mix brain.verify` as a required gate, so that error is a red build. The
fix is one word — add `inbox` to the list — after which the identity layer stops
seeing those files entirely. The same edit also decides the `verified`-field
question: an unscanned file is never subjected to the capture/grounding rules, so
the inbox is free to omit `verified` (which is correct — a candidate link is a
capture, and captures are never `verified`).

## Route tags come along for free — but check anyway

`SecondBrain.RouteTags` has two inputs: **thread sources** under `meta/threads/`
(the files that may carry `<routes ref="…">` regions) and **concept sinks**, which
it obtains from the registry's concept set. Because sinks are drawn from the same
`Registry` scan, excluding `inbox` from the registry *also* removes inbox pages
from the route-tags checker's concept universe — no separate edit needed. And since
inbox digests carry no `<routes>` tags and are not `meta/threads/` files, they are
invisible to that checker from both directions. Confirming this ("let me check the
route-tags scanner too") is why the finding ends the way it does: the fix is
correct only once you've verified the *dependent* scanners inherit it rather than
maintaining their own list.

## The site is the deliberate exception

Here is the asymmetry that makes the model worth understanding. The static-site
generator keeps a **separate** exclusion list:

```elixir
# SecondBrain.Site
@excluded_dirs ~w(.git .github .githooks _build deps tmp deprecated .claude lib test)
```

Notice what is **not** there: `meta` and `inbox`. The site *does* render them. This
is intentional — the published knowledge base surfaces governance docs (policies,
tutorials, threads) and the daily inbox feed as browsable pages, even though none of
them are identity-bearing bundle concepts. A page with a `type` but no `id` renders
fine: the id index and evidence-backlink panels simply skip it (they are built only
from pages that *have* an `id`).

So a file's membership is really **two orthogonal decisions**:

1. **Is it a bundle concept?** — governed by `Registry.@excluded_dirs`. Yes ⇒ it
   must carry an `sb:` id and obey the verification rules. This is the *identity*
   boundary.
2. **Is it published?** — governed by `Site.@excluded_dirs`. Yes ⇒ it becomes an
   HTML page. This is the *rendering* boundary.

`meta/` and `inbox/` sit in the same quadrant: **not a concept, but published.**
`deprecated/` sits in another: excluded from *both* (archived and hidden). Regular
concepts under `knowledge/`, `beliefs/`, etc. are in both. Keeping the two lists
separate is what lets the brain publish more than it identity-checks.

## The checklist for a new non-bundle namespace

When you add a top-level namespace that holds candidates, governance, or any
non-concept material, walk these in order:

1. **Add it to `SecondBrain.Registry.@excluded_dirs`.** This is the load-bearing
   step — it takes the namespace out of `mix brain.registry` *and* `mix brain.verify`
   (which delegates) *and* the route-tags concept set (which draws from the
   registry) in one edit.
2. **Decide rendering.** Leave it *out* of `Site.@excluded_dirs` to publish it (like
   `meta/`, `inbox/`); add it there to hide it (like `deprecated/`).
3. **Files carry a `type` but no `id`.** They stay OKF-conformant (non-empty
   `type`, parseable frontmatter) without joining the identity layer. Omit
   `verified` — non-concepts are not verifiable statements.
4. **Run the full gate suite** — `mix brain.contract --check`, `mix brain.registry
   --check`, `mix brain.verify`, `mix brain.route_tags`, `mix brain.site` — and
   confirm green before committing. The site build doubles as proof the new pages
   render.

The general lesson: in this repo, "which files does the tooling see?" has no single
answer. Identity, route tags, the contract, and the site each scope themselves, and
a healthy change reasons about **each** boundary a new file crosses — not one global
list.

# See also

- [Why the brain's toolchain runs offline in CI and any sandbox](/meta/tutorials/why-the-toolchain-runs-offline.md)
- The identity & verification rules in the [operating contract](/CLAUDE.md)
- The [`/research`](/.claude/skills/research/SKILL.md) skill and the [`inbox/`](/inbox/index.md) namespace
