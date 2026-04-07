---
name: dev-workflow
description: Branch policy, CI, and local build/test commands for contentstack-ios-persistence
---

# Dev workflow – Contentstack iOS Persistence

## When to use

- You are opening a PR, choosing a base branch, or interpreting CI failures
- You need the canonical `pod install` / `xcodebuild` commands for this repo
- You want release or versioning expectations (podspecs, tags)

## Instructions

### Branches and PRs

- **Default branch workflow:** `.github/workflows/check-branch.yml` blocks merging into `master` unless the PR branch is `next`. For changes targeting `master`, open PRs **from** `next` as described in that workflow’s message.
- Use **CODEOWNERS** for required reviewers when present.

### Local development

1. Install pods: `pod install` from the repo root (generates/updates `Pods/` and integrates with the workspace).
2. Open **`ContentstackPersistence.xcworkspace`** (not the `.xcodeproj` alone) when working with CocoaPods.

### Build and test

- **Build:** `xcodebuild -workspace ContentstackPersistence.xcworkspace -scheme ContentstackPersistence -sdk iphonesimulator build`
- **Test:** `xcodebuild -workspace ContentstackPersistence.xcworkspace -scheme ContentstackPersistence -destination 'platform=iOS Simulator,name=iPhone 16' test` — pick a simulator that exists on your Mac.

### CI (GitHub Actions)

- **Branch check:** `.github/workflows/check-branch.yml` — PRs to `master` from branches other than `next` fail by policy.
- **SCA:** `.github/workflows/sca-scan.yml` — Snyk `snyk test` on PRs (requires `SNYK_TOKEN` in org secrets).
- **Policy:** `.github/workflows/policy-scan.yml` — public repos: `SECURITY.md` and license file with current year.
- **Issues:** `.github/workflows/issues-jira.yml` — Jira integration for issues.

### Versioning and release hints

- Three podspecs at repo root must stay aligned when you bump versions: `ContentstackPersistence.podspec`, `ContentstackPersistenceCoreData.podspec`, `ContentstackPersistenceRealm.podspec` (see `s.version` and `s.source` tag).
- **Talisman:** `.talismanrc` may apply to pre-commit secret scanning; do not commit API keys or tokens.

## References

- [AGENTS.md](../../AGENTS.md)
- [contentstack-ios-persistence-sdk](../contentstack-ios-persistence-sdk/SKILL.md)
- [testing](../testing/SKILL.md)
- [ios-persistence-platform](../ios-persistence-platform/SKILL.md)
