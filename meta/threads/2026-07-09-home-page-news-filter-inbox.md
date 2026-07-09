---
type: reference
title: "Thread — home-page news-filter inbox (/news + inbox/ namespace)"
description: Designed and built a daily, taxonomy-matched candidate feed — the /news skill and a non-bundle inbox/ namespace with reason tags — then wrote a tutorial on the scanner-scope finding that made it CI-safe.
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-09; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, inbox, news, skills, namespaces, tooling]
timestamp: 2026-07-09
---

# Thread — home-page news-filter inbox (/news + inbox/ namespace)

## Where this landed

The operator asked what a "home page" news-filter inbox would look like: a daily,
regenerated feed of news/articles/papers/resources matched against the brain's
taxonomy, each item reason-tagged (`recent`/`impactful`/`influential`/`groundbreaking`/`buzz`)
with a synopsis, filed under KB-mirroring categories, with an option to hand a link
off into the brain. After a design proposal and a three-question ratification (the
operator selected all recommended options via a screenshot), the feature was built
end-to-end: the **`/news`** skill, a non-bundle **`inbox/`** namespace (candidates,
no `sb:` ids), a real first digest (`inbox/2026-07-09.md`, 7 items), site + root-index
wiring, and registration in the skills registry (recompiled `CLAUDE.md`). The load-bearing
implementation insight — that `SecondBrain.Registry`'s excluded-dirs list *defines* what
a bundle concept is, so `inbox/` had to be added there or CI's `mix brain.verify` would
demand `sb:` ids — was later written up as a tutorial. All gates stayed green across two
commits (`7efb6be`, `b08f142`). Two items remain unresolved: the daily cron **Routine**
could not be created (the trigger tool is permission-gated and its approval stream failed
here; it also depends on the branch merging to `main`), and whether to open a **PR** is
still the operator's call.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Design + build of the home-page news-filter inbox (taxonomy-as-query, reason tags, daily regen, intake handoff) | closed | [/.claude/skills/news/SKILL.md](/.claude/skills/news/SKILL.md) | - |
| `inbox/` as a non-bundle namespace + first daily digest | closed | [/inbox/index.md](/inbox/index.md) | - |
| Registry-exclusion finding → which scanner sees what, and CI safety | closed | [/meta/tutorials/bundle-scope-and-non-bundle-namespaces.md](/meta/tutorials/bundle-scope-and-non-bundle-namespaces.md) | - |
| Is the `/news` purpose self-contained in the skill? (operator question) | closed | [/.claude/skills/news/SKILL.md](/.claude/skills/news/SKILL.md) | - |
| Daily cron Routine for `/news` | paused | `unrouted` | Trigger tool is permission-gated (approval stream failing) and depends on the branch merging to `main` |
| Open a PR for the branch | open | `unrouted` | Operator hasn't decided; offered at the end of two turns |

## User

What would it look like to crate a "home page" news filter inbox that searches for news, articles, papers, and resources that match the categories here in the knowledge base? The idea would be to be able to come to this with tagged/categorized entries/links, and each one including a brief synopsis. I would also have the option of telling the agent that I would like to process a link into the knowledge base. These would be regenerated daily, with previous days being persisted. Links should be filed under categories that mirror the knowledge base, and should be tagged according to why it was chosen:
- recent
- impactful
- influential
- groundbreaking
- buzz

## Assistant

I've now got a clear picture of how the brain is built — the OKF bundle, the `mix brain.*` tooling, the static-site generator, the skills, and the taxonomy protocol. Here's what this feature would look like, designed to fit inside that architecture rather than bolt onto it.

## The core idea

A **daily-regenerated candidate feed** that lives in its own namespace, mirrors the KB taxonomy, and hands off to `/intake` when you decide to keep something. It is deliberately *not* part of the OKF bundle — it's the waiting room *outside* the brain.

That distinction is the crux, because your contract has a rule that would otherwise forbid this outright:

