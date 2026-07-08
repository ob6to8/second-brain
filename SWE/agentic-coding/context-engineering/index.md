# Context engineering

How to structure, curate, and manage the context an LLM conversation or agent
holds — distinct from the [agentic-loop](/SWE/agentic-coding/agentic-loop/index.md)'s
tool-calling mechanics.

## References

- [Conversation Tree Architecture — branching context to avoid logical context poisoning](/SWE/agentic-coding/context-engineering/conversation-tree-architecture.md) — structures conversations as trees with selective downstream/upstream context flow between branches. `sb:784985` _(reference)_
- [When F1 fails: granularity-aware evaluation for dialogue topic segmentation (Michael Coen)](/SWE/agentic-coding/context-engineering/granularity-aware-evaluation-for-dialogue-topic-segmentation.md) — separates boundary scoring from boundary selection; shows sweeping boundary density changes W-F1 more than switching segmentation methods does. `sb:649457` _(reference)_
