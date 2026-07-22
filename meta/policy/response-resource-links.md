---
type: policy
title: Cite brain resources by their live site URL
description: In delivered responses, link a brain resource to its page on the deployed Pages site, not a bundle-absolute or relative repo path.
section: filing
order: 4
status: active
tags: [meta, governance, filing, links, responses]
timestamp: 2026-07-22
attribution:
  when: 2026-07-13T07:50:19+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
  from: [/meta/threads/2026-07-13-response-resource-links-policy-and-site-config.md, /meta/threads/2026-07-22-qiju-thread-storage-and-fit-each-layer-doctrine.md]
---
**In responses, link resources to the deployed site, not to repo paths.** When an
agent's **delivered response** (chat to the operator, a PR body, an issue comment —
anything read outside a checkout) references a document in the brain, cite it as a
link to that document's page on the **deployed Pages site**, not as a bundle-absolute
(`/knowledge/…md`) or relative repo path. A repo path is not navigable for a reader
in chat; the live URL is a click away.

- **The site.** The bundle is published to GitHub Pages at
  **`{{site_base_url}}`** (`mix brain.site` → `pages.yml`, one page per document and
  per `index.md`). That base URL lives in config
  (`config/config.exs` → `ElixirMind.SiteConfig.base_url/0`); it is the single
  source of truth, and this contract's copy of it is compiled in from that config —
  a deploy move (e.g. a custom domain) is one config edit, not a doc rewrite.
- **Get the URL from the tool, never by hand. `mix brain.url <path>` prints the
  working URL** for any bundle path — always run it; do **not** construct a URL
  yourself. The correct URL depends on state you have to check (is the doc live on
  `main` yet? see below), not on the path alone, so hand-construction is exactly
  what produces dead links. *Under the hood* the tool maps a live, rendered doc by
  swapping base and extension — `P.md` → `{{site_base_url}}P.html` (a directory's
  `index.md` → `…/<dir>/index.html`; governance `meta/…` docs render too) — but
  that mapping is **what the site does at build time, not a recipe to apply in a
  response**. Reproducing it by hand is the anti-pattern this policy exists to
  stop.
- **Live only after merge — cite unmerged docs by branch.** Pages deploys **only
  from the default branch** (`pages.yml` → `push: branches: [main]`), so a document
  *created or modified on an unmerged branch has no live page yet*: its Pages URL
  **404s** (new doc) or shows **stale** content (modified doc) until the PR merges
  and Pages rebuilds. Cite such a doc by its GitHub **blob URL at the branch ref**
  (`<repo>/blob/<branch>/<path>.md`), which resolves immediately and shows the
  current content. `mix brain.url` does this automatically — it emits the live
  Pages URL when the doc is rendered *and* unchanged vs `origin/main`, and the
  branch blob URL otherwise (new, modified, or under a non-rendered directory).
  The Pages URL is the canonical form once merged; a branch blob link is fine in
  ephemeral chat (branches are deleted post-merge, so never hardcode a blob URL
  into a durable doc body).
- **Not rendered → no live URL.** Resources under directories the site excludes
  (`deprecated/`, `.claude/`, `lib/`, `test/`) have no page ever; `mix brain.url`
  cites those by their GitHub blob URL instead of fabricating a Pages URL.
- **This is the response-side rule only.** Cross-links *inside* document bodies stay
  bundle-absolute markdown paths per
  [filenames-and-cross-linking](/meta/policy/filenames-and-cross-linking.md) — the
  site rewrites those `.md` links to the right relative `.html` at build time. Do not
  hardcode live URLs into document bodies; use them when speaking to a human outside
  the bundle.
