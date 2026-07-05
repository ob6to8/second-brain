# Publish Staging

Generated content for itsjustshell.com. Files here are drafts — edit before copying to the Phoenix site.

## Structure

```
posts/its-just-shell/YYYY/MM-DD-slug.md      # Blog posts from compound assertions
research/its-just-shell/YYYY/MM-DD-slug.md    # Research items from sources
```

## Format

Posts and research items use NimblePublisher Elixir map syntax for frontmatter:

```
%{
  title: "Title Here",
  description: "One sentence.",
  tags: ["tag1", "tag2"]
}
---
Body markdown here.
```

## Workflow

1. `./scripts/publish-post.sh <assertion-id>` — generate blog post from compound assertion
2. `./scripts/publish-research.sh <source-id>` — generate research item from source
3. Review and edit the generated file
4. Copy to Phoenix site's content directory
