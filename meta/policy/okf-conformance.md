---
type: policy
title: OKF conformance
description: The three conditions for OKF v0.1 conformance, and the rule to be a tolerant consumer.
section: conformance
order: 1
status: active
tags: [meta, governance, okf, conformance]
timestamp: 2026-07-05
attribution:
  when: 2026-07-05T12:30:48+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
  from: [/meta/threads/2026-07-05-greenfield-okf-bootstrap-and-verification-layer.md]
---
A bundle conforms to OKF v0.1 when:

1. Every non-reserved `.md` file has parseable YAML frontmatter.
2. Every frontmatter block has a non-empty `type`.
3. Reserved files (`index.md`, `log.md`) follow their structures when present.

Be a tolerant **consumer**: never reject the bundle for missing optional fields,
unknown types, extra frontmatter keys, broken links, or absent `index.md` files.
