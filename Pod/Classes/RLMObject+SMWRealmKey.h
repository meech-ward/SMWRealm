//
//  RLMObject+SMWRealmKey.h
//  Pods
//
//  Created by Sam Meech Ward on 2015-10-12.
//
//

#import <Realm/Realm.h>

@class SMWRealmKey;

NS_ASSUME_NONNULL_BEGIN

@interface RLMObject (SMWRealmKey)

/**
 Create or update the current RLMObject in the default realm.
 @return A `SMWRealmKey` object that represents this object.
 */
- (SMWRealmKey *)smw_createOrUpdate;
/**
 Create or update the current RLMObject.
 @param realm The Realm in which this object is persisted.
 @return A `SMWRealmKey` object that represents this object.
 */
- (SMWRealmKey *)smw_createOrUpdateInRealm:(RLMRealm *)realm;

@end

NS_ASSUME_NONNULL_END