---
name: require-skills-on-session-continue
enabled: true
event: prompt
conditions:
  - field: user_prompt
    operator: regex_match
    pattern: (continued from a previous conversation|continue the conversation|continue from where|last task|keep going|pick up where)
action: block
---

**Session continuation detected. Check for applicable superpowers skills BEFORE writing any code.**

Checklist:
1. **Is there a plan file?** Check `.claude/plans/` — if yes, invoke `superpowers:executing-plans`
2. **Are there pending tasks?** Check TaskList — if resuming multi-step work, invoke the relevant skill
3. **Scan for all applicable skills** — the `using-superpowers` skill requires checking even at 1% chance

Do NOT jump straight into coding. Skills determine HOW you work.
