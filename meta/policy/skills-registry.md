---
type: policy
title: Skills registry
description: The available skills and where new skills are added.
section: skills
order: 1
status: active
tags: [meta, governance, skills]
timestamp: 2026-07-13
---
- **`/intake`** — process pasted content into one or more filed documents. See
  `.claude/skills/intake/SKILL.md`. This is the primary way knowledge enters the
  brain.
- **`/render-contract`** — recompile `CLAUDE.md` from `meta/policy/*.md` after editing
  any policy. See `.claude/skills/render-contract/SKILL.md`. `CLAUDE.md` is a
  generated artifact — never hand-edit it.
- **`/capture`** — persist the current session as a **distilled** thread doc under
  `meta/threads/`: substantive exchanges only (tool calls, reasoning, and short
  pre-tool narration stripped), then a routing ledger and route tags over the frozen
  body. This is the session-persistence skill. See `.claude/skills/capture/SKILL.md`.
- **`/summarize-technical`** — produce a three-part layered breakdown of a technical
  paper/article/spec: a plain-language summary, a glossary of its key technical terms,
  then an integrated technical summary reusing those terms. See
  `.claude/skills/summarize-technical/SKILL.md`.
- **`/elaborate`** — unpack a technical **phrase or short passage** (from the
  conversation, a doc, a commit message, or pasted text): define the terms it uses and
  give a less technical overview of the concepts and actions it describes, delivered
  in chat **and persisted** as a `type: elaboration` doc under
  [`meta/elaborations/`](/meta/elaborations/index.md) (governance namespace, no `sb:`
  id; link glossary terms that already exist; hand off to `/add-to-glossary` to
  persist new ones per-term). The doc's `thread` back-link to its originating session
  is set later by `/create-pull-request`, never by this skill. The phrase-scale
  sibling of `/summarize-technical`. See `.claude/skills/elaborate/SKILL.md`.
- **`/add-to-glossary`** — scan a persisted thread (`meta/threads/`), a paper, a post,
  or a filed document; extract the technical terms it actually uses; and merge distilled
  definitions into the glossary — **one `concept` document per term** under
  [`/beliefs/glossary/`](/beliefs/glossary/index.md) (hub: [`/beliefs/glossary.md`](/beliefs/glossary.md)), each with
  its own `sb:` id and *Seen in:* citations, so any response or document can cite a
  term by link (pointer entries defer to filed documents instead of duplicating them).
  Also invoked automatically by `/create-pull-request` on the thread doc its
  `/capture` step writes. See `.claude/skills/add-to-glossary/SKILL.md`.
- **`/research`** — generate today's **inbox**: a daily candidate feed of research, articles,
  papers, and resources matched against the brain's taxonomy, grouped by category and
  reason-tagged (`recent`/`impactful`/`influential`/`groundbreaking`/`buzz`) — then
  **auto-intake the featured items** into the bundle via `/intake`. The digest is the
  dated record in the non-bundle `inbox/` namespace (no `sb:` ids); its featured items
  graduate into filed documents in the same run, bounded to the known tree (items needing
  a new top-level domain are deferred for operator ratification) and tagged `auto-intake`
  for the operator's post-intake editorial pass. See `.claude/skills/research/SKILL.md`.
- **`/create-pull-request`** — run `/capture` to completion, run `/add-to-glossary`
  over the captured thread doc, **back-link this session's elaboration docs** (set
  `thread:` in each `meta/elaborations/` doc the session created or updated, pointing
  at the just-captured thread), then commit the current working changes, push the
  branch, and open a pull request — so the frozen thread doc, the glossary updates it
  feeds, and the elaboration trace all ship in the same PR. Invoking the skill **is**
  the authorization to open the PR (no separate confirmation gate); PR-template
  detection and the GitHub MCP tools handle the rest. See
  `.claude/skills/create-pull-request/SKILL.md`.
- **`/todo`** — add and list `type: todo` task items under `meta/todos/`. Dispatches on
  a subcommand argument: `/todo create <title>` files a new open todo (and maintains
  the index); `/todo list` shows the todos grouped by `status`. See
  `.claude/skills/todo/SKILL.md`.
- **`/priorities`** — list the brain's open work as a prioritized appraisal: runs
  `mix brain.session_init` (open issues, open todos, active plans, dangling ledger
  strands) and closes with a heuristic top-3 the agent refines with judgment — the
  on-demand successor to the old SessionStart digest (no longer auto-injected at
  session start). Read-only. See `.claude/skills/priorities/SKILL.md`.
- **`/issue`** — list `type: issue` tracked problems under `meta/issues/`, grouped by
  `status` (default `open`). The issues-only slice of `/priorities`; read-only
  (filing an issue stays inline per the contract). See `.claude/skills/issue/SKILL.md`.
- **`/plan`** — list `type: plan` design/decision records under `meta/plans/`, grouped
  by `status` (default `active` = proposed/accepted/in-progress). The plans-only slice
  of `/priorities`; read-only (persisting a plan stays inline per the persist-plans
  policy). See `.claude/skills/plan/SKILL.md`.

New skills are added under `.claude/skills/<name>/SKILL.md`.
