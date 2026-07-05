# /publish — Generate publishable content from knowledge base

## Dispatch

Determine the content type and call the appropriate script:

### Blog post (from compound assertion)
```bash
./scripts/publish-post.sh <assertion-id> [--slug "custom-slug"]
```
Use when the user provides an assertion ID (a compound assertion with deps and implication).

### Research item (from source)
```bash
./scripts/publish-research.sh <source-id>
```
Use when the user provides a source ID.

## Workflow

1. Ask the user what to publish if not specified (assertion or source, and which ID)
2. Run the appropriate script
3. Show the user the generated file path and a preview of the content
4. Ask if they want to edit before committing

## Notes

- Both scripts use `claude` backend (heavy reasoning, Max plan)
- Output goes to `publish/` staging directory
- Files use NimblePublisher Elixir map syntax, not YAML frontmatter
- Generated content is a draft — always review before copying to the Phoenix site
