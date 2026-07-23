---
type: reference
title: "Bookmarks — survey register"
description: The survey tier — links parked with a one-line summary and topical tags, awaiting full intake. A lower-effort staging register than a filed reference; process with /bookmarks, promote with /intake.
provenance: "Maintained by /bookmarks — the operator drops raw URLs under Pending; the skill fetches each and writes a summarized, tagged Surveyed entry."
tags: [survey, bookmark]
timestamp: 2026-07-23
---

# Bookmarks — survey register

The brain's **survey tier**: links worth keeping but not worth fully ingesting yet.
Each surveyed entry carries a one-line summary and topical tags — enough to be found
by a topic query — without the full distill-file-cross-link pass that a
[`reference`](/knowledge/knowledge-management/open-knowledge-format.md) demands. This
namespace sits *outside* the OKF bundle (no `em:` ids, never verified), the same way
[`inbox/`](/inbox/index.md) and `meta/` do.

Two tiers, one bridge:

- **Surveyed** (here) — bulk-droppable, fetched-and-summarized, tagged, `status: surveyed`.
- **Ingested** — a promoted bookmark becomes a filed `reference` in the taxonomy, with
  an `em:` id and cross-links. `status: promoted → <link>` records the graduation.

The bridge is [`/intake`](/.claude/skills/intake/SKILL.md), driven by
[`/bookmarks promote`](/.claude/skills/bookmarks/SKILL.md): that is the single point
where the knowledge-layer filing rule
([capture the knowledge, cite the source](/meta/policy/capture-knowledge-cite-the-source.md))
re-engages.

## Pending

<!--
  Drop raw URLs here under a date-added heading — an `### YYYY-MM-DD` line marking
  when you added them — one URL per line (a trailing " — note" is optional context):

    ### 2026-07-22
    https://example.com/article
    https://example.com/other — focus on the eval section

  Then run `/bookmarks` (no argument) to fetch each, generate a one-line summary and
  tags, and move it to Surveyed below, carrying that heading date as the bookmark's
  **Added** date. The skill empties this section as it processes. A URL with no date
  heading defaults its Added date to the day it is processed.
-->

5/28/26
https://medium.com/jonathans-musings/what-warps-open-source-release-tells-us-about-the-future-of-agentic-software-development-5d4409726bf1
https://lobu.ai/blog/hello-world/
https://news.ycombinator.com/item?id=48313530
https://www.dbos.dev/blog/postgres-is-all-you-need-for-durable-execution
https://lobu.ai/blog/filesystem-vs-database-agent-memory/
https://substack.com/@shrivu/p-197131989
https://blog.sshh.io/p/designing-software-for-software-factories
https://blog.sshh.io/p/how-i-use-every-claude-code-feature
https://blog.sshh.io/p/everything-wrong-with-mcp
https://substack.com/@shrivu/p-197131989
https://arxiv.org/pdf/2409.00608
https://www.appunite.com/blog/integrating-generative-ai-into-elixir-based-applications-by-using-the-jido-agentic-framework
https://www.reddit.com/r/elixir/comments/1t7hrat/built_a_ledger_reconciliation_library_for_elixir/
https://www.reddit.com/r/elixir/comments/1to9l94/opensourcing_a_distributed_bot_platform_built_on/
https://jola.dev/posts/ci-workflows-on-tangled
https://jola.dev/posts/elixir-cluster-101
https://jola.dev/posts/how-to-stop-claude-from-saying-load-bearing
https://mikezornek.com/posts/2026/7/guarding-against-ai-drift/?utm_source=reddit&utm_campaign=guarding-against-ai-drift
https://georgeguimaraes.com/what-the-critics-got-right-about-elixir-and-ai-agents/
https://x.com/trq212/status/2035372716820218141
https://resend.com/changelog/resend-claude-code-plugin
https://claude.com/blog/introducing-dynamic-workflows-in-claude-code
https://www.youtube.com/watch?v=dKaZ89SkVYY&t=1s
https://platform.claude.com/docs/en/agents-and-tools/tool-use/advisor-tool
https://www.anthropic.com/engineering/managed-agents
https://www.anthropic.com/engineering/harness-design-long-running-apps
https://www.anthropic.com/news/finance-agents
https://www.youtube.com/watch?v=_GHKTCFcdaQ
https://www.crustofcode.com/how1/
https://www.youtube.com/watch?v=2zkDtgLeU14
https://www.youtube.com/watch?v=OjgZ8vOHE6I
https://blog.stenmans.org/theBeamBook/#_preface
https://www.youtube.com/watch?v=TL527yTpxlk
https://pikdum.dev/posts/thistle-tea-2025-update/

CB REDDIT
https://www.reddit.com/r/AgentsOfAI/comments/1st6uxc/karpathys_llm_wiki_idea_might_be_the_real_moat/

CB REFS
https://promptql.io/
https://github.com/GAIR-NLP/ASI-Evolve
https://arxiv.org/abs/2603.29640
https://github.com/karpathy/autoresearch

LOUDER ARCH
https://www.anthropic.com/engineering/building-effective-agents
https://www.reddit.com/r/elixir/comments/1ssmqox/livestash_v020_is_out_simpler_declarative_state/
https://www.anthropic.com/engineering/claude-code-auto-mode
https://www.reddit.com/r/AgentsOfAI/comments/1u3otge/we_tried_knowledge_graphs_for_internal_ai_results/
https://hindsight.vectorize.io/developer/mcp-server
https://arxiv.org/abs/2512.12818
https://markhuang.ai/blog/ai-memory-beyond-rag
https://markhuang.ai/blog/dense-mem-hosted-demo-test-instance

cb 6/26
https://cloud.google.com/blog/products/data-analytics/how-the-open-knowledge-format-can-improve-data-sharing
  https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f 
https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f


evals
https://olshansky.substack.com/p/vibe-checks-are-all-you-need
https://openai.com/index/evals-drive-next-chapter-of-ai/
https://academy.langchain.com/
https://docs.langchain.com/langsmith/evaluation-concepts
https://github.com/Arize-ai/phoenix/tree/main/tutorials/evals
https://arize.com/blog/ai-evals-maven-course-homework-the-recipe-bot-workflow/
https://github.com/openai/evals
https://developers.openai.com/api/docs/guides/evals
https://developers.openai.com/cookbook/examples/evaluation/use-cases/completion-monitoring
https://developers.openai.com/api/docs/guides/model-optimization
https://developers.openai.com/api/docs/guides/supervised-fine-tuning#distilling-from-a-larger-model
https://developers.openai.com/cookbook/examples/evaluation/use-cases/bulk-experimentation
https://developers.openai.com/cookbook/examples/evaluation/use-cases/regression
https://developers.openai.com/cookbook/examples/evaluation/use-cases/regression
https://hamel.dev/blog/posts/evals/
https://hamel.dev/blog/posts/llm-judge/
https://hamel.dev/blog/posts/field-guide/
https://hamel.dev/blog/posts/evals-faq/
https://platform.claude.com/docs/en/test-and-evaluate/develop-tests
https://platform.claude.com/cookbook/misc-building-evals
https://developers.openai.com/learn/evals
https://developers.openai.com/api/docs/guides/evaluation-best-practices
https://arize.com/docs/phoenix
https://hamel.dev/blog/posts/evals-skills/
https://github.com/hamelsmu/evals-skills
https://wandb.ai/site/courses/evals/
https://www.evidentlyai.com/courses
https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents
https://www.oreilly.com/library/view/evals-for-ai/9798341660717/
https://hamel.dev/blog/posts/evals-faq/evals-faq.pdf
https://medium.com/@zhengfke/ai-evaluations-a-moat-bigger-than-the-model-0577aa32c4d7
https://maven.com/parlance-labs/evals
https://www.youtube.com/watch?v=TL527yTpxlk
https://labelbox.com/evals/
https://info.langchain.com/eval-frameworks
https://github.com/promptfoo/promptfoo
https://mlflow.org/genai
https://www.usebraintrust.com/
https://deepeval.com/
https://developers.openai.com/api/docs/guides/evals
https://developers.openai.com/cookbook/examples/evaluation/use-cases/completion-monitoring
https://developers.openai.com/api/docs/guides/model-optimization
https://developers.openai.com/api/docs/guides/supervised-fine-tuning#distilling-from-a-larger-model
https://developers.openai.com/cookbook/examples/evaluation/use-cases/bulk-experimentation
https://developers.openai.com/cookbook/examples/evaluation/use-cases/regression
https://hamel.dev/blog/posts/evals/
https://hamel.dev/blog/posts/llm-judge/
https://hamel.dev/blog/posts/field-guide/
https://hamel.dev/blog/posts/evals-faq/
https://platform.claude.com/docs/en/test-and-evaluate/develop-tests
https://platform.claude.com/cookbook/misc-building-evals
https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents
https://developers.openai.com/learn/evals
https://developers.openai.com/api/docs/guides/evals
https://developers.openai.com/api/docs/guides/evaluation-best-practices
https://github.com/openai/evals
https://arize.com/docs/phoenix
https://github.com/Arize-ai/phoenix/tree/main/tutorials/evals
https://arize.com/blog/ai-evals-maven-course-homework-the-recipe-bot-workflow/
https://docs.langchain.com/langsmith/evaluation-concepts
https://academy.langchain.com/
https://openai.com/index/evals-drive-next-chapter-of-ai/

