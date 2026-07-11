# Plans

Intended work on the brain or its tooling — design/decision records for proposed
changes, each capturing motivation, the shape of the change, scope boundaries, and
open questions so a future session can execute against something concrete. A separate
namespace from `issues` (problems to track) and `policy` (the rules that compile into
the contract).

Each plan is a `type: plan` doc carrying a `status` (`proposed` · `accepted` ·
`in-progress` · `done` · `superseded`). Superseded and done plans stay filed as a
record of what was decided and why.

## Proposed

- [Epistemic overlay: the four operations as a frontmatter-native graph over concepts](/meta/plans/epistemic-overlay.md) — promote the latent attestation/aggregation/inference/prescription structure to a first-class, queryable layer over existing concepts, with an integrity-checking `mix brain.graph`; explicitly bounds out atomization and strength-as-count. `status: proposed`.

## Accepted / In progress

_(none yet)_

## Done / Superseded

- [The daily read: a cross-domain synthesis lede for /news digests](/meta/plans/news-daily-read-synthesis.md) — add a `## The read` section at the top of each digest: a short, `sb:`-id-grounded perspective reading the day's selections as a set against the brain's standing concerns, connecting threads across domains. Proposed, ratified, and implemented same session. `status: done`.
- [The flows genre + formal scenario testing](/meta/plans/flows-genre-and-scenario-testing.md) — establish a `meta/flows/` genre (per-flow touch-sequence docs) backed by ExUnit scenario tests over each flow's deterministic spine; collapse the capture docs and build the `session-capture` + `intake` flows. `status: done`.
