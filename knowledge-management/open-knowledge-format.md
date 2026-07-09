---
id: sb:24bd1e
type: reference
title: Open Knowledge Format (OKF)
description: An open format for storing a knowledge base as a plain-directory "bundle" of markdown concept documents with YAML frontmatter — the format this second brain is built on (OKF v0.1).
resource: https://github.com/GoogleCloudPlatform/knowledge-catalog
provenance: "Distilled from the OKF specification (GoogleCloudPlatform/knowledge-catalog) and this bundle's own usage of it"
tags: [knowledge-management, okf, knowledge-format, markdown, yaml, frontmatter, second-brain]
timestamp: 2026-07-08
---

# Open Knowledge Format (OKF)

The **Open Knowledge Format** is an open specification for representing a body of
knowledge as a **bundle**: a plain directory of UTF-8 markdown *concept* documents,
each carrying **YAML frontmatter** plus a markdown body. It is deliberately
low-ceremony — the knowledge lives as ordinary files that both humans and agents
can read, diff, and edit with no special tooling. This repository is itself an OKF
**v0.1** bundle; see the [operating contract](/CLAUDE.md) for how the format is
applied and extended here.

## Core model

- **Bundle** — a directory of concept documents. The directory hierarchy is free
  to carry meaning (this brain treats the tree *as* its taxonomy), but the format
  does not impose a fixed schema.
- **Concept** — a single markdown file = **YAML frontmatter** (delimited by `---`)
  + a **markdown body**. The one hard requirement is a non-empty **`type`**;
  everything else is optional and open.
- **Tolerant consumer** — a conforming reader must not reject a bundle for missing
  optional fields, unknown `type` values, extra frontmatter keys, or broken links.
  The format degrades gracefully rather than failing closed.

## How this brain uses and extends it

OKF is the substrate; the operating contract layers local conventions on top —
none of which OKF itself mandates:

- a **controlled `type` vocabulary** so the brain stays queryable;
- **stable `sb:` ids** and id-based edges (`verified_by`) so references survive
  file moves;
- **reserved files** (`index.md` for progressive disclosure, `log.md` for history);
- a **verification/grounding** discipline for agent-authored statements.

Keeping these as extensions — rather than assuming them in the format — is what lets
the bundle remain a *conforming* OKF bundle that any tolerant OKF consumer can still
read.

# Citations

Open Knowledge Format — GoogleCloudPlatform/knowledge-catalog:
<https://github.com/GoogleCloudPlatform/knowledge-catalog>

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="sb:24bd1e">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-05-greenfield-okf-bootstrap-and-verification-layer (2026-07-05)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`sb:24bd1e`]**

I've read the full **OKF v0.1 spec**, so these are grounded in it. A bundle is just a directory of markdown concept files (YAML frontmatter with a mandatory `type` field + a markdown body), with reserved `index.md` (progressive-disclosure listings) and `log.md` (chronological history) allowed at any level, and `okf_version` declared in the root `index.md`.