6/10
https://www.oreilly.com/library/view/evals-for-ai/9798341660717/
https://www.reddit.com/r/AgentsOfAI/comments/1txk7xf/spent_a_week_running_claude_codes_dynamic/
https://huggingface.co/docs/transformers.js/en/index
https://github.com/Egonex-AI/Understand-Anything
https://github.com/GlitterKill/sdl-mcp
https://www.mneemo.com/post/ai-music-electronic-dance-music-2026
https://www.mneemo.com/post/mneemo-uk-garage-2026-never-left-just-faster
https://www.mneemo.com/post/mneemo-london-clubs-small-rooms-vs-festivals
https://github.com/microsoft/ML-For-Beginners
https://microsoft.github.io/AI-For-Beginners/
https://github.com/microsoft/Data-Science-For-Beginners
https://github.com/zed-industries/awesome-gpui
https://github.com/moltis-org/moltis
https://news.ycombinator.com/item?id=46993587
https://pen.so/2026/02/12/moltis-a-personal-ai-assistant-built-in-rust/
https://github.com/0xErwin1/dbflux
https://mohkohn.co.uk/writing/html-first/
https://github.com/boringcollege/postgres-by-example
https://jonready.com/blog/posts/claude-fable5-is-allowed-to-sabotage-your-app-if-youre-a-competitor.html
https://news.ycombinator.com/item?id=48467896


ableton
https://github.com/errows/ablx-triage
https://github.com/federico-pepe/ableton-live-extensions/tree/main
https://benebellwen.com/wp-content/uploads/2024/12/thoth-on-the-eight-of-cups-spirit-keepers-tarot.jpg
https://extforlive.com/resources/extensions-guide
https://www.ableton.com/en/live/extensions
https://github.com/pnomolos/ableton-extensions-public
https://randomtarotcard.com/


6/8/26 hn
https://news.ycombinator.com/item?id=48414027
https://sumnerevans.com/posts/software-engineering/stop-using-conventional-commits/
https://news.ycombinator.com/item?id=48398925
https://www.saturnci.com/my-agent-skill-for-test-driven-development.html
https://news.ycombinator.com/item?id=48419571
https://andersmurphy.com/2026/06/05/the-perils-of-uuid-primary-keys-in-sqlite.html
https://tech.wmg.com/why-we-shrank-our-timescaledb-chunks-from-30-days-to-7-07cab8afefc5
https://news.ycombinator.com/item?id=48406174
https://news.ycombinator.com/item?id=48389360
https://www.0xkato.xyz/how-llms-actually-work/
https://www.ycombinator.com/rfs
https://news.ycombinator.com/newcomments
https://news.ycombinator.com/item?id=48348578
https://www.dbos.dev/blog/postgres-is-all-you-need-for-durable-execution
https://obeli.sk/blog/sqlite-is-all-you-need-for-durable-workflows/
https://obeli.sk/features/
https://github.com/obeli-sk/obelisk
https://news.ycombinator.com/item?id=48326802
https://www.owenmcgrann.com/p/the-dead-economy-theory
https://arxiv.org/pdf/2603.20617
https://www.cato-unbound.org/2009/04/13/peter-thiel/education-libertarian/
https://news.ycombinator.com/item?id=48324712
https://ejholmes.github.io/2026/02/28/mcp-is-dead-long-live-the-cli.html
https://www.quandri.io/engineering-blog/mcp-is-dead
https://news.ycombinator.com/item?id=48330436
https://www.lucasfcosta.com/blog/backpressure-is-all-you-need
https://fly.io/blog/litestream-writable-vfs/
https://fly.io/blog/litestream-v050-is-here/
https://fly.io/blog/litestream-revamped/
https://fly.io/blog/litestream-revamped/
https://litestream.io/
https://github.com/benbjohnson/litestream
https://github.com/benbjohnson/litestream/issues
https://github.com/benbjohnson/litestream/blob/main/AGENTS.md
https://blog.google/innovation-and-ai/technology/developers-tools/introducing-gemma-4-12b/
https://blog.google/innovation-and-ai/technology/developers-tools/introducing-gemma-4-12b/
https://news.ycombinator.com/item?id=48385906
https://claude.com/blog/introducing-dynamic-workflows-in-claude-code
https://elixir-lang.org/blog/2026/06/03/elixir-v1-20-0-released/
https://news.ycombinator.com/item?id=48388324
https://github.com/anthropics/defending-code-reference-harness
https://news.ycombinator.com/item?id=48403980
https://github.com/alibaba/open-code-review
https://news.ycombinator.com/item?id=48406358
https://www.anthropic.com/institute/recursive-self-improvement
https://news.ycombinator.com/item?id=48400842

Design refs
https://feltsense.com/#thesis

5-28
https://www.anthropic.com/engineering/harness-design-long-running-apps
cole karpathy kb : https://www.youtube.com/watch?v=7huCP6RkcY4 https://www.perplexity.ai/search/c976c47a-3326-433f-8983-e0197c9dc050
https://zed.dev/blog/why-llms-cant-build-software
delta db: https://zed.dev/blog/sequoia-backs-zed
https://zed.dev/blog/not-building-ai-for-the-money
https://www.pinecone.io/blog/knowledge-infrastructure-for-agents/
https://www.pinecone.io/blog/introducing-nexus-knowledge-engine/
pinecone nate b: https://www.youtube.com/watch?v=lqiwQiDglGk
https://www.anthropic.com/news/finance-agents
https://www.anthropic.com/news/claude-for-small-business
https://shadcn-html.com/documentation/
cc and html: https://x.com/trq212/status/2052809885763747935
https://www.agentsh.org/
https://github.com/anthropics/financial-services
https://github.com/anthropics/claude-cookbooks/blob/main/skills/README.md



4-27
https://x.com/lifeof_jer/article/2048103471019434248

4-24
https://www.forbes.com/sites/zakdoffman/2026/04/11/nsa-warning-reboot-your-internet-router-now/?streamIndex=0
https://cloudscaling.com/blog/cloud-computing/the-history-of-pets-vs-cattle/
http://www.incompleteideas.net/IncIdeas/BitterLesson.html
https://www.reddit.com/r/elixir/comments/1shufk0/i_built_a_local_embedding_pipeline_that_pulls/
https://www.youtube.com/watch?v=v7qMjy_RxOs
https://claude.com/blog/claude-code-desktop-redesign
https://georgeguimaraes.com/what-the-critics-got-right-about-elixir-and-ai-agents/
https://www.youtube.com/watch?v=dKaZ89SkVYY&t=1s (beam)
https://elixir-lang.org/blog/2020/10/08/real-time-communication-at-scale-with-elixir-at-discord/
https://hexdocs.pm/live_svelte/LiveSvelte.html
https://github.com/atomicmemory/llm-wiki-compiler
https://news.ycombinator.com/item?id=47854051
https://weavemind.ai/blog/future-of-programming
https://weavemind.ai/blog/three-properties-for-alignment
https://weavemind.ai/blog/topology-of-llm-behavior
https://modelriver.com/blog/debugging-ai-agents-in-production
https://modelriver.com/blog/hidden-architecture-behind-reliable-ai-agents
https://modelriver.com/blog/why-elixir-phoenix-ai-gateway

4-21
https://www.dbreunig.com/2026/03/26/winchester-mystery-house.html
https://blog.exe.dev/bones-of-the-software-factory
https://claude.com/resources/tutorials/working-with-claude-opus-4-7?open_in_browser=1
https://www.dbreunig.com/2026/04/14/cybersecurity-is-proof-of-work-now.html

4-9
https://bittensor.com/
https://www.reddit.com/r/AgentsOfAI/comments/1sfg3tf/i_built_92_opensource_skillsagents_for_claude/
https://github.com/karpathy/autoresearch
https://finbold.com/claude-ai-powered-trading-bot-turns-1-into-3-3-million-on-polymarket/
https://www.reddit.com/r/elixir/comments/1rh7ucz/loom_an_elixirnative_ai_coding_assistant_with/
https://github.com/pass-agent/loomkin
https://github.com/glittercowboy/taches-cc-resources/blob/main/commands/create-prompt.md
https://github.com/obra/superpowers
https://finbold.com/claude-ai-powered-trading-bot-turns-1-into-3-3-million-on-polymarket/
https://code.claude.com/docs/en/quickstart
https://gist.github.com/roman01la/483d1db15043018096ac3babf5688881
https://www.instagram.com/reel/DWiXOjcD9_k/?igsh=NTc4MTIwNjQ2YQ==
https://matklad.github.io/2022/07/04/unit-and-integration-tests.html
https://matklad.github.io/2021/05/31/how-to-test.html
https://arxiv.org/abs/2512.24601
https://www.instagram.com/p/DWqo4oTiIKN/?img_index=1&igsh=NTc4MTIwNjQ2YQ%3D%3D
http://GitHub.com/dukedorje/narrative-network
https://www.instagram.com/reels/DVnBrmJCqRi/
https://www.instagram.com/reels/DWDJIlUE4uB/
https://github.com/strongdm/attractor/blob/main/attractor-spec.md
https://github.com/strongdm/attractor/blob/main/coding-agent-loop-spec.md
https://github.com/strongdm/attractor/blob/main/unified-llm-spec.md
https://github.com/strongdm/attractor
https://github.com/theDakshJaitly/mex
https://www.reddit.com/r/AgentsOfAI/comments/1sfz0tu/i_built_this_last_week_woke_up_to_300_stars_and_a/

4-3
https://claw-code.codes/getting-started
https://github.com/ultraworkers/claw-code
https://www.youtube.com/watch?v=Dli5slNaJu0
https://www.psypost.org/audio-tapes-reveal-mass-rule-breaking-in-milgram-s-obedience-experiments-2026-03-26/
https://www.agentixlabs.com/blog/
https://www.reddit.com/r/elixir/comments/1rh7ucz/loom_an_elixirnative_ai_coding_assistant_with/
https://github.com/pass-agent/loomkin
https://www.greptile.com/blog/ai-slopware-future
https://news.ycombinator.com/item?id=47586778
https://alex000kim.com/posts/2026-03-31-claude-code-source-leak/
https://curling.io/blog/21-reasons-ai-agents-love-gleam
https://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare/
https://curling.io/blog/background-jobs-without-the-baggage
https://codespeak.dev/blog/codespeak-test-20250324
https://block.xyz/inside/from-hierarchy-to-intelligence
https://www.theregister.com/2026/04/02/ai_models_will_deceive_you/
https://neuromatch.social/@jonny/116325123136895805

