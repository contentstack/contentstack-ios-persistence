//
//  BSONOIDGenerator.h
//  ContentstackPersistence
//
//  Created by Vikram Kalta on 13/02/2024.
//  Copyright © 2024 Contentstack. All rights reserved.
//

#ifndef BSONOIDGenerator_h
#define BSONOIDGenerator_h

#import <Foundation/Foundation.h>

typedef union {
    char bytes[12];
    int ints[3];
} bson_oid_t;

@interface BSONOIDGenerator : NSObject

+ (NSString *)generate:(NSInteger)timestamp;

@end

#endif /* BSONOIDGenerator_h */
