//
//  SyncPersistable.h
//  ContentstackPersistence
//
//  Created by Uttam Ukkoji on 30/07/18.
//  Copyright © 2018 Contentstack. All rights reserved.
//

#ifndef SyncPersistable_h
#define SyncPersistable_h

#endif /* SyncPersistable_h */
#import <CoreData/CoreData.h>
@protocol PersistanceDelegate <NSObject>
@optional
/**
 Performs the actual save to the persistence store.
 */
-(void)save;

@required
/**
 Provide super class like 'NSManageObject' for core data.
 */
-(Class)getSuperClass;

/**
Check if property is date type.

 @param propertyName Property for which check is needed.
 @param object Object in which propert is checked.
 @return True if the property is date else return False.
 */
-(BOOL)isDate:(NSString*)propertyName forClass:(NSObject*)object;

/**
 Create a new object of the given type.
 
 @param class he type of which a new object should be created
 @return A newly created object of the given type
 */
-(id)create:(Class)class;


/**
 Returns reltionsship with class object

 @param class Class from which to get reletionships
 @return Dictionary of relationships.
 */
-(NSDictionary*)relationShipByName:(Class)class;

/**
 Delete objects of the given type which also match the predicate.

 @param class Class from which delete is perform.
 @param array Array of UID's to be deleted.
 */
-(void)delete:(Class)class inUid:(NSArray*)array;

/**
  Delete all objects of the given array of Object.

 @param array Array of object to be deleted
 */
-(void)delete:(NSArray*)array;


/**
 Get objects for class that matches predicate.

 @param class Class from which to fetch.
 @param predicate Predicate for conditions
 @return Array of objects.
 */
-(NSArray*)fetchAll:(Class)class predicate:(NSPredicate*)predicate;


/**
 Provide class name for the key having relationship.

 @param relationshipName Relationship Dictioary.
 @param key String name of field.
 @return Class for the relationship key
 */
-(Class)classfor:(NSDictionary*)relationshipName forKey:(NSString*)key;


/**
 check if relationship is one-to-one or one-to-many.

 @param relationshipName Relationship Dictioary.
 @param key String name of field.
 @return true if one-to-many relationshio else return false.
 */
-(BOOL)isToManyRelationfor:(NSDictionary*)relationshipName forKey:(NSString*)key;

/**
 Performs the Block Operation to write into the persistence store.
 */
-(void)performBlock:(void (^)(void))block;

/**
 Performs the Block Operation and Wait to write into the persistence store.
 */
-(void)performBlockAndWait:(void (^)(void))block;

@end
