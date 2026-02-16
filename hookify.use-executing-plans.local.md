---
name: use-executing-plans
enabled: true
event: prompt
conditions:
  - field: user_prompt
    operator: regex_match
    pattern: (?i)(execute|implement|start|go ahead|do it|proceed|run|carry out|follow).{0,30}(plan|steps|tasks|implementation|spec|design)
action: warn
---

**Use the `executing-plans` skill!**

The user wants you to execute a plan. You MUST use the `executing-plans` skill which enforces:

1. **Load and review** the plan critically first
2. **Execute in batches of 3 tasks** - not all at once
3. **Report and wait for feedback** between batches
4. **Stop immediately** if blocked - don't guess

Do NOT barrel through all tasks without checkpoints.
