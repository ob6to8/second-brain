---
type: policy
title: Cite brain resources by their live site URL
description: In delivered responses, link a brain resource to its page on the deployed Pages site, not a bundle-absolute or relative repo path.
section: filing
order: 4
status: active
tags: [meta, governance, filing, links, responses]
timestamp: 2026-07-15
attribution:
  when: 2026-07-13T07:50:19+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
  from: [/meta/threads/2026-07-13-response-resource-links-policy-and-site-config.md]
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
- **The mapping.** Take the resource's bundle path and swap the base and extension:
  bundle path `P.md` → `{{site_base_url}}P.html`. So
  `/knowledge/knowledge-management/open-knowledge-format.md` is cited as
  `{{site_base_url}}knowledge/knowledge-management/open-knowledge-format.html`,
  and a directory's `index.md` as `…/<dir>/index.html`. This covers governance docs
  too (`meta/…`), which are rendered as well. `mix brain.url <path>` prints the
  mapped URL for a bundle path — the mechanical way to get it right.
- **Not rendered → no live URL.** Resources under directories the site excludes
  (`deprecated/`, `.claude/`, `lib/`, `test/`) have no page; cite those by repo path
  (or link the file on GitHub) rather than fabricating a Pages URL.
- **This is the response-side rule only.** Cross-links *inside* document bodies stay
  bundle-absolute markdown paths per
  [filenames-and-cross-linking](/meta/policy/filenames-and-cross-linking.md) — the
  site rewrites those `.md` links to the right relative `.html` at build time. Do not
  hardcode live URLs into document bodies; use them when speaking to a human outside
  the bundle.
