//
//  SyncRealm.h
//  ContentstackPersistence
//
//  Created by Uttam Ukkoji on 30/07/18.
//  Copyright © 2018 Contentstack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ContentstackPersistence/SyncPersistable.h>
#import <Realm/Realm.h>
@interface RealmStore : NSObject <PersistanceDelegate>
/**
 Create new RealmStore with RLMRealm instance
 
    //Obj-C
    RLMRealm *realm = [RLMRealm defaultRealm];
    RealmStore *realmStore = [[RealmStore alloc] initWithRealm: realm];
 
    //Swift
    let realm = try! Realm()
    let realmStore = RealmStore(realm: realm)
 
 @param realm instance of RLMRealm
 @return new Instance of RealmStore
 */
-(instancetype)initWithRealm:(RLMRealm*)realm;
@end

