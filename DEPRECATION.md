# CocoaPods persistence modules (ContentstackPersistence, Core Data, Realm)

This notice applies to the **CocoaPods** distribution of the Contentstack **iOS Persistence** add-ons—pods such as `ContentstackPersistence`, `ContentstackPersistenceCoreData`, and `ContentstackPersistenceRealm`—that work with the **legacy Objective-C Content Delivery SDK** delivered via CocoaPods.

## Who this is for

You should read this if you integrate these persistence modules through **CocoaPods**, or if you are choosing how to add offline storage and sync-related persistence for a **new** iOS or Apple platform app.

## What we recommend for new work

For **new** applications and greenfield projects, use the **[Contentstack Swift SDK](https://github.com/contentstack/contentstack-swift)** and add it with **Swift Package Manager (SPM)**—for example via the [Swift Package Index listing](https://swiftpackageindex.com/contentstack/contentstack-swift). See the **[Swift Content Delivery API reference](https://www.contentstack.com/docs/developers/sdks/content-delivery-sdk/swift/reference)** for API details.

These CocoaPods persistence modules sit on the **legacy Objective-C CDA + CocoaPods** path. That path is **deprecated for new work**. We are **not** shipping a CocoaPods-first persistence package aligned with the Swift SDK; instead, **handle persistence with your own approach** (Core Data, Realm, or other storage) using the Swift SDK’s APIs, and follow **published product guidance** for sync and offline patterns where we provide it.

## If you already ship with these pods

**Existing** projects that already depend on these CocoaPods can **continue to use and ship** them. Deprecation here means we are **not recommending** this integration path for **new** projects—not that you must stop shipping tomorrow. Plan a **migration when it makes sense** for your product (for example, when you adopt the Swift SDK and SPM, or when you rework offline storage).

## Why we are deprecating the CocoaPods persistence path for new projects

**CocoaPods and the trunk specs workflow** are part of a broader ecosystem shift; the CocoaPods project has described changes around the [Specs repo and distribution](https://blog.cocoapods.org/CocoaPods-Specs-Repo/). Separately, Contentstack’s **product direction** for Apple platforms is the **Swift SDK** and **SPM**, which is where we focus **new** features and documentation.

Together, that means the **CocoaPods persistence modules**—as add-ons on the legacy Objective-C stack—are **not** the path we want **new** customers to adopt.

## Maintenance compared with new features

We may still provide **limited maintenance** (for example, compatibility or critical fixes) for existing CocoaPods users where feasible. **New** capabilities and improvements are expected to land in the **Swift SDK** and related **SPM**-based workflows, not in new CocoaPods-only persistence features.

## Dates and expectations

We are not publishing a single “end of life” date for these pods in this document. Treat **today** as the point from which **new** projects should **not** start on this CocoaPods persistence path; use the Swift SDK and SPM instead. Watch this repository’s **[changelog](changelog.md)**, **[README](README.md)**, and **[Docs/overview](Docs/overview.md)** for any later updates.

## Help and support

If you need help with your stack, contract, or migration planning, contact **[Contentstack support](https://www.contentstack.com/support/)**.

For the full customer-facing summary, see **[README.md](README.md)** (Important section at the top).
