# Tutorials

Long-form explanatory notes about how the brain's tooling and governance work —
the "why", written to be read start to finish. Distinct from `policy` (the rules
that compile into the contract) and `threads` (verbatim conversation archives).

## Contents

- [Why the brain's toolchain runs offline in CI and any sandbox](/meta/tutorials/why-the-toolchain-runs-offline.md) — how zero external dependencies (`deps: []`) let every `mix brain.*` task, including the site generator, build with no network, and the CI/sandbox specifics that make that matter.
- [What makes a commit show as "Verified" on GitHub](/meta/tutorials/what-makes-a-commit-verified-on-github.md) — author vs committer identities, why "Verified" is a signature check (not an email), why re-authoring an agent commit to `noreply@anthropic.com` lets this environment's signature attach, and the only-rewrite-unpushed-commits rule.
- [Bundle scope and non-bundle namespaces](/meta/tutorials/bundle-scope-and-non-bundle-namespaces.md) — why the brain has four independent scanners (identity/verify, route-tags, contract, site), how the registry's exclusion list *defines* what a bundle concept is (and why adding `inbox/` there is what keeps candidate feeds from breaking CI), and why the site deliberately renders namespaces the registry ignores.
- [The three bundle scanners — Registry, Verifier, and RouteTags](/meta/tutorials/the-three-bundle-scanners.md) — one crawler (`Registry.scan/1`: wildcard + directory-exclusion + frontmatter parse) and two consumers; RouteTags adds a second surface over `meta/threads` and joins the governance and knowledge namespaces by stable id; why excluded dirs (e.g. `test/` fixtures) are invisible to all three.
- [How the Pages deploy is gated on a verified bundle](/meta/tutorials/gating-the-pages-deploy-on-a-verified-bundle.md) — why GitHub Actions' per-workflow isolation means a `needs:` can't reach across from `pages.yml` to `ci.yml`, and how repeating the integrity checks in the Pages build job makes the live site reachable only for a bundle that verifies.
- [Why a true merge (not a squash) keeps cited commits reachable](/meta/tutorials/why-a-true-merge-keeps-cited-commits-reachable.md) — reachability as the mental model: deleting a branch deletes a ref, not commits; a squash-merge abandons the original SHAs while a true merge wires them into `main`'s ancestry, so documents that cite commits by SHA (like a plan citing port commits) stay valid after the branch is deleted.
