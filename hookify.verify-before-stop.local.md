---
name: verify-before-stop
enabled: true
event: stop
pattern: .*
action: warn
---

**STOP - Verify before claiming completion.**

You MUST use the `verification-before-completion` skill before stopping.

Checklist:
- [ ] Did you run the actual commands to verify your changes work?
- [ ] Did you check for regressions (import errors, syntax errors)?
- [ ] Do you have **evidence** (command output) for every success claim?

Do NOT stop until you have run verification. Evidence before assertions.
