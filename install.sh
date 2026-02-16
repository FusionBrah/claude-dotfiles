#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"

echo "=== Claude Code Dotfiles Installer ==="
echo ""

# Ensure ~/.claude exists
mkdir -p "$CLAUDE_DIR"

# --- Symlink CLAUDE.md ---
if [ -L "$CLAUDE_DIR/CLAUDE.md" ]; then
    echo "[skip] CLAUDE.md already symlinked"
elif [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    echo "[backup] CLAUDE.md exists, backing up to CLAUDE.md.bak"
    cp "$CLAUDE_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md.bak"
    ln -sf "$DOTFILES_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
    echo "[done] CLAUDE.md symlinked (backup saved)"
else
    ln -sf "$DOTFILES_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
    echo "[done] CLAUDE.md symlinked"
fi

# --- Symlink settings.json ---
if [ -L "$CLAUDE_DIR/settings.json" ]; then
    echo "[skip] settings.json already symlinked"
elif [ -f "$CLAUDE_DIR/settings.json" ]; then
    echo "[backup] settings.json exists, backing up to settings.json.bak"
    cp "$CLAUDE_DIR/settings.json" "$CLAUDE_DIR/settings.json.bak"
    ln -sf "$DOTFILES_DIR/settings.json" "$CLAUDE_DIR/settings.json"
    echo "[done] settings.json symlinked (backup saved)"
else
    ln -sf "$DOTFILES_DIR/settings.json" "$CLAUDE_DIR/settings.json"
    echo "[done] settings.json symlinked"
fi

# --- Symlink hookify rules ---
echo ""
echo "--- Hookify Rules ---"
for rule in "$DOTFILES_DIR"/hookify.*.local.md; do
    [ -f "$rule" ] || continue
    filename="$(basename "$rule")"
    if [ -L "$CLAUDE_DIR/$filename" ]; then
        echo "[skip] $filename already symlinked"
    else
        ln -sf "$rule" "$CLAUDE_DIR/$filename"
        echo "[done] $filename symlinked"
    fi
done

# --- Symlink custom skills ---
echo ""
echo "--- Custom Skills ---"
if [ -d "$DOTFILES_DIR/skills" ]; then
    mkdir -p "$CLAUDE_DIR/skills"
    for skill_dir in "$DOTFILES_DIR"/skills/*/; do
        [ -d "$skill_dir" ] || continue
        skill_name="$(basename "$skill_dir")"
        if [ -L "$CLAUDE_DIR/skills/$skill_name" ]; then
            echo "[skip] skills/$skill_name already symlinked"
        else
            ln -sf "$skill_dir" "$CLAUDE_DIR/skills/$skill_name"
            echo "[done] skills/$skill_name symlinked"
        fi
    done
else
    echo "[skip] No custom skills to install"
fi

# --- Configure git to use delta ---
echo ""
echo "--- Git Config ---"
if command -v delta &>/dev/null; then
    git config --global core.pager delta
    git config --global interactive.diffFilter "delta --color-only"
    git config --global delta.navigate true
    git config --global delta.side-by-side true
    git config --global merge.conflictstyle diff3
    git config --global diff.colorMoved default
    echo "[done] delta configured as git pager (side-by-side)"
else
    echo "[skip] delta not installed - run prerequisites first"
fi

# --- Plugin install instructions ---
echo ""
echo "=== Plugins ==="
echo ""
echo "Plugins must be installed manually in a Claude Code session."
echo "Start claude and run these commands:"
echo ""

# Read plugin list from settings.json
plugins=$(python3 -c "
import json
with open('$DOTFILES_DIR/settings.json') as f:
    data = json.load(f)
for plugin in data.get('enabledPlugins', {}):
    print(plugin)
" 2>/dev/null || echo "")

if [ -n "$plugins" ]; then
    while IFS= read -r plugin; do
        echo "  /plugin install $plugin"
    done <<< "$plugins"
else
    echo "  (could not read plugin list from settings.json)"
fi

echo ""
echo "=== Done ==="
echo "Config files are symlinked. Install plugins above on first session."
