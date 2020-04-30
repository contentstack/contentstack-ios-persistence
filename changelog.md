## Changelog

### Version 0.0.3 (2019-04-16) ###

#### Changes

 - Dependency update for Contentstack framework

### Version 0.0.2 (2019-04-05) ###

#### Fixed
    - CoreData threading assertions issue resolved.

#### Changes
    - PersistanceDelegate
        - Added method ```-(void)performBlock:(void (^)(void))block```
        - Added method ```-(void)performBlockAndWait:(void (^)(void))block```
    - CoreDataStore
        - Change method name '''-(instancetype) initWithContext:(NSManagedObjectContext*) context'''
        - Implemented '''PersisitenceDelegate``` new methods:
            - ```-(void)performBlock:(void (^)(void))block```
            - ```-(void)performBlockAndWait:(void (^)(void))block```
    - RealmStore
        - Implemented '''PersisitenceDelegate``` new methods:
            - ```-(void)performBlock:(void (^)(void))block```
            - ```-(void)performBlockAndWait:(void (^)(void))block```
        
### Version 0.0.1 (2018-10-30) ###

- Initial release.
