//
//  PersistenceModel.h
//  Pods
//
//  Created by Uttam Ukkoji on 18/10/23.
//

#import <Foundation/Foundation.h>

@interface PersistenceModel: NSObject

-(instancetype _Nonnull )initWithSyncStack:(Class _Nonnull)syncStack asset:(Class _Nonnull)asset entries:(NSArray<Class>* _Nonnull) entries;

@property (nonatomic, copy)  Class _Nonnull syncStack;
@property (nonatomic, copy)  Class _Nonnull asset;
@property (nonatomic, copy)  NSArray<Class> * _Nullable entries;

@end


