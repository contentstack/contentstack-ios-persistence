//
//  PersistenceModel.m
//  ContentstackPersistence
//
//  Created by Uttam Ukkoji on 18/10/23.
//

#import <Foundation/Foundation.h>
#import "PersistenceModel.h"

@implementation PersistenceModel
-(instancetype)initWithSyncStack:(Class)syncStack asset:(Class)asset entries:(NSArray<Class> *)entries {
    self = [super init];
    if (self) {
        _syncStack = syncStack;
        _asset = asset;
        _entries = entries;
    }
    return self;
}


@end
