# Threads

Archived operator–agent conversations (exchanges only; tool calls omitted).
Time-ordered, so filenames carry a `YYYY-MM-DD-` prefix per the filing conventions.

## Contents

- [2026-07-05 — greenfield OKF bootstrap and verification layer](/meta/threads/2026-07-05-greenfield-okf-bootstrap-and-verification-layer.md) — archiving the legacy repo, scaffolding the OKF bundle, compiling CLAUDE.md from policies, and building the stable-id registry and grounded verification.
- [2026-07-08 — adopt session capture, routing ledger, and route tags](/meta/threads/2026-07-08-adopt-session-capture-routing-and-route-tags.md) — porting the `/capture` skill, routing ledger, concept excerpt log, and route tags (`mix brain.route_tags`) from Composable Beliefs, then refining them (retiring `/persist-thread`, matching the keep/strip rule to cb, adding `meta/verification-flows/`). Landed as PRs #13 and #15. The **first real `/capture`** — it supersedes the hand-authored worked-example version of this doc in place.
- [2026-07-09 — home-page news-filter inbox (/news + inbox/ namespace)](/meta/threads/2026-07-09-home-page-news-filter-inbox.md) — designing and building a daily, taxonomy-matched candidate feed: the `/news` skill, a non-bundle `inbox/` namespace with reason tags, a first digest, and site/root wiring; plus the tutorial on scanner scope (why `inbox/` had to join the registry's excluded dirs to stay CI-safe).
- [2026-07-09 — daily news-inbox Routine (scheduled /news trigger)](/meta/threads/2026-07-09-daily-news-inbox-routine.md) — created a claude-code-remote Routine (`trig_01PAiKWrWgVs4djSkhELoLYw`) that fires a fresh session daily at 13:00 UTC to run `/news`, write the day's digest, and push to `main`.
- [2026-07-09 — news Routine verification, issue tracking, and /news featuring docs](/meta/threads/2026-07-09-news-routine-issue-and-featuring.md) — verified that same Routine, found its automated fires land nothing on `main` (suspected env-wide approval gate), filed the first `meta/issues/` issue, added the `issue` type, and documented how `/news` decides what to feature.
- [2026-07-09 — vector-DB recall evaluation and the `analysis` type](/meta/threads/2026-07-09-vector-db-recall-evaluation-and-analysis-type.md) — stress-tested a "not yet" call on adding a vector DB; a dedup-recall probe over the live corpus showed grep already misses existing concepts semantically, landing on fix-intake-first (no vector DB); filed the finding as the first `analysis`-type doc and ratified that type (PR #24).
