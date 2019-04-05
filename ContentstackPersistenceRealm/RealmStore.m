//
//  SyncRealm.m
//  ContentstackPersistence
//
//  Created by Uttam Ukkoji on 30/07/18.
//  Copyright © 2018 Contentstack. All rights reserved.
//

#import "RealmStore.h"
#import <Realm/Realm.h>
#import "SyncManager.h"
@interface RealmStore ()
@property (nonnull, copy)RLMRealm *realm;
@end

@implementation RealmStore

-(instancetype)initWithRealm:(RLMRealm *)realm {
    self = [super init];
    if (self) {
        _realm = realm;
    }
    return self;
}

-(Class)getSuperClass {
    return RLMObject.class;
}

-(BOOL)isDate:(NSString *)propertyName forClass:(NSObject*)object {
    NSArray *properties = [[(RLMObject*)object objectSchema].properties filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@",propertyName]];
    
    if ([properties count] > 0) {
        RLMProperty *propert = properties.firstObject;
        if (propert.type == RLMPropertyTypeDate) {
            return true;
        }
    }
    return false;
}

- (void)performBlockAndWait:(void (^)(void))block {
    [_realm beginWriteTransaction];
    block();
    [_realm commitWriteTransaction];
}

- (void)performBlock:(void (^)(void))block {
    [_realm beginWriteTransaction];
    block();
    [_realm commitWriteTransaction];
}

-(id)create:(Class)class {
    RLMObject *object = [[class alloc] init];
    [_realm addObject:object];
    return object;
}

-(NSDictionary*)relationShipByName:(Class)class {
    NSMutableDictionary *relationShip = [NSMutableDictionary new];
    NSString *className = NSStringFromClass(class);
    if ([SyncManageSwiftSupport isSwiftClassName:className]) {
        className = [SyncManageSwiftSupport demangleClassName:className];
    }
    RLMObjectSchema *schema = _realm.schema[className];
    [schema.properties enumerateObjectsUsingBlock:^(RLMProperty * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.objectClassName != nil) {
            [relationShip setObject:obj forKey:obj.name];
        }
    }];
    return relationShip;
}

-(void)delete:(Class)class inUid:(NSArray*)array {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid IN %@",array];
    RLMResults *result = [class performSelector:@selector(objectsWithPredicate:) withObject:predicate];
    [_realm deleteObjects:result];
}

-(void)delete:(NSArray*)array {
    for (id value in array) {
        if ([value isKindOfClass:[RLMObject class]]) {
            [_realm deleteObject:(RLMObject*)value];
        }else if ([value isKindOfClass:[RLMArray class]]) {
            for (RLMObject *object in (RLMArray*)value) {
                [_realm deleteObject:object];
            }
        }
    }
}

-(NSArray*)fetchAll:(Class)class predicate:(NSPredicate*)predicate {
    NSMutableArray *array = [NSMutableArray array];
    RLMResults *results = [class performSelector:@selector(objectsWithPredicate:) withObject:predicate];
    for (RLMObject *object in results) {
        [_realm addObject:object];
        [array addObject:object];
    }
    return array;
}

-(Class)classfor:(NSDictionary*)relationshipName forKey:(NSString*)key {
    RLMProperty *property = [relationshipName valueForKey:key];
    Class classsName = NSClassFromString(property.objectClassName);
    if (classsName == nil) {
        NSString * nameSpace = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleExecutable"];
        nameSpace = [[nameSpace componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@"_"];
        classsName = NSClassFromString([NSString stringWithFormat:@"%@.%@",nameSpace, property.objectClassName]);
    }
    return classsName;
}


-(BOOL)isToManyRelationfor:(NSDictionary*)relationshipName forKey:(NSString*)key {
    RLMProperty *property = [relationshipName valueForKey:key];
    return property.array;
}

@end

