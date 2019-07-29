//
//  SyncCoreData.m
//  ContentstackPersistence
//
//  Created by Uttam Ukkoji on 30/07/18.
//  Copyright © 2018 Contentstack. All rights reserved.
//

#import "CoreDataStore.h"

@interface CoreDataStore ()
@property (nonatomic, copy) NSManagedObjectContext *context;
@end
@implementation CoreDataStore
-(instancetype)initWithContext:(NSManagedObjectContext *)context {
    self = [super init];
    if (self) {
        _context = context;
    }
    return self;
}

-(Class)getSuperClass {
    return NSManagedObject.class;
}

-(BOOL)isDate:(NSString *)propertyName forClass:(NSObject*)object {
    if ([[[[(NSManagedObject*)object entity] attributesByName] valueForKey:propertyName] attributeType] == NSDateAttributeType) {
        return true;
    }
    return false;
}

-(void)save {
    [_context save:nil];
}

-(id)create:(Class)class {
    NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:class.description inManagedObjectContext:_context];
    return entity;
}

-(NSManagedObjectContext *)context{
    return _context;
}

-(NSDictionary*)relationShipByName:(Class)class {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:class.description inManagedObjectContext:_context];
    return entityDescription.relationshipsByName;
}

- (void)delete:(Class)class inUid:(NSArray*)array {
    NSArray *assets = [self fetchAll:class predicate:[NSPredicate predicateWithFormat:@"uid IN %@",array]];
    for (NSManagedObject* manageObject in assets) {
        [_context deleteObject:manageObject];
    }
}

-(void)delete:(NSArray*)array {
    for (NSManagedObject* manageObject in array) {
        [_context deleteObject:manageObject];
    }
}

-(NSArray*)fetchAll:(Class)class predicate:(NSPredicate*)predicate {
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:class.description];
    fetchRequest.predicate = predicate;
    return [_context executeFetchRequest:fetchRequest error:nil];
}

-(BOOL)isToManyRelationfor:(NSDictionary *)relationshipName forKey:(NSString *)key {
    NSRelationshipDescription *relationDescription = [relationshipName valueForKey:key];
    return relationDescription.isToMany;
}

- (Class)classfor:(NSDictionary *)relationshipName forKey:(NSString *)key {
    NSRelationshipDescription *relationDescription = [relationshipName valueForKey:key];
    NSEntityDescription * desc = [relationDescription destinationEntity];
    Class classsName = NSClassFromString(desc.name);
    if (classsName == nil) {
        NSString * nameSpace = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleExecutable"];
        classsName = NSClassFromString([NSString stringWithFormat:@"%@.%@",nameSpace, desc.name]);
    }
    return classsName;
}

-(void)performBlock:(void (^)(void))block {
    [_context performBlock:^{
        block();
    }];
}

-(void)performBlockAndWait:(void (^)(void))block {
    [_context performBlockAndWait:^{
        block();
    }];
}

@end