3-30
https://www.psypost.org/audio-tapes-reveal-mass-rule-breaking-in-milgram-s-obedience-experiments-2026-03-26/
https://impeccable.style/
https://github.com/pbakaus/impeccable
https://github.com/theDakshJaitly/mex
https://github.com/simonw/present/blob/main/walkthrough.md
https://gisthost.github.io/?29b0d0ebef50c57e7985a6004aad01c4/page-001.html#msg-2026-02-06T07-33-41-296Z
https://github.com/simonw/showboat/tree/main?tab=readme-ov-file
https://github.com/simonw/showboat/blob/main/help.txt
https://simonwillison.net/guides/agentic-engineering-patterns/linear-walkthroughs/
https://simonwillison.net/guides/agentic-engineering-patterns/red-green-tdd/
https://simonwillison.net/guides/agentic-engineering-patterns/first-run-the-tests/
https://dashbit.co/blog/type-systems-are-leaky-abstractions-map-take
https://dashbit.co/blog/distributed-python-livebook
https://www.reddit.com/r/elixir/comments/1s2jwfl/building_a_blog_with_elixir_and_phoenix/
https://jola.dev/posts/building-a-blog-with-elixir-and-phoenix
https://blabbermouth.net/news/adrian-smith-even-people-who-dont-really-know-about-iron-maiden-might-be-interested-in-upcoming-official-documentary
https://www.anthropic.com/news/introducing-anthropic-labs
https://www.anthropic.com/engineering/harness-design-long-running-apps
https://www.reddit.com/r/ClaudeAI/comments/1s6jouf/anthropic_shares_how_to_make_claude_code_better/
https://www.reddit.com/r/vibecoding/comments/1s4mpa8/i_spent_the_weekend_testing_apps_from_the_lovable/
https://www.reddit.com/r/elixir/comments/1s4b6bd/a_phoenixinspired_web_framework_for_gleam_glimr/
https://www.youtube.com/watch?v=5tKAaEqoJq0
https://theplaylist.net/the-dark-wizard-trailer-hbo-chronicles-the-thrilling-troubled-life-of-climber-dean-potter-in-new-four-part-docuseries-20260327/
https://github.com/obra/superpowers
https://blog.fsck.com/2026/03/09/superpowers-5/
https://blog.fsck.com/2026/03/25/Classical-Software/

3-25
https://stripe.dev/blog/minions-stripes-one-shot-end-to-end-coding-agents
https://www.anthropic.com/engineering/building-effective-agents
https://platform.claude.com/docs/en/agent-sdk/overview
https://code.claude.com/docs/en/chrome
https://github.com/ruvnet/ruflo
https://dev.to/arshtechpro/mirofish-the-open-source-ai-engine-that-builds-digital-worlds-to-predict-the-future-ki8

3-20
https://github.com/yeachan-heo/oh-my-claudecode
https://docs.learnbittensor.org/learn/introduction
https://bittensor.com/about
https://gitnexus.vercel.app/
https://deepwiki.org/
https://github.com/abhigyanpatwari/GitNexus?tab=readme-ov-file
https://www.youtube.com/watch?v=qKU-e0x2EmE
https://cmux.com/
https://github.com/dukedorje/narrative-network (duke)
https://beambots.dev/
https://www.reddit.com/r/AgentsOfAI/comments/1rjhvc7/new_paper_treat_all_ai_context_like_a_unix_file/
https://arxiv.org/abs/2512.05470
https://arxiv.org/html/2601.11672v1
https://cmux.com/docs/concepts
https://worrydream.com/refs/Brooks_1986_-_No_Silver_Bullet.pdf
https://github.com/HKUDS/CLI-Anything
https://www.searchapi.io
https://github.com/abhigyanpatwari/GitNexus
https://hexdocs.pm/jido/readme.html
https://platform.claude.com/cookbook/patterns-agents-basic-workflows
https://www.anthropic.com/engineering/building-effective-agents
https://stripe.dev/blog/minions-stripes-one-shot-end-to-end-coding-agents
https://stripe.dev/blog/minions-stripes-one-shot-end-to-end-coding-agents-part-2
https://www.reddit.com/r/singularity/comments/1roo6v0/andrew_karpathys_autoresearch_an_autonomous_loop/
https://www.youtube.com/watch?v=_vpNQ6IwP9w
https://www.reddit.com/r/commandline/comments/1rga3gg/3d_model_renderer_that_runs_entirely_in_the/
https://github.com/casey/just?tab=readme-ov-file
https://just.systems/man/en/
https://github.com/fpgmaas/justx
https://fpgmaas.github.io/justx/configuration/global/

3-17
https://healeycodes.com/building-a-shell
https://github.com/ivanjm3/gmail-tui

2-15-26
https://simonwillison.net/2025/Nov/2/new-prompt-injection-papers/
https://www.reddit.com/r/ClaudeAI/comments/1r3hr40/anthropic_released_32_page_detailed_guide_on/
https://openai.com/index/harness-engineering/
https://github.com/luebken/llm-plugin-directory
https://zoug.fr/
https://www.youtube.com/watch?v=wjZofJX0v4M
https://zoug.fr/local-llms-potato-computers/

2-13-26
https://www.reddit.com/r/ClaudeAI/comments/1r186gl/my_agent_stole_my_api_keys/
https://www.reddit.com/r/technology/comments/1r11yvc/the_first_signs_of_burnout_are_coming_from_the/
https://www.reddit.com/r/AgentsOfAI/comments/1r0sltl/i_turned_codex_into_a_selfevolving_assistant_with/
https://www.reddit.com/r/AgentsOfAI/comments/1r0sltl/i_turned_codex_into_a_selfevolving_assistant_with/
https://meshtastic.org/
https://www.reddit.com/r/berkeleyca/comments/1pn1wmv/free_no_cell_network_text_communications_in/
https://www.meshcollective.co/programme
https://oaklandnorth.net/2013/11/27/mesh-network-offers-potential-for-free-wireless-internet-in-oakland/
https://beechat.network/2025/07/29/hopsync-a-stateless-frequency-hopping-revolution-in-military-mesh-communications/
https://meshcore.co.uk/
https://github.com/rahulnyk/knowledge_graph
https://www.youtube.com/watch?v=nKiPOxDpcJY
https://natesnewsletter.substack.com/p/january-is-already-obsolete-my-honest?utm_source=podcast-email&publication_id=1373231&post_id=187453030&utm_campaign=email-play-on-substack&utm_content=watch_now_button&r=3ubgw&triedRedirect=true&utm_medium=email
https://www.youtube.com/watch?v=XmweZ4fLkcI
https://www.youtube.com/watch?v=1PxEziv5XIU
https://www.youtube.com/watch?v=q-sClVMYY4w
https://github.com/ob6to8/openclaw
https://github.com/casey/just?tab=readme-ov-file
https://just.systems/man/en/quick-start.html
https://github.com/charmbracelet/gum?tab=readme-ov-file
https://github.com/charmbracelet/bubbles
https://github.com/charmbracelet/lipgloss
https://shumer.dev/something-big-is-happening


2-10-26
https://matklad.github.io/2021/05/31/how-to-test.html
https://matklad.github.io/2022/07/04/unit-and-integration-tests.html
https://www.anthropic.com/news/claude-new-constitution
https://www.anthropic.com/constitution
https://www-cdn.anthropic.com/14e4fb01875d2a69f646fa5e574dea2b1c0ff7b5.pdf
https://www.anthropic.com/research
https://www.anthropic.com/research/disempowerment-patterns
https://www.anthropic.com/research/AI-assistance-coding-skills
https://news.ycombinator.com/item?id=46909468
https://rcrowley.org/2010/01/06/things-unix-can-do-atomically.html
https://www.anthropic.com/research/disempowerment-patterns
https://arxiv.org/abs/2512.16856
https://www.joelonsoftware.com/2022/12/19/progress-on-the-block-protocol/
https://www.joelonsoftware.com/2002/11/11/the-law-of-leaky-abstractions/
https://www.youtube.com/watch?v=CAbrRTu5xcw&list=PL84xMklD_GwmlOmCyk_OsRJ6hQD0TsPYm
https://arxiv.org/html/2507.06850v3
https://arxiv.org/abs/2512.24601
https://garnix.io/
https://news.ycombinator.com/item?id=46903616
https://www.anthropic.com/engineering/building-c-compiler
https://news.ycombinator.com/item?id=46909439
https://theprogrammersparadox.blogspot.com/2026/02/systems-thinking.html

2/9/26
https://code.claude.com/docs/en/agent-teams
https://news.ycombinator.com/item?id=46902368
https://news.ycombinator.com/item?id=46904569
https://news.ycombinator.com/item?id=46908491
https://acotra.substack.com/p/the-stable-marriage-problem?utm_source=multiple-personal-recommendations-email&utm_medium=email&triedRedirect=true

2/2/26
https://www.youtube.com/watch?v=8lF7HmQ_RgY
https://www.youtube.com/watch?v=u-qLj4YBry0
https://www.youtube.com/watch?v=vdn_pKJUda8
https://www.youtube.com/watch?v=9FW43mb1vTM
https://www.youtube.com/watch?v=oR_B2gQDVf4
https://www.youtube.com/watch?v=nTqu6w2wc68
https://www.youtube.com/watch?v=CF1tMjvHDRA
https://www.youtube.com/watch?v=9FW43mb1vTM
https://www.youtube.com/watch?v=-GyX21BL1Nw
https://www.youtube.com/watch?v=mmqDYw9C30I
https://www.youtube.com/watch?v=iKb3cHDD9hw

