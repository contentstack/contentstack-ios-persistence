//
//  SyncManager.h
//  ContentstackPersistence
//
//  Created by Uttam Ukkoji on 06/07/18.
//  Copyright © 2018 Contentstack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Contentstack/Contentstack.h>
#import "SyncProtocol.h"
#import "SyncPersistable.h"
#import "PersistenceModel.h"

@interface SyncManageSwiftSupport  : NSObject

/**
 Class method returns true if className is Swift class.

 @param className Class Name
 @return returns true if className is Swift class.
 */
+ (BOOL)isSwiftClassName:(NSString *_Nonnull)className;

/**
 Class method returns class Simple class name from Swift Class name

 @param className Class name
 @return Simple class name from Swift Class name
 */
+ (NSString *_Nonnull)demangleClassName:(NSString *_Nonnull)className;
@end

@interface SyncManager : NSObject

/**
 Create SyncManager instance from Stack and PersistanceDelegate
     //Obj-C
     Config *config = [[Config alloc] init];
     config.host = @"customcontentstack.io";
     Stack *stack = [Contentstack stackWithAPIKey:<APIKey> accessToken:<AccessToken> environmentName:<EnvironmentName> config:config];

     //Swift
     let config = Config()
     config.host = @"customcontentstack.io";
     let stack : Stack = Contentstack.stack(withAPIKey: <APIKey>, accessToken: <AccessToken>, environmentName: <EnvironmentName>, config:config)
     let syncManager : SyncManager = SyncManager(stack: stack, persistance: persistenceObject)


 @param stack instance of Stack
 @param delegate instance of PersistanceDelegate
 @return instance of SyncManager
 */
-(instancetype _Nonnull )initWithStack:(Stack*_Nonnull)stack persistance:(id<PersistanceDelegate> _Nonnull)delegate;

/**
 Create SyncManager instance from Stack and PersistanceDelegate
     //Obj-C
     Config *config = [[Config alloc] init];
     config.host = @"customcontentstack.io";
     Stack *stack = [Contentstack stackWithAPIKey:<APIKey> accessToken:<AccessToken> environmentName:<EnvironmentName> config:config];
        
     //Swift
     let config = Config()
     config.host = @"customcontentstack.io";
     let stack : Stack = Contentstack.stack(withAPIKey: <APIKey>, accessToken: <AccessToken>, environmentName: <EnvironmentName>, config:config)
     let PersistenceModel = PersistenceModel(syncStack: SyncStore.self, asset: Assets.self, entries: [Product.self])
     let syncManager : SyncManager = SyncManager(stack: stack, persistance: persistenceObject, PersistenceModel: PersistenceModel)


 @param stack instance of Stack
 @param delegate instance of PersistanceDelegate
 @return instance of SyncManager
 */
-(instancetype _Nonnull)initWithStack:(Stack *_Nonnull)stack persistance:(id<PersistanceDelegate>_Nonnull)delegate PersistenceModels: (PersistenceModel*_Nonnull) PersistenceModel;
/**
 Initiate Synchronization from SyncManager provide percentage of sync and provide true once completed with synchronization
     //Obj-C
     Config *config = [[Config alloc] init];
     config.host = @"customcontentstack.io";
     Stack *stack = [Contentstack stackWithAPIKey:<APIKey> accessToken:<AccessToken> environmentName:<EnvironmentName> config:config];
     SyncManager *syncManager = [[SyncManager alloc] initWithStack:stack persistance:persistenceObject]
     [syncManager sync:{ (percentageComplete, isSyncCompleted, error) in
    
     }];
 
     //Swift
     let config = Config()
     config.host = @"customcontentstack.io";
     let stack : Stack = Contentstack.stack(withAPIKey: <APIKey>, accessToken: <AccessToken>, environmentName: <EnvironmentName>, config:config)
     let syncManager : SyncManager = SyncManager(stack: stack, persistance: persistenceObject)
     syncManager.sync { (percentageComplete, isSyncCompleted, error) in
 
     }
 
 @param completion completion block  provide percentage of sync and provide true once completed with synchronization
 */
-(void)sync:(void (^_Nullable) (double percentageComplete, BOOL isSyncCompleted, NSError  * BUILT_NULLABLE_P error))completion;
@end




