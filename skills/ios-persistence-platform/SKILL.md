---
name: ios-persistence-platform
description: CocoaPods, Xcode workspace, Realm vs Core Data, and iOS deployment for this repo
---

# iOS persistence platform – Contentstack iOS Persistence

## When to use

- You change **CocoaPods** integration (`Podfile`, `Podfile.lock`, podspecs)
- You choose or explain **Realm** vs **Core Data** delivery paths
- You adjust **iOS deployment target** or linker settings (`OTHER_LDFLAGS`, etc.)

## Instructions

### CocoaPods

- **Install:** `pod install` from repo root; open **`ContentstackPersistence.xcworkspace`**.
- **Consumable pods:** `ContentstackPersistence` (core), `ContentstackPersistenceCoreData`, `ContentstackPersistenceRealm` — see [README.md](../../README.md) for `Podfile` lines.
- **Lockfile:** Commit `Podfile.lock` when dependency resolution should be reproducible for CI or the team (follow existing repo practice).

### Realm vs Core Data

- **Realm:** `ContentstackPersistenceRealm` pod; depends on **Realm** (see `ContentstackPersistenceRealm.podspec`); implementation in `ContentstackPersistenceRealm/`.
- **Core Data:** `ContentstackPersistenceCoreData` pod; no Realm dependency; implementation in `ContentstackPersistenceCoredata/`.
- **Core** pod `ContentstackPersistence` is shared; apps pick one persistence backend or structure their app module graph accordingly.

### Xcode

- **Scheme:** Use `ContentstackPersistence` for build/test of the main framework (scheme may be generated in Xcode if not checked in—create/share schemes if the team standardizes on committed schemes).
- **SDK:** `iphonesimulator` for typical local builds; device builds when validating arm64/device-only issues.

### Deployment target

- Podspecs specify **`s.ios.deployment_target = '12.0'`** — keep podspecs aligned when raising the minimum iOS version.

### Contentstack SDK

- Base dependency on **Contentstack** iOS SDK with ranges in podspecs (`~> 3.12` core / Core Data, `~> 3.6` Realm podspec for historical range—verify compatibility when bumping).

## References

- [contentstack-ios-persistence-sdk](../contentstack-ios-persistence-sdk/SKILL.md)
- [dev-workflow](../dev-workflow/SKILL.md)
- [Example app (external)](https://github.com/contentstack/contentstack-ios-persistence-example)
