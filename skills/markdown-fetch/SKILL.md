---
name: markdown-fetch
description: Use when you need to fetch documentation, web pages, or any URL content. Prefer this over WebFetch for documentation sites, API references, and technical content. Use when WebFetch fails or returns garbled HTML.
---

# Fetching Web Content as Markdown

## When to Use

- Fetching documentation or API references
- When WebFetch returns errors, blocks, or garbled HTML
- When you need clean, token-efficient content from a URL
- Reading blog posts, guides, or technical articles

## How to Use

Use `markdown.new` to convert any URL to clean markdown via Bash:

```bash
curl -s 'https://markdown.new/URL_HERE' | head -500
```

For JS-heavy sites, force browser rendering:

```bash
curl -s 'https://markdown.new/URL_HERE?method=browser' | head -500
```

POST API for programmatic use:

```bash
curl -s 'https://markdown.new/' \
  -H 'Content-Type: application/json' \
  -d '{"url": "URL_HERE", "method": "auto"}'
```

## Parameters

- `method`: `auto` (default), `ai`, or `browser`
- `retain_images`: `true` or `false` (default: `false`)

## Conversion Pipeline

1. **Primary**: Requests `Accept: text/markdown` from Cloudflare edge
2. **Fallback**: Cloudflare Workers AI `toMarkdown()` for HTML
3. **Final**: Headless browser for JS-heavy pages

## Tips

- Output is markdown with YAML frontmatter (title, description, image)
- Use `head -N` to limit output for large pages
- JSON response includes `content`, `title`, `url`, `method`, `duration_ms`
- Parse JSON content field: `curl -s URL | python3 -c "import sys,json; print(json.load(sys.stdin)['content'])"`
- Some sites still block it (GitBook, heavy bot protection) - not a silver bullet
- 80% fewer tokens than raw HTML

## Prefer Over WebFetch When

- Target is documentation (Python docs, framework docs, API references)
- WebFetch returned a 403/500 or garbled content
- You need code examples preserved cleanly
- Token efficiency matters (large pages)