2/1/26
https://www.youtube.com/watch?v=6omInQipcag
https://arxiv.org/html/2512.08296v1
https://derickschaefer.medium.com/claude-code-vs-the-unix-philosophy-e1141d9111e6

1/27/26
https://webmatrices.com/post/ai-won-t-take-your-job-a-guy-with-a-599-mac-mini-and-claude-will
agent scaling paper: https://arxiv.org/html/2512.08296v1
https://atmoio.substack.com/p/after-two-years-of-vibecoding-im
https://atmoio.substack.com/p/after-two-years-of-vibecoding-im/comments
https://news.ycombinator.com/item?id=46765460
clawdbot security: https://www.reddit.com/r/ClaudeCode/comments/1qnsn9t/how_a_single_email_turned_my_clawdbot_into_a_data/

1/22/26
https://blog.sshh.io/
https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
https://github.com/Gazler/termite
https://www.youtube.com/watch?v=eNbZcWTu0i0
https://www.infoq.com/articles/agentic-terminal-cli-agents/


1/20/26
https://davistreybig.substack.com/p/all-agents-will-become-coding-agents?utm_source=substack&utm_campaign=post_embed&utm_medium=email
https://vmisra.notion.site/Ephemeral-code-and-yes-agents-1963d301380b4a90b9c1477e8ef13584
https://blog.replit.com/automated-self-testing
https://www.youtube.com/watch?v=6_BcCthVvb8
https://rlancemartin.github.io/2025/10/15/manus/
https://blog.sshh.io/p/building-multi-agent-systems-part-c0c?utm_source=podcast-email%2Csubstack&publication_id=1943298&post_id=184887421&utm_campaign=email-play-on-substack&utm_medium=email&r=3ubgw&triedRedirect=true
https://blog.sshh.io/p/building-multi-agent-systems-part-c0c?utm_source=podcast-email%2Csubstack&publication_id=1943298&post_id=184887421&utm_campaign=email-play-on-substack&utm_medium=email&r=3ubgw&triedRedirect=true#footnote-3-184887421
https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents
https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus
https://simonwillison.net/2026/Jan/9/sprites-dev/
https://docs.sprites.dev/quickstart/
https://fly.io/blog/code-and-let-live/
https://community.fly.io/t/track-sprites-dev-progress/26852
https://community.fly.io/t/sprites-clone-sprite/26728
https://github.com/restyler/awesome-sandbox
https://every.to/chain-of-thought/compound-engineering-how-every-codes-with-agents
https://every.to/source-code/my-ai-had-already-fixed-the-code-before-i-saw-it
https://www.reddit.com/r/ClaudeAI/comments/1qegsta/announcing_claude_flow_v3_a_full_rebuild_with_a/
https://www.ksred.com/claude-code-dangerously-skip-permissions-when-to-use-it-and-when-you-absolutely-shouldnt/
https://github.com/Agent-Field/agentfield?rdt_cid=5789079740166012239
https://www.agentfield.ai/blog/posts/ai-backend
https://www.perplexity.ai/search/what-is-elixir-ratatouille-I1Eh7SfvRKuCU7E.Ylzv5g
https://www.youtube.com/watch?v=eNbZcWTu0i0
https://hex.pm/packages/termite
https://www.youtube.com/watch?v=TTgQV21X0SQ
https://www.youtube.com/watch?v=zjUAUqcmZ3w
https://www.youtube.com/watch?v=3uE33T0j1w8
https://www.youtube.com/watch?v=3LLmUk5_l30
https://www.nerdfonts.com/font-downloads


buid vs buy : build vs buy: https://venturebeat.com/ai/build-vs-buy-is-dead-ai-just-killed-it


KIMI DIRECTION THREADS
causal dev : https://www.kimi.com/chat/19acb90f-8a82-8a76-8000-093410d5c497
elixir learning journey : https://www.kimi.com/chat/19abbf65-f982-8a90-8000-0934b4caddbc
dan koe beam: https://www.perplexity.ai/search/consider-dan-koe-his-philosoph-45W4a_X9Si2yCe.mQH8XgQ
elixir sup : perp https://www.perplexity.ai/search/outline-a-potential-sound-desi-sDvDotXKSxWfqGa.Nj8oEg
elixir sup: https://www.kimi.com/chat/19adb7c6-3242-8206-8000-0934f8ef0e05
agents on the beam : https://www.kimi.com/chat/19aad83c-3b72-8ac4-8000-0934b4f0b0c3

siddarth agents
https://www.siddharthbharath.com/ultimate-guide-ai-agents/

— networked elixir supercollider
https://creativecodingtech.com/machine-learning/audio/synthesis/2025/05/08/machine-learning-supercollider-2025.html
https://github.com/Tok/SuperColliderMCP
https://www.perplexity.ai/search/outline-a-sound-design-workflo-g8Guv19GTNWzTpkpUG5jBA (perp)
https://hexdocs.pm/oscx/readme.html
https://github.com/haubie/oscx
https://github.com/haubie/supercollider
https://cycling74.com/articles/generating-sound-and-organizing-time-an-interview-with-graham-wakefield-and-gregory-taylor-1

sonification
https://indico.cern.ch/event/369153/contributions/1788410/attachments/734530/1007737/gridpp34-subtlenoise.pdf
elixir osc sonification: https://www.kimi.com/chat/19abc2d3-e162-86b3-8000-0934754a6b9a
https://home.cern/news/news/cern/sonified-higgs-data-show-surprising-result
https://github.com/ptrlv/subtlenoise
https://arxiv.org/html/2402.16558v2#S6
https://pmc.ncbi.nlm.nih.gov/articles/PMC10448511/
https://ui.adsabs.harvard.edu/abs/2024AJ....167..150G/abstract
https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0195948
https://arxiv.org/abs/2402.16558
https://www.media.mit.edu/publications/sonification-platform-for-interaction-with-real-time-particle-collision-data-from-the-atlas-detector/#:~:text=Groups,more%20prevalent%20real%2Dtime%20sensors.
https://www.perplexity.ai/search/3eb04416-f512-4b16-b16c-2a3b5dcb715a

elixir
https://www.linkedin.com/posts/david-stevens-connecting-dots_the-more-i-learn-about-the-beam-and-elixir-activity-7350888911298048002-22_y/
how to learn : https://www.kimi.com/chat/19acbc35-99c2-800a-8000-093487a82ffa
swarm: https://www.perplexity.ai/search/what-is-the-elixir-library-swa-fXK6Sf6aS92SW4POdBfNQQ
observability: https://underjord.io/unpacking-elixir-observability.html
1 bil founder: https://www.perplexity.ai/search/were-going-to-see-10-person-1b-Wrb3SCNIRIWbEt3tyI2XUw
chris mccord https://www.youtube.com/watch?v=6fj2u6Vm42E
https://dev.to/abreujp/contributing-to-elixir-documentation-a-step-by-step-guide-222g

dan koe
https://www.youtube.com/watch?v=HhspudqFSvU
https://thedankoe.com/letters/you-have-about-36-months-to-make-it/
https://letters.thedankoe.com/p/this-single-decision-will-determine

nate b data substrate
https://www.youtube.com/watch?v=x-01UrScIrA
https://www.perplexity.ai/search/summarize-https-www-youtube-co-p6dVxW.eTpKrOzmEQJX8Qw

FSCK
https://blog.fsck.com/2025/10/05/how-im-using-coding-agents-in-september-2025/
https://southbridge-research.notion.site/conducting-smarter-intelligences-than-me#2065fec70db18020bacfe30aee1eb5d3

BAML
https://hex.pm/packages/baml_elixir
https://github.com/boundaryml/baml

mr tinkleberry: 
https://www.kimi.com/chat/19ad7ab7-7662-8325-8000-093446438a92

fuck you show me the prompt
https://hamel.dev/blog/posts/prompt/

12 factor
https://www.humanlayer.dev/blog/12-factor-agents#factor-1-natural-language-to-tool-calls
https://github.com/humanlayer/12-factor-agents?tab=readme-ov-file
https://www.youtube.com/watch?v=8kMaTybvDUw

advanced context engineering 
https://www.youtube.com/watch?v=IS_y40zY-hc
https://github.com/humanlayer/advanced-context-engineering-for-coding-agents/blob/main/ace-fca.md
https://news.ycombinator.com/item?id=45347532

humanlayer writing a good claude.md
https://www.humanlayer.dev/blog/writing-a-good-claude-md
https://news.ycombinator.com/item?id=46098838
https://arxiv.org/pdf/2507.11538

master up to -7 lufs
https://www.reddit.com/r/musicproduction/comments/1pas14a/why_dont_we_master_to_14_lufs/

twitter accounts
https://x.com/dmwlff
https://x.com/claudeai

claude spec based dev
https://www.reddit.com/r/ClaudeAI/comments/1p8n2wi/claude_code_and_opus_45_capabilities_that_i_am/

cc blogs
https://kean.blog/post/experiencing-claude-code

zed cc
https://zed.dev/blog/claude-code-via-acp

adelaine
https://labs.adaline.ai/p/context-engineering-with-claude-code?hide_intro_popup=true

cc
https://github.com/hesreallyhim/awesome-claude-code?tab=readme-ov-file
https://www.youtube.com/watch?v=hOqgFNlbrYE
https://www.youtube.com/@PatrickOakleyEllis/videos
https://www.reddit.com/r/ClaudeCode/comments/1oywsa1/claude_code_skills_activate_20_of_the_time_heres/
https://claudecodecommands.directory/

