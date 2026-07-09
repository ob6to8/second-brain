# Threads

Archived operator–agent conversations (exchanges only; tool calls omitted).
Time-ordered, so filenames carry a `YYYY-MM-DD-` prefix per the filing conventions.

## Contents

- [2026-07-05 — greenfield OKF bootstrap and verification layer](/meta/threads/2026-07-05-greenfield-okf-bootstrap-and-verification-layer.md) — archiving the legacy repo, scaffolding the OKF bundle, compiling CLAUDE.md from policies, and building the stable-id registry and grounded verification.
- [2026-07-08 — adopt session capture, routing ledger, and route tags](/meta/threads/2026-07-08-adopt-session-capture-routing-and-route-tags.md) — porting the `/capture` skill, routing ledger, concept excerpt log, and route tags (`mix brain.route_tags`) from Composable Beliefs, then refining them (retiring `/persist-thread`, matching the keep/strip rule to cb, adding `meta/verification-flows/`). Landed as PRs #13 and #15. The **first real `/capture`** — it supersedes the hand-authored worked-example version of this doc in place.
- [2026-07-09 — home-page news-filter inbox (/news + inbox/ namespace)](/meta/threads/2026-07-09-home-page-news-filter-inbox.md) — designing and building a daily, taxonomy-matched candidate feed: the `/news` skill, a non-bundle `inbox/` namespace with reason tags, a first digest, and site/root wiring; plus the tutorial on scanner scope (why `inbox/` had to join the registry's excluded dirs to stay CI-safe).
- [2026-07-09 — daily news-inbox Routine (scheduled /news trigger)](/meta/threads/2026-07-09-daily-news-inbox-routine.md) — created a claude-code-remote Routine (`trig_01PAiKWrWgVs4djSkhELoLYw`) that fires a fresh session daily at 13:00 UTC to run `/news`, write the day's digest, and push to `main`.
