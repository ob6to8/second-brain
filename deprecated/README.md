# Deprecated — legacy content pending migration

Remnants of the pre-OKF "assertion graph" knowledge base. The system's
machinery (shell scripts, schema, templates, skills, generated index and
publish staging) was deleted on 2026-07-11 — it survives in git history.
What remains is **content awaiting triage/migration** into the OKF bundle
via `/intake`:

- `sources/` — 13 legacy source captures (articles, videos, discussions).
- `assertions/` — 9 atomic claims with evidence links into `sources/`.
- `intake/` — a raw backlog of collected URLs, never processed.
- `plans/` — architecture decision records for the old system (historical).

This directory is **not part of the OKF bundle** (no `sb:` ids, excluded
from verification). Delete the whole directory once the content above has
been migrated or consciously discarded.

Migrated so far:

- `sources/ai-agent-memory-markdown-files.md` →
  [/SWE/agentic-coding/context-engineering/ai-agent-memory-management-markdown-files.md](/SWE/agentic-coding/context-engineering/ai-agent-memory-management-markdown-files.md) (`sb:41a1e3`, 2026-07-11)
