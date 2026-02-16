---
name: use-writing-plans
enabled: true
event: prompt
conditions:
  - field: user_prompt
    operator: regex_match
    pattern: (?i)(write|create|draft|make|build).{0,20}(plan|spec|design|implementation plan|architecture)|plan (for|out|how)|let'?s plan
action: warn
---

**Use the `writing-plans` skill!**

The user wants a plan. Use the `writing-plans` skill to produce a structured plan with:

- Bite-sized tasks (2-5 min each)
- Exact file paths and line ranges
- Complete code in the plan (not "add validation")
- Exact commands with expected output
- Save to `docs/plans/YYYY-MM-DD-<feature-name>.md`

After the plan is written, offer execution choice (subagent-driven vs parallel session).
