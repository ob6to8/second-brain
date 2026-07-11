# Glossary

One concept file per technical term, alphabetical, maintained by
[`/add-to-glossary`](/.claude/skills/add-to-glossary/SKILL.md). Each definition
is individually linkable — cite a term in any response as a bundle-absolute
link (e.g. `[route tag](/beliefs/glossary/route-tag.md)`) and the link lands on its
definition. See the [glossary hub](/beliefs/glossary.md) for how the system works.

## Terms

- [analysis (type)](/beliefs/glossary/analysis-type.md) — controlled type: a reasoned point-in-time judgment on a question, with findings + recommendation
- [approval gate](/beliefs/glossary/approval-gate.md) — a control blocking a tool/MCP action until approval resolves; environment-wide if it blocks every session
- [approximate nearest neighbor (ANN)](/beliefs/glossary/approximate-nearest-neighbor.md) — index class trading exactness for speed on nearest-vector queries; worth it only at large corpus size
- [candidate feed](/beliefs/glossary/candidate-feed.md) — a regenerated list of external candidates held outside the bundle until a human accepts one
- [CI smoke check](/beliefs/glossary/ci-smoke-check.md) — a cheap CI check that fails the build on a basic broken invariant — a tripwire, not a full test
- [compiled contract](/beliefs/glossary/compiled-contract.md) — a policy/config file regenerated from source docs, never hand-edited (e.g. `CLAUDE.md` via `mix brain.contract`)
- [Composable Beliefs (cb)](/beliefs/glossary/composable-beliefs.md) — the external Elixir belief-management repo whose capture/routing/verifier patterns were ported into this brain
- [concept (OKF)](/beliefs/glossary/concept-okf.md) — the unit of knowledge in this bundle: a markdown file with YAML frontmatter, id = path minus `.md`
- [cron expression](/beliefs/glossary/cron-expression.md) — the five-field spec (min hr dom mon dow) defining when a recurring job fires, e.g. `0 13 * * *`
- [cross-site scripting (XSS)](/beliefs/glossary/cross-site-scripting.md) — a vuln where unescaped attacker content runs as markup/script; closed by HTML escaping
- [deduplication](/beliefs/glossary/deduplication.md) — checking for an existing equivalent before filing, to avoid fragmenting the brain (intake-time)
- [dependency-free](/beliefs/glossary/dependency-free.md) — relying only on the standard library — no external packages, so it runs offline in restricted sandboxes
- [deploy gating](/beliefs/glossary/deploy-gating.md) — gating a deploy on verification passing, so a failed check skips publish and the last good deploy stays live
- [deterministic spine](/beliefs/glossary/deterministic-spine.md) — the input-determined, mechanical part of a workflow that a conventional test can pin
- [digest](/beliefs/glossary/digest.md) — one dated per-day document collecting candidate items with synopses, grouped by category
- [embeddings](/beliefs/glossary/embeddings.md) — dense vectors placing semantically similar text nearby, compared via distances like cosine
- [epistemic overlay](/beliefs/glossary/epistemic-overlay.md) — a layer classifying docs by epistemic role and linking their dependencies (the cb model)
- [ExUnit](/beliefs/glossary/exunit.md) — Elixir's built-in unit-testing framework (fixtures, tags like `:tmp_dir`)
- [fast-forward merge](/beliefs/glossary/fast-forward-merge.md) — a merge that advances the branch pointer with no merge commit; leaves a zero-diff branch
- [featuring](/beliefs/glossary/featuring.md) — how `/news` decides what makes the cut: relevance → novelty → a reason tag → source quality, capped
- [flow (touch-sequence)](/beliefs/glossary/flow-touch-sequence.md) — a per-workflow touch-sequence doc tracing one canonical run, each step actor-tagged (`meta/flows/`)
- [fresh-session-per-fire](/beliefs/glossary/fresh-session-per-fire.md) — a scheduling mode where every trigger firing spawns a clean session, inheriting no prior state
- [GitHub Flavored Markdown (GFM)](/beliefs/glossary/github-flavored-markdown.md) — GitHub's CommonMark superset (tables, task lists, strikethrough, autolinks)
- [GitHub Pages](/beliefs/glossary/github-pages.md) — GitHub's static-site hosting, publishing a repo or build artifact to a public URL via Actions
- [golden test (snapshot test)](/beliefs/glossary/golden-test.md) — a test comparing current output to a checked-in "golden" reference artifact, flagging any drift
- [graduation](/beliefs/glossary/graduation.md) — a term outgrowing the glossary relocates into the domain taxonomy, id travelling with it, a pointer stub left behind
- [HTML escaping](/beliefs/glossary/html-escaping.md) — encoding `& " < >` as entities so untrusted text can't break out of its HTML context
- [inbox namespace](/beliefs/glossary/inbox-namespace.md) — the non-bundle `inbox/` waiting room for `/news` candidate digests (no ids, never verified)
- [issue (type)](/beliefs/glossary/issue-type.md) — controlled type: a tracked operational problem with a status (open/resolved/wontfix), under `meta/issues/`
- [markdown renderer](/beliefs/glossary/markdown-renderer.md) — a component parsing markdown to HTML (here dependency-free `SecondBrain.Markdown`)
- [methodology (type)](/beliefs/glossary/methodology-type.md) — controlled type: a repeatable prescriptive how-to/playbook for a recurring task
- [mix task](/beliefs/glossary/mix-task.md) — a named `mix` command defined under `Mix.Tasks` (e.g. `mix brain.verify`)
- [non-bundle namespace](/beliefs/glossary/non-bundle-namespace.md) — a top-level dir excluded from the registry — no `sb:` ids, skipped by verify (e.g. `meta/`, `inbox/`)
- [operating contract](/beliefs/glossary/operating-contract.md) — the root `CLAUDE.md` auto-loaded each session; a compiled artifact, never hand-edited
- [parse-the-log](/beliefs/glossary/parse-the-log.md) — capturing a session by parsing the host log file (exact delivered text) vs. reconstructing from context
- [plan (type)](/beliefs/glossary/plan-type.md) — controlled type: a one-off design/decision record for an intended change, with a status
- [plugin](/beliefs/glossary/plugin.md) — a distributable bundle of Claude Code skills; its skills get an automatic `plugin-name:` namespace
- [pointer entry](/beliefs/glossary/pointer-entry.md) — an entry for a term canonically defined elsewhere: one-line gloss + link, never a duplicate definition
- [property-based testing](/beliefs/glossary/property-based-testing.md) — testing that asserts invariants over many generated inputs, not hand-picked examples
- [proto-belief document](/beliefs/glossary/proto-belief-document.md) — cb's per-matter accreting page; maps onto this brain's per-topic `concept` sink
- [provenance](/beliefs/glossary/provenance.md) — the frontmatter field for a statement's immutable origin; orthogonal to verification
- [query profile](/beliefs/glossary/query-profile.md) — per-category interest signals derived from the taxonomy tree, used as the `/news` retrieval filter
- [reason tags](/beliefs/glossary/reason-tags.md) — the `recent`/`impactful`/`influential`/`groundbreaking`/`buzz` vocabulary marking why a `/news` item surfaced
- [recall](/beliefs/glossary/recall.md) — the fraction of relevant items a search surfaces; low recall means existing material is missed
- [recall probe](/beliefs/glossary/recall-probe.md) — a repeatable eval firing known queries at known targets to measure (and watch) search recall
- [recall@k](/beliefs/glossary/recall-at-k.md) — a metric: is the correct target within the top *k* results? reported across a query set
- [research spike](/beliefs/glossary/research-spike.md) — a time-boxed investigation answering a design/feasibility question, yielding a verdict not code
- [route tag](/beliefs/glossary/route-tag.md) — inline `<routes ref="…">` region marking which concept(s) a paragraph of a frozen thread feeds
- [Routine](/beliefs/glossary/routine.md) — a saved scheduled trigger that fires a preset prompt into an agent session on a cron schedule
- [routing ledger](/beliefs/glossary/routing-ledger.md) — the per-thread dispatch table (topic/state/routed-to/dangling); pointers and states only, no content
- [scenario test](/beliefs/glossary/scenario-test.md) — an end-to-end test driving a whole workflow against a realistic fixture and asserting on final state
- [self-consistency check](/beliefs/glossary/self-consistency-check.md) — a check that re-derives a value from its own source; catches drift but is blind to shared-logic errors
- [semantic search](/beliefs/glossary/semantic-search.md) — meaning-based retrieval via embedding similarity, bridging synonym/jargon gaps lexical search misses
- [session capture](/beliefs/glossary/session-capture.md) — rendering a session into a verbatim thread doc, dropping only tool calls, reasoning, short pre-tool narration
- [SessionStart hook](/beliefs/glossary/sessionstart-hook.md) — a hook that runs at session start to provision or validate the environment (e.g. warm the Elixir toolchain)
- [sink (route-tag sink)](/beliefs/glossary/route-tag-sink.md) — the doc a route tag feeds; an `sb:` id sink accretes a log, a path back-link does not
- [skill](/beliefs/glossary/skill.md) — a named, invocable `SKILL.md` capability; the glossary holds the concepts a skill enacts, not its bare `/command` handle
- [skill namespacing](/beliefs/glossary/skill-namespacing.md) — prefixing skill names to resolve as a set; in Claude Code only plugin skills are auto-namespaced
- [skill-to-skill delegation](/beliefs/glossary/skill-to-skill-delegation.md) — one skill invoking another as a sub-step (e.g. `/create-pull-request` runs `/capture`), composing behavior
- [stable id (`sb:` id)](/beliefs/glossary/stable-id.md) — the opaque, immutable `sb:` + 6-hex identifier every bundle concept carries
- [static-site generator](/beliefs/glossary/static-site-generator.md) — a tool rendering source files into pre-built static pages, no backend (here `mix brain.site`)
- [supersession](/beliefs/glossary/supersession.md) — updating by recording `superseded_by` instead of overwriting; preserves history (cb's model)
- [thread doc](/beliefs/glossary/thread-doc.md) — the frozen, verbatim session record `/capture` writes under `meta/threads/`
- [tree is the taxonomy](/beliefs/glossary/tree-is-the-taxonomy.md) — the directory tree, surfaced via `index.md` files (progressive disclosure), *is* the canonical taxonomy
- [tutorial (type)](/beliefs/glossary/tutorial-type.md) — controlled type: a long-form read-start-to-finish explainer (the why/how), under `meta/tutorials/`
- [typed edge](/beliefs/glossary/typed-edge.md) — an id-based relationship in frontmatter that tooling traverses (e.g. `verified_by`); prose links stay untyped
- [vector database](/beliefs/glossary/vector-database.md) — a store indexing items as embedding vectors, answering nearest-neighbor queries for semantic retrieval
- [verification grounding](/beliefs/glossary/verification-grounding.md) — the rule that `verified: true` needs evidence (`verified_by`), not its own link, and only on statements
- [verified_by](/beliefs/glossary/verified-by.md) — the frontmatter field holding a statement's evidence edges (inline list of stable ids)
