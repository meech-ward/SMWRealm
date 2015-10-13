//
//  SMWRealmKey.h
//  Pods
//
//  Created by Sam Meech Ward on 2015-10-12.
//
//

#import <Foundation/Foundation.h>

@class RLMObject, RLMRealm;

NS_ASSUME_NONNULL_BEGIN

@interface SMWRealmKey<RLMObjectType> : NSObject

/// A class method that does the same thing as the initWithRealmObject object method.
+ (instancetype)keyWithRealmObject:(RLMObject *)realmObject;

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
- (void)readRealmObject:(void(^)(RLMObjectType _Nullable object))block;


/// @name Update

/**
 Update any properties of the realm object.
 @param block Any updates to the realm object should take place inside this block.
 */
- (void)updateRealmObject:(void(^)(RLMObjectType _Nullable object, RLMRealm * _Nullable realm))block;


/// Delete

/**
 Delete the realm object.
 */
- (void)deleteRealmObject;


/// @name Equality

/**
 Compare two realm key objects to determine if they represent the same RLMObject.
 @param object A realm key object to be compared to this object.
 @return YES when the two objects represent the same RLMObject, NO otherwise.
 */
- (BOOL)isEqualToKey:(nullable id)object;

@end

NS_ASSUME_NONNULL_END
