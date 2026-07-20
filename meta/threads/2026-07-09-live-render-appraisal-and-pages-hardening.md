---
type: reference
title: 2026-07-09-live-render-appraisal-and-pages-hardening
description: Built a parallel mix brain.render site generator, then — on finding the other thread had already shipped mix brain.site to main — abandoned it, appraised the shipped version, and instead landed two safety fixes (deploy-gating on verify, link-href escaping) plus a tutorial as PR #16.
provenance: "Claude Code session (Claude Fable 5, then Claude Opus 4.8 after a mid-session model switch), 2026-07-09; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, github-pages, ci, site-generator, markdown, tooling]
timestamp: 2026-07-09
session: https://claude.ai/code/session_01TCKnEf8uGDcK7ihcJ3SVfN
pr: 28
---

# 2026-07-09-live-render-appraisal-and-pages-hardening

## Where this landed

The session opened as "how would we live-deploy an HTML render of the brain on
push?" and I built a full parallel implementation — a dependency-free
`mix brain.render` with its own `SecondBrain.Site`/`SecondBrain.Markdown`. On
pulling `main` we discovered another thread had already shipped an equivalent,
fuller `mix brain.site` generator (PR #12). Rather than merge a competing build,
I evaluated both end-to-end, recommended keeping the shipped one, and **abandoned
my branch** — resetting it to `main`.

What survived was small and additive: two safety fixes ported onto the shipped
generator — **gating the Pages deploy on the bundle-integrity checks** (so the
live site only ever renders a verified bundle) and **escaping rewritten link
hrefs** (an unescaped-attribute XSS class, the same one that got Earmark
retired) — plus GFM table-alignment and Pages auto-enablement. These shipped as
**PR #16**, along with a `type: tutorial` explaining the deploy-gating mechanic.
The operator confirmed none of the abandoned implementation leaked in (verified
three ways), then had me merge; the post-merge run on `main` — the first real
exercise of the gate — passed, and the live site deployed at
https://ob6to8.github.io/second-brain/.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Parallel `mix brain.render` generator — built, then abandoned once the shipped `mix brain.site` was found on `main` | closed | `unrouted` | - |
| Appraisal of the shipped `mix brain.site` vs the abandoned build; decision to keep theirs and port two safety fixes | closed | `unrouted` | - |
| Deploy-gating the Pages site on the integrity checks + Pages auto-enablement (PR #16) | closed | [/meta/tutorials/gating-the-pages-deploy-on-a-verified-bundle.md](/meta/tutorials/gating-the-pages-deploy-on-a-verified-bundle.md) | - |
| Markdown converter hardening — escape link hrefs (XSS class) + GFM table alignment | closed | `unrouted` | - |
| Tutorial explaining the deploy-gating mechanic | closed | [/meta/tutorials/gating-the-pages-deploy-on-a-verified-bundle.md](/meta/tutorials/gating-the-pages-deploy-on-a-verified-bundle.md) | - |
| Confirm the abandoned implementation didn't reach PR #16; merge and verify the post-merge deploy | closed | `unrouted` | - |

## User

What might it look like to create some sort of live deployed html render of the concept collection that updates on github push. Could this be something like github pages? Or cloudflare?

## Assistant

Yes — this is a very natural fit for a static-site pipeline, and the repo is already 90% set up for it. Here's my assessment of what it would look like, and where GitHub Pages vs Cloudflare each land.

## The shape of the thing

The bundle is already a static site waiting to happen: every concept is markdown with YAML frontmatter, the `index.md` files at each level are literally navigation pages, and CI already runs on every push. So the architecture is just one more stage bolted onto what exists:

```
push to main
  → CI verifies bundle (already exists: brain.verify, registry check, etc.)
  → generator renders *.md → HTML (respecting frontmatter, index.md hierarchy)
  → deploy the rendered output to a host
```

The interesting decisions are (1) which generator and (2) which host.

## Generator options

**Reuse the Elixir tooling (`mix brain.render`).** You already have `SecondBrain.Frontmatter` parsing the exact YAML subset the bundle uses, and the registry gives you id → path for resolving `verified_by` edges into rendered evidence links — something no off-the-shelf tool will understand. The catch: the project deliberately has zero deps, and writing a markdown-to-HTML converter in stdlib Elixir is real work. Adding Earmark (a pure-Elixir markdown library) as the first dependency would make this straightforward, and it could render things generic tools can't: type badges, verified/unverified indicators, provenance blocks, evidence chains from `mix brain.evidence`.

**Off-the-shelf SSG.** [Quartz](https://quartz.jzhao.xyz/) is worth a specific mention because it's built precisely for publishing second brains — backlinks, an interactive graph view of concept links, full-text search, and it consumes markdown-with-frontmatter directly. Hugo or MkDocs Material would also work with near-zero config since your bundle-absolute links (`/references/foo.md`) map cleanly onto site routes. The trade-off: these treat your frontmatter as generic metadata, so `verified_by`, `provenance`, and the type vocabulary render as inert key-value lists rather than first-class UI.

**GitHub Pages' built-in Jekyll** is the zero-effort floor — flip a switch, no workflow needed — but it will fight you on the frontmatter-less `index.md` convention and give you a generic doc site.

My take: start with Quartz or a small `mix brain.render` depending on whether you value the graph/search experience (Quartz) or OKF-aware rendering that grows with the policy layer (Elixir). The Elixir route fits the repo's ethos — the render becomes another compiled artifact like `CLAUDE.md` and the registry.

## GitHub Pages vs Cloudflare

The decisive question is **privacy**. This is a personal second brain — do you want it on the public internet?

| | GitHub Pages | Cloudflare (Workers/Pages) |
|---|---|---|
| Setup | One workflow step (`actions/deploy-pages`), zero accounts | Cloudflare account + wrangler deploy step or git integration |
| Push-triggered | Native via Actions | Native (git integration) or via Actions |
| Access control | **Public only** (private Pages requires GitHub Enterprise) | **Cloudflare Access** can gate the whole site behind your Google login — free tier covers up to 50 users |
| Custom domain / edge | Yes, basic | Yes, plus edge functions if you ever want dynamic bits (search API, on-demand evidence rendering) |
| Cost | Free | Free tier is ample for this |

So: if the rendered brain is fine being public (or you'd curate what publishes), **GitHub Pages is the least machinery** — one extra job in the existing `ci.yml` that runs the generator and calls `actions/upload-pages-artifact` + `actions/deploy-pages`, gated on the verify job passing so a broken bundle never deploys. That gating is a nice property: the site is only ever a render of a *verified* bundle.

If you want it private — which I'd guess is the case for a second brain containing personal areas — **Cloudflare is the practical answer**: deploy to Cloudflare Workers/Pages from the same Action (via `wrangler`), and put Cloudflare Access in front so only mreveley@gmail.com can view it. GitHub simply doesn't offer authenticated Pages outside Enterprise.

## Concretely, the minimal GitHub Pages version

A new job appended to `.github/workflows/ci.yml`:

```yaml
  deploy:
    needs: verify
    if: github.ref == 'refs/heads/main'
    permissions: { pages: write, id-token: write }
    environment: github-pages
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: erlef/setup-beam@v1
        with: { otp-version: "25", elixir-version: "1.14" }
      - run: mix brain.render --out _site   # or: npx quartz build
      - uses: actions/upload-pages-artifact@v3
        with: { path: _site }
      - uses: actions/deploy-pages@v4
```

The Cloudflare variant swaps the last two steps for `wrangler deploy` (or you skip Actions entirely and point Cloudflare's git integration at the repo with the build command).

**Recommendation:** decide the privacy question first — it picks the host for you. Then I'd lean toward a small `mix brain.render` task (with Earmark as the bundle's first dependency) so the site understands types, verification status, and evidence edges natively, deployed to Cloudflare behind Access. If you'd rather see something live today with graph view and search for free, Quartz + GitHub Pages is an afternoon.

Happy to build either — say the word on public vs. private and generator choice and I'll wire it up on this branch.

## User

Public is fine
Would like to stay elixir
Fine with taking on deps ie: Earmark etc

## Assistant

Done — the live render is built and pushed to `claude/concept-collection-live-render-nvx07g`. All 34 bundle pages render, the full test suite (34 tests) passes, and CI's existing checks (format, contract, registry, verify) are all green.

**One important pivot from the plan: no Earmark.** When I went to add it, it turned out Earmark has been retired upstream ("no longer maintained, migrate to MDEx") and its final release carries an unpatched stored-XSS advisory (CVE-2026-48591). I then tried the recommended successors and both failed in restricted sandboxes: MDEx needs a Rust NIF downloaded from GitHub releases (the sandbox proxy denies it, and it requires Elixir ≥1.15), and the pure-Elixir `md` pulls in floki, which needs leex build tooling this sandbox's OTP install lacks. Since this repo's whole ethos is "tooling runs offline in any sandbox" (the frontmatter parser was hand-rolled for exactly this reason), I wrote a small dependency-free `SecondBrain.Markdown` instead — it covers everything the bundle's markdown uses (headings with anchors, nested lists, fenced code, blockquotes, GFM tables, inline formatting, links, autolinks) and never passes raw HTML through, so it's XSS-immune by construction. The project stays at zero deps; if you ever want a full CommonMark engine, swapping MDEx into `Site.render_page/2` is a one-line change.

What's on the branch:

- **`mix brain.render`** — compiles every page (concepts, `index.md`/`log.md`, `meta/` governance, `CLAUDE.md`, the registry) into `_site/`, which is gitignored: the site is a regenerated view, same philosophy as `CLAUDE.md` and `meta/registry.md`. OKF-aware rendering: type and verified/unverified badges, tags, id chip, description, provenance, `resource` link, and `verified_by` edges resolved through the registry into clickable evidence links (you can see this on the git-fetch concept screenshot — "Grounded by: Pro Git…, gitglossary…").
- **Relative-link rewriting** — bundle-absolute prose links like `/SWE/index.md` become page-relative `.html` links, so the site works under the `https://ob6to8.github.io/second-brain/` base path without any configuration.
- **`deploy-pages` CI job** — runs only on pushes to `main`, only after `verify` succeeds, so the live site is always a render of a valid, verified bundle. It uses `actions/configure-pages` with `enablement: true`, which should switch Pages on automatically the first time it runs — no repo-settings step needed.

Once this merges to `main`, the first CI run will publish the site at **https://ob6to8.github.io/second-brain/**, and every subsequent push re-deploys it. If you'd like, I can open a PR for the branch.

## User

Pull main and merge to update branch

*(The session was running Claude Fable 5, which hit its usage limit at this point; the operator switched the model to Claude Opus 4.8 via `/model` and re-sent the instruction. An earlier `Continue` / `Continue from where you left off.` nudge during the first build is likewise omitted as noise.)*

## Assistant

Found it. The file contains a lone table-like line inside a blockquote:

```
> | Attached to | The cloud environment | Your repository |
```

That's a `|...|` row with **no separator row** following it, so it's not a real GFM table. My `blocks/2` routes into the table branch only on `table_start?` (header + separator), but `paragraph_line?` *excludes* any table-row line — so this line matches no consuming branch and the paragraph fallback splits to empty, recursing forever on the same line. It's a general bug: any stray `|...|` line hangs the renderer. The fix is to guarantee the paragraph branch always consumes at least the current line.

Done. The branch is now updated with `main` and pushed.

**What happened:** The merge brought in main's new work — the `SWE/agentic-coding/` subtree (16 agentic-loop references, the CCR architecture notes and source excerpts), the `SWE/testing/` subtree, and the reframed verification model. Two log files conflicted, but only because both sides appended entries under the same `## 2026-07-06` heading; I kept both sets.

**One real bug caught by the merge:** one of main's new files (`cloud-web-environments-carry-config.md`) embeds a lone pipe row inside a blockquote — `> | Attached to | ... |` — which is *not* a full GFM table (no separator row). My markdown renderer had a latent infinite loop: such a line matched no block-consuming branch, and the paragraph fallback also refused it, so it recursed forever on the same line. This would have hung the Pages deploy on every push. Fixed by making the paragraph branch always consume the current line (guaranteeing progress), with a regression test for both the bare and blockquoted forms. Stray pipe rows now render as literal text.

**Verification after the merge:**
- Render completes: **63 pages** (was 34), no hang
- **35 tests pass** (added the regression test)
- Format, `mix compile --warnings-as-errors`, `brain.contract --check`, `brain.registry --check`, and `brain.verify` all green

I split it into two commits — the merge (log resolution) and the renderer fix — so history stays clear. Branch `claude/concept-collection-live-render-nvx07g` is pushed and current with `main`.

## User

This was accidentally implemented by another thread. Pull main and evaluate the shipped functionality. What is your appraisal of it vs what you built? Is rhere anything we shoukd consider changing?

## Assistant

Their markdown converter is **correct where mine was buggy** — their paragraph predicate keys off `table_start?` (header + separator), consistent with the block router, so a lone `|…|` line is always consumed as a paragraph. No infinite loop. Cleaner predicate design than my original.

Confirmed — a real (if low-severity) bug in their converter: `rewrite_href`'s output goes into `<a href="...">` **without escaping**, so a URL containing `"` breaks out of the attribute (`href="…/a"onmouseover="alert(1"`), and `&` in URLs isn't turned into `&amp;`. Mine escapes the whole text *before* substituting links, so it doesn't have this. Ironic detail: unescaped-attribute XSS is the exact CVE class both threads cited when rejecting Earmark. Let me clean up and give you the appraisal.

Here's my appraisal after building and testing both end-to-end.

## Verdict: keep theirs. It's the better product.

The version that shipped on `main` (PR #12, `mix brain.site`) is a fuller, well-engineered docs site. I built it, ran its 69 tests (all green), and screenshotted it — sidebar taxonomy tree with active-state highlighting, breadcrumbs, a working client-side search index, a clean metadata table, **reverse backlinks ("Cited by")**, a persisted light/dark toggle, and separated cacheable CSS/JS assets. Mine (`mix brain.render`, still unmerged on my branch) is a simpler single-column reading view with none of the navigation or search. Same core philosophy in both — dependency-free, reuses `Frontmatter`, relative links, `.nojekyll`, metadata panels driven by `verified_by` — but theirs is the more complete realization.

So the two of us converged on the same design; they just took it further. I'd **retire my branch** rather than merge it.

## But there are 2 things worth porting from mine — both about safety, not features

<routes ref="meta/tutorials/gating-the-pages-deploy-on-a-verified-bundle.md .github/workflows/pages.yml">
**1. The Pages deploy isn't gated on the bundle verifying. (This is the one that matters.)**
Their `pages.yml` is a standalone workflow: on push to `main` it checks out, builds, and deploys — with no dependency on `ci.yml`'s `verify` job. The two run in parallel, so if `mix brain.verify` fails (broken evidence edge, stale `CLAUDE.md`, duplicate id), **the site still deploys**. Their `ci.yml` adds a "site builds" smoke check, but *builds ≠ verifies*. My branch gated deploy on `needs: verify`, so the live site was only ever a render of a valid, verified brain. I'd fold that gating in — either give the Pages `build` job a `needs`/verify dependency, or move deployment into `ci.yml` after `verify`.
</routes>

<routes ref="lib/elixir_mind/markdown.ex">
**2. Unescaped `href` in the markdown converter (a real, verifiable bug).**
Their inline pipeline lifts links out *before* the escape pass and never escapes the URL, so I confirmed:
- `[x](…/?a=1&b=2)` → `href="…/?a=1&b=2"` (should be `&amp;` — invalid HTML)
- `[x](…/a"onmouseover="alert(1))` → the `"` breaks out of the attribute

For a personal brain with operator/agent-authored content the risk is low, but it's a genuine correctness bug and it's *exactly* the unescaped-attribute XSS class (CVE-2026-48591) both threads cited to justify dropping Earmark — so it'd be good to close. One-line fix: escape the rewritten href before interpolating.
</routes>

**Minor / optional:** their tables don't honor `:--`/`--:` alignment (mine did); and their `pages.yml` needs a manual one-time "set Pages source to GitHub Actions" (my `actions/configure-pages@v5 { enablement: true }` auto-enables it on first run) — worth adding so the first deploy just works.

**One latent bug they *don't* have:** the infinite-loop-on-stray-pipe-row I hit and fixed on my branch. Their paragraph predicate keys off `table_start?` (header + separator) consistently with their block router, so a lone `|…|` line is always consumed. Cleaner than my original — no action needed there.

## Recommendation

Keep `main` as-is, abandon my branch, and apply two small hardening changes onto the shipped version:
1. Gate the Pages deploy behind `verify` (highest value).
2. Escape hrefs in `SecondBrain.Markdown`.

Optionally: table alignment + Pages auto-enablement.

Want me to open a small PR against `main` with #1 and #2 (plus the optional bits if you like)? It's ~15 lines across `pages.yml` and `markdown.ex` and I'd add a regression test for the href escaping.

## User

Yes

## Assistant

PR opened: **[#16 — Harden the Pages site: gate deploy on verify, escape link hrefs](https://github.com/ob6to8/second-brain/pull/16)**

## What's in it

Four changes on top of the shipped `mix brain.site` generator — two safety fixes, two niceties, no feature changes:

1. **Deploy gated on verify** — the Pages build job now runs `brain.contract --check`, `brain.registry --check`, `brain.verify`, and `brain.route_tags` before building, so a push that fails verification no longer publishes to the live site.
2. **Href escaping** — fixed the unescaped-attribute bug in the markdown converter (`&` → `&amp;`, and a `"` can no longer break out of `href="…"`). Same CVE class both threads cited to drop Earmark.
3. **Table alignment** — `:--`/`:-:`/`--:` now honored (was discarded).
4. **Pages auto-enable** — `configure-pages` so the first deploy needs no manual settings toggle.

## Verified

73 tests pass (+4 new regressions), format/compile clean, all CI gates green, full 90-page site builds, and I confirmed rendered hrefs are escaped and table pages (`CLAUDE.md`) render unchanged.

Housekeeping note: I restarted the designated branch from `main` for this — it previously held my now-abandoned parallel implementation, which never had a PR, so the force-push was clean.

Want me to watch PR #16 and autofix any CI failures, or is it fine to leave with you to review and merge?

## User

Create a tutorial explaining the mechanics of this "Now I’ll gate the Pages build on the same verification checks CI runs, so the live site only ever reflects a valid, verified bundle"

## Assistant

Done. The tutorial is filed and pushed.

## What I created

**[`meta/tutorials/how-the-pages-deploy-is-gated-on-a-verified-bundle`](https://github.com/ob6to8/second-brain/blob/claude/concept-collection-live-render-nvx07g/meta/tutorials/gating-the-pages-deploy-on-a-verified-bundle.md)** — a `type: tutorial` doc matching the house style of the existing offline-toolchain tutorial. It explains the mechanics start to finish:

- **Two workflows, one push** — `ci.yml` and `pages.yml` both fire on a push to `main` and run in *isolation*, so originally the deploy proceeded regardless of whether CI went red.
- **Why `needs:` can't fix it** — `needs:` only orders jobs *within* one workflow file; the dependency graph is per-workflow. It lays out the three real cross-workflow options (`workflow_run`, consolidate, repeat-the-gate) and why repeat-the-gate shipped.
- **The gating primitive** — a `run:` step that exits non-zero fails the `build` job, later steps (including `mix brain.site` and the artifact upload) are skipped, and `deploy` (which `needs: build`) never runs. It also makes the "fails safe" point: gating blocks a *bad* publish but leaves the last good site live.
- **What the four checks guarantee** vs. why the test suite is deliberately *not* in the gate (bundle validity vs. code correctness).
- **The trade-off** — duplication between the two workflows and the drift risk, with the consolidation alternative noted.

I filed it autonomously into the existing `meta/tutorials/` directory (governance namespace, so no `sb:` id), added it to the tutorials `index.md`, and logged it in `meta/log.md` — per the maintain-reserved-files policy. All integrity gates stay green (`verify`, `route_tags`, `registry --check`, `contract --check`), and the site builds to 91 pages with the tutorial rendering correctly under Meta › Tutorials.

**Note on where it landed:** it's committed to the same branch as the hardening changes, so it's now part of **PR #16**. That's thematically coherent — the tutorial documents the exact gating mechanic that PR introduces — but if you'd rather keep the PR purely to the code change, I can split the tutorial onto its own branch/PR. Your call.

## User

What work is in the first commit on this thread? I don't want any of the work that was done on the site in this thread to make its way in

## Assistant

Here are the exact facts.

**The first commit on this thread** was `6f26b4e` — my *own* parallel site implementation: `mix brain.render`, my versions of `SecondBrain.Site` and `SecondBrain.Markdown`, `lib/mix/tasks/brain.render.ex`, their tests, and a `deploy-pages` job in `ci.yml`. That's the work we agreed to abandon once we saw the other thread had already shipped `mix brain.site` to `main`.

**None of it is on this branch.** When we abandoned it, I reset the branch with `git checkout -B … origin/main`, which dropped that commit (and its two follow-ups), and force-pushed so the remote lost them too. I verified this three ways just now:

- `6f26b4e` is **not an ancestor** of the current branch.
- `lib/mix/tasks/brain.render.ex` is **not tracked**.
- `lib/second_brain/site.ex` is **byte-identical to `main`**, and `lib/second_brain/markdown.ex` differs from `main` *only* by the hardening edits.

**The current branch adds exactly two commits over `main`:**
1. `1eeacfc` — the hardening (PR #16): `pages.yml` deploy-gating, `markdown.ex` href-escape + table-alignment, README note, tests.
2. `38cb0e6` — the tutorial.

So my abandoned `brain.render` work is fully gone. The one thing I can't decide for you: the **hardening commit is also "site work done in this thread"** — but it edits the *shipped* site (the other thread's files) rather than my abandoned rewrite, and you approved it earlier. I don't want to assume which you mean.

You're all set — nothing to change.

The abandoned `brain.render` implementation (the first commit on this thread, `6f26b4e`) is completely off this branch and off the remote, verified three ways. PR #16 stays as-is: the two commits over `main` are the approved hardening (`1eeacfc`) and the tutorial (`38cb0e6`), and both `site.ex` (identical to `main`) and `markdown.ex` (only the hardening edits) confirm none of my parallel rewrite leaked in.

## User

Anything left to do here?

## Assistant

CI is green on the merge commit. **PR #16 is now conflict-free and passing.**

## Where things stand

There *was* something left — the PR had gone stale. `main` advanced by four merged PRs (#18–21: the `inbox/`/`/news` namespace, a `meta/issues/` namespace + `issue` type, and two new tutorials), which put PR #16 into a conflicted (`dirty`) state. I:

- Merged `main` into the branch and resolved the two conflicts (both purely additive — the tutorials index and `meta/log.md`), keeping every side's entries.
- Re-ran the full suite on the merged tree: **73 tests pass**, all four integrity gates green (`contract --check`, `registry --check`, `verify`, `route_tags`), and the site builds **101 pages** (now including `inbox/` and `meta/issues/`).
- Confirmed the hardening edits survived the merge intact (href-escape + table-align in `markdown.ex`, gating in `pages.yml`).
- Pushed; **CI re-ran green** on the merge commit and the PR is mergeable.

Worth noting: one of `main`'s new tutorials, *"Bundle scope and non-bundle namespaces,"* is complementary to mine — it covers the four scanners' scope, while mine covers the deploy-gate mechanic. No overlap.

**Now genuinely done on my end.** PR #16 is green, up to date with `main`, and ready for your review/merge. The only remaining action is yours: merge it. Want me to watch it and autofix if anything regresses, or leave it with you?

## User

Merge it and autofix

## Assistant

Merged (main is now `934ce4a`). The important thing to watch now is the **post-merge run on `main`** — this is the first-ever Pages deploy, exercising my gating changes and `configure-pages` enablement. Since the PR is closed, I'll monitor `main`'s workflow runs directly rather than via PR webhooks. Let me find the runs triggered by the merge.

Both post-merge workflows on `main` (merge commit `934ce4a`) completed **successfully**:

- **CI** (`verify`) — ✅ success
- **Deploy knowledge base to GitHub Pages** — ✅ success

## Done — everything's green

PR #16 is **merged** and the post-merge deploy passed. Notably, this run was the first real exercise of the deploy-gating change: the four integrity checks (`brain.contract --check`, `brain.registry --check`, `brain.verify`, `brain.route_tags`) ran inside the Pages `build` job, passed on the verified bundle, and only then did `mix brain.site` build and `deploy` publish. The gate worked exactly as designed.

The live site is at **https://ob6to8.github.io/second-brain/**, now serving the merged bundle — including your new tutorial and, from the escaping fix, correctly-escaped links.

Nothing to autofix — there were no failures to catch. Both the abandoned implementation and any conflicts are behind us; the hardening + tutorial shipped clean. Since the PR is merged and `main` is green, there's no open PR left to babysit, so I'll stop here rather than schedule idle check-ins. If you push more to `main` and want me to keep an eye on the deploy, just say so.
