//
//  SyncManager.m
//  ContentstackPersistence
//
//  Created by Uttam Ukkoji on 06/07/18.
//  Copyright © 2018 Contentstack. All rights reserved.
//

#import "SyncManager.h"
#import "SyncProtocol.h"
#import "PersistenceModel.h"
#import <CoreData/CoreData.h>
#import <objc/runtime.h>
#import "CSIOInternalHeaders.h"
#import "BSONOIDGenerator.h"

@implementation SyncManageSwiftSupport
+ (BOOL)isSwiftClassName:(NSString *)className {
    return [className rangeOfString:@"."].location != NSNotFound;
}

+ (NSString *)demangleClassName:(NSString *)className {
    return [className substringFromIndex:[className rangeOfString:@"."].location + 1];
}
@end

@interface SyncManager ()
@property (nonatomic, retain) Stack * stack;
@property (nonatomic) double percentageComplete;
@property (nonatomic, copy) NSArray * entry;
@property (nonatomic, copy) Class asset;
@property (nonatomic, copy) Class syncStack;
@property (nonatomic, weak) id<PersistanceDelegate> persistanceDelegate;
@end
@implementation SyncManager

-(instancetype)initWithStack:(Stack *)stack persistance:(id<PersistanceDelegate>)delegate
{
    self = [super init];
    if (self) {
        _stack = stack;
        _persistanceDelegate = delegate;
        Class superClass = [_persistanceDelegate getSuperClass];
        _entry = classConformsProtocol(@protocol(EntryProtocol), superClass);
        NSArray *assets = classConformsProtocol(@protocol(AssetProtocol), superClass);
        if (assets.count > 0) {
            _asset = assets.firstObject;
        }
        NSArray *stack = classConformsProtocol(@protocol(SyncStoreProtocol), superClass);
        
        if (stack.count > 0) {
            _syncStack = stack.firstObject;
        }else {
            @throw [NSException exceptionWithName:@"SyncStoreProtocol should be define." reason:nil userInfo:nil];
        }
    }
    return self;
}

-(instancetype)initWithStack:(Stack *)stack persistance:(id<PersistanceDelegate>)delegate PersistenceModels: (PersistenceModel*) PersistenceModel
{
    self = [super init];
    if (self) {
        _stack = stack;
        _persistanceDelegate = delegate;
        _entry = PersistenceModel.entries;
        _asset = PersistenceModel.asset;
        _syncStack = PersistenceModel.syncStack;
    }
    return self;
}

-(NSDate*)getDateFrom:(NSString*)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    return [formatter dateFromString:dateString];
}

-(NSString*) getPaginationToken {
    __block NSString *paginationToken ;
    [self.persistanceDelegate performBlockAndWait:^{
        id<SyncStoreProtocol> syncStack  = [self findOrCreate:self->_syncStack predicate:nil];
        paginationToken = syncStack.paginationToken;
    }];
    return paginationToken;
}

-(NSString*) getSyncToken {
    __block NSString* syncToken ;
    [self.persistanceDelegate performBlockAndWait:^{
        id<SyncStoreProtocol> syncStack = [self findOrCreate:self->_syncStack predicate:nil];
        syncToken = syncStack.syncToken;
    }];
    return syncToken;
}

-(NSString*) getSeqId {
    __block NSString *seqId;
    [self.persistanceDelegate performBlockAndWait:^{
        id<SyncStoreProtocol> syncStack  = [self findOrCreate:self->_syncStack predicate:nil];
        seqId = syncStack.seqId;
    }];
    return seqId;
}

-(void)updateSyncStack:(SyncStack*)syncStack {
    id<SyncStoreProtocol> syncStore = (id<SyncStoreProtocol>)[self findOrCreate:_syncStack predicate:nil];
    syncStore.syncToken = syncStack.syncToken;
    syncStore.paginationToken = syncStack.paginationToken;
    syncStore.seqId = syncStack.seqId;
}

