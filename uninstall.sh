#!/usr/bin/env bash
set -euo pipefail

CLAUDE_DIR="${HOME}/.claude"

echo "=== Claude Code Dotfiles Uninstaller ==="
echo ""

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Remove dotfiles plugins from settings.json (keep user's own plugins)
if [ -L "$CLAUDE_DIR/settings.json" ]; then
    # Legacy symlink install — restore backup
    rm "$CLAUDE_DIR/settings.json"
    echo "[removed] settings.json symlink"
    if [ -f "$CLAUDE_DIR/settings.json.bak" ]; then
        mv "$CLAUDE_DIR/settings.json.bak" "$CLAUDE_DIR/settings.json"
        echo "[restored] settings.json from backup"
    fi
elif [ -f "$CLAUDE_DIR/settings.json" ] && [ -f "$DOTFILES_DIR/settings.json" ]; then
    # Merged install — remove only the plugins the dotfiles added
    dotfiles_plugins=$(jq -r '.enabledPlugins // {} | keys[]' "$DOTFILES_DIR/settings.json")
    if [ -n "$dotfiles_plugins" ]; then
        jq --argjson remove "$(jq '.enabledPlugins // {} | keys' "$DOTFILES_DIR/settings.json")" '
            .enabledPlugins |= with_entries(select(.key as $k | $remove | index($k) | not))
        ' "$CLAUDE_DIR/settings.json" > "$CLAUDE_DIR/settings.json.tmp"
        mv "$CLAUDE_DIR/settings.json.tmp" "$CLAUDE_DIR/settings.json"
        echo "[done] removed dotfiles plugins from settings.json (your plugins preserved)"
    fi
else
    echo "[skip] settings.json not found or dotfiles settings.json missing"
fi

# Remove symlinked hookify rules
for rule in "$CLAUDE_DIR"/hookify.*.local.md; do
    [ -L "$rule" ] || continue
    filename="$(basename "$rule")"
    rm "$rule"
    echo "[removed] $filename symlink"
done

# Remove dotfiles section from CLAUDE.md
MARKER_START="<!-- CLAUDE_DOTFILES_START -->"
MARKER_END="<!-- CLAUDE_DOTFILES_END -->"

if [ -L "$CLAUDE_DIR/CLAUDE.md" ]; then
    # Legacy symlink install — restore backup
    rm "$CLAUDE_DIR/CLAUDE.md"
    echo "[removed] CLAUDE.md symlink"
    if [ -f "$CLAUDE_DIR/CLAUDE.md.bak" ]; then
        mv "$CLAUDE_DIR/CLAUDE.md.bak" "$CLAUDE_DIR/CLAUDE.md"
        echo "[restored] CLAUDE.md from backup"
    fi
elif [ -f "$CLAUDE_DIR/CLAUDE.md" ] && grep -qF "$MARKER_START" "$CLAUDE_DIR/CLAUDE.md"; then
    # Merged install — strip the managed section
    awk -v start="$MARKER_START" -v end="$MARKER_END" '
        $0 == start { skip=1; next }
        $0 == end { skip=0; next }
        !skip { print }
    ' "$CLAUDE_DIR/CLAUDE.md" > "$CLAUDE_DIR/CLAUDE.md.tmp"
    mv "$CLAUDE_DIR/CLAUDE.md.tmp" "$CLAUDE_DIR/CLAUDE.md"
    # Remove file if it's now empty (only whitespace)
    if [ ! -s "$CLAUDE_DIR/CLAUDE.md" ] || ! grep -q '[^[:space:]]' "$CLAUDE_DIR/CLAUDE.md"; then
        rm "$CLAUDE_DIR/CLAUDE.md"
        echo "[removed] CLAUDE.md (was only dotfiles content)"
    else
        echo "[done] removed dotfiles section from CLAUDE.md (your content preserved)"
    fi
else
    echo "[skip] CLAUDE.md has no dotfiles section"
fi

# Remove symlinked skills
if [ -d "$DOTFILES_DIR/skills" ]; then
    for skill_dir in "$DOTFILES_DIR"/skills/*/; do
        [ -d "$skill_dir" ] || continue
        skill_name="$(basename "$skill_dir")"
        if [ -L "$CLAUDE_DIR/skills/$skill_name" ]; then
            rm "$CLAUDE_DIR/skills/$skill_name"
            echo "[removed] skills/$skill_name symlink"
        fi
    done
fi

echo ""
echo "=== Done ==="
