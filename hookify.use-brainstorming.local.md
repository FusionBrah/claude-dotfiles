---
name: use-brainstorming
enabled: true
event: prompt
conditions:
  - field: user_prompt
    operator: regex_match
    pattern: (?i)(which (one|option|approach)|recommend|your (opinion|take|thought)|what do you (think|suggest|recommend)|pros and cons|trade.?offs?|compare .{0,30}(approach|option|method)|how should (we|i)|what('?s| is) the best (way|approach|option)|weigh .{0,20}(option|approach|choice)|help me (choose|decide|pick))
action: warn
---

**Use the `brainstorming` skill!**

The user is asking for your opinion, recommendation, or help choosing between approaches. Use the `brainstorming` skill to:

- Explore the current context and constraints
- Propose 2-3 approaches with trade-offs
- Lead with your recommendation and reasoning
- Get user alignment before jumping to implementation

Do NOT skip straight to planning or implementation. The user wants collaborative discussion first.
