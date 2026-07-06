# Testing

Software testing — test design, strategy, and the properties that make tests fast
and reliable.

## References

- [How to test: test features, not code (matklad)](/SWE/testing/how-to-test-features-not-code.md) — couple tests to features not code structure; funnel through a `check` helper, keep logic sans-IO, drive from data, and climb from examples to property-based/exhaustive/fuzz testing. `sb:a5ea86` _(reference)_
- [Unit vs. integration tests: replace the dichotomy with purity and extent (matklad)](/SWE/testing/unit-vs-integration-purity-and-extent.md) — drop the confused unit/integration split; measure tests by purity (freedom from threads/time/IO/processes) and extent (how much code runs). `sb:73115b` _(reference)_
