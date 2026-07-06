# Claude Code — sources

Primary-source excerpts from Anthropic's official Claude Code documentation, used
as verification grounding for the Claude Code concepts and notes in this directory.

## Contents

- [environments carry config; each session gets a fresh VM](/SWE/agentic-coding/claude-code/sources/cloud-web-environments-carry-config.md) — an environment owns network access, env vars, and the setup script; sessions run in a fresh VM with the repo cloned. `sb:863b32`
- [environment caching (filesystem snapshots)](/SWE/agentic-coding/claude-code/sources/cloud-web-environment-caching.md) — Anthropic snapshots the filesystem per environment, reuses it for later sessions, captures files not processes, rebuilds on config change or ~7-day expiry. `sb:eb418b`
- [environments reclaimed after inactivity](/SWE/agentic-coding/claude-code/sources/cloud-web-environment-reclaimed-on-inactivity.md) — cloud sessions stop after inactivity and the environment is reclaimed; the VM clones from GitHub, not your machine. `sb:3420c8`
- [credentials and signing keys never inside the sandbox](/SWE/agentic-coding/claude-code/sources/cloud-web-credentials-outside-sandbox.md) — git credentials and signing keys stay outside the sandbox; a proxy translates scoped credentials and restricts push to the current branch. `sb:564b8e`
- [user-level settings don't carry to cloud; hooks come from repo and org](/SWE/agentic-coding/claude-code/sources/cloud-web-user-settings-dont-carry-to-cloud.md) — `~/.claude` settings don't carry over; cloud hooks come from the repo and server-managed org settings. `sb:3f35e1`
