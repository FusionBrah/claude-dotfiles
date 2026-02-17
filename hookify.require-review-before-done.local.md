---
name: require-review-before-done
enabled: true
event: stop
pattern: .*
action: block
---

**Before finishing, check if a code review is needed.**

If this session involved:
- Multi-file code changes → invoke `superpowers:requesting-code-review`
- Completing a plan → verify all plan requirements against the checklist
- A development branch → invoke `superpowers:finishing-a-development-branch`

Do NOT stop without reviewing significant work against the original plan/requirements.
