---
name: generate-contributor-guide
description: >
  This skill should be used when the user asks to "generate a contributor guide",
  "analyze this codebase", "create a contributor reference", "understand the codebase patterns",
  "help me contribute to this repo", "what patterns does this codebase use",
  "create an onboarding guide", or wants to understand how internal developers have
  structured a project before contributing. Also trigger when user mentions
  "contributor guide", "codebase conventions", or "match internal patterns".
---

# Generate Contributor Guide

Analyze any codebase to produce a `.claude/contributor-guide.md` that documents
the patterns, conventions, and expectations of the project's internal developers.
The goal is to help an external contributor submit PRs that match how the
internal team actually writes code, not just what the README says.

## When to Use

- Before starting work on an unfamiliar open-source codebase
- When past PRs have been rejected for not matching project conventions
- When onboarding to a new project as an external contributor
- To refresh understanding after a codebase has evolved

## Process

### Phase 1: Detect Stack and Read Existing Docs

1. Identify the tech stack by examining the project root for language/framework markers
   (package.json, Gemfile, go.mod, pyproject.toml, Cargo.toml, pom.xml, etc.)
2. Read all existing documentation that governs contributions:
   - `CLAUDE.md`, `.claude/CLAUDE.md`
   - `CONTRIBUTING.md`, `.github/CONTRIBUTING.md`
   - `README.md` (development/contributing sections)
   - `.github/PULL_REQUEST_TEMPLATE.md`
   - `.github/ISSUE_TEMPLATE/`
   - Code style configs (`.eslintrc`, `.rubocop.yml`, `ruff.toml`, `.prettierrc`, etc.)
3. Read recent git history (last 40-80 commits) to understand:
   - Commit message conventions
   - PR size patterns
   - Common prefixes/tags

### Phase 2: Analyze Code Patterns (Parallel Agents)

Read `references/analysis-checklist.md` for the detected stack to determine
which layers exist and what to look for in each. Then use the Task tool to
launch parallel Explore subagents -- one per architectural layer. Each agent
should examine 4-8 representative files and report back concrete patterns
with code examples.

**How to structure the agents:**

Spawn all agents in a single message so they run concurrently. Each agent
gets a focused prompt following this template:

```
Analyze the [LAYER] patterns in [PROJECT_PATH]. Examine 4-8 representative
files and report concrete conventions for each item below. Include short
code examples from the actual codebase. This is research only -- do not
edit anything.

[PASTE RELEVANT CHECKLIST ITEMS FROM references/analysis-checklist.md]
```

**Which agents to spawn depends on the detected stack:**

For a full-stack web app (e.g., Rails + React, Django + Vue, Laravel + React):
1. **Models/Entities agent** -- Data layer patterns, associations, validations, callbacks, soft deletes, enums
2. **Controllers/Handlers agent** -- Auth, params, rendering, error handling, pagination
3. **Services and Jobs agent** -- Service structure, return values, job queues, retries, error handling, presenters/serializers, policies
4. **Tests agent** -- Test framework, naming, data setup, factories, assertion style, mocking, shared examples
5. **Frontend agent** -- Components, state management, styling, type patterns, forms, data fetching, file organization

For a backend-only app (API, CLI, library):
1. **Models/Data Layer agent** -- Entity patterns, ORM conventions, migrations, constraints
2. **API/Handler Layer agent** -- Routing, auth, validation, response formats, error handling
3. **Services and Background Processing agent** -- Business logic layer, job patterns, error handling
4. **Tests agent** -- Framework, naming, data setup, assertion style, mocking, integration tests

For a frontend-only app (SPA, component library):
1. **Components and Architecture agent** -- Component patterns, file naming, composition, directory structure
2. **State and Data agent** -- State management, data fetching, form handling, type patterns
3. **Styling and Build agent** -- CSS methodology, design tokens, build config, linting
4. **Tests agent** -- Framework, component testing, mocking, fixture patterns

For a systems/library project (Go, Rust, C):
1. **Architecture and Patterns agent** -- Module structure, interface/trait design, error handling, concurrency
2. **API Surface agent** -- Public API conventions, documentation patterns, builder patterns
3. **Tests agent** -- Test organization, table-driven tests, benchmarks, integration tests

Adapt these groupings based on what actually exists in the codebase. If a
layer has very few files (e.g., only 2 controllers), merge it into an
adjacent agent rather than spawning a dedicated one. If the codebase has a
layer not listed here (e.g., GraphQL resolvers, gRPC services, CLI commands),
add an agent for it.

Each agent prompt must include the specific checklist items from
`references/analysis-checklist.md` relevant to that layer -- do not send
generic instructions. The checklist items tell the agent exactly what
patterns to look for.

### Phase 3: Generate the Guide

Write `.claude/contributor-guide.md` with the following structure. Adapt
sections to the detected stack - omit sections that don't apply, add
stack-specific sections as needed.

```markdown
# [Project Name] Contributor Guide (External Dev Reference)

Personal reference for contributing in a way that matches internal
developer patterns. Supplements the repo's official documentation.

## What Maintainers Care About Most
[Top 5-8 things, derived from CONTRIBUTING.md, PR template, and observed patterns]

## Terminology
[Project-specific naming conventions, legacy vs preferred terms]

## [Stack-Specific Pattern Sections]
[Concrete patterns with short code examples from the actual codebase.
Group by architectural layer. Show "Good" vs "Bad" where conventions
are non-obvious.]

## Testing Patterns
[How tests are structured, assertion style, data setup, naming]

## PR Checklist (Before Submitting)
[Actionable checklist combining official requirements and observed norms]
```

### Key Principles for the Generated Guide

- **Show concrete examples from the actual codebase**, not generic advice
- **Prioritize patterns that differ from common defaults** - these are what trip up external contributors
- **Include "Good vs Bad" examples** for non-obvious conventions
- **Keep it actionable** - every section should change how someone writes code
- **Don't duplicate CONTRIBUTING.md** - reference it, then add the patterns it doesn't cover
- **Flag terminology traps** (e.g., "product" not "link", "buyer" not "customer")

## Output

The guide is written to `.claude/contributor-guide.md` in the project root.
This location is gitignored by default and serves as a personal reference
that Claude Code loads automatically when working in the project.

Inform the user of the file location and suggest they review it before
starting work on the codebase.
