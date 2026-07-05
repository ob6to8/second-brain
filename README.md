# second-brain

A personal knowledge base stored as an
[Open Knowledge Format](https://github.com/GoogleCloudPlatform/knowledge-catalog)
(OKF v0.1) bundle — a directory of plain-markdown "concept" documents with YAML
frontmatter, designed to be read and extended by AI agents and humans alike.

## Layout

- **`index.md`** — bundle-root index; the entry point for navigation.
- **`log.md`** — chronological change history.
- **`CLAUDE.md`** — the operating contract every agent follows (OKF rules, filing
  conventions, `type` vocabulary, and the taxonomy-evolution protocol).
- **`.claude/skills/`** — skills. Start with **`/intake`** for capturing content.
- **`deprecated/`** — archived legacy content and tooling (read-only; not part of the
  knowledge bundle).

The knowledge taxonomy starts **blank** and grows **collaboratively**: the agent files
into existing directories on its own, but proposes any new directory for the operator
to ratify before creating it.

## Usage

From the Claude Code app, paste material after `/intake` to capture it into the brain.
