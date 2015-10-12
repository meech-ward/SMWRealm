//
//  SMWRealmKey.h
//  Pods
//
//  Created by Sam Meech Ward on 2015-10-12.
//
//

#import <Foundation/Foundation.h>

@class RLMObject, RLMRealm;

@interface SMWRealmKey<RLMObjectType> : NSObject

/**
 Create a new `SMWRealmKey` object using the data from a realm object.
 @param realmObject The realm object that this object will represent.
 @return A new `SMWRealmKey` object.
 */
- (instancetype)initWithRealmObject:(RLMObject *)realmObject;

/// The value of the primary key of the realm object that this represents.
@property (strong, nonatomic, readonly) id primaryKey;


/// @name Read

/**
 Read any properties from the realm object.
 @param block Any reading of the realm object's properties should take place inside this block.
 */
- (void)readRealmObject:(void(^)(RLMObjectType object))block;


/// @name Update

/**
 Update any properties of the realm object.
 @param block Any updates to the realm object should take place inside this block.
 */
- (void)updateRealmObject:(void(^)(RLMObjectType object, RLMRealm *realm))block;


/// Delete

/**
 Delete the realm object.
 */
- (void)deleteRealmObject;

@end
