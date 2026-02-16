# Claude Code Dotfiles

Portable Claude Code configuration: plugins, global hookify rules, custom skills, and CLI tool preferences. Symlinks into `~/.claude/` on any workstation.

## Quick Start

```bash
git clone https://github.com/FusionBrah/claude-dotfiles.git
cd claude-dotfiles
./install.sh
```

Then in your first Claude Code session, install plugins (the script prints these):

```
/plugin install context7@claude-plugins-official
/plugin install superpowers@claude-plugins-official
/plugin install claude-md-management@claude-plugins-official
/plugin install claude-code-setup@claude-plugins-official
/plugin install ralph-loop@claude-plugins-official
/plugin install pyright-lsp@claude-plugins-official
/plugin install hookify@claude-plugins-official
/plugin install plugin-dev@claude-plugins-official
/plugin install agent-sdk-dev@claude-plugins-official
```

## Prerequisites

CLI tools referenced in the global CLAUDE.md. Install before first use:

```bash
# Ubuntu/Debian
sudo apt-get install -y ripgrep jq fd-find tree
sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd  # Ubuntu names it fdfind
sudo snap install yq
# delta: https://github.com/dandavison/delta/releases
wget -qO /tmp/delta.deb https://github.com/dandavison/delta/releases/latest/download/git-delta_0.18.2_amd64.deb
sudo dpkg -i /tmp/delta.deb

# macOS
brew install ripgrep jq fd tree yq git-delta
```

| Tool | Replaces | Purpose |
|------|----------|---------|
| `rg` (ripgrep) | `grep` | Fast regex search, respects .gitignore |
| `jq` | `python3 -c "import json"` | JSON parsing and transformation |
| `yq` | `grep`/python on YAML | YAML parsing and editing |
| `fd` | `find` | Fast file finding, respects .gitignore |
| `tree` | `ls -R` | Directory structure visualization |
| `delta` | default git diff | Syntax-highlighted diffs |

## What's Included

### Global CLAUDE.md

Preferences that apply to all projects:
- Prefer `jq` over python for JSON
- Prefer `yq` over grep/python for YAML
- Prefer `fd` over `find`
- Prefer `tree` over `ls -R`
- Use `delta` for diffs
- Use `rg` in Bash when Grep tool isn't enough

### Plugins (settings.json)

| Plugin | Purpose |
|--------|---------|
| superpowers | Skills framework: brainstorming, debugging, TDD, plans, verification, git workflows |
| hookify | Rule-based hooks from markdown config files |
| context7 | Up-to-date library documentation via MCP |
| claude-md-management | CLAUDE.md auditing and session learning capture |
| claude-code-setup | Automation recommendations for new projects |
| ralph-loop | Autonomous loop execution |
| pyright-lsp | Python type checking via Pyright |
| plugin-dev | Plugin creation and development tools |
| agent-sdk-dev | Claude Agent SDK app scaffolding and verification |

### Hookify Rules (6 global rules)

| Rule | Event | Action | Triggers When |
|------|-------|--------|---------------|
| `verify-before-stop` | stop | warn | Claude tries to stop - forces verification skill |
| `git-force-push-protection` | bash | block | `git push --force` - hard blocks force pushes |
| `finishing-branch` | bash | warn | `gh pr create`, `git merge main` - triggers finishing skill |
| `use-debugging-skill` | prompt | warn | User mentions bugs/errors/failures - forces systematic debugging |
| `use-executing-plans` | prompt | warn | User says "execute/implement the plan" - forces batched execution |
| `use-writing-plans` | prompt | warn | User says "write/create a plan" - forces structured plan format |

### Custom Skills

| Skill | Purpose |
|-------|---------|
| `markdown-fetch` | Fetch web pages as clean markdown via `markdown.new` - preferred over WebFetch for docs |

## File Structure

```
claude-dotfiles/
  CLAUDE.md                                    # Global CLI tool preferences
  settings.json                                # Plugin enables
  hookify.verify-before-stop.local.md          # Stop event: verify work
  hookify.git-force-push-protection.local.md   # Bash event: block force push
  hookify.finishing-branch.local.md            # Bash event: PR/merge workflow
  hookify.use-debugging-skill.local.md         # Prompt event: bugs/errors
  hookify.use-executing-plans.local.md         # Prompt event: plan execution
  hookify.use-writing-plans.local.md           # Prompt event: plan writing
  skills/
    markdown-fetch/
      SKILL.md                                 # Web-to-markdown fetching skill
  install.sh                                   # Symlinks into ~/.claude/
  uninstall.sh                                 # Clean removal
```

## How It Works

`install.sh` creates symlinks from this repo into `~/.claude/`:
- `CLAUDE.md` -> global preferences
- `settings.json` -> plugin configuration
- `hookify.*.local.md` -> global hookify rules
- `skills/*/` -> custom skills directories

Edits to either the symlink or the repo file update the same source. Changes take effect immediately (no restart needed for hookify rules and skills).

Plugins are not auto-installed from `settings.json` - they require a one-time `/plugin install` in a Claude Code session per machine.

## Uninstall

```bash
./uninstall.sh
```

Removes symlinks and restores backed-up settings if present.