agents
https://fly.io/blog/everyone-write-an-agent/

req/finch
https://www.kimi.com/chat/19ad6551-3582-8cdc-8000-0934fc4dec2c (kimi)
https://www.perplexity.ai/search/see-this-lib-https-hexdocs-pm-i80MPVo8Ql2oFLnEs72J.A (perp)
https://www.kimi.com/chat/19ad5f1f-43f2-899f-8000-09347b4fbda7 (kimi)
https://www.youtube.com/watch?v=P-3lsKrOWxY
https://www.reddit.com/r/elixir/comments/1nje0f4/introducing_reqllm_req_plugins_for_llm/
https://elixirforum.com/t/reqllm-composable-llm-client-built-on-req/72514/12
https://hexdocs.pm/req_llm/overview.html

jido
https://github.com/agentjido/jido/discussions/43
https://www.youtube.com/watch?v=qi0Hl_RSbAU
https://www.youtube.com/watch?v=8pQNvhafTlk

causal
https://arxiv.org/abs/2402.10877
https://www.cs.cmu.edu/~motionplanning/papers/sbp_papers/integrated1/woodridge_intelligent_agents.pdf
https://www.youtube.com/watch?v=kpOWmwA6tJc
https://www.youtube.com/watch?v=aR20FWCCjAs
gary marcus : https://www.kimi.com/chat/19acba71-2252-8996-8000-0934bb914b70
sutton : https://www.youtube.com/watch?v=gEbbGyNkR2U
http://www.incompleteideas.net/IncIdeas/BitterLesson.html

bil co
https://www.forbes.com/sites/markminevich/2025/08/20/the-billion-dollar-company-of-one-is-coming-faster-than-you-think/


https://models.dev

audio
au5 https://www.instagram.com/reel/DRIrpu0kdZO/?igsh=NTc4MTIwNjQ2YQ%3D%3D

EL POLy
https://www.joekoski.com/blog/2025/08/20/elixir-polymorphism.html
https://hexdocs.pm/funx/readme.html
https://pragprog.com/titles/jkelixir/advanced-functional-programming-with-elixir/
https://elixirforum.com/t/polymorphism-in-elixir/72196/2


https://www.youtube.com/watch?v=F6O7r9LqhC0
https://www.youtube.com/watch?v=LuOZ2PKvd4s
https://www.youtube.com/watch?v=6wR6xblSays


STUFF
https://boundaryml.com/https://www.youtube.com/watch?v=xt1KNDmOYqA
zig: https://www.youtube.com/watch?v=IroPQ150F6c
casey: https://www.youtube.com/watch?v=xt1KNDmOYqA

opus soul doc
https://gist.github.com/Richard-Weiss/efe157692991535403bd7e7fb20b6695#file-opus_4_5_soul_document_cleaned_up-md

https://interconnected.org/home/2025/08/29/dwim
https://interconnected.org/home/2025/11/28/plumbing

https://www.youtube.com/watch?v=hPPTrsUzLA8
https://www.youtube.com/watch?v=TledrLrVUQI
https://www.youtube.com/watch?v=rmvDxxNubIg
https://www.youtube.com/watch?v=Cor-t9xC1ck&list=PL6zLuuRVa1_iUNbel-8MxxpqKIyesaubA&index=2

hickey
https://pages.cs.wisc.edu/~remzi/Naur.pdf
https://www.youtube.com/watch?v=SxdOUGdseq4
https://www.youtube.com/watch?v=f84n5oFoZBc
https://www.arthropod.software/p/vibe-coding-our-way-to-disaster

https://www.youtube.com/watch?v=MZZCW179nKM
https://www.youtube.com/watch?v=uhJJgc-0iTQ
https://www.youtube.com/watch?v=j2tI3YGVEz0
https://www.youtube.com/watch?v=wKx66sYyyUs

elix
https://elixir-lang.org/blog/2025/12/02/lazier-bdds-for-set-theoretic-types/
https://www.perplexity.ai/search/opcorn-atom-vm-elixir-cAfzCkCnQqyOkilZ64uzIg
https://v1.tauri.app/v1/guides/development/development-cycle
https://www.perplexity.ai/search/compare-this-approach-to-using-6M2NXWh4SaWNQGgNeEKlyA

zig
https://sinclairtarget.com/blog/2025/08/thoughts-on-go-vs.-rust-vs.-zig/
https://ziglang.org/learn/
https://codeberg.org/ziglang/zig

https://sylverstudios.dev/blog/2025/03/25/elixir-ai

https://www.youtube.com/watch?v=B3rSU7XROrg

coding agents - distributed systems
https://www.linkedin.com/posts/annievella_oooh-these-are-very-interesting-results-activity-7384812092421419008-YPZ9/

cc life database - https://www.reddit.com/r/ClaudeCode/comments/1q2phbx/i_built_a_personal_life_database_with_claude_in/

agentic design patterns
https://www.reddit.com/r/AgentsOfAI/comments/1px0y6h/a_senior_google_engineer_dropped_a_424page_doc/

cc ralph
https://www.youtube.com/watch?v=ny_BAA3eYaI

supersonic
https://sonic-pi.net/supersonic/demo.html

boris cc setup - https://www.reddit.com/r/AgentsOfAI/comments/1q2s83g/boris_cherny_creator_of_claude_code_shares_his/

cc
https://www.reddit.com/r/ClaudeCode/comments/1px2umk/what_i_learned_from_writing_500k_lines_with/

self improving cc
https://www.youtube.com/watch?v=-4nUCaMNBR8

glm 4.7
https://www.reddit.com/r/ClaudeCode/comments/1q6f62t/tried_new_model_glm_47_for_coding_and_honestly/

opencode
dax twitter - https://x.com/thdxr
https://opencode.ai/
opencode $200 - https://www.reddit.com/r/opencodeCLI/comments/1q7jxjx/the_claude_exodus_is_real_opencode_to_launch_200/

n8n
ai catching up - https://www.reddit.com/r/AgentsOfAI/comments/1q8azq2/ai_workflow_platforms_are_catching_up_to_n8n/

manus cc skill 
https://www.reddit.com/r/ClaudeAI/comments/1q8fera/the_pattern_that_made_manus_worth_2b_now_a_free/
repo - https://github.com/OthmanAdi/planning-with-files

cc 2.1 skills
https://www.reddit.com/r/ClaudeCode/comments/1q84z3u/the_skills_update_in_claude_21_are_just_amazing/

kaparthy llm board: https://www.instagram.com/reel/DRuf9w9DRM7/?igsh=NTc4MTIwNjQ2YQ==

benn jordan dl
https://www.instagram.com/reel/DTRAN_tEQlt/?igsh=NTc4MTIwNjQ2YQ==

Bayseian debugging loop
This is the weird thing about LLMs. When they get stuck they get *really* stuck.
I’ve had some luck with putting CC into a Bayesian Debugging Loop (BDL), basically instead of trying to one shot the solution, have it maintain and curate multiple hypothesis of the problem. CC seems to understand what a BDL is without explanation.

cali delete privacy info
https://www.instagram.com/reel/DS9Cy-mkX8f/?igsh=NTc4MTIwNjQ2YQ==
https://www.instagram.com/reel/DTKAmyvAoyN/?igsh=NTc4MTIwNjQ2YQ==

ai avatar
https://www.instagram.com/brodyautomates?igsh=NTc4MTIwNjQ2YQ==

agentic coding techniques
https://medium.com/jonathans-musings/clean-code-in-the-age-of-ai-fc00d204d3e4
https://medium.com/jonathans-musings/understanding-code-in-the-age-of-ai-fddaa4d41848
https://medium.com/jonathans-musings/all-hail-the-monorepo-long-live-microservices-4f96209c66e4
https://medium.com/jonathans-musings/staff-software-engineer-finally-writes-a-line-of-code-by-hand-630987e1fc0f
https://medium.com/jonathans-musings/vibe-coding-in-production-a-five-month-reflection-7d170b7581cb

ralph wiggum
https://www.youtube.com/watch?v=RpvQH0r0ecM

boris setup cc
https://news.ycombinator.com/item?id=46470017
https://www.youtube.com/watch?v=B-UXpneKw6M

cc update
https://www.youtube.com/watch?v=NmKdYlODC24

ai engineers
https://www.youtube.com/watch?v=ttdWPDmBN_4

cc 
https://www.youtube.com/watch?v=lGWFlpffWk4

ANTHROPIC
https://every.to/thesis/two-ways-to-win-in-the-post-software-era
https://transformer-circuits.pub/2025/introspection/index.html
https://www.anthropic.com/engineering/advanced-tool-use?utm_source=perplexity
https://www.anthropic.com/research/introspection
https://red.anthropic.com/2025/smart-contracts/
https://www.youtube.com/watch?v=CEvIs9y1uog
https://www.youtube.com/watch?v=xNcEgqzlPqs
https://www.youtube.com/watch?v=X2ciJedw2vU
https://www.youtube.com/watch?v=faZId0PS78s
https://www.reddit.com/r/ClaudeAI/comments/1pjpbji/i_cannot_for_the_life_of_me_understand_the_value/
https://www.youtube.com/watch?v=13HP_bSeNjU
https://www.reddit.com/r/ClaudeCode/comments/1plrpbq/is_it_just_me_who_doesnt_use_skills_plugins_and/

