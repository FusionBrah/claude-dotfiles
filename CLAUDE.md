<!-- CLAUDE_DOTFILES_START -->
# Global Claude Code Preferences

## CLI Tools

- **Use `jq` for JSON parsing**, not `python3 -c "import json..."`. Examples:
  - `curl -s URL | jq -r '.content'` not `curl -s URL | python3 -c "import sys,json; print(json.load(sys.stdin)['content'])"`
  - `jq '.key' file.json` not `python3 -c "import json; ..."`
  - `jq -r '.[] | .name'` for iterating arrays
- **Use `yq` for YAML parsing/editing**, not python or grep. Examples:
  - `yq '.exit_rules.atr_multiplier' config.yaml` to read a value
  - `yq '.active_mode' config.yaml` not `grep active_mode config.yaml`
  - `yq -i '.key = "value"' file.yaml` for in-place edits
- **Use `fd` for file finding in Bash**, not `find`. Examples:
  - `fd '\.py$'` not `find . -name "*.py"`
  - `fd -e json journal/` to find JSON files in a directory
  - `fd` respects .gitignore by default
- **Use `tree` for directory structure**, not `ls -R` or nested `ls`. Examples:
  - `tree -L 2` for top 2 levels
  - `tree -L 3 --dironly` for directories only
  - `tree -I '__pycache__|.venv|node_modules'` to exclude patterns
- **Use `delta` for diffs** — already configured as git pager. When piping diffs manually:
  - `diff file1 file2 | delta`
  - `git diff | delta` (automatic if configured)
- **Use `rg`** directly in Bash when the Grep tool is insufficient (e.g., complex piped workflows)
<!-- CLAUDE_DOTFILES_END -->
