---
name: finishing-branch
enabled: true
event: bash
pattern: gh\s+pr\s+create|git\s+merge\s+(main|master)|git\s+checkout\s+(main|master)
action: warn
---

**Use the `finishing-a-development-branch` skill!**

You're about to integrate work (PR creation, merge, or switching to main).

Before proceeding, invoke the `finishing-a-development-branch` skill which will:
- Present structured options (merge, PR, or cleanup)
- Ensure all tests/verification are complete
- Guide proper branch completion workflow

Don't skip this - it prevents incomplete merges and forgotten cleanup.