ELIXIR
https://underjord.io/unpacking-elixir-observability.html
https://underjord.io/unpacking-elixir-concurrency.html
https://underjord.io/unpacking-elixir-resilience.html
https://underjord.io/unpacking-elixir-realtime-latency.html
https://underjord.io/unpacking-elixir-syntax.html
https://underjord.io/conference-report-goatmire-elixir-2025.html
https://adabeat.com/fp/beam-vs-microservices/
https://dev.to/pierrelegall/about-elixir-and-the-microservices-architecture-37gi
https://www.honeybadger.io/blog/elixir-memory-structure/
https://blog.appsignal.com/2023/02/14/under-the-hood-of-ecto.html
https://www.zachdaniel.dev/p/llms-and-elixir-windfall-or-deathblow
https://www.zachdaniel.dev/p/elixir-misconceptions-1
https://substack.com/home/post/p-168616789
https://www.youtube.com/watch?v=0Dvn039qD8I
https://www.reddit.com/r/elixir/comments/1pk774a/route_shield_an_opensource_tool_for_teams/

CC
https://www.reddit.com/r/ClaudeCode/comments/1pm4vqq/spent_way_too_long_building_a_free_claude/
https://www.claudedirectory.co/
https://www.reddit.com/r/ClaudeAI/comments/1ptcbm3/code_quality_of_claude_a_sad_realization/
https://www.youtube.com/watch?v=wKx66sYyyUs

utilites
https://isitnerfed.org/

opencode
https://github.com/code-yeongyu/oh-my-opencode/blob/master/README.md#goodbye-claude-code-hello-oh-my-opencode

SECOND BRAIN
https://www.perplexity.ai/search/what-is-a-better-system-of-org-kI3b_A3BQ9yZOqssx4MU8A
https://www.kimi.com/chat/19baeff2-5fa2-82db-8000-09346c1c3400
https://www.reddit.com/r/ClaudeCode/comments/1pjon1r/til_that_claude_code_has_opentelemetry_metrics/#lightbox

STRATTA
https://forum.letta.com/t/general-agent-tips/100/2
https://www.kimi.com/chat/19baf470-4aa2-802c-8000-0934471e12e4
agentic design patterns google : file:///Users/mark/Dirtwire%20LLC%20Dropbox/Mark%20Reveley/Dev/books/Agentic_Design_Patterns.pdf
https://elixirforum.com/
https://www.kimi.com/chat/19ab4d1e-fb32-8ea6-8000-093416b28fd1
https://www.kimi.com/chat/19aad83c-3b72-8ac4-8000-0934b4f0b0c3
https://www.perplexity.ai/search/is-there-room-for-a-site-strat-lsu3Yb9pTC22_eV0lr0Jtw
https://learn.deeplearning.ai/courses/llms-as-operating-systems-agent-memory/lesson/c25gr/editable-memory
https://nader.substack.com/p/the-complete-guide-to-building-agents?utm_source=multiple-personal-recommendations-email&utm_medium=email&triedRedirect=true

OPENCODE
https://www.reddit.com/r/ClaudeCode/comments/1pp2tyw/comment/nul5kct/
https://github.com/code-yeongyu/oh-my-opencode/blob/master/README.md#goodbye-claude-code-hello-oh-my-opencode
https://www.reddit.com/r/ClaudeCode/comments/1pp2tyw/ohmyopencode_has_been_a_gamechanger/
https://github.com/obra/superpowers
https://www.perplexity.ai/search/evaluate-the-accuracy-of-this-geMXt8E0Qwm69A36t0YRdw

ELIXIR/FLY
https://hexdocs.pm/elixir/introduction.html
https://github.com/agentjido/jido
https://hexdocs.pm/phoenix/fly.html
https://www.browserbase.com/

DESIGN
https://www.figma.com/design/gzQqhvCzaxjnjQFtaT9mT6/YT-Thumbnails?node-id=49-2
https://new.express.adobe.com/

## Surveyed

