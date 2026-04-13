---
name: code-review
description: PR checklist and severity guidance for contentstack-ios-persistence changes
---

# Code review – Contentstack iOS Persistence

## When to use

- You are reviewing a PR or preparing one for this repository
- You need a consistent checklist aligned with CI and product boundaries

## Instructions

### Before you approve

- **Branch policy:** Confirm the PR meets `.github/workflows/check-branch.yml` expectations (merges to `master` from `next` where required).
- **Build:** Workspace builds after `pod install`; all three podspec-relevant targets remain consistent if core APIs changed.
- **Tests:** New behavior has XCTest coverage where practical; no committed secrets.
- **Pods:** `Podfile` / `Podfile.lock` changes are intentional; dependency ranges in podspecs match release intent.
- **Docs:** User-visible API or setup changes update [README.md](../../README.md) or product docs links as needed.
- **Security / compliance:** No credentials in code; Talisman-sensitive files respected.

### Optional severity (for discussion)

| Level | Examples |
| --- | --- |
| **Blocker** | Breaks consumers’ public API without semver major plan; security issue; build broken |
| **Major** | Missing tests for risky logic; incorrect podspec dependency; sync/data loss risk |
| **Minor** | Style nits, non-user-facing refactors, doc typos |

### CODEOWNERS

- Follow [CODEOWNERS](../../CODEOWNERS) for required reviewers.

## References

- [dev-workflow](../dev-workflow/SKILL.md)
- [testing](../testing/SKILL.md)
- [contentstack-ios-persistence-sdk](../contentstack-ios-persistence-sdk/SKILL.md)