> **Links must be processed, not parked.** A web resource enters the brain only once it has been processed into a `reference`… There is deliberately no lightweight "bookmark" type.

The inbox doesn't break that rule — it *respects* it. Inbox items are **candidates awaiting your decision**, held in a separate namespace (like `meta/` governance sits beside the taxonomy, carrying no `sb:` ids). Nothing enters the bundle until you say "intake this," at which point the existing `/intake` skill fetches, distills, mints an id, and files it. The inbox is the funnel; the brain stays clean.

## File layout

```
inbox/
  index.md              # "home page": today's digest inline + archive list (reserved, no frontmatter)
  log.md                # generation history, newest first
  2026-07-09.md         # today's digest  (type: reference, no sb: id — governance-style namespace)
  2026-07-08.md         # persisted, untouched
  2026-07-07.md
  ...
```

One **digest doc per day** (not one file per link — that would look exactly like the "parked bare links" the contract forbids). Each digest is `type: reference` because every item carries a synopsis: it's a *processed* digest, not a dump. Days are inherently time-ordered, so the `YYYY-MM-DD-` filename convention from your filing rules applies directly.

## What a day looks like

`inbox/2026-07-09.md`, grouped by the **same top-level categories as the KB** (`SWE`, `ai-industry`, `knowledge-management`), each item = link · synopsis · reason-tag · suggested filing path:

```markdown
---
type: reference
title: "Inbox — 2026-07-09"
description: Daily candidate feed matched against the brain's taxonomy; 7 finds across 3 domains.
provenance: "Generated by /news — WebSearch + alphaXiv + HN, matched against KB index tree, 2026-07-09"
tags: [inbox, feed]
timestamp: 2026-07-09
---

# Inbox — 2026-07-09

## ai-industry
- **[Anthropic's Q2 economic index shows uneven enterprise AI adoption](https://…)**
  `impactful` — Fresh data backing the "long ROI runway outside tech" thesis you
  already filed; names the same slow sectors (healthcare, insurance).
  → would file under `/ai-industry/`  ·  relates to `sb:2867ac`

- **[GLM-6 released, matches frontier coding at 1/20th inference cost](https://…)**
  `groundbreaking` `buzz` — Extends the margin-collapse story directly.
  → would file under `/ai-industry/`  ·  relates to `sb:07610c`

## SWE
- **[Paper: Context compaction for long-horizon agent loops (arXiv)](https://…)**
  `influential` — Cited 40× in three weeks; relevant to your agentic-loop notes.
  → would file under `/SWE/agentic-coding/agentic-loop/`

## knowledge-management
- **[A critique of Zettelkasten at scale](https://…)**
  `recent` — Counterpoint to PKM assumptions; light but worth a glance.
  → would file under `/knowledge-management/`
```

Each item shows you *why it surfaced* (the reason tag), *where it would go* (a real bundle path), and *what it connects to* (existing `sb:` ids it echoes) — so a single glance tells you whether to intake it or skip it.

## The `/news` skill (generation flow)

A new skill under `.claude/skills/news/SKILL.md`. On each run it:

1. **Reads the taxonomy as the query profile** — walks the `index.md` tree plus concept titles/tags to derive per-category interest signals. The tree literally *is* the filter, so the feed evolves automatically as your brain grows (this is the "tree is the taxonomy" principle applied to retrieval).
2. **Searches per category** — `WebSearch`, `alphaXiv.discover_papers` for papers, HN, etc.
3. **Dedups twice** — against the bundle (don't resurface what you've already filed) and against recent digests (don't repeat yesterday's items).
4. **Selects and reason-tags** each survivor, groups by KB category, writes the digest, and updates `inbox/index.md` + `inbox/log.md`.

## Reason tags — a small governed vocabulary

Your five tags map to distinct, checkable signals so selection is consistent rather than vibes:

