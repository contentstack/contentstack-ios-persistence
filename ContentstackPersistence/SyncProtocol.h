//
//  SyncProtocol.h
//  ContentstackPersistence
//
//  Created by Uttam Ukkoji on 30/07/18.
//  Copyright © 2018 Contentstack. All rights reserved.
//

#ifndef SyncProtocol_h
#define SyncProtocol_h
/**
 Base protocol for all `AssetProtocol` and `EntryProtocol`.
 */
@protocol ContentStackProtocol<NSObject>
@required

/// The title of the Resource.
@property (nonatomic)NSString *title;
/// The url of the Resource.
@property (nonatomic)NSString *url;
/// The unique identifier of the Resource.
@property (nonatomic)NSString *uid;
/// The code which represents which locale the Resource of interest contains data for.
@property (nonatomic)NSString *publishLocale;
/// The date representing the last time the Contentful Resource was created.
@property (nonatomic)NSDate *createdAt;
/// The date representing the last time the Contentful Resource was updated.
@property (nonatomic)NSDate *updatedAt;
@end

/**
 Your subclass should conform to this `SyncStoreProtocol` to enable continuing
 a sync from a sync token on subsequent launches of your application rather than re-fetching all data during an initialSync.
 */
@protocol SyncStoreProtocol<NSObject>
@required
@property (nonatomic)NSString* paginationToken;
@property (nonatomic)NSString* syncToken;
@property (nonatomic)NSString* seqId;
@end

/**
 Conform to `EntryProtocol` protocol to enable mapping of your ContentStack content type to
 your subclass.
 */
@protocol EntryProtocol<ContentStackProtocol>
@required
/// The code which represents which locale the Resource of interest contains data for.
@property (nonatomic)NSString *locale;

/// The identifier of the ContentStack content type that will map to this type of `EntryProtocol`
+(NSString*)contentTypeid;

/// This method must be implemented to provide a custom mapping from ContentStack fields to Swift properties.
+(NSDictionary *)fieldMapping;
@end

/**
 Conform to `EntryGroupProtocol` protocol to enable mapping of your ContentStack content type to your subclass.
 */
@protocol EntryGroupProtocol
@required
/// This method must be implemented to provide a custom mapping from ContentStack fields to Swift properties.
+(NSDictionary *)fieldMapping;
@end

/**
 Conform to `AssetProtocol` protocol to enable mapping of your ContentStack media Assets to
 your subclass.
 */
@protocol AssetProtocol<ContentStackProtocol>
@required
/// The name of the underlying binary media file.
@property (nonatomic)NSString *fileName;
@end
#endif /* SyncProtocol_h */

