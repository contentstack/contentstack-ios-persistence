---
name: testing
description: XCTest layout, simulator runs, and secrets policy for ContentstackPersistenceTests
---

# Testing – Contentstack iOS Persistence

## When to use

- You add or change tests under `ContentstackPersistenceTests/`
- You run tests locally or debug CI test failures
- You need guidance on credentials and fixtures

## Instructions

### Runner and location

- **Framework:** XCTest (`ContentstackPersistenceTests.m` and future `*Tests.m` files).
- **Target:** `ContentstackPersistenceTests` (xctest bundle `ContentstackPersistenceTests.xctest`).
- **Run:** After `pod install`, use `xcodebuild` with scheme `ContentstackPersistence` and action `test`, with an iOS Simulator destination (see [AGENTS.md](../../AGENTS.md)).

### Naming and structure

- Test class inherits from `XCTestCase`; methods follow `- (void)test*` naming.
- Prefer descriptive test names that state what is being verified (replace placeholder `testExample` when adding real coverage).

### Credentials and data

- **Do not** commit API keys, delivery tokens, or stack secrets to tests or repo files.
- Prefer mocks, dependency injection at the store/sync boundaries, or local fixtures checked in without secrets.
- If integration tests against a real stack are ever added, isolate them behind explicit schemes or skipped-by-default targets and load credentials from the environment or ignored local config—not from git.

### Coverage

- No shared coverage gate is defined in-repo; if the team adds Xcode coverage or a script, document the command in [dev-workflow](../dev-workflow/SKILL.md) and [AGENTS.md](../../AGENTS.md).

## References

- [dev-workflow](../dev-workflow/SKILL.md)
- [contentstack-ios-persistence-sdk](../contentstack-ios-persistence-sdk/SKILL.md)