/* The following method will be deprecated soon */
-(void)syncWithInit:(BOOL) shouldInit syncToken:(NSString *)syncToken onCompletion:(void (^)(double, BOOL, NSError * _Nullable))completion {
    __weak typeof (self) weakSelf = self;
    NSString *paginationToken = [self getPaginationToken];

    id completionBlock = ^(SyncStack * _Nullable syncStack, NSError * _Nullable error) {
        if (error != nil) {
            //Init the sync API on pagination and sync token errors
            if (error.code == 422) {
                if (error.userInfo && error.userInfo[@"errors"]) {
                    NSDictionary *errors = error.userInfo[@"errors"];
                    if (errors[@"pagination_token"] || errors[@"sync_token"]) {
                        [weakSelf syncWithInit:true syncToken:nil onCompletion:completion];
                        return;
                    }
                }
            }
            completion(self.percentageComplete, false, error);
        } else {
            __block BOOL isSyncCompleted = false;
            [self.persistanceDelegate performBlockAndWait:^{
                
                if (syncStack.items) {
                    self.percentageComplete = ((double)(syncStack.skip) + (double)syncStack.items.count) / (double)syncStack.totalCount;
                }
                
                //entry_unpublished || entry_deleted
                NSArray *deletedEntryArray = [syncStack.items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type = 'entry_unpublished' || type = 'entry_deleted' "]];
                [self deleteEntries:deletedEntryArray];
                
                //asset_unpublished || asset_deleted
                if (self->_asset != nil) {
                    NSArray *deletedAssetsArray = [syncStack.items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type = 'asset_unpublished' || type = 'asset_deleted'"]];
                    [self.persistanceDelegate delete:self->_asset inUid:[deletedAssetsArray valueForKeyPath:@"data.uid"]];
                }
                
                //asset_published
                NSArray *publishAssetArray = [syncStack.items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type = 'asset_published'"]];
                [self createAssets:publishAssetArray];
                
                //entry_published
                NSArray *publishEntryArray = [syncStack.items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type = 'entry_published'"]];
                [self createEntries:publishEntryArray];
                
                //Sync toke Update
                if (syncStack.syncToken != nil) {
                    isSyncCompleted = true;
                    [self updateSyncStack:syncStack];
                }
                //Save context
                if ([self.persistanceDelegate respondsToSelector:@selector(save)]) {
                    [self.persistanceDelegate save];
                }
            }];
            completion(self.percentageComplete, isSyncCompleted, error);
        }
    };
    if (shouldInit) {
        self.percentageComplete = 0;
        [_stack sync:completionBlock];
    }else if (paginationToken != nil) {
        [_stack syncPaginationToken:paginationToken completion:completionBlock];
    }else if (syncToken != nil) {
        [_stack syncToken:syncToken completion:completionBlock];
    }else {
        self.percentageComplete = 0;
        [_stack sync:completionBlock];
    }
}

-(void)syncWithSeqId:(NSString *)seqId syncToken:(NSString *)syncToken onCompletion:(void (^)(double, BOOL, NSError * _Nullable))completion {
    __weak typeof (self) weakSelf = self;
    id completionBlock = ^(SyncStack * _Nullable syncStack, NSError * _Nullable error) {
        if (error != nil) {
            //Init the sync API on pagination and sync token errors
            if (error.code == 422) {
                if (error.userInfo && error.userInfo[@"errors"]) {
                    NSDictionary *errors = error.userInfo[@"errors"];
                    if (errors[@"seq_id"]) {
                        [weakSelf syncWithSeqId:nil syncToken:nil onCompletion:completion];
                        return;
                    }
                }
            }
            completion(self.percentageComplete, false, error);
        } else {
            __block BOOL isSyncCompleted = false;
            [self.persistanceDelegate performBlockAndWait:^{
                
                if (syncStack.items) {
                    self.percentageComplete = ((double)(syncStack.skip) + (double)syncStack.items.count) / (double)syncStack.totalCount;
                    
                    if (syncToken && syncStack.seqId == nil && syncStack.items.count > 0) {
                        // Generate seq id.
                        [self generateAndPersistSeqId:syncStack];
                    }
                }
                
                //entry_unpublished || entry_deleted
                NSArray *deletedEntryArray = [syncStack.items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type = 'entry_unpublished' || type = 'entry_deleted' "]];
                [self deleteEntries:deletedEntryArray];
                
                //asset_unpublished || asset_deleted
                if (self->_asset != nil) {
                    NSArray *deletedAssetsArray = [syncStack.items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type = 'asset_unpublished' || type = 'asset_deleted'"]];
                    [self.persistanceDelegate delete:self->_asset inUid:[deletedAssetsArray valueForKeyPath:@"data.uid"]];
                }
                
                //asset_published
                NSArray *publishAssetArray = [syncStack.items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type = 'asset_published'"]];
                [self createAssets:publishAssetArray];
                
                //entry_published
                NSArray *publishEntryArray = [syncStack.items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type = 'entry_published'"]];
                [self createEntries:publishEntryArray];
                
                //Sync toke Update
                if (syncStack.seqId != nil) {
                    isSyncCompleted = true;
                    [self updateSyncStack:syncStack];
                }
                //Save context
                if ([self.persistanceDelegate respondsToSelector:@selector(save)]) {
                    [self.persistanceDelegate save];
                }
            }];
            completion(self.percentageComplete, isSyncCompleted, error);
        }
    };
    if (seqId != nil) {
        [_stack syncSeqId:seqId syncToken:syncToken completion:completionBlock];
    } else if (syncToken != nil) {
        [_stack syncSeqId:seqId syncToken:syncToken completion:completionBlock];
    } else {
        self.percentageComplete = 0;
        [_stack initSeqSync:completionBlock];
    }
}

-(void)generateAndPersistSeqId:(SyncStack * _Nullable)syncStack {
    // Get the last object's event_at
    NSDictionary *lastObject = nil;
    for (NSInteger i = syncStack.items.count - 1; i >= 0; i--) {
        id object = syncStack.items[i];
        if ([object isKindOfClass:[NSDictionary class]]) {
            lastObject = object;
            break;
        }
    }
    syncStack.seqId = [self generateSeqId:[lastObject objectForKey:@"event_at"]];
    syncStack.syncToken = nil;
    
}

-(NSString *)generateSeqId:(NSString *)eventAt {
    // Create a date formatter to parse the date string
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    NSDate *date = [dateFormater dateFromString:eventAt];
    if (date) {
        // Convert the NSDate object to an NSTimeInterval
        NSTimeInterval timeInterval = [date timeIntervalSince1970];
        NSInteger timeIntervalInSeconds = (NSInteger)timeInterval;
        return [BSONOIDGenerator generate:timeIntervalInSeconds];
    } else {
        // Handle case where date conversion failed.
        [NSException raise:@"Unable to parse date string" format:@"Invalid date format %@", eventAt];
        return nil;
    }
}

-(void)sync:(void (^)(double, BOOL, NSError * _Nullable))completion {
    NSString *syncToken = [self getSyncToken];
    NSString *seqId = [self getSeqId];
    if (syncToken) {
        [self syncWithSeqId:nil syncToken:syncToken onCompletion:completion];
    } else if (seqId) {
        [self syncWithSeqId:seqId syncToken:nil onCompletion:completion];
    } else {
        [self syncWithSeqId:nil syncToken:nil onCompletion:completion];
    }
}

-(void)createAssets:(NSArray*)assetsArray {
    for (NSDictionary *assetDict in assetsArray) {
        if ([assetDict valueForKey:@"data"] != nil && [[assetDict valueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDict = [assetDict valueForKey:@"data"];
            if ([dataDict valueForKey:@"uid"] != nil && [[dataDict valueForKey:@"uid"] isKindOfClass:[NSString class]]) {
                NSString *uid = [dataDict valueForKey:@"uid"];
                [self createAssetWithUID:uid withDictionary:dataDict];
            }
        }
    }
}

-(void)createEntries:(NSArray*)entryArray {
    for (NSDictionary *entryDict in entryArray) {
        if ([entryDict valueForKey:@"content_type_uid"] != nil && [[entryDict valueForKey:@"content_type_uid"] isKindOfClass:[NSString class]]) {
            NSString *contenttype = [entryDict valueForKey:@"content_type_uid"];
            NSArray* entryClassArray = [self.entry filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"contentTypeid = %@",contenttype]];
            if (entryClassArray.count > 0) {
                Class class = entryClassArray.firstObject;
                if ([entryDict valueForKey:@"data"] != nil && [[entryDict valueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dataDict = [entryDict valueForKey:@"data"];
                    if ([dataDict valueForKey:@"uid"] != nil && [[dataDict valueForKey:@"uid"] isKindOfClass:[NSString class]]) {
                        NSString *uid = [dataDict valueForKey:@"uid"];
                        [self createEntry:class forUID:uid withDictionary:dataDict];
                    }
                }
            }
        }
    }
}

-(id)createAssetWithUID:(NSString *)uid withDictionary:(NSDictionary*)dictionary {
    if (_asset != nil) {
        id<AssetProtocol> asset = (id<AssetProtocol>)[self findOrCreate:_asset predicate:[NSPredicate predicateWithFormat:@"uid = %@", uid]];
        asset.uid = uid;
        if ([dictionary valueForKey:@"title"] != nil) {
            asset.title = [dictionary valueForKey:@"title"];
        }
        if ([dictionary valueForKey:@"url"] != nil) {
            asset.url = [dictionary valueForKey:@"url"];
        }
        if ([dictionary valueForKeyPath:@"publish_details.locale"] != nil) {
            asset.publishLocale = [dictionary valueForKeyPath:@"publish_details.locale"];
        }
        if ([dictionary valueForKey:@"filename"] != nil) {
            asset.fileName = [dictionary valueForKey:@"filename"];
        }
        if ([dictionary valueForKey:@"updated_at"] != nil) {
            asset.updatedAt = [self getDateFrom:[dictionary valueForKey:@"updated_at"]];
        }
        if ([dictionary valueForKey:@"created_at"] != nil) {
            asset.createdAt = [self getDateFrom:[dictionary valueForKey:@"created_at"]];
        }
        return asset;
    }
    return nil;
}

-(id)createEntry:(Class)class forUID:(NSString*)uid withDictionary:(NSDictionary*)dictionary {
    
    id<EntryProtocol> entry = (id<EntryProtocol>)[self findOrCreate:class predicate:[NSPredicate predicateWithFormat:@"uid = %@", uid]];
    entry.uid = uid;
    if ([dictionary valueForKey:@"title"] != nil) {
        entry.title = [dictionary valueForKey:@"title"];
    }
    if ([dictionary valueForKey:@"url"] != nil) {
        entry.url = [dictionary valueForKey:@"url"];
    }
    if ([dictionary valueForKeyPath:@"publish_details.locale"] != nil) {
        entry.publishLocale = [dictionary valueForKeyPath:@"publish_details.locale"];
    }
    if ([dictionary valueForKey:@"updated_at"] != nil) {
        entry.updatedAt = [self getDateFrom:[dictionary valueForKey:@"updated_at"]];
    }
    if ([dictionary valueForKey:@"created_at"] != nil) {
        entry.createdAt = [self getDateFrom:[dictionary valueForKey:@"created_at"]];
    }
    if ([dictionary valueForKey:@"locale"] != nil) {
        entry.locale = [dictionary valueForKey:@"locale"];
    }
    
    // all relationship with entity
    NSDictionary *fieldDict = [class valueForKey:@"fieldMapping"];
    [self mapClass:class forObject:(NSObject*)entry forFields:fieldDict withDictionary:dictionary];
    
    return entry;
}

-(id)createGroup:(Class)class withDictionary:(NSDictionary*)dictionary {
    
    id<EntryGroupProtocol> group = (id<EntryGroupProtocol>)[self.persistanceDelegate create:class];
    // all relationship with entity
    NSDictionary *fieldDict = [class valueForKey:@"fieldMapping"];
    [self mapClass:class forObject:(NSObject*)group forFields:fieldDict withDictionary:dictionary];
    return group;
}

-(void)mapClass:(Class)class forObject:(NSObject*)object forFields:(NSDictionary*) fieldDict withDictionary:(NSDictionary*) dictionary {
    NSDictionary* relationshipbyname = [self.persistanceDelegate relationShipByName:class];
    for (NSString *key in fieldDict.allKeys) {
        NSString *value = [fieldDict valueForKey:key];
        if ([[relationshipbyname allKeys] containsObject:key]) {
            Class class = [self.persistanceDelegate classfor:relationshipbyname forKey:key];
            if (class != nil) {
                if ([class conformsToProtocol:@protocol(EntryGroupProtocol)]) {
                    if ([object valueForKey:key] != nil) {
                        id relationObject = [object valueForKey:key];
                        if ([relationObject isKindOfClass:[NSSet class]]) {
                            [self.persistanceDelegate delete:[(NSSet*)relationObject allObjects]];
                        }else {
                            [self.persistanceDelegate delete:@[relationObject]];
                        }
                    }
                }
                id relationEntity = [self resolveClass:class byRelationshipMapping:relationshipbyname withKey:key withobject:[dictionary valueForKeyPath:value]];
                [object setValue:relationEntity forKey:key];
            }
        }else {
            if (![[dictionary valueForKeyPath:value] isKindOfClass:[NSNull class]] && [dictionary valueForKeyPath:value] != nil) {
                if ([self.persistanceDelegate isDate:key forClass:object]){
                    [object setValue:[self getDateFrom:[dictionary valueForKeyPath:value]] forKey:key];
                }else {
                    [object setValue:[dictionary valueForKeyPath:value] forKey:key];
                }
            }
        }
    }
}

-(id)stringDataEntry:(Class)class forUID:(NSString*)uid {
    if ([self.entry containsObject:class]) {
        return [self createEntry:class forUID:uid withDictionary:nil];
    }else if ([self.asset isEqual:class]) {
        return [self createAssetWithUID:uid withDictionary:nil];
    }else if ([class conformsToProtocol:@protocol(EntryGroupProtocol)]) {
        return [self createGroup:class withDictionary:@{@"value":uid}];
    }
    return nil;
}

-(id)dictionaryDataEntry:(Class)class forDictionary:(NSDictionary*)referenceDict {
    if ([referenceDict valueForKey:@"uid"] != nil && [[referenceDict valueForKey:@"uid"] isKindOfClass:[NSString class]]) {
        NSString *uid = [referenceDict valueForKey:@"uid"];
        if ([self.entry containsObject:class]) {
            return [self createEntry:class forUID:uid withDictionary:referenceDict];
        }else if ([self.asset isEqual:class]) {
            return [self createAssetWithUID:uid withDictionary:referenceDict];
        }
    }else {
        return [self createGroup:class withDictionary:referenceDict];
    }
    return nil;
}

-(void)deleteEntries:(NSArray*)entryArray {
    NSArray *contentTypeArray = [entryArray valueForKey:@"content_type_uid"];
    for (NSString *contentType in contentTypeArray) {
        NSArray* entryClassArray = [self.entry filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"contentTypeid = %@",contentType]];
        NSArray* entryObjects = [entryArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"content_type_uid = %@",contentType]];
        if (entryClassArray.count > 0 && entryObjects.count > 0) {
            Class class = entryClassArray.firstObject;
            id uidArray = [entryObjects valueForKeyPath:@"data.uid"];
            if (uidArray != nil) {
                if ([uidArray isKindOfClass:[NSString class]]) {
                    [self.persistanceDelegate delete:class inUid:@[uidArray]];
                }else if(([uidArray isKindOfClass:[NSArray class]])){
                    [self.persistanceDelegate delete:class inUid:(NSArray*)uidArray];
                }
            }
        }
    }
}


-(id)findOrCreate:(Class)class predicate:(NSPredicate*)predicate {
    NSArray *manageObjectsArray = [self.persistanceDelegate fetchAll:class predicate:predicate];
    if (manageObjectsArray.count > 0) {
        return manageObjectsArray.firstObject;
    }
    return [self.persistanceDelegate create:class];
}

-(id)resolveClass:(Class)class byRelationshipMapping:(NSDictionary*) relationshipbyname withKey:(NSString*)key withobject:(id)object{
    Class referenceClass = class;
    if ([self.persistanceDelegate isToManyRelationfor:relationshipbyname forKey:key]) {
        NSMutableSet *set = [NSMutableSet set];
        if ([object isKindOfClass:[NSArray class]]) {
            NSArray *referenceArray = object;
            for (id referenceVal in referenceArray) {
                referenceClass = class;
                id reference = referenceVal;
                if ([referenceVal isKindOfClass:[NSDictionary class]] && [referenceVal valueForKey:@"uid"] && [referenceVal valueForKey:@"_content_type_uid"]) {
                    reference = [referenceVal valueForKey:@"uid"];
                    NSString *contenttype = [referenceVal valueForKey:@"_content_type_uid"];
                    NSArray* entryClassArray = [self.entry filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"contentTypeid = %@",contenttype]];
                    if (entryClassArray.count > 0) {
                        referenceClass = entryClassArray.firstObject;
                    }
                }
                [set addObject:[self parseObject:reference forClass:referenceClass]];
            }
        }else if (![object isKindOfClass:[NSNull class]] && object != nil){
            id reference = object;
            if ([object isKindOfClass:[NSDictionary class]] && [object valueForKey:@"uid"] && [object valueForKey:@"_content_type_uid"]) {
                reference = [object valueForKey:@"uid"];
                NSString *contenttype = [object valueForKey:@"_content_type_uid"];
                NSArray* entryClassArray = [self.entry filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"contentTypeid = %@",contenttype]];
                if (entryClassArray.count > 0) {
                    referenceClass = entryClassArray.firstObject;
                }
            }
            [set addObject:[self parseObject:reference forClass:referenceClass]];
        }
        return set;
    }else {
        if ([object isKindOfClass:[NSArray class]]) {
            NSArray *referenceArray = object;
            if ([referenceArray count] > 0) {
                id reference = referenceArray.firstObject;
                if ([reference isKindOfClass:[NSDictionary class]] && [reference valueForKey:@"uid"] && [reference valueForKey:@"_content_type_uid"]) {
                    NSDictionary *refDict = reference;
                    reference = [refDict valueForKey:@"uid"];
                    NSString *contenttype = [refDict valueForKey:@"_content_type_uid"];
                    NSArray* entryClassArray = [self.entry filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"contentTypeid = %@",contenttype]];
                    if (entryClassArray.count > 0) {
                        referenceClass = entryClassArray.firstObject;
                    }
                }
                return [self parseObject:reference forClass:referenceClass];
            }
        }else {
            id reference = object;
            if ([reference isKindOfClass:[NSDictionary class]] && [reference valueForKey:@"uid"] && [reference valueForKey:@"_content_type_uid"]) {
                NSDictionary *refDict = reference;
                reference = [refDict valueForKey:@"uid"];
                NSString *contenttype = [refDict valueForKey:@"_content_type_uid"];
                NSArray* entryClassArray = [self.entry filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"contentTypeid = %@",contenttype]];
                if (entryClassArray.count > 0) {
                    referenceClass = entryClassArray.firstObject;
                }
            }
            return [self parseObject:reference forClass:referenceClass];
        }
    }
    return nil;
}

-(id)parseObject:(id)object forClass:(Class)class {
    if (![object isKindOfClass:[NSNull class]] && object != nil) {
        if ([object isKindOfClass:[NSDictionary class]]){
            return [self dictionaryDataEntry:class forDictionary:object];
        }else if ([object isKindOfClass:[NSString class]]){
            return [self stringDataEntry:class forUID:object];
        }else if ([class conformsToProtocol:@protocol(EntryGroupProtocol)]) {
            return [self createGroup:class withDictionary:@{@"value":object}];
        }
    }
    return nil;
}

NSArray *classConformsProtocol(Protocol* protocol, Class superClass) {
    NSMutableArray *classesArray = [NSMutableArray array];
    int numberOfClasses = objc_getClassList(NULL, 0);
    Class *classList = (Class *)malloc(numberOfClasses * sizeof(Class));
    numberOfClasses = objc_getClassList(classList, numberOfClasses);
    
    for (int idx = 0; idx < numberOfClasses; idx++)
    {
        Class class = classList[idx];
        if (class_getClassMethod(class, @selector(superclass)) && [superClass isEqual: [class superclass]] && class_getClassMethod(class, @selector(conformsToProtocol:)) && [class conformsToProtocol:protocol])
        {
            [classesArray addObject:class];
        }
    }
    free(classList);
    return classesArray;
}

@end

