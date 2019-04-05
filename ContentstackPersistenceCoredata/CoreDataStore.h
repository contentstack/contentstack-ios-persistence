//
//  SyncCoreData.h
//  ContentstackPersistence
//
//  Created by Uttam Ukkoji on 30/07/18.
//  Copyright © 2018 Contentstack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ContentstackPersistence/SyncPersistable.h>
#import <CoreData/CoreData.h>

@interface CoreDataStore : NSObject <PersistanceDelegate>

/**
 Create new CoreDataStore with NSManageObjecContext

    //Obj-C
    CoreDataStore *coreDataStore = [[CoreDataStore alloc] initWithContenxt:managedObjectContext];
 
    //Swift
    let coreDataStore = CoreDataStore(context: managedObjectContext)
 @param context instance of NSManageObjecContext
 @return new Instance of CoreDataStore
 */
-(instancetype) initWithContext:(NSManagedObjectContext*) context;

@end
