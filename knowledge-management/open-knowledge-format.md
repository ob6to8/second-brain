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

### 2026-07-09-github-pages-knowledge-base-site (2026-07-09)

2 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`sb:24bd1e`]**

The okf link goes to https://github.com/GoogleCloudPlatform/knowledge-catalog

Better would be to link to an internal node representing okf that contains that link in it

---

**[`sb:24bd1e`]**

That screenshot is your answer to my earlier question (the tool errored on my end): you selected **"New top-level `knowledge-management/`"**. That ratifies creating it as a new top-level — thank you, that's the cleaner home.

Before I build on it, let me verify exactly what's on `main` now, because the branch reset surfaced some file states that suggest the tutorial commits may not all be there.

Now it's clear: **PR #11 merged only the first commit** (`90c880f`, the site generator). My two later commits — the `meta/tutorials/` doc and the `tutorial` type — never made it to `main`; they're unmerged work sitting on the old branch. Per the workflow I must **keep** those, so I'll replay them onto the fresh base rather than lose them.

Done. **PR #12: https://github.com/ob6to8/second-brain/pull/12**

**What I did**

**Your answer came through via the screenshot** — you picked **"New top-level `knowledge-management/`"**, so I created it as a ratified new domain rather than wedging OKF under SWE.

**The OKF link fix (your request):**
- Created `knowledge-management/open-knowledge-format.md` — a `type: reference` node (`sb:24bd1e`) that now holds the canonical `https://github.com/GoogleCloudPlatform/knowledge-catalog` URL (in `resource` + citations) and summarizes what OKF is and how this brain extends it.
- Repointed **every** internal "Open Knowledge Format" mention — root `index.md`, `README.md`, and `meta/preamble.md` (→ recompiled `CLAUDE.md`) — to that node. The raw external URL now appears **only** inside the node, exactly the "process the link once, reference it everywhere" pattern the contract calls for.
- Listed the new domain in the root index, regenerated the registry, logged it.

**A catch I found and fixed along the way:** when I reset my branch from `main`, I discovered **PR #11 had merged only its first commit** — the `meta/tutorials/` doc and the `tutorial` type were left unmerged. I replayed those two commits onto the fresh base so they aren't lost; they're included in this PR.

**Verified:** contract/registry/verify checks ✓, 45 tests ✓, format ✓, site rebuilds to 82 pages, home-page OKF link resolves internally, new domain in the nav.

Once you merge #12, the Pages workflow auto-deploys — no settings step needed this time. Want me to watch #12's CI, or trigger the deploy after merge?
