# Tutorials

Long-form explanatory notes about how the brain's tooling and governance work —
the "why", written to be read start to finish. Distinct from `policy` (the rules
that compile into the contract) and `threads` (verbatim conversation archives).

## Contents

- [Why the brain's toolchain runs offline in CI and any sandbox](/meta/tutorials/why-the-toolchain-runs-offline.md) — how zero external dependencies (`deps: []`) let every `mix brain.*` task, including the site generator, build with no network, and the CI/sandbox specifics that make that matter.
- [How the Pages deploy is gated on a verified bundle](/meta/tutorials/gating-the-pages-deploy-on-a-verified-bundle.md) — why GitHub Actions' per-workflow isolation means a `needs:` can't reach across from `pages.yml` to `ci.yml`, and how repeating the integrity checks in the Pages build job makes the live site reachable only for a bundle that verifies.
