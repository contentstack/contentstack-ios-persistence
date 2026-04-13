# Contentstack iOS Persistence – Agent guide

*Universal entry point* for contributors and AI agents. Detailed conventions live in **skills/*/SKILL.md**.

## What this repo is

| Field | Detail |
| --- | --- |
| *Name:* | https://github.com/contentstack/contentstack-ios-persistence |
| *Purpose:* | iOS library that persists Contentstack sync data locally so apps can work offline. Ships a shared core plus Core Data and Realm adapters consumed via CocoaPods. |
| *Out of scope (if any):* | Not a standalone HTTP client; network and sync protocol come from the **Contentstack** iOS SDK dependency. Does not ship the example app (see [contentstack-ios-persistence-example](https://github.com/contentstack/contentstack-ios-persistence-example)). |

## Tech stack (at a glance)

| Area | Details |
| --- | --- |
| Language | Objective-C (primary); Swift-compatible module imports documented in README. iOS deployment target **12.0** (see podspecs). |
| Build | **Xcode** workspace `ContentstackPersistence.xcworkspace`; **CocoaPods** (`Podfile`, `pod install`). Key sources: `ContentstackPersistence/`, `ContentstackPersistenceCoredata/`, `ContentstackPersistenceRealm/`. Podspecs: `ContentstackPersistence.podspec`, `ContentstackPersistenceCoreData.podspec`, `ContentstackPersistenceRealm.podspec`. |
| Tests | **XCTest** target `ContentstackPersistenceTests`; tests under `ContentstackPersistenceTests/`. |
| Lint / coverage | No SwiftLint / shared coverage config in-repo; follow team standards if added later. |
| Other | Dependencies: **Contentstack** iOS SDK, **Realm** (Realm subspec). Optional persistence: Core Data vs Realm via separate pods. |

## Commands (quick reference)

| Command Type | Command |
| --- | --- |
| Build | `pod install` then `xcodebuild -workspace ContentstackPersistence.xcworkspace -scheme ContentstackPersistence -sdk iphonesimulator build` |
| Test | `xcodebuild -workspace ContentstackPersistence.xcworkspace -scheme ContentstackPersistence -destination 'platform=iOS Simulator,name=iPhone 16' test` (adjust simulator name to one installed locally) |
| Lint | *(none configured)* |

**CI:** PR checks include branch policy (`.github/workflows/check-branch.yml`), Snyk SCA (`.github/workflows/sca-scan.yml`), and policy scans (`.github/workflows/policy-scan.yml`). Jira linkage: `.github/workflows/issues-jira.yml`.

## Where the documentation lives: skills

| Skill | Path | What it covers |
| --- | --- | --- |
| Dev workflow & CI | [skills/dev-workflow/SKILL.md](skills/dev-workflow/SKILL.md) | Branches, build/test, PR expectations, CI overview |
| SDK & public API | [skills/contentstack-ios-persistence-sdk/SKILL.md](skills/contentstack-ios-persistence-sdk/SKILL.md) | Entry points, pods, sync/persistence boundaries, versioning |
| Objective-C / Swift & layout | [skills/objc-swift-ios/SKILL.md](skills/objc-swift-ios/SKILL.md) | Language conventions and repository layout |
| Testing | [skills/testing/SKILL.md](skills/testing/SKILL.md) | XCTest layout, naming, fixtures, secrets |
| Code review | [skills/code-review/SKILL.md](skills/code-review/SKILL.md) | PR checklist for this repo |
| iOS platform & packaging | [skills/ios-persistence-platform/SKILL.md](skills/ios-persistence-platform/SKILL.md) | CocoaPods, Core Data, Realm, Xcode workspace |

An index with “when to use” hints is in [skills/README.md](skills/README.md).

## Using Cursor (optional)

If you use *Cursor*, [.cursor/rules/README.md](.cursor/rules/README.md) only points to *AGENTS.md*—same docs as everyone else.
