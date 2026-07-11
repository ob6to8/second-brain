#!/bin/bash
set -euo pipefail

# 1. Ensure the Elixir/OTP toolchain is present so the contract compiler
#    (`mix brain.contract`) and the test suite (`mix test`) work in the session.
#    The install is only needed in Claude Code on the web (remote) sessions;
#    local machines are expected to already have Elixir installed.
# 2. Emit the session-init digest (`mix brain.session_init`) — open issues,
#    active plans, dangling ledger strands, and a heuristic top-3 priority
#    ranking — so it lands in the fresh session's context and the agent can
#    open the thread with a priority appraisal.

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
  echo "second-brain: $(elixir --version 2>/dev/null | tail -1) ready — mix brain.contract available."
  echo
  mix brain.session_init 2>>"$log" \
    || echo "second-brain: WARNING — session-init digest failed; see $log." >&2
else
  echo "second-brain: WARNING — failed to install Elixir; see $log." >&2
fi
