---
name: objc-swift-ios
description: Objective-C-first layout, headers, and Swift interop for this iOS persistence repo
---

# Objective-C / Swift & repo layout – Contentstack iOS Persistence

## When to use

- You add or rename `.h` / `.m` files under `ContentstackPersistence/`, `ContentstackPersistenceCoredata/`, or `ContentstackPersistenceRealm/`
- You expose symbols to Swift consumers (`@import` / `import` patterns in README)
- You align with existing naming and module structure

## Instructions

### Language

- **Primary implementation language:** Objective-C (`.m` / `.h`).
- **Swift:** Documented in [README.md](../../README.md) via module imports; keep public APIs Objective-C–friendly (`NS_SWIFT_NAME` only if you introduce names that need Swift polish—follow existing project style).

### Layout (by folder)

| Path | Role |
| --- | --- |
| `ContentstackPersistence/` | Core framework: `SyncManager`, `PersistenceModel`, protocols, umbrella `ContentstackPersistence.h` |
| `ContentstackPersistenceCoredata/` | Core Data store implementation |
| `ContentstackPersistenceRealm/` | Realm store implementation |
| `ContentstackPersistenceTests/` | XCTest sources |

### Headers and modules

- Public API is driven by **`s.public_header_files`** in each podspec—new public headers must be listed there.
- Keep umbrella / main header includes predictable; consumers may use `#import <Module/Module.h>` or `@import Module`.

### Naming and style

- Match existing patterns: Objective-C naming, file names aligned with class names (e.g. `SyncManager.h` / `SyncManager.m`).
- Avoid drive-by reformatting unrelated code in the same change as feature work.

## References

- [contentstack-ios-persistence-sdk](../contentstack-ios-persistence-sdk/SKILL.md)
- [testing](../testing/SKILL.md)
