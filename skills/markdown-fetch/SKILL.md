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

## Methods

### Quick fetch (GET - auto method)

```bash
curl -s 'https://markdown.new/URL_HERE' | head -500
```

### JS-heavy sites (GET - browser rendering)

```bash
curl -s 'https://markdown.new/URL_HERE?method=browser' | head -500
```

### With images retained

```bash
curl -s 'https://markdown.new/URL_HERE?method=browser&retain_images=true' | head -500
```

### POST API (full control)

**Auto (fastest, tries all 3 tiers):**
```bash
curl -s 'https://markdown.new/' \
  -H 'Content-Type: application/json' \
  -d '{"url": "URL_HERE"}'
```

**Browser rendering (JS-heavy sites):**
```bash
curl -s 'https://markdown.new/' \
  -H 'Content-Type: application/json' \
  -d '{"url": "URL_HERE", "method": "browser"}'
```

**Workers AI with images:**
```bash
curl -s 'https://markdown.new/' \
  -H 'Content-Type: application/json' \
  -d '{"url": "URL_HERE", "method": "ai", "retain_images": true}'
```

## Parameters

| Parameter | Values | Default | Notes |
|-----------|--------|---------|-------|
| `method` | `auto`, `ai`, `browser` | `auto` | `browser` for JS-heavy sites, `ai` for Cloudflare Workers AI |
| `retain_images` | `true`, `false` | `false` | Include image markdown in output |

## Conversion Pipeline (auto method)

1. **Primary**: Requests `Accept: text/markdown` from Cloudflare edge (fastest)
2. **Fallback**: Cloudflare Workers AI `toMarkdown()` for HTML
3. **Final**: Headless browser rendering for JS-heavy pages

## Choosing a Method

| Scenario | Method |
|----------|--------|
| Standard docs (Python, MDN, etc.) | `auto` |
| JS-rendered SPAs, React sites | `browser` |
| Need images in output | any + `retain_images=true` |
| First attempt failed | Retry with `browser` explicitly |

## Response Format

**GET requests**: Returns raw markdown text directly.

**POST requests**: Returns JSON:
```json
{
  "success": true,
  "url": "...",
  "title": "...",
  "content": "markdown here...",
  "method": "Cloudflare Workers AI",
  "duration_ms": 1234
}
```

Extract content from POST: `curl -s ... | jq -r '.content'`

## Known Limitations

- GitBook sites are blocked ("URL pattern not allowed for security reasons")
- Some heavily bot-protected sites fail all 3 methods
- Not a silver bullet, but works for most public documentation
- 80% fewer tokens than raw HTML when it works

## Prefer Over WebFetch When

- Target is documentation (Python docs, framework docs, API references)
- WebFetch returned a 403/500 or garbled content
- You need code examples preserved cleanly
- Token efficiency matters (large pages)
