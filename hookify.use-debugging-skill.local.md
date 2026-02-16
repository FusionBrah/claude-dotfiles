---
name: use-debugging-skill
enabled: true
event: prompt
conditions:
  - field: user_prompt
    operator: regex_match
    pattern: (?i)(bug|broken|not working|fail|error|wrong|losing money|bad trade|unexpected|crash|traceback|exception|why (is|did|does)|what went wrong|loss analysis|debug|fix this|investigate)
action: warn
---

**Systematic Debugging Required!**

The user appears to be reporting a bug, error, or unexpected behavior.

You MUST use the `systematic-debugging` skill before proposing ANY fixes.

Reminder of the Iron Law:
> NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST

Do NOT:
- Propose "quick fixes"
- Stack multiple changes at once
- Skip reproduction steps
- Guess at the cause

DO:
- Read error messages completely
- Reproduce the issue
- Check recent changes (git diff)
- Trace the data flow
- Form a single hypothesis and test minimally
