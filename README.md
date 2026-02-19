# Claude Code Dotfiles

My opinionated Claude Code setup. Portable across workstations via symlinks.

The idea: Claude Code is powerful out of the box, but without guardrails it'll happily barrel through a 10-step plan without stopping, propose "quick fixes" without finding root cause, force-push to main, and claim work is done without verifying anything. This repo fixes that.

## Philosophy

**Three layers of discipline:**

1. **Hookify rules** catch me in the act — before I stop without verifying, before I skip the debugging process, before I push to a branch without the proper workflow. These are the seatbelts.

2. **Global CLAUDE.md** preferences keep me reaching for the right tools — `jq` not python for JSON, `yq` not grep for YAML, `fd` not find, `tree` not `ls -R`. Small things that compound over hundreds of tool calls per session.

3. **Custom skills** fill gaps the plugins don't cover — like `markdown-fetch` for pulling clean documentation from the web when WebFetch gets blocked (which is often).

## Quick Start

```bash
git clone https://github.com/FusionBrah/claude-dotfiles.git
cd claude-dotfiles
./install.sh
```

Then in your first Claude Code session, install plugins (the script prints the full list):

```
/plugin install superpowers@claude-plugins-official
/plugin install hookify@claude-plugins-official
/plugin install context7@claude-plugins-official
/plugin install claude-md-management@claude-plugins-official
/plugin install claude-code-setup@claude-plugins-official
/plugin install ralph-loop@claude-plugins-official
/plugin install pyright-lsp@claude-plugins-official
/plugin install plugin-dev@claude-plugins-official
/plugin install agent-sdk-dev@claude-plugins-official
/plugin install code-simplifier@claude-plugins-official
/plugin install frontend-design@claude-plugins-official
/plugin install code-review@claude-plugins-official
```

## Prerequisites

Modern CLI tools that the global CLAUDE.md tells Claude to prefer:

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

| Tool | Replaces | Why bother |
|------|----------|------------|
| `rg` | `grep` | 10x faster, respects .gitignore, sane defaults |
| `jq` | `python3 -c "import json"` | `jq -r '.content'` vs a 60-char python one-liner |
| `yq` | grep/python on YAML | Query config files directly instead of regex guessing |
| `fd` | `find` | `fd '\.py$'` vs `find . -name "*.py" -type f` |
| `tree` | `ls -R` | Actually see the structure instead of a wall of text |
| `delta` | default git diff | Syntax-highlighted, side-by-side diffs. Hard to go back. |

## What's Inside

### The Guardrails (Hookify Rules)

Rules that fire automatically based on what Claude is about to do:

| Rule | What it prevents |
|------|-----------------|
| `verify-before-stop` | Claiming "done" without running verification. Evidence before assertions. |
| `git-force-push-protection` | Force pushing. Hard blocked, no exceptions. |
| `finishing-branch` | Creating PRs or merging without the proper branch completion workflow. |
| `use-debugging-skill` | Jumping to fixes when a bug is reported. Forces root cause investigation first. |
| `use-brainstorming` | Skipping design exploration. Forces 2-3 approaches before committing to one. |
| `require-review-before-done` | Finishing work without code review. Forces review before declaring done. |
| `require-skills-on-session-continue` | Resuming sessions without checking for applicable skills. |

### The Toolbelt (Plugins)

| Plugin | What it does |
|--------|-------------|
| superpowers | The big one. Skills for brainstorming, debugging, TDD, plan writing/execution, verification, git workflows. |
| hookify | Makes the guardrail rules above work. Reads `.local.md` files and enforces them. |
| context7 | Pulls up-to-date library docs via MCP. No more outdated API references. |
| claude-md-management | Keeps CLAUDE.md files current with session learnings. |
| claude-code-setup | Recommends automations for new projects. |
| ralph-loop | Autonomous loop execution for long-running tasks. |
| pyright-lsp | Python type checking. Catches type errors before runtime. |
| plugin-dev | Tools for building Claude Code plugins. |
| agent-sdk-dev | Claude Agent SDK scaffolding. |
| code-simplifier | Simplifies and refines code for clarity and maintainability. |
| frontend-design | Production-grade frontend interfaces with high design quality. |
| code-review | Code review for pull requests. |

### The Preferences (Global CLAUDE.md)

Tells Claude to reach for the right tool every time:
- `jq` for JSON, `yq` for YAML, `fd` for files, `tree` for directories, `delta` for diffs, `rg` when the Grep tool isn't enough

### Custom Skills

| Skill | What it solves |
|-------|---------------|
| `markdown-fetch` | WebFetch gets blocked by half the internet. This uses [markdown.new](https://markdown.new) to convert pages to clean markdown via Cloudflare's pipeline — auto, Workers AI, or headless browser fallback. |

## File Structure

```
claude-dotfiles/
  CLAUDE.md                                            # Global preferences
  settings.json                                        # Plugin config
  hookify.verify-before-stop.local.md                  # Stop: verify first
  hookify.git-force-push-protection.local.md           # Bash: block force push
  hookify.finishing-branch.local.md                    # Bash: PR/merge workflow
  hookify.use-debugging-skill.local.md                 # Prompt: force debugging
  hookify.use-brainstorming.local.md                   # Prompt: force design exploration
  hookify.require-review-before-done.local.md          # Stop: require code review
  hookify.require-skills-on-session-continue.local.md  # Prompt: check skills on resume
  hookify.use-executing-plans.local.md                 # (disabled) redundant with superpowers
  hookify.use-writing-plans.local.md                   # (disabled) redundant with superpowers
  skills/
    markdown-fetch/
      SKILL.md                                         # markdown.new web fetcher
  install.sh                                           # Symlinks + delta config
  uninstall.sh                                         # Clean removal
```

## How It Works

`install.sh` symlinks everything into `~/.claude/`. Edits in either location update the same file. Hookify rules and skills take effect immediately — no restart needed.

The one manual step: plugins require `/plugin install` once per machine. The script prints the commands.

`uninstall.sh` removes symlinks and restores backups.

## Extending

**Add a hookify rule:** Create `hookify.my-rule.local.md` in this repo, commit, pull on other machines. Done.

**Add a skill:** Create `skills/my-skill/SKILL.md`, commit, pull. The install script handles the symlink.

**Change a preference:** Edit `CLAUDE.md`, commit, pull. Active immediately.
