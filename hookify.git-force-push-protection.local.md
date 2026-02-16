---
name: git-force-push-protection
enabled: true
event: bash
pattern: git\s+push\s+.*(-f|--force)
action: block
---

**BLOCKED: Force push detected!**

Force pushing is extremely dangerous and can destroy remote history.

If you genuinely need to force push:
1. Confirm with the user first
2. Never force push to `main` or `master`
3. Ensure no other sessions depend on the current remote state
