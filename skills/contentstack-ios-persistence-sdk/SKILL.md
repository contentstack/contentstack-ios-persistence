---
name: contentstack-ios-persistence-sdk
description: Public API, SyncManager, Core Data and Realm stores, pod boundaries for iOS persistence
---

# Contentstack iOS Persistence SDK – Contentstack iOS Persistence

## When to use

- You change **`SyncManager`**, **`PersistenceModel`**, **`SyncPersistable`**, **`SyncProtocol`**, or store implementations
- You edit **podspecs** or dependency ranges (`Contentstack`, `Realm`)
- You need to explain how this library relates to the **Contentstack** iOS SDK and sync

## Instructions

### What this library owns

- **Core framework** (`ContentstackPersistence/`): shared types and **`SyncManager`** orchestration; depends on **Contentstack** for stack/sync, not on Realm/Core Data directly in the base podspec.
- **Core Data path** (`ContentstackPersistenceCoredata/` + `ContentstackPersistenceCoreData.podspec`): **`CoreDataStore`** and Core Data–backed persistence.
- **Realm path** (`ContentstackPersistenceRealm/` + `ContentstackPersistenceRealm.podspec`): **`RealmStore`** and Realm-backed persistence; adds an explicit **Realm** dependency range in the podspec.

### Public surface

- Umbrella / public headers are declared per podspec (`s.public_header_files`); keep Objective-C headers stable for binary compatibility expectations in downstream apps.
- **`SyncManager`** is the main integration point: constructed with a **Stack** (from Contentstack SDK) and a store conforming to the persistence abstraction (`CoreDataStore`, `RealmStore`, etc.).
- **`PersistenceModel`** maps sync stack, assets, and entry types when customizing what gets persisted.

### Boundaries

- **In scope:** Local persistence adapters, sync callback handling, model mapping for offline storage.
- **Out of scope:** Implementing REST/CDA calls here—that lives in **Contentstack**; this repo consumes **Stack** and sync flows from that SDK.

### Versioning

- Bump **`s.version`** consistently across podspecs when releasing; **`s.source`** `:tag` should match your git tagging convention (e.g. `v0.1.1`).
- Subspecs depend on **`ContentstackPersistence`** with a matching semver range—keep those constraints coherent when you change the core.

## References

- [README.md](../../README.md) — integration examples (Objective-C and Swift)
- [objc-swift-ios](../objc-swift-ios/SKILL.md)
- [ios-persistence-platform](../ios-persistence-platform/SKILL.md)
- [Contentstack iOS Persistence docs](https://www.contentstack.com/docs/guide/synchronization/using-realm-persistence-library-with-ios-sync-sdk)
- [Content Delivery API](https://www.contentstack.com/docs/apis/content-delivery-api/)