| Tag | Fires when |
|-----|-----------|
| `recent` | Published in the window; primary axis is freshness |
| `impactful` | Real-world consequence — shifts a decision, market, or practice |
| `influential` | Being cited / built on by others (citation velocity, references) |
| `groundbreaking` | Genuinely novel result or capability, not incremental |
| `buzz` | High discussion volume (HN points, social velocity) regardless of merit |

I'd register these in a tiny `meta/policy/inbox-selection-tags.md` so they're governed the same way your `type` vocabulary is — and so `/news` and any tooling share one definition.

## "Regenerated daily, previous days persisted"

The digest files are immutable once written (persistence = they just accumulate). For the *daily* trigger, the natural fit in this environment is a **Routine** (scheduled cron trigger via the Claude-Code-Remote integration) that fires `/news` into a session each morning. That's cleaner than a GitHub Action, because generation needs an agent (web search + judgment), not just `mix`. I'd set one cron trigger and you're done.

## The "home page" — site integration

Your bundle already publishes to GitHub Pages via `mix brain.site`. I'd teach the generator to render `inbox/` as the **landing view**: today's digest front-and-center, prior days in a collapsible archive, each item linking out — and each *already-intaken* item showing a backlink to the concept it became. That makes the inbox the literal home page of your published brain.

## The intake handoff

No new machinery — you point at an item ("intake the GLM-6 one") and the existing `/intake` runs: fetch → distill → file under the suggested path → mint id → update indexes. Optionally `/news` can then mark that digest line as `✓ intaken → /ai-industry/glm-6-margin.md` so the archive records what graduated into the brain.

---

## What needs your ratification

Per your own contract, four of these are *shape* changes I can't make autonomously — so before I build anything, these are your calls:

- **New top-level `inbox/` namespace** (vs. tucking it under `meta/`)
- **New `/news` skill** (skills-registry change) — and its name
- **The `meta/policy/inbox-selection-tags.md` policy** for the five reason tags
- **The daily Routine** (cron trigger) vs. running `/news` manually

Everything else (the digest format, taxonomy-as-query, `/intake` handoff) follows existing conventions and needs no new precedent.

---

The design proposal above is complete. My interactive question prompt didn't go through, so here are the three decisions I need from you to move forward — just reply with your picks:

**1. Where should the feed live?**
- **(a) Top-level `inbox/`** *(my recommendation)* — a sibling to the taxonomy, marked as a non-bundle namespace with no `sb:` ids, like `meta/`. Cleanest separation, and it becomes the natural site home page.
- **(b) Under `meta/inbox/`** — keeps the root uncluttered but conflates the feed with governance.

**2. How should the daily regeneration fire?**
- **(a) Routine / cron trigger** *(my recommendation)* — a scheduled trigger fires `/news` into a session each morning. Best fit, since generation needs an agent (web search + judgment), not just `mix`.
- **(b) Manual for now** — build the skill, you run `/news` when you want a fresh digest, automate later.

**3. What should I do next?**
- **(a) Build it end-to-end** *(my recommendation)* — scaffold the `/news` skill, the `inbox-selection-tags` policy, wire the site integration, and generate a real first digest — after you ratify the shape changes.
- **(b) Generate one sample digest first** — I run the search-and-select flow by hand once and write a real `inbox/2026-07-09.md` so you can see actual output before committing to the machinery.
- **(c) Just the written design** — keep this as a proposal; no files or skills yet.

A reasonable path if you want to see it work with the least commitment is **(b) + manual**: I produce a real digest today, you react to the actual output, and we harden it into a skill once the format feels right. If you'd rather just commit, **1a / 2a / 3a** builds the whole thing.

One note worth surfacing: options 1 and 2 are genuine changes to the *shape* of the brain (a new top-level namespace, a new skill, a new selection-tag policy), which your contract says I shouldn't create without your ratification — so I'll wait for your call before writing anything into the bundle.

## User

