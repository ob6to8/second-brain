---
type: reference
title: 2026-07-13-response-resource-links-policy-and-site-config
description: Added a filing policy requiring agent responses to cite brain resources by their deployed Pages URL (not repo paths), then made that base URL config-driven via SecondBrain.SiteConfig with token expansion and a mix brain.url helper.
provenance: "Claude Code session (claude-opus-4-8), 2026-07-13; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, policy, contract, links, site, config]
timestamp: 2026-07-13
pr: 62
---

# 2026-07-13-response-resource-links-policy-and-site-config

## Where this landed

Agent responses had begun citing brain resources with repo paths
(`/knowledge/…​.md`) — not navigable for a reader in chat. The session added a new
filing policy, **`response-resource-links`**, requiring delivered responses (chat,
PR bodies, comments) to link a resource to its page on the deployed GitHub Pages
site (`P.md` → `…/P.html`), while keeping in-bundle cross-links bundle-absolute per
`filenames-and-cross-linking`. It was seated right after that policy in the `filing`
section (renumbering the subsequent policies), `meta/policy/index.md` updated, and
`CLAUDE.md` recompiled.

On the operator's follow-up ("introduce config"), the hardcoded base URL was made
config-driven: a new **`SecondBrain.SiteConfig`** module is the single source of
truth — `base_url/0` reads `:second_brain, :site_base_url` from `config/config.exs`
(defaulting to the Pages URL), `live_url/1` maps a bundle path to its page, and
`expand_tokens/1` substitutes a `{{site_base_url}}` token. Both the contract
compiler and the static-site renderer expand that token, so `CLAUDE.md` and every
rendered page carry one config-driven URL; `site.ex` also reuses
`SiteConfig.excluded_dirs/0`. A new **`mix brain.url <path>`** task prints the
mapped live URL (the mechanical helper the policy points at). A custom-domain move
is now a one-line config edit. All gates pass (124 tests incl. new `SiteConfigTest`,
`contract --check`, `registry --check`, `verify`, `route_tags`, site build, format).
Both changes landed as two atomic commits on the feature branch.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Policy: cite brain resources by their deployed Pages URL in responses, not repo paths | closed | [response-resource-links policy](/meta/policy/response-resource-links.md) | - |
| Make the site base URL config-driven (SiteConfig, token expansion, `mix brain.url`) | closed | [response-resource-links policy](/meta/policy/response-resource-links.md) | - |

## User

Responses by the agent are beginning to reference resources within the brain, but linking to relative paths. Create a policy that when referencing resources to use as the url a link to the resource in the deployed pages site

## Assistant

<routes ref="meta/policy/response-resource-links.md">
Done. I added a new governance policy and pushed it to `claude/agent-resource-linking-k9p4og`.

## What I did

The problem: agent **responses** had started citing brain resources with repo paths (e.g. `/knowledge/…​.md`) — not navigable for someone reading in chat. The bundle is published to GitHub Pages at `https://ob6to8.github.io/second-brain/`, so there's a live, clickable page for every concept.

New policy **`meta/policy/response-resource-links.md`** ("Cite brain resources by their live site URL"), in the `filing` section right after `filenames-and-cross-linking`:

- **Rule** — in any delivered response (chat, PR bodies, comments), link a resource to its page on the deployed Pages site, not a repo path.
- **Mapping** — `P.md` → `https://ob6to8.github.io/second-brain/P.html` (covers `meta/…` governance docs too, since they're rendered).
- **Edge case** — resources under excluded dirs (`deprecated/`, `.claude/`, `lib/`, `test/`) have no page, so cite those by repo path.
- **Boundary** — explicitly scoped to *responses*. Cross-links *inside* concept bodies stay bundle-absolute markdown paths per the existing `filenames-and-cross-linking` policy (the site rewrites those to relative `.html` at build time); live URLs must not be hardcoded into concept bodies.

Mechanics handled per the operating contract:
- Renumbered the subsequent filing policies (`link-processing` 4→5, `maintain-reserved-files` 5→6, `persist-plans` 6→7, `merge-strategy` 7→8) to seat the new rule in the right spot.
- Updated `meta/policy/index.md`.
- Recompiled `CLAUDE.md` with `mix brain.contract` (never hand-edited).
- `mix brain.contract --check`, `mix brain.verify`, and `mix brain.route_tags` all pass.

I did **not** open a PR (not requested). Say the word — or run `/create-pull-request` — and I'll capture the session and open one.

One note: since this is a change to the *shape* of the contract (a new policy), it's yours to ratify. If you'd prefer the base URL sourced from config rather than stated literally in the policy (e.g. anticipating a custom domain), I can adjust.
</routes>

## User

Commit then Yes, introduce config

## Assistant

<routes ref="meta/policy/response-resource-links.md lib/second_brain/site_config.ex">
Committed and pushed. Both commits are on `claude/agent-resource-linking-k9p4og`.

## What the second commit added

The base URL is now sourced from config instead of a hardcoded literal.

**`SecondBrain.SiteConfig`** (new module) — single source of truth for where the bundle is published:
- `base_url/0` reads `:second_brain, :site_base_url` from **`config/config.exs`**, defaulting to the Pages URL so tooling still runs in a bare checkout (normalizes to one trailing slash).
- `live_url/1` maps a bundle path → its live page (`.md`→`.html`, base prepended), returning `{:error, :not_rendered}` for excluded dirs.
- `expand_tokens/1` substitutes the `{{site_base_url}}` token.

**Two consumers wired to it:**
- **Contract compiler** — expands `{{site_base_url}}` in policy/preamble bodies, so `CLAUDE.md` carries one config-driven literal. The existing `mix brain.contract --check` CI gate now guarantees it stays consistent with config.
- **Site renderer** — expands the same token on every page (so the policy's own page shows the real URL, not the token), and reuses `SiteConfig.excluded_dirs/0` so "not rendered → no live URL" is defined once.

**Policy source** now uses the `{{site_base_url}}` token and names config as canonical.

**`mix brain.url <path>`** (new task) — prints the mapped live URL for a bundle path, or a "cite by repo path" notice for excluded dirs. The mechanical way for an agent to get the link right rather than hand-constructing it.

A custom-domain move is now a one-line edit to `config/config.exs` followed by `mix brain.contract` + `mix brain.site`.

**Verification:** 124 tests pass (added `SiteConfigTest`); `contract --check`, `registry --check`, `verify`, `route_tags`, the site build (342 pages), and `mix format --check-formatted` all pass. Confirmed no raw `{{site_base_url}}` token leaks into `CLAUDE.md` or the rendered site.

No PR opened (not requested) — say the word or run `/create-pull-request` and I'll capture the session and open one.
</routes>
