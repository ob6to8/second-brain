---
type: reference
title: 2026-07-22-qiju-thread-storage-and-fit-each-layer-doctrine
description: Decoding the qiju session-record tool led to a critique of the "distill, don't dump" slogan, its retirement into the fit-each-layer-to-its-purpose doctrine, an is-to-ought analysis and two glossary terms, two new future-beliefs (artifacts state what-is; off-repo rules must be correct-by-tool), and a liveness-aware mix brain.url that emits branch blob URLs until merge.
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-22; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, qiju, distillation, doctrine, is-ought, glossary, response-links, tooling]
timestamp: 2026-07-22
session: https://claude.ai/code/session_016sMoc9k6FSwoQgjtmuKS8K
pr: 127
---

# 2026-07-22-qiju-thread-storage-and-fit-each-layer-doctrine

## Where this landed

The session opened as a read-only decode of [qiju](https://github.com/jasonshrepo/qiju)
— a local-first session-record tool for coding agents — asking what it stores, what
its (unreadable) artifact demo showed, and what elixir-mind could learn. That surfaced
a philosophical tension the operator pressed hard: the brain's "distill, don't dump"
slogan is miscast — thread docs aren't clean dumps, knowledge docs aren't clean
distillations, and the two aren't a single axis but describe *different layers*. The
settled outcome retired the slogan and formalized the accurate direction as a
doctrine, [fit each layer to its purpose](/meta/doctrine/fit-each-layer-to-its-purpose.md)
(knowledge → concision + queryability; provenance → fidelity), with the old policy
reworked/renamed to [capture-knowledge-cite-the-source](/meta/policy/capture-knowledge-cite-the-source.md)
and a companion [is-to-ought analysis](/meta/analysis/is-to-ought-belief-grounds-doctrine.md)
plus glossary terms [normative conclusion](/beliefs/glossary/normative-conclusion.md)
and [descriptive premise](/beliefs/glossary/descriptive-premise.md).

Two general lessons were then captured as `future-beliefs` (both flagged as *oughts*
destined for doctrine): an artifact states what it *is*, not what it replaced (the
commit graph is the change-narrative layer); and a rule over off-repo output must be
made correct in the tooling it mandates, not merely asserted in prose. The last
concretely fixed a live bug — a Pages URL that 404'd for an unmerged doc — by making
`mix brain.url` liveness-aware (live Pages URL when a doc is on `main`, GitHub branch
blob URL until merged), backed by `SiteConfig.blob_url/2` and tests.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| qiju decode (storage model, cross-agent, distill-don't-dump) | closed | unrouted (external tool; no intake — operator's call) | - |
| "distill, don't dump" is miscast → per-layer doctrine | closed | [fit each layer to its purpose](/meta/doctrine/fit-each-layer-to-its-purpose.md) | - |
| Knowledge-layer filing rule kept as policy | closed | [capture-knowledge-cite-the-source](/meta/policy/capture-knowledge-cite-the-source.md) | - |
| doctrine vs belief; is-to-ought bridge | closed | [is-to-ought analysis](/meta/analysis/is-to-ought-belief-grounds-doctrine.md), [normative conclusion](/beliefs/glossary/normative-conclusion.md), [descriptive premise](/beliefs/glossary/descriptive-premise.md) | - |
| Belief: artifacts state what-is, not change history | closed | [future beliefs](/beliefs/future-beliefs.md) | - |
| Belief: off-repo rules must be correct-by-tool | closed | [future beliefs](/beliefs/future-beliefs.md) | - |
| Consistent working links → liveness-aware brain.url | closed | [response-resource-links policy](/meta/policy/response-resource-links.md), [lib/mix/tasks/brain.url.ex](/lib/mix/tasks/brain.url.ex) | - |

## User

consider this https://github.com/jasonshrepo/qiju and the demo https://claude.ai/code/artifact/4394e12e-677b-4ccf-af11-477e38c3e0e7?via=auto_preview

decode for me what exactly this is presenting as related to how threads are stored, what the artifacts demo is showing, and if there might be anything this repo could learn from this. do not /intake yet, don't want to intake if not useful or relevant

## Assistant

I could read the repo and its docs thoroughly, but **not the artifact demo** — claude.ai served it to me as a public (non-member) reader, which my tooling isn't allowed to open. So the demo section below is the one gap. If you paste its contents or a screenshot I'll fold it in; everything else is from the repo itself.

<routes ref="em:bec37f">
### What Qiju is, and how it stores "threads"

Qiju is a **local-first session-record system for AI coding agents** — a shared memory layer that Claude Code, Codex, Kiro, and Cursor all write to and read from, so an agent can "continue from verifiable development history" after the context window compacts or you switch tools. Three commands: `/qiju-log` (record what's worth keeping), `/qiju-search` (retrieve), `/qiju-review` (mine recent records for patterns).

The crux — and the part most relevant to us — is **what it stores and how**: it stores distilled decision records, never transcripts. A record is a structured JSON object (title, tags, search_terms, next_steps, redactions, body_md). The docs are explicit: *"Qiju does not capture sessions silently and does not ingest raw transcripts… decisions, evidence, failed paths, and next steps survive the session that produced them."* Three-tier storage keyed on age/access — hot (`<project>/.qiju/short.jsonl`), durable (`~/.qiju/long/<project>.jsonl`), archive (monthly parquet) — with reads merging all tiers and deduping by id, and a deliberately embedding-free two-phase retrieval (explicit filters → hydrate by id).
</routes>

The striking thing is how much of Qiju's philosophy elixir-mind already independently landed on — distill-don't-dump, plain local files, explicit-filter retrieval, no embeddings, outlive the session — and where it deliberately diverges (Qiju is machine-first records; elixir-mind is human-first published docs). The two things worth considering: a `/qiju-review`-style self-retrospective that mines the brain's *own* thread history for recurring frictions, and redaction-awareness before publishing verbatim threads to public Pages. Storage tiering and cross-agent portability are not applicable and correctly so. Bottom line: Qiju is mostly a confirmation that elixir-mind's core bets are sound. Neither idea rises to "must intake." Want me to write up either of those two as a `plan` or `issue`, or leave it here?

## User

Is there a capability in Qiju that enables for cross agent work (clauee and codex reviewing eachother's responses for example)
If Qiju persists entire jsonl threads, how is that "distill don't dump"?

## Assistant

Both grounded now.

**1. Cross-agent work — no, not in the sense you mean.** The docs state flatly: *"Qiju is not an agent framework and does not orchestrate hosts."* There is no mechanism for one agent to review, critique, or respond to another's output. What it *does* provide is a shared passive substrate plus an `--agent` filter: all supported agents read/write the same store, and `qiju search --agent codex` slices records by author. So the capability is **handoff/continuity, not mutual review** — a filing cabinet both agents share, not a room where they talk. You could build "Claude reviews Codex's work" on top, but Qiju supplies only the shared memory and the author filter, not the orchestration.

**2. The JSONL is not "entire threads" — my earlier framing was loose, and you caught it.** Qiju does not persist threads at all. JSONL here is just the container encoding — one authored structured record per line, not a conversation dump. *"Qiju does not capture sessions silently and does not ingest raw transcripts."* The distillation happens at `qiju log` time. So Qiju is genuinely distill-don't-dump — arguably *more* aggressively than elixir-mind, which is the point worth owning: elixir-mind is actually the one that keeps verbatim (our `/capture` retains every substantive exchange word-for-word; the distillation in our model happens one layer later, when routing lifts content into topic docs). So to correct the table I gave you earlier: where I wrote Qiju stores "threads," it stores **records**; the "no raw transcript" bet is one Qiju holds more strictly than we do. My "distill don't dump" label was right about Qiju — I just muddied it by calling the JSONL a thread store, which it isn't.

## User

How is Elixir mind distilled out dump in that we're persisting verbatim content threads, which is essentially dump, and then extracting elements of those to inform and create provenance for analyses, which is, I guess, a form of distillation, but not really. Um, I don't think you could come to any conclusions whatsoever if you consider all expository pros layered over the threads to be distillation. And, meanwhile, we are clearly persisting these threads verbatim, which seems to be dumping. So, uh, please, if you could explain how we came to that conclusion and if it's still accurate. that this repo embodies distilled don't dump.

## Assistant

<routes ref="em:bec37f em:1b3c79">
You're right to push, and part of what I told you earlier was sloppy. First, the correction: routing is *not* distillation. The thread body is verbatim; the doc-side route-tagged excerpt log *lifts the tagged regions whole* — verbatim excerpts, headers demoted. So the entire routing/route-tagging apparatus is **provenance wiring, not distillation**. If anyone claimed "the tags/ledger over the threads *are* the distillation," that claim is false — and I effectively made it. You cannot call expository/provenance layering over a verbatim record "distillation." Conceded.

What's actually going on: two artifacts, two policies, two senses of one word. **Knowledge documents** (governed by distill-dont-dump) genuinely distill — raw material goes to citations. **Thread docs** (governed by session-capture) are deliberately verbatim; the policy *explicitly narrows* the word: *"'Distilled' here means the noise is dropped, not that the kept text is condensed."* So the thread doc is a dump minus the noise — that's not a bug, it's the archive layer doing its job. The two layers serve opposite masters: knowledge wants concision + queryability; provenance wants fidelity (you cannot reconstruct "what did we decide and why" from a lossy summary — a condensed record is a *worse* record).
</routes>

Verdict on "does elixir-mind embody distill-don't-dump?": **Yes, at the layer the policy governs** — the knowledge base a reader queries. **No, it does not distill its session archive — and never claimed to.** Where I misled you was collapsing those two layers and implying the provenance machinery over the threads counts as distillation. It doesn't. One honest smell falls out of this: "distilled" is overloaded in the contract (condensed-to-knowledge vs. noise-stripped), and that overload is exactly what tripped me. That's arguably a `type: issue` worth filing. Want me to write that up, or is the clarification enough?

## User

in general it feels to me that "distill, don't dump" is misapplied in this repo and should not be the wording of the principle/doctrine. they are not mutually exclusive - thread docs are "dumps" (though technically not as tool calls etc are stripped), and knowledge docs are "distillations" (though technically not, as they are expansions with the fragments of threads functioning as provenance). So, not only do I not agree that dumping or distilling are strictly accurate here, they are not mutually exclusive as they apply to different levels of the system. I propose the "distill, don't dump" doctrine be stripped from the repo and rewritten as something more accurate

add the following to the list of beliefs (to be formalized later):

* Knowledge wants concision + queryability → distill hard, cite the raw.
* Provenance wants fidelity → you cannot reconstruct "what did we actually decide, what got rejected, and why" from a lossy summary. A condensed record is a worse record.

## Assistant

<routes ref="em:1b3c79">
Done — added to `beliefs/future-beliefs.md`, with your two principles verbatim, and the bundle still verifies clean. On the substance, I agree with you, and your framing is sharper than mine last turn. My "distill vs. dump" split still smuggled in the false binary — you're right on both counts: thread docs aren't cleanly "dumps" (tool-noise is stripped), and knowledge docs aren't cleanly "distillations" — they're often *expansions*, with thread fragments acting as provenance rather than raw material being boiled down. And the deeper point: dump and distill aren't mutually exclusive and don't live on one axis — they describe different layers doing their jobs.
</routes>

I recorded the retirement/rewrite as a **proposal**, not executed it — stripping a `type: policy` and re-rendering `CLAUDE.md` is a change to the brain's shape, and you framed it as "to be formalized later." A couple of things worth your eye before any rewrite lands: it likely wants to be a `doctrine`, not a `policy` (your replacement is a standing direction, not a mechanical rule); and don't lose the one good injunction buried in the old slogan (on intake, capture the knowledge and cite the source). Two open questions: **scope** of the rewrite (intake-only vs. the full two-layer doctrine) and **when** (holding pen vs. draft now). I've left the beliefs change in the working tree uncommitted, since the rewrite may want to ride in the same PR.

## User

1 - agree, formalize as a doctrine
(also - how might the definition of a doctrine contrast with the potential definition of a belief?)
2 -

## Assistant

Two things before I write anything — first, **your "2 -" came through empty** (the message cuts off right after it), so I'll hold on the doctrine draft until you finish that thought. Noting #1: agreed, formalize as a `doctrine`.

<routes ref="em:6a9e78 em:0c343a em:ca7b27">
## Doctrine vs. belief

The cleanest way to separate them is by **register** — what kind of statement each one *is*. A **belief** is descriptive (the *is* register): it answers "what is the case?", is truth-apt (true/false, verifiable), and if wrong it is *false* → corrected against evidence. A **doctrine** is normative (the *ought* register): it answers "what should guide design and priorities?", is a commitment (adhered-to, not verified), and if wrong it is *misguided* → the direction is re-decided. In the stack, belief *grounds* doctrine (the *is* that motivates the *ought*), and doctrine *sits above* policy (a policy implements it as an enforceable rule). "Belief" isn't a type while "doctrine" is — because the descriptive register is already covered by `claim`/`note`/`concept`; the normative-direction register had no type, and that gap is what `doctrine` fills. The bridge — each of your two bullets is shaped `descriptive premise → normative conclusion`, and that `→` is the is-to-ought step. Tidy statement of the contrast: **a belief is something the brain holds *true*; a doctrine is something the brain holds *to*.**
</routes>

Ready to draft the `doctrine` doc, strip `distill-dont-dump`, and re-render the contract on your go — but I'll wait for your **#2** and a nod on scope first.

## User

2 - yes of course - we are not discussing changes of functionality, we are discussing how we characterize functionality and what doctrine's underlie them
Re: scope - what is "fitness for purpose"? But the second full scope option
Re: when - yes both now
Define normative conclusions ans descriptive premises, add to glossary
Create an analysis document describing the is-to-ought layer in the context you are presenting it
Ready also to proceed with your listed action items

## Assistant

Done — committed and pushed. Here's the answer to "fitness for purpose."

<routes ref="lib/elixir_mind/site_config.ex">
**"Fitness for purpose"** = each layer is shaped and judged against the *function it must serve*, not against one global standard. The mistake in "distill, don't dump" was treating retention as a single virtue applied everywhere. But the brain runs two layers whose jobs pull in opposite directions: the **knowledge layer** (understanding on demand) is fit when concise and queryable → distill hard and cite the raw; the **provenance/record layer** (reconstructing what was decided and why) is fit only when faithful → a condensed record is a *worse* record. "Distill" and "dump" aren't competing virtues on one dial — they're the right tools for two different jobs, and the verbatim record is what *licenses* aggressive distillation elsewhere.
</routes>

I built the full scope: the [fit each layer to its purpose](/meta/doctrine/fit-each-layer-to-its-purpose.md) doctrine, the reworded/renamed [capture-knowledge-cite-the-source](/meta/policy/capture-knowledge-cite-the-source.md) policy (functionality preserved, characterization fixed), the [is-to-ought analysis](/meta/analysis/is-to-ought-belief-grounds-doctrine.md), and the glossary terms [normative conclusion](/beliefs/glossary/normative-conclusion.md) and [descriptive premise](/beliefs/glossary/descriptive-premise.md). One decision worth your veto: I kept a *policy* (reworded) rather than folding everything into the doctrine, because removing the filing rule from the contract would be a functionality change — and policy-implements-doctrine is the structure the repo already teaches. Bundle verifies, 177 tests pass.

## User

for doctrine - do NOT specify what was replaced or changed, this is evident in the git history if needed. this is a recurring issue, draft a belief that states this (and make a note in the belief itself - that will eventually become a belief of type "doctrine" aka "ought" [was prescriptive])

re: " I kept a policy (reworded) rather than folding everything into the doctrine" - which document is this referring to?

## Assistant

Quick answer to your question first, then I'll make the changes. **"Which document?"** — `meta/policy/capture-knowledge-cite-the-source.md` (the renamed, reworded former `distill-dont-dump.md`). That's the one I kept as a `policy` rather than folding its concrete filing rule into the doctrine. My reasoning: dropping it from `meta/policy/` would remove the enforceable filing rule from the compiled `CLAUDE.md` — a functionality change you'd said we weren't making.

<routes ref="em:1b3c79">
Both done. The doctrine now reads as a standing positive statement of the direction — the "why this replaces 'distill, don't dump'" section is gone, and the description/provenance/attribution and index entry no longer name what it replaced. The change record lives in git history where it belongs. And the belief: *An artifact states what it **is**, not what it replaced or changed from — the commit graph is the change-narrative layer.* I flagged the deliberate exception (a glossary entry *about* a retired term), cited this session's own first-draft doctrine as the failure case, and wrote the self-referential note: this belief is itself an **ought**, so when formalized it becomes a `doctrine`, never a `note`/`concept`. That connects it cleanly to the normative-conclusion / descriptive-premise distinction — a worked example of a belief that's an *ought*, which is exactly why it's doctrine-bound.
</routes>

## User

https://github.com/ob6to8/elixir-mind/blob/claude/qiju-thread-storage-59ur3l/meta/policy/capture-knowledge-cite-the-source.md is working

https://ob6to8.github.io/elixir-mind/meta/doctrine/fit-each-layer-to-its-purpose.html is not

how can we get you to consistently present links as active working urls

## Assistant

<routes ref="lib/mix/tasks/brain.url.ex">
Root cause confirmed: **Pages deploys only on push to `main`** (`pages.yml` → `branches: [main]`). So any doc created or changed on a feature branch has no live Pages page until the PR merges — the Pages URL 404s meanwhile, while the GitHub blob URL at the branch ref resolves immediately. My mistake was citing the canonical Pages URL for docs that only exist on this unmerged branch. The durable answer to "consistently" is mechanical: make `mix brain.url` liveness-aware so I run the tool instead of hand-building URLs (hand-behavior is exactly what fails intermittently). It now emits the live Pages URL when a doc is rendered *and* unchanged vs `origin/main`, and the GitHub branch blob URL otherwise (new, modified, or non-rendered dir), with `--pages` to force canonical. Backed by `SiteConfig.blob_url/2`, git-based liveness detection, 3 new tests, and an amended `response-resource-links` policy that says: route every response link through `mix brain.url`.
</routes>

So going forward: I'll run `mix brain.url <path>` for every brain link I cite rather than constructing URLs by hand.

## User

you say you will, but how will future sessions know to do this too?

## Assistant

<routes ref="em:1b3c79">
That's the right challenge — a per-session promise dies with this session, so the question is purely what structural thing a future session inherits. Two things changed, in order of strength. **1. The correctness now lives in the tool, not in agent memory.** The old contract *already* said "use `mix brain.url`" — the failure wasn't that I ignored it, it's that the tool itself returned the wrong URL (hard-coded to Pages, zero branch-awareness). A diligent future agent who ran it would *still* have gotten the 404. So the durable fix was making the tool correct by construction; the knowledge (branch vs main) is embedded in the tool, the only place it reliably persists. **2. The contract now forbids the thing I did** (hand-construction), compiled into `CLAUDE.md`. The honest ceiling: this rule governs off-repo output (chat, PR bodies) with no in-repo artifact to gate, so it can *never* be CI-verified like route-tags or contract-drift — its reliability rests forever on correct tooling + contract adherence. I'm the live proof prose alone is insufficient, which is exactly why the fix went into the tool.
</routes>

Two things would raise it further, neither done unilaterally: capture the meta-lesson as a belief/doctrine (*a rule over off-repo output must be made correct in the tooling it mandates, not merely asserted in prose — because it cannot be CI-gated*), and demote the hand-mapping in the policy so it can't be copied by hand. Want me to do either? The first is the more valuable — it generalizes past this one link bug to every response-side rule the brain will ever have.

## User

do both

## Assistant

<routes ref="em:1b3c79">
Both done, committed and pushed. **1. Belief captured** — *A rule over off-repo output must be made correct in the tooling it mandates, not merely asserted in prose — because it cannot be CI-gated.* Grounded in the 2026-07-22 link bug as its proof case, flagged as an *ought* destined for doctrine, and linked as the sibling of the "artifact states what it is" belief — both cases where the durable lever is structural (tool, commit graph), not exhortation. **2. Policy demoted the hand-mapping** — `response-resource-links` now leads with "Get the URL from the tool, never by hand" and reframes `P.md → …P.html` as "what the site does at build time, not a recipe to apply in a response." The trap I fell into is now labeled as the trap, in the compiled contract every session reads.
</routes>

So the full answer to "how will future sessions know" now has three structural legs, none of which depend on memory: the **tool** returns the right URL by construction, the **contract** mandates the tool and forbids hand-construction, and the **belief** generalizes the lesson so the next off-repo rule gets built correct-by-tool from the start.