@"/root/.claude/uploads/f66236d9-9b79-5b95-8970-138961d79fc0/9a263de9-IMG_7346.png"

*(Screenshot of the operator's answers to the three questions — Namespace: **top-level `inbox/`**; Daily trigger: **Routine / cron trigger**; Next step: **Build it end-to-end** — each the recommended option. Later in the turn the operator also sent: "Proceed.")*

## Assistant

<routes ref="meta/tutorials/bundle-scope-and-non-bundle-namespaces.md lib/second_brain/registry.ex">
Critical finding: `Registry` (used by the verifier) scans all top-level dirs *except* an excluded list — and `inbox` isn't on it. So `inbox/*.md` would be required to carry `sb:` ids and would break CI. I need to add `inbox` to that exclusion list. Let me check the route-tags scanner and the site generator too.
</routes>

<routes ref="meta/tutorials/bundle-scope-and-non-bundle-namespaces.md lib/second_brain/registry.ex">
All clear on the mechanics. Route-tags scans only `meta/threads` + registry concepts, so excluding `inbox` from the registry keeps it out of every verifier. The site generator does *not* exclude `inbox`, so digests render into the published site automatically. My one required code change is adding `inbox` to the registry's excluded dirs.

Let me set up task tracking, load WebSearch, and run real searches for the first digest.
</routes>

Everything except the automated Routine is done, verified, committed, and pushed. The cron-trigger tool is permission-gated and its approval stream isn't resolving in this environment (it errored twice with "requires approval" — the same failure the earlier interactive prompt hit), so I can't create it for you from here. I'll hand you that one step below.

## Done — the news-filter inbox is built and pushed

Branch `claude/home-news-filter-inbox-wxqlpj` (commit `7efb6be`). All gates green: `compile --warnings-as-errors`, `format`, **69 tests**, `brain.contract --check`, `brain.registry --check`, `brain.verify`, `brain.route_tags`, and `brain.site` (94 pages, inbox included).

**What shipped**

- **`/news` skill** (`.claude/skills/news/SKILL.md`) — reads the taxonomy as its query profile, searches per domain, dedups against both the bundle and prior digests, reason-tags each find, writes the dated digest, and maintains the inbox reserved files. Registered in the skills-registry policy; `CLAUDE.md` recompiled.
- **`inbox/` namespace** — a non-bundle waiting room (like `meta/`): candidates carry no `sb:` ids and are never verified. One line in `registry.ex` (`inbox` added to excluded dirs) keeps it out of verify/registry/route-tags while the static site still renders it.
- **First real digest** — `inbox/2026-07-09.md`, 7 live items across ai-industry (3), SWE (3), knowledge-management (1), exercising all five reason tags. Each item has a synopsis, a `→ would file under /path` hint, and `sb:` back-links where it extends an existing concept (e.g. the Epoch inference-price data and the Matsuoka arXiv paper both back-link your margin-collapse note `sb:07610c`).
- **Home-page wiring** — `inbox/` is the landing section of the root `index.md`, and `inbox/index.md` carries Latest + Archive. In the published site it renders at `/inbox/`.
- **Intake handoff** — say *"intake the TurboQuant item"* (or any item) and `/intake` fetches, distills, mints an id, and files it. `/news` proposes; `/intake` is still the only path into the bundle.

**The one thing left to you: the daily Routine**

The scheduled trigger needs your approval and the tool won't complete it from here. Two ways to get it running:

1. **Easiest** — once this branch merges to `main` (so a fresh daily session has the `/news` skill), just tell me "create the daily news trigger" in a session where the approval prompt works, and I'll set it: **fresh session, `0 13 * * *` (daily 13:00 UTC)**, prompt = run `/news` → verify → commit/push to `main`.
2. **Now, yourself** — create a Routine with those same settings (daily cron, new-session-per-fire, the run-`/news`-then-push prompt).

Note the dependency either way: the daily job clones `main`, so it only produces digests **after this branch is merged**. Until then you can run `/news` manually anytime to regenerate today's feed.

Want me to open a PR for this branch, or leave it as a pushed branch for you to review first?

## User

Commit

Could you explain the following in more detail and save as a tutorial document?

"Critical finding: Registry (used by the verifier) scans all top-level dirs except an excluded list — and inbox isn’t on it. So inbox/*.md would be required to carry sb: ids and would break CI. I need to add inbox to that exclusion list. Let me check the route-tags scanner and the site generator too."

Is the purpose of the news skill as you've described it Persisted within the new skill itself?

## Assistant

<routes ref=".claude/skills/news/SKILL.md">
**On your skill question — yes, the purpose is fully self-contained in the skill.** `/news`'s reason for existing lives in two places inside `.claude/skills/news/SKILL.md`:

- The frontmatter `description:` — this is exactly what a fresh agent sees when skills are listed (you can see it echoed in the system reminder that announced the skill: *"Generate today's inbox — a daily candidate feed…"*). It travels with the skill; nothing external is needed.
- The opening body paragraph — the fuller "waiting room / candidates-until-intake" framing, plus the two contract rules that shape it.

So a sandboxed agent that has never seen this conversation gets the purpose, the procedure, and the guardrails from the file alone. The design rationale (*why* it's built this way — the tension with "links must be processed") is in the skill too, but the deeper mechanics of *how the namespace stays out of CI* is exactly what your tutorial request should capture, since that lives in the Elixir tooling, not the skill. Let me write that up.
</routes>

Done — committed and pushed (`b08f142`).

## The tutorial

Filed at `meta/tutorials/bundle-scope-and-non-bundle-namespaces.md` (`type: tutorial`), indexed, logged, and it renders into the published site. It expands that one-sentence finding into the full scoping model, grounded in the actual code. The core points:

- **There isn't one "what's in the brain" list — there are four scanners**, each answering a different question with its own scope: identity/verify (`Registry`→`Verifier`), route-tags (`RouteTags`), the contract compiler (`Contract`←`Policy`), and the site (`Site`).
- **`Registry.@excluded_dirs` *is* the definition of "bundle concept."** Anything the glob doesn't reject must carry an `sb:` id — so a bare new top-level dir like `inbox/` gets treated as concepts and trips the verifier's `missing stable id` rule, which is a required CI gate. One word (`inbox` on the list) removes it from the identity layer entirely.
- **The verifier and route-tags checker inherit that scope by delegation** — `Verifier.run/1` calls `Registry.scan/1`, and `RouteTags` draws its sinks from the registry — so the single edit propagates without touching either. (The note stresses *checking* this, which is why the original finding ends "let me check the route-tags scanner and the site generator too.")
- **The site is the deliberate exception**: its *separate* exclusion list omits `meta/` and `inbox/`, so they're published even though they're not identity-bearing. That gives the real lesson — membership is two orthogonal questions: *is it a concept?* (identity boundary) vs *is it published?* (rendering boundary) — plus a four-step checklist for adding any future non-bundle namespace.

## Recap on your skill question

The `/news` purpose is persisted in the skill file itself — both machine-visible (frontmatter `description`, which is what a fresh agent sees in the skill list) and human-readable (the opening body). A sandboxed agent needs nothing from this conversation to understand and run it.

## Still open: the daily Routine

That's the one piece I couldn't complete — the cron-trigger tool is permission-gated and its approval didn't resolve here (it errored on both attempts). When you're ready, say "create the daily news trigger" and I'll set it (daily `0 13 * * *`, fresh session, run `/news` → verify → push), or you can create it yourself. Either way it only starts producing digests once this branch is merged to `main`, since the daily session clones `main`. Want me to open a PR for the branch?

## User

Commit

Then run /capture

## Assistant

*(This `/capture` run — the session was frozen into this thread doc, its routing ledger written, and route tags applied over the frozen body.)*