<!--
  Each entry is appended by /bookmarks in this shape — newest first. **Added** is the
  date-added the operator flagged in Pending (its `### YYYY-MM-DD` heading), not the
  day it was processed:

  ### [Page title](https://example.com/article)
  - **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `tag-a` `tag-b`
  - One-sentence summary of what the resource is and why it might matter.

  For a Hacker News (or similar) link, /bookmarks extracts the underlying resource as
  the primary link and keeps the discussion alongside it — one bookmark, two URLs:
  ### [Page title](https://example.com/the-actual-article)
  - **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `tag-a` · **Discussion:** [HN](https://news.ycombinator.com/item?id=48623434)
  - One-sentence summary.

  On promotion, /bookmarks flips the Status (Added is preserved):
  - **Added:** 2026-07-22 · **Status:** promoted → [filed reference](/knowledge/…/x.md) · **Tags:** …
-->

### [Fine Tuning a Local LLM to Categorize Questions](https://www.teachmecoolstuff.com/viewarticle/fine-tuning-a-local-llm-to-categorize-questions)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `fine-tuning` `local-llm` `qwen` `rag` `classification` · **Discussion:** [HN](https://news.ycombinator.com/item?id=48623434)
- A hands-on walkthrough of fine-tuning a tiny 600M-parameter Qwen model to classify household questions into metadata categories for a RAG chatbot.

### [American AI is locked down and proprietary. It's losing.](https://werd.io/american-ai-is-locked-down-and-proprietary-its-losing/)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `open-weights` `ai-strategy` `china-ai` `proprietary-ai` `ai-policy` · **Discussion:** [HN](https://news.ycombinator.com/item?id=48979269)
- Ben Werdmuller argues China's open-weight AI strategy is outcompeting America's closed/proprietary approach.

### [Over 30% of papers submitted on arXiv read as AI-written](https://unslop.run/blog/measuring-ai-writing-on-arxiv)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-writing-detection` `arxiv` `evals` `llm-text-analysis` `measurement` · **Discussion:** [HN](https://news.ycombinator.com/item?id=48981206)
- A study of 12,750 arXiv papers estimating ~30% read as AI-written, with a look at where such measurement breaks down.

### [Jack Dorsey launches Buzz to combine team chat, AI agents and Git hosting](https://runtimewire.com/article/jack-dorsey-block-buzz-team-chat-ai-agents-git)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-agents` `git-hosting` `team-chat` `jack-dorsey` `developer-tools`
- News that Jack Dorsey's Block launched Buzz, a platform merging team chat, AI agents, and Git hosting.

### [Human-like autonomy emerges from self-play and a pinch of human data (talk)](https://luma.com/8g05zj69)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `self-play` `reinforcement-learning` `autonomous-driving` `research-talk`
- Event listing for a talk on training autonomous-driving policies via self-play plus ~30 minutes of human data, without reward engineering.

### [SPICED: self-play autonomous driving](https://spiced-self-play.com/?utm_source=luma)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `self-play` `reinforcement-learning` `autonomous-driving` `simulation`
- Project/paper landing page for "SPICED," combining large-scale simulation with minimal human driving data to produce policies that coordinate with human drivers.

### [GoogleCloudPlatform/scion](https://github.com/GoogleCloudPlatform/scion)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `multi-agent-orchestration` `ai-agents` `containers` `claude-code` `developer-tools`
- A Google Cloud multi-agent orchestration testbed running deep agents (Claude Code, Gemini CLI) concurrently in isolated containers on one project.

### [knowledge-catalog / toolbox/mdcode/demo](https://github.com/GoogleCloudPlatform/knowledge-catalog/tree/main/toolbox/mdcode/demo)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `mdcode` `metadata-as-code` `okf` `bigquery` `google-cloud`
- Demo scripts for mdcode, a "metadata as code" tool that pulls/edits/pushes metadata snapshots for BigQuery and knowledge/wiki bundles via local files.

### [knowledge-catalog / okf (source tree)](https://github.com/GoogleCloudPlatform/knowledge-catalog/tree/main/okf)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `okf` `knowledge-management` `google-cloud`
- Source tree for the Open Knowledge Format spec — the already-filed [OKF reference](/knowledge/knowledge-management/open-knowledge-format.md) cites the parent repo, not this exact subtree, so it's kept as a bookmark rather than treated as a duplicate.

### [Introducing the Open Knowledge Format](https://cloud.google.com/blog/products/data-analytics/how-the-open-knowledge-format-can-improve-data-sharing)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `okf` `knowledge-management` `data-sharing` `google-cloud` `ai-agents`
- Google Cloud's announcement blog for OKF v0.1, a vendor-neutral markdown+YAML standard for portable, shareable knowledge across agents and orgs.

### [Detecting hallucinations and prompt injections in LLMs](https://www.reddit.com/r/LLMDevs/comments/1uc8qub/detecting_hallucinations_and_prompt_injections_in/)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `llm` `evals` `prompt-injection` `hallucination` `ai-safety`
- (unfetched: reddit.com blocked to fetch) r/LLMDevs discussion on techniques for detecting hallucinations and prompt-injection attacks in LLM applications.

### [To spawn, or not to spawn?](https://www.theerlangelist.com/article/spawn_or_not)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `elixir` `erlang` `beam` `concurrency` `software-design`
- Saša Jurić's argument that processes should separate runtime concerns from thought concerns, illustrated with a blackjack implementation keeping domain logic in pure functions and adding processes only for scaling/fault isolation.

### [I ran an agent autonomously for 300 hours](https://www.reddit.com/r/AgentsOfAI/comments/1uz8m6s/i_ran_an_agent_autonomously_for_300_hours_the_way/)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-agents` `autonomous-agents` `agent-orchestration` `llm`
- (unfetched: reddit.com blocked to fetch) r/AgentsOfAI first-hand account of running an AI agent autonomously for ~300 hours.

### [GLM-5.2 – How to Run Locally](https://unsloth.ai/docs/models/glm-5.2)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `llm` `local-inference` `open-weights` `glm` `unsloth` · **Discussion:** [HN](https://news.ycombinator.com/item?id=48636377)
- Unsloth's guide to running the GLM-5.2 open-weight model locally, covering hardware requirements and quantization.

### [Show HN: Oak – Git alternative designed for agents](https://oak.space/oak/oak)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `version-control` `ai-agents` `developer-tools` `git` · **Discussion:** [HN](https://news.ycombinator.com/item?id=48631726)
- Oak is a version-control system pitched as a Git alternative purpose-built for AI coding agents.

### [hunk — review-first terminal diff viewer](https://www.hunk.dev/)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `developer-tools` `code-review` `ai-agents` `terminal` `diff`
- Landing page for Hunk, a review-first terminal diff viewer built for reviewing agent-authored changesets (split view, multi-file sidebar, inline AI annotations).

### [modem-dev/hunk](https://github.com/modem-dev/hunk)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `developer-tools` `code-review` `ai-agents` `typescript` `diff`
- GitHub source for Hunk (TypeScript, built on OpenTUI and Pierre diffs), with Git/Jujutsu/Sapling support.

### [Orchestrate teams of Claude Code sessions](https://code.claude.com/docs/en/agent-teams.md)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `claude-code` `ai-agents` `agent-orchestration` `multi-agent` `developer-tools`
- Official Claude Code docs for the experimental "agent teams" feature — multiple sessions coordinating via a shared task list and inter-agent mailbox, contrasted with subagents.

### [Verbalizable Representations Form a Global Workspace in Language Models](https://transformer-circuits.pub/2026/workspace/)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `interpretability` `llm` `mechanistic-interpretability` `global-workspace` `ai-safety`
- Anthropic interpretability paper introducing the Jacobian lens to identify "verbalizable representations," arguing LLMs have a privileged global-workspace-like set of internal representations, with alignment-auditing applications.

### [Emotion Concepts and their Function in a Large Language Model](https://transformer-circuits.pub/2026/emotions/index.html)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `interpretability` `llm` `mechanistic-interpretability` `emotion` `ai-safety`
- Anthropic interpretability paper finding internal "emotion vectors" in Claude Sonnet 4.5 that causally influence behavior and can be decoupled from output text.

### [How I Coordinate 19 AI Agents Across 4 Model Families With OpenCode and Recallium](https://medium.com/@saurabbhatia/how-i-coordinate-19-ai-agents-across-4-model-families-with-opencode-and-recallium-00bc14fb8ccb)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-agents` `multi-agent` `multi-model` `orchestration` `shared-memory`
- An architecture coordinating 19 AI agents across four model families, using OpenCode for orchestration and Recallium as persistent shared memory instead of direct inter-agent messaging.

### [musistudio/claude-code-router](https://github.com/musistudio/claude-code-router)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `claude-code` `multi-model` `llm-router` `proxy` `provider-agnostic`
- A local control-plane/gateway giving Claude Code (and other CLIs) one stable endpoint while routing each request to the best backend model across providers with per-task rules and failover.

### [Claude Code Router Docs](https://ccrdesk.top/)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `claude-code` `llm-router` `documentation` `multi-model`
- Official documentation site for the claude-code-router project, covering providers, routing rules, and configuration.

### [A guide to cloud software factories for engineering leaders](https://www.warp.dev/blog/a-guide-to-cloud-software-factories-for-engineering-leaders)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `software-factory` `ai-agents` `engineering-leadership` `devops` `warp`
- Leader-oriented explainer on "cloud software factories" automating the SDLC through centralized, orchestrated agent systems.

### [We are now factory engineers, not product engineers](https://www.warp.dev/blog/we-are-now-factory-engineers-not-product-engineers)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `software-factory` `ai-agents` `engineering-culture` `warp`
- Opinion piece arguing engineers should shift from building products directly to building automated cloud software factories where agents handle triage-to-deployment.

### [How Rectangle Health Built an AI Teammate That Writes Its Own Code](https://www.warp.dev/blog/rectangle-health-self-improving-ai-teammate)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `software-factory` `ai-agents` `case-study` `self-improving` `warp`
- Case study of Rectangle Health building "Rex," a self-improving agent on Warp's Oz platform that has generated 54% of its own codebase.

### [The virtuous loop of open, automated development](https://www.warp.dev/blog/the-virtuous-loop-of-open-agentic-development)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `software-factory` `open-source` `agentic-development` `warp`
- Warp introduces "Open Agentic Development," where users and agents collaboratively improve software through community contributions and automated verification.

### [How to build a cloud software factory — add spec-driven development skills](https://www.warp.dev/blog/how-to-build-a-cloud-software-factory-add-spec-driven-development-skills)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `software-factory` `spec-driven-development` `ai-agents` `warp` `tutorial`
- Tutorial on adding a Spec agent that writes product and technical specs for complex issues before implementation begins.

### [How to build a cloud software factory — self-improving code review](https://www.warp.dev/blog/how-to-build-a-cloud-software-factory-self-improving-code-review)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `software-factory` `code-review` `ai-agents` `self-improving` `warp`
- Tutorial on building an automated code-review agent that improves over time via human feedback and self-learning loops.

### [How to build a cloud software factory — the automatic triage skill](https://www.warp.dev/blog/how-to-build-a-cloud-software-factory-the-automatic-triage-skill)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `software-factory` `issue-triage` `ai-agents` `warp` `tutorial`
- Foundational tutorial on setting up agents to automatically triage GitHub issues and implement simple fixes.

### [Unfortunately, Sprites Now Speak MCP](https://fly.io/blog/unfortunately-mcp/)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `mcp` `fly-io` `sandboxing` `ai-agents` `disposable-vms`
- Fly.io announces MCP support for its Sprites platform, letting AI agents provision and manage disposable VMs through an MCP interface.

### [Stopped trusting what my agent says it did](https://www.reddit.com/r/LLMDevs/comments/1uxzquu/stopped_trusting_what_my_agent_says_it_did/)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-agents` `agent-verification` `reliability` `llm-agents`
- (unfetched: reddit.com blocked to fetch) r/LLMDevs post on not trusting an agent's self-reported "done" and building external verification instead.

### [How do you know your agent actually did the thing?](https://www.reddit.com/r/LLMDevs/comments/1uxh14x/how_do_you_know_your_agent_actually_did_the_thing/)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-agents` `agent-verification` `evals` `reliability`
- (unfetched: reddit.com blocked to fetch) r/LLMDevs discussion on how practitioners verify an LLM agent genuinely completed a task.

### [I studied how Cognee, Graphiti, and Neo4j build memory](https://www.reddit.com/r/LLMDevs/comments/1ux306l/i_studied_how_cognee_graphiti_and_neo4j_build/)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `agent-memory` `knowledge-graph` `cognee` `graphiti` `neo4j`
- (unfetched: reddit.com blocked to fetch) r/LLMDevs write-up comparing how Cognee, Graphiti, and Neo4j build agent memory/knowledge-graph layers.

### [carsteneu/ai-memory-comparison](https://github.com/carsteneu/ai-memory-comparison)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `agent-memory` `knowledge-graph` `comparison` `ai-agents`
- A feature-level comparison of memory systems for AI coding agents — 81 systems across 79 features, each claim backed by public source citations.

### [Let Claude Code search your repo, not crawl it](https://www.reddit.com/r/LLMDevs/comments/1uy4sca/let_claude_code_search_your_repo_not_crawl_it/)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `claude-code` `code-search` `repo-context` `ai-agents`
- (unfetched: reddit.com blocked to fetch) r/LLMDevs post arguing Claude Code should search a repo via Glob/Grep/Read rather than crawl or pre-index it.

### [Same-family self-grading inflated my eval by 176%](https://www.reddit.com/r/LLMDevs/comments/1uxua8u/samefamily_selfgrading_inflated_my_eval_by_176/)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `evals` `llm-as-judge` `self-bias` `model-evaluation`
- (unfetched: reddit.com blocked to fetch) r/LLMDevs report that using a same-family model as LLM-judge inflated eval scores by 176%.

### [Skills evals](https://www.reddit.com/r/LLMDevs/comments/1uxv3tk/skills_evals/)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `claude-code` `skills` `evals` `agent-testing`
- (unfetched: reddit.com blocked to fetch) r/LLMDevs post on evaluating agent skills.

### [ahnafyy/skills-evals](https://github.com/ahnafyy/skills-evals)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `claude-code` `skills` `evals` `agent-testing` `regression-testing`
- A tool that validates, trigger-tests, and regression-tests every agent skill in a repo to catch when skills stop working or triggering correctly.

### [Unlocking the Cloudflare app ecosystem with OAuth for all](https://blog.cloudflare.com/oauth-for-all/)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `oauth` `cloudflare` `api-auth` `zero-downtime-migration` · **Discussion:** [HN](https://news.ycombinator.com/item?id=48668033)
- Cloudflare opened self-managed OAuth to all developers via a zero-downtime migration of its OAuth engine, letting customers create their own OAuth apps.

### [Trunk-based Development](https://www.atlassian.com/continuous-delivery/continuous-integration/trunk-based-development)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `trunk-based-development` `version-control` `ci-cd` `git-workflow`
- Atlassian's CI/CD guide explaining trunk-based development, a practice of merging small, frequent updates to a single main trunk.

### [jasonshrepo/qiju](https://github.com/jasonshrepo/qiju)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-agents` `session-records` `claude-code` `local-first` `agent-memory`
- Qiju (起居) provides local-first, structured session records so Claude Code, Codex, Kiro, Cursor, and future agents can continue from verifiable development history.

### [Claude Code artifact 4394e12e](https://claude.ai/code/artifact/4394e12e-677b-4ccf-af11-477e38c3e0e7)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `claude-artifact`
- (unfetched: artifact is auth-gated, not readable by a non-member fetch)

### [If you're not already using a CI pipeline with Claude Code...](https://www.reddit.com/r/ClaudeAI/comments/1v28snk/if_youre_not_already_using_a_ci_pipeline_with/)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `claude-code` `ci-pipeline` `agentic-workflow`
- (unfetched: reddit.com blocked to fetch) r/ClaudeAI post advocating running Claude Code inside a CI pipeline.

### [I stopped building a database for my AI agents](https://www.reddit.com/r/LLMDevs/comments/1v0aw41/i_stopped_building_a_database_for_my_ai_agents/)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-agents` `agent-memory` `database`
- (unfetched: reddit.com blocked to fetch) r/LLMDevs post rethinking the memory/database layer for AI agents.

### [I made a modern Dark Pro theme for Warp terminal](https://www.reddit.com/r/warpdotdev/comments/1us28d5/i_made_a_modern_dark_pro_theme_for_warp_terminal/)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `warp-terminal` `terminal-theme` `dark-theme`
- (unfetched: reddit.com blocked to fetch) r/warpdotdev post sharing a custom "Dark Pro" color theme for the Warp terminal.

### [Evidence of inconsistencies in evaluation process and selection of winners](https://www.kaggle.com/competitions/kaggle-measuring-agi/discussion/724918#3498423)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `kaggle` `agi-benchmark` `competition-integrity` `evaluation` · **Discussion:** [HN](https://news.ycombinator.com/item?id=48946010)
- A Kaggle "Measuring Progress Toward AGI" competition discussion thread alleging inconsistencies in the evaluation process and winner selection.

### [Immersive Linear Algebra](https://immersivemath.com/ila/)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `linear-algebra` `interactive-textbook` `mathematics` `education` · **Discussion:** [HN](https://news.ycombinator.com/item?id=48935951)
- A free online textbook billed as the world's first linear algebra book with fully interactive figures.

### [Mathematics of Data Science](https://arxiv.org/abs/2607.11938)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `data-science` `mathematics` `machine-learning` `arxiv` · **Discussion:** [HN](https://news.ycombinator.com/item?id=48939896)
- An arXiv paper on the mathematical foundations of data science, from dimension reduction and linear regression through deep learning and matrix recovery.

### [METR (Model Evaluation & Threat Research)](https://metr.org/)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-safety` `evaluation` `research-nonprofit` `frontier-models`
- A research nonprofit that measures whether and when frontier AI systems might pose catastrophic risks.

### [Claude Code artifact bfdfaef9](https://claude.ai/code/artifact/bfdfaef9-bc62-4dfe-ba9e-c58a26c9accf)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `claude-artifact`
- (unfetched: artifact is auth-gated, not readable by a non-member fetch)

### [YouTube video — FFfz81XM57k](https://www.youtube.com/watch?v=FFfz81XM57k)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-agents` `claude-code` `developer-tools`
- (unfetched: YouTube metadata unavailable)

### [Atuin in about 6 minutes](https://www.youtube.com/watch?v=JzVXK0WorpI)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `shell-history` `atuin` `cli` `developer-tools` `terminal`
- A quick walkthrough of Atuin, a tool that makes shell command history far more useful via import/sync features.

### [YouTube video — WkBPX-oDMnA](https://www.youtube.com/watch?v=WkBPX-oDMnA)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-agents` `developer-tools` `terminal`
- (unfetched: YouTube metadata unavailable)

### [This Tmux "Rewrite" Is Actually Brilliant](https://www.youtube.com/watch?v=5GtkyPvuvbQ)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `tmux` `terminal-multiplexer` `rust` `developer-tools` `cli`
- A look at Herdr, a Rust-based terminal multiplexer positioned as a modern rewrite of tmux with additional features.

### [Terax: One Developer Built an AI Terminal Better Than Warp](https://www.youtube.com/watch?v=3L8htHUzAI4)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-terminal` `rust` `tauri` `developer-tools` `terminal`
- Overview of Terax, a 7MB open-source AI-native terminal built with Tauri 2/Rust bundling a terminal, code editor, file explorer, and web preview.

### [YouTube video — m8VC2SV2igM](https://www.youtube.com/watch?v=m8VC2SV2igM)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-agents` `claude-code` `developer-tools`
- (unfetched: YouTube metadata unavailable)

### [SEE CMUX SOLVE Multi-Agent Orchestration (Claude Code and Pi Agent)](https://www.youtube.com/watch?v=WAFUMBLOjHo)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-agents` `multi-agent-orchestration` `claude-code` `cmux` `terminal`
- Demo of cmux, an open-source Ghostty-based macOS terminal for running agents like Claude Code and Pi Agent in parallel.

### [YouTube video — jPuN4ilZLdU](https://www.youtube.com/watch?v=jPuN4ilZLdU)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-agents` `claude-code` `llm`
- (unfetched: YouTube metadata unavailable)

### [YouTube video — AQl5Q-0l7FQ](https://www.youtube.com/watch?v=AQl5Q-0l7FQ)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-agents` `llm` `claude-code`
- (unfetched: YouTube metadata unavailable)

### [No, AI is NOT like the DotCom bubble. Don't believe their B.S.](https://www.youtube.com/watch?v=a3-vf78ZwTc)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-industry` `ai-hype` `tech-economics` `commentary`
- Internet of Bugs argues against the common comparison of the current AI boom to the DotCom bubble.

### ["The engineer of the future is the person who is able to choose what is worth doing." — Addy Osmani](https://www.youtube.com/watch?v=n97BCfyFIvw)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-engineering` `software-engineering` `career` `conference-talk`
- AI Engineer conference talk on how the engineer's role is shifting toward judgment about what work is worth doing in an AI-augmented world.

### [Don't Ship Skills Without Evals — Philipp Schmid, Google DeepMind](https://www.youtube.com/watch?v=0vphxNt4wyk)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-agents` `evals` `agent-skills` `conference-talk`
- Argues that agent skills must be backed by evaluations before shipping.

### [The Golden Age of AI Engineering](https://www.youtube.com/watch?v=pMggiOb18tc)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-engineering` `openai` `conference-talk` `agentic-coding`
- OpenAI panel discussing what makes the present a golden age of AI engineering and where agentic development is headed.

### [In the Land of AI Agents, the Verifiers Are King — Tariq Shaukat, Sonar](https://www.youtube.com/watch?v=VrpEyglYgeU)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-agents` `verification` `code-quality` `conference-talk`
- Argues that verification and verifiers are the decisive component for making AI agents reliable in production.

### [Why Your Agent Disagrees With Itself (And What To Do About It) — Diane Lin, Datadog](https://www.youtube.com/watch?v=wEc9aG7cRQc)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-agents` `agent-reliability` `consistency` `conference-talk`
- Examines why AI agents produce inconsistent or self-contradictory outputs and offers strategies to address it.

### [Don't Let the LLM Drive — Ornella Bahidika & Joel Allou, Microsoft](https://www.youtube.com/watch?v=m24UKZomm7k)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-agents` `llm-orchestration` `agent-architecture` `conference-talk`
- Makes the case for constraining LLM autonomy rather than letting the model control the overall flow of an agentic system.

### [Enterprise Agents Have a Structure Problem — Ishita Daga, Tesla](https://www.youtube.com/watch?v=B8l81jhvHbI)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-agents` `enterprise` `agent-architecture` `conference-talk`
- Argues that enterprise AI agents suffer from a structural design problem and discusses building them more soundly.

### [Agent Output Is Not UX: The Rendering Layer Your LLM Pipeline Is Missing — Bala Ramdoss, Amazon Lens](https://www.youtube.com/watch?v=maTp79FD9gI)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-agents` `llm-pipeline` `ux` `rendering` `conference-talk`
- Argues that raw agent output is not a user experience and that LLM pipelines need a dedicated rendering layer.

### [From Blind Spots to Merged PRs: Continuous Agentic Performance Optimization — May Walter, Hud](https://www.youtube.com/watch?v=JJGbw4ggaFs)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-agents` `performance-optimization` `continuous-improvement` `conference-talk`
- Presents a continuous approach to optimizing agentic performance, from surfacing blind spots to landing merged PRs.

### [Build Evals That Actually Matter — Nick Ung & Akshay Sharma, Lyft](https://www.youtube.com/watch?v=3z2uT5aDx_Y)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `evals` `ai-agents` `measurement` `conference-talk`
- Discusses how to design evaluations that meaningfully measure AI agent quality rather than vanity metrics.

### [A Practitioner's Guide to Graphs — Tim Ainge, Good Collective](https://www.youtube.com/watch?v=3ySF0I5iE_0)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `knowledge-graphs` `ai-agents` `data-modeling` `conference-talk`
- A practitioner-oriented guide to using graphs in AI/agentic systems.

### [Your Agents Need a Save Button — Hamza Tahir, ZenML](https://www.youtube.com/watch?v=bZISsg7H7DA)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-agents` `state-management` `checkpointing` `conference-talk`
- Argues that AI agents need durable state and checkpointing — a "save button" — to be reliable and resumable.

### [The Great Loops Debate — Dex Horthy, Geoff Huntley, Ian Livingstone, Greg Pstrucha](https://www.youtube.com/watch?v=c35YoMdnI78)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-agents` `agentic-loops` `panel-debate` `conference-talk`
- Panel debate on the role and design of agentic loops.

### [We're Discovering Things We Can't Explain](https://www.youtube.com/watch?v=Zo20PVvcIXg)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `ai-research` `interpretability` `emergent-behavior` `commentary`
- Discusses emergent AI capabilities and phenomena that researchers are observing but cannot yet fully explain.

### [FORGET Loop Engineering. Agentic Engineering is about THIS](https://www.youtube.com/watch?v=VQy50fuxI34)
- **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `agentic-engineering` `ai-agents` `claude-code` `workflow`
- Argues that agentic engineering is about more than loop engineering, reframing what practitioners should focus on when building agentic coding workflows.
