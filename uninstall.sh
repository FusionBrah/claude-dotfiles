#!/usr/bin/env bash
set -euo pipefail

CLAUDE_DIR="${HOME}/.claude"

echo "=== Claude Code Dotfiles Uninstaller ==="
echo ""

# Remove symlinked settings.json
if [ -L "$CLAUDE_DIR/settings.json" ]; then
    rm "$CLAUDE_DIR/settings.json"
    echo "[removed] settings.json symlink"
    if [ -f "$CLAUDE_DIR/settings.json.bak" ]; then
        mv "$CLAUDE_DIR/settings.json.bak" "$CLAUDE_DIR/settings.json"
        echo "[restored] settings.json from backup"
    fi
else
    echo "[skip] settings.json is not a symlink"
fi

# Remove symlinked hookify rules
for rule in "$CLAUDE_DIR"/hookify.*.local.md; do
    [ -L "$rule" ] || continue
    filename="$(basename "$rule")"
    rm "$rule"
    echo "[removed] $filename symlink"
done

echo ""
echo "=== Done ==="
