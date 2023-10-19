[![Contentstack](https://www.contentstack.com/docs/static/images/contentstack.png)](https://www.contentstack.com/)

# Contentstack iOS Persistence Library

Contentstack provides [iOS Persistence Library](https://www.contentstack.com/docs/guide/synchronization/using-realm-persistence-library-with-ios-sync-sdk) that lets your application store data on the device's local storage. This helps you build apps that can work offline too. Given below is a detailed guide and helpful resources to get started with our iOS Persistence Library.

## Prerequisites

- Latest Xcode and Mac OS X

## Setup and Initialize library

You can use the iOS Persistence Library with CoreData and Realm databases.  Let's understand how to set these up for your project.

### For CoreData
To set up this library for CoreData, follow the steps given below.

#### Setup using CocoaPods
1. Add the following line to your Podfile:
```
pod 'ContentstackPersistenceCoreData'
```
2. Run pod install, and you should now have the latest version of the library.

#### Import header/module

```sh
#import <ContentstackPersistenceCoreData/ContentstackPersistenceCoreData.h>;
```
You can also import as a Module:

- Objective-C
    ```
    @import ContentstackPersistenceCoreData
    ```
- Swift
    ```
    import ContentstackPersistenceCoreData
    ```

#### Initialize the library
##### Initialize with Stack details and CoreDataStore
To start using the library in your application, you will need to initialize it by providing your stack details:
- Objective-C
    ```sh
    Config *config = [[Config alloc] init];
    config.host = @"customcontentstack.io";
    Stack *stack = [Contentstack stackWithAPIKey:<APIKey> accessToken:<AccessToken> environmentName:<EnvironmentName> config:config];
    CoreDataStore *coreDataStore = [[CoreDataStore alloc] initWithContenxt: <NSManageObjectContext>];
    SyncManager *syncManager = [[SyncManager alloc] initWithStack:stack persistance:coreDataStore]
    [syncManager sync:{ (percentageComplete, isSyncCompleted, error) in

    }];

- Swift
  ```
  let config = Config()
  config.host = @"customcontentstack.io";
  let stack : Stack = Contentstack.stack(withAPIKey: <APIKey>, accessToken: <AccessToken>, environmentName: <EnvironmentName>, config:config)
  var coreDataStore = CoreDataStore(contenxt: <NSManageObjectContext>)
  var syncManager : SyncManager = SyncManager(stack: stack, persistance: coreDataStore)
  syncManager.sync({ (percentage, isSynccompleted, error) in

  })
  ```
##### Initialize with Stack details, CoreDataStore and PersistenceModel

- Objective-C
    ```sh
    Config *config = [[Config alloc] init];
    config.host = @"customcontentstack.io";
    Stack *stack = [Contentstack stackWithAPIKey:<APIKey> accessToken:<AccessToken> environmentName:<EnvironmentName> config:config];
    CoreDataStore *coreDataStore = [[CoreDataStore alloc] initWithContenxt: <NSManageObjectContext>];
    PersistenceModel * persistenceModel = [[PersistenceModel alloc] initWithSyncStack: SyncStore asset: AssetStore entries: [Session, Product]]
    SyncManager *syncManager = [[SyncManager alloc] initWithStack: stack persistance: coreDataStore persistenceModel: persistenceModel]
    [syncManager sync:{ (percentageComplete, isSyncCompleted, error) in

    }];

- Swift
  ```
  let config = Config()
  config.host = @"customcontentstack.io";
  let stack : Stack = Contentstack.stack(withAPIKey: <APIKey>, accessToken: <AccessToken>, environmentName: <EnvironmentName>, config:config)
  var coreDataStore = CoreDataStore(contenxt: <NSManageObjectContext>)
  var persistenceModel = PersistenceModel(syncStack: SyncStore.self, asset: Assets.self, entries: [Product.self])
  var syncManager : SyncManager = SyncManager(stack: stack, persistance: coreDataStore, persistenceModel: persistenceModel)
  syncManager.sync({ (percentage, isSynccompleted, error) in

  })
  ```

### For Realm
To set up this library for Realm, follow the steps given below.

#### Setup using CocoaPods

1. Add the following line to your Podfile:
```
pod 'ContentstackPersistenceRealm'
```
2. Run pod install, and you should now have the latest version of the library.

#### Import header/module
You can import header file in Objective-C project as:
```sh
#import <ContentstackPersistenceRealm/ContentstackPersistenceRealm.h>;
```
You can also import as a Module:
- Objective-C
  ```
  @import ContentstackPersistenceRealm
  ```
- Swift
  ```
  import ContentstackPersistenceRealm
  ```

#### Initialize the library

To start using the library in your application, you will need to initialize it by providing the stack details:
- Objective- C
  ```sh
  Config *config = [[Config alloc] init];
  config.host = @"customcontentstack.io";
  Stack *stack = [Contentstack stackWithAPIKey:<APIKey> accessToken:<AccessToken> environmentName:<EnvironmentName> config:config];
  RealmStore *realmStore = [[RealmStore alloc] initWithRealm:[[RLMRealm alloc] init]];
  SyncManager *syncManager = [[SyncManager alloc] initWithStack:stack persistance:realmStore]
  [syncManager sync:{ (percentageComplete, isSyncCompleted, error) in

  }];
  ```
- Swift
  ```
  let config = Config()
  config.host = @"customcontentstack.io";
  let stack : Stack = Contentstack.stack(withAPIKey: <APIKey>, accessToken: <AccessToken>, environmentName: <EnvironmentName>, config:config)
  var realmStore = RealmStore(realm: RLMRealm())
  var syncManager : SyncManager = SyncManager(stack: stack, persistance: realmStore)
  syncManager.sync({ (percentage, isSynccompleted, error) in

  })
  ```
We have created an example app using iOS Persistence Library that stores data on the device's local storage. [Read the tutorial](https://github.com/contentstack/contentstack-ios-persistence-example) to get started with the example app.

### Helpful Links

- [iOS Persistence Library Docs](https://www.contentstack.com/docs/guide/synchronization/using-realm-persistence-library-with-ios-sync-sdk)
- [iOS Persistence Example App](https://github.com/contentstack/contentstack-ios-persistence-example)
- [Content Delivery API Docs](https://contentstack.com/docs/apis/content-delivery-api/)

