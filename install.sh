#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"

echo "=== Claude Code Dotfiles Installer ==="
echo ""

# Ensure ~/.claude exists
mkdir -p "$CLAUDE_DIR"

# --- Merge CLAUDE.md ---
MARKER_START="<!-- CLAUDE_DOTFILES_START -->"
MARKER_END="<!-- CLAUDE_DOTFILES_END -->"

# If it's currently a symlink from a previous install, replace with the actual file
if [ -L "$CLAUDE_DIR/CLAUDE.md" ]; then
    rm "$CLAUDE_DIR/CLAUDE.md"
    if [ -f "$CLAUDE_DIR/CLAUDE.md.bak" ]; then
        mv "$CLAUDE_DIR/CLAUDE.md.bak" "$CLAUDE_DIR/CLAUDE.md"
        echo "[restored] CLAUDE.md from backup (was symlinked)"
    else
        touch "$CLAUDE_DIR/CLAUDE.md"
        echo "[migrated] removed old symlink, starting fresh"
    fi
fi

DOTFILES_CONTENT="$(cat "$DOTFILES_DIR/CLAUDE.md")"

if [ ! -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    # No existing file — just create it
    echo "$DOTFILES_CONTENT" > "$CLAUDE_DIR/CLAUDE.md"
    echo "[done] CLAUDE.md created"
elif grep -qF "$MARKER_START" "$CLAUDE_DIR/CLAUDE.md"; then
    # Markers exist — replace the managed section in-place
    # Use awk to replace everything between markers (inclusive)
    awk -v start="$MARKER_START" -v end="$MARKER_END" -v content="$DOTFILES_CONTENT" '
        $0 == start { print content; skip=1; next }
        $0 == end { skip=0; next }
        !skip { print }
    ' "$CLAUDE_DIR/CLAUDE.md" > "$CLAUDE_DIR/CLAUDE.md.tmp"
    mv "$CLAUDE_DIR/CLAUDE.md.tmp" "$CLAUDE_DIR/CLAUDE.md"
    echo "[done] CLAUDE.md updated (existing content preserved)"
else
    # No markers — append with a blank line separator
    echo "" >> "$CLAUDE_DIR/CLAUDE.md"
    echo "$DOTFILES_CONTENT" >> "$CLAUDE_DIR/CLAUDE.md"
    echo "[done] CLAUDE.md appended (existing content preserved)"
fi

# --- Merge settings.json ---
# If it's currently a symlink from a previous install, restore the backup first
if [ -L "$CLAUDE_DIR/settings.json" ]; then
    rm "$CLAUDE_DIR/settings.json"
    if [ -f "$CLAUDE_DIR/settings.json.bak" ]; then
        mv "$CLAUDE_DIR/settings.json.bak" "$CLAUDE_DIR/settings.json"
        echo "[restored] settings.json from previous symlink install"
    fi
fi

if [ -f "$CLAUDE_DIR/settings.json" ]; then
    # Merge: add dotfiles plugins into existing settings, preserving user's plugins
    jq -s '.[0] as $user | .[1] as $dotfiles |
        $user * {
            enabledPlugins: (($user.enabledPlugins // {}) * ($dotfiles.enabledPlugins // {}))
        }' \
        "$CLAUDE_DIR/settings.json" "$DOTFILES_DIR/settings.json" > "$CLAUDE_DIR/settings.json.tmp"
    mv "$CLAUDE_DIR/settings.json.tmp" "$CLAUDE_DIR/settings.json"
    echo "[done] settings.json merged (your plugins preserved, dotfiles plugins added)"
else
    cp "$DOTFILES_DIR/settings.json" "$CLAUDE_DIR/settings.json"
    echo "[done] settings.json created from dotfiles"
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
plugins=$(jq -r '.enabledPlugins // {} | keys[]' "$DOTFILES_DIR/settings.json" 2>/dev/null || echo "")

if [ -n "$plugins" ]; then
    while IFS= read -r plugin; do
        echo "  /plugin install $plugin"
    done <<< "$plugins"
else
    echo "  (could not read plugin list from settings.json)"
fi

echo ""
echo "=== Done ==="
echo "CLAUDE.md merged, config files linked. Install plugins above on first session."
