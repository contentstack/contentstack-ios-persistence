[![Contentstack](https://www.contentstack.com/docs/static/images/contentstack.png)](https://www.contentstack.com/)

## iOS SDK for Contentstack Persistence

Contentstack is a headless CMS with an API-first approach. It is a CMS that developers can use to build powerful cross-platform applications in their favorite languages. Build your application frontend, and Contentstack will take care of the rest. [Read More](https://www.contentstack.com/).

Contentstack provides iOS Persistence SDK to build application on top of iOS. Given below is the detailed guide and helpful resources to get started with our iOS SDK.

The [Persistence Library](https://www.contentstack.com/docs/guide/synchronization/using-realm-persistence-library-with-ios-sync-sdk) lets you store data on the device’s local storage, helping you create apps that can work offline too. Perform the steps given below to use the app.

### Prerequisite

Latest Xcode and Mac OS X

### Setup and Installation

To use this SDK on iOS platform, you will have to install the SDK according to the steps given below. Current SDK support CoreData and Realm support.

If you are using CoreData as your database to store data following is way to use ContentstackPersistenceCoreData:
##### CocoaPods

1. Add the following line to your Podfile:
```
pod 'ContentstackPersistenceCoreData'
```
2. Run pod install, and you should now have the latest Contentstack release.

##### Import Header/Module

```sh
#import <ContentstackPersistenceCoreData/ContentstackPersistenceCoreData.h>;

You can also import as a Module:

//Objc

@import ContentstackPersistenceCoreData

//Swift

import ContentstackPersistenceCoreData
```

#### Initializing your SDK

To start using the SDK in your application, you will need to initialize the stack by providing the required keys and values associated with them:
```sh
//Objc
Config *config = [[Config alloc] init];
config.host = @"customcontentstack.io";
Stack *stack = [Contentstack stackWithAPIKey:<APIKey> accessToken:<AccessToken> environmentName:<EnvironmentName> config:config];
CoreDataStore *realmStore = [[CoreDataStore alloc] initWithContenxt: <NSManageObjectContext>];
SyncManager *syncManager = [[SyncManager alloc] initWithStack:stack persistance:realmStore]
[syncManager sync:{ (percentageComplete, isSyncCompleted, error) in

}];

//Swift

let config = Config()
config.host = @"customcontentstack.io";
let stack : Stack = Contentstack.stack(withAPIKey: <APIKey>, accessToken: <AccessToken>, environmentName: <EnvironmentName>, config:config)
var coreDataStore = coreDataStore(realm: <NSManageObjectContext>)
var syncManager : SyncManager = SyncManager(stack: stack, persistance: coreDataStore)
syncManager.sync({ (percentage, isSynccompleted, error) in

})
```

If you are using Realm as your database to store data following is way to use ContentstackPersistenceRealm:
##### CocoaPods

1. Add the following line to your Podfile:
```
pod 'ContentstackPersistenceRealm'
```
2. Run pod install, and you should now have the latest Contentstack release.

##### Import Header/Module
You can import header file in Objective-C project as:
```sh
#import <ContentstackPersistenceRealm/ContentstackPersistenceRealm.h>;

You can also import as a Module:

//Objc

@import ContentstackPersistenceRealm

//Swift

import ContentstackPersistenceRealm
```

#### Initializing your SDK

To start using the SDK in your application, you will need to initialize the stack by providing the required keys and values associated with them:
```sh
//Objc
Config *config = [[Config alloc] init];
config.host = @"customcontentstack.io";
Stack *stack = [Contentstack stackWithAPIKey:<APIKey> accessToken:<AccessToken> environmentName:<EnvironmentName> config:config];
RealmStore *realm = [[RealmStore alloc] initWithRealm:[[RLMRealm alloc] init]];
SyncManager *syncManager = [[SyncManager alloc] initWithStack:stack persistance:realm]
[syncManager sync:{ (percentageComplete, isSyncCompleted, error) in

}];

//Swift

let config = Config()
config.host = @"customcontentstack.io";
let stack : Stack = Contentstack.stack(withAPIKey: <APIKey>, accessToken: <AccessToken>, environmentName: <EnvironmentName>, config:config)
var realmStore = RealmStore(realm: RLMRealm())
var syncManager : SyncManager = SyncManager(stack: stack, persistance: realmStore)
syncManager.sync({ (percentage, isSynccompleted, error) in

})
```

### Helpful Links

- [Contentstack Website](https://www.contentstack.com)
- [Official Documentation](http://contentstack.com/docs)
- [Content Delivery API Docs](https://contentstack.com/docs/apis/content-delivery-api/)

