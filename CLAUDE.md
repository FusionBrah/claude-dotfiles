# Global Claude Code Preferences

## CLI Tools

- **Use `jq` for JSON parsing**, not `python3 -c "import json..."`. Examples:
  - `curl -s URL | jq -r '.content'` not `curl -s URL | python3 -c "import sys,json; print(json.load(sys.stdin)['content'])"`
  - `jq '.key' file.json` not `python3 -c "import json; ..."`
  - `jq -r '.[] | .name'` for iterating arrays
- **Use `rg`** directly in Bash when the Grep tool is insufficient (e.g., complex piped workflows)
