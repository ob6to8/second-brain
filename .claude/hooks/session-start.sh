#!/bin/bash
set -euo pipefail

# Provision the session's toolchain — nothing more. This hook used to also emit
# the session-init digest (open work + a heuristic top-3) into every session's
# context; that appraisal now lives behind the on-demand `/priorities` skill
# (see .claude/skills/priorities/SKILL.md), so the hook's sole job is to ensure
# the Elixir/OTP toolchain is present and warm so `mix brain.*` — including the
# priorities skill, the contract compiler, and the test suite — works.
#
# The install is only needed in Claude Code on the web (remote) sessions;
# local machines are expected to already have Elixir installed.

log=/tmp/second-brain-session-start.log

if [ "${CLAUDE_CODE_REMOTE:-}" = "true" ] && ! command -v mix >/dev/null 2>&1; then
  export DEBIAN_FRONTEND=noninteractive
  # The package is usually directly installable; fall back to an index refresh.
  apt-get install -y elixir >"$log" 2>&1 \
    || { apt-get update -y >>"$log" 2>&1 && apt-get install -y elixir >>"$log" 2>&1; }
fi

if command -v mix >/dev/null 2>&1; then
  cd "${CLAUDE_PROJECT_DIR:-$PWD}"
  # Warm the build cache (this project has no external deps to fetch).
  mix compile >>"$log" 2>&1 || true
  echo "second-brain: $(elixir --version 2>/dev/null | tail -1) ready — run /priorities to review open work."
else
  echo "second-brain: WARNING — failed to install Elixir; see $log." >&2
fi
