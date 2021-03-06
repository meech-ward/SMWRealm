//
//  SMWRealmKey.m
//  Pods
//
//  Created by Sam Meech Ward on 2015-10-12.
//
//

#import "SMWRealmKey.h"
#import <Realm/Realm.h>

@interface SMWRealmKey ()

// The value of the primary key of the realm object that this represents.
@property (strong, nonatomic) id primaryKey;

// The class of the realm object this object represents.
@property (strong, nonatomic) Class realmClass;

// The path of the realm that the object has when it is passed in.
@property (strong, nonatomic) NSURL *realmURL;
// The realm that the object has when it is passed in.
@property (strong, nonatomic, readonly) RLMRealm *objectsRealm;

// The realm object that this key represents
@property (strong, nonatomic) RLMObject *realmObject;

@end

@implementation SMWRealmKey

#pragma mark - SetUp

+ (instancetype)createOrUpdateObject:(RLMObject *)object {
    return [self createOrUpdateObject:object inRealm:[RLMRealm defaultRealm]];
}

+ (instancetype)createOrUpdateObject:(RLMObject *)object inRealm:(RLMRealm *)realm {
    // Create or update this object
    [realm beginWriteTransaction];
    [object.class createOrUpdateInRealm:realm withValue:object];
    [realm commitWriteTransaction];
    
    // Create a new realm key object for this object
    return [self keyWithRealmObject:object];
}

+ (instancetype)keyWithRealmObject:(RLMObject *)realmObject {
    return [[SMWRealmKey alloc] initWithRealmObject:realmObject];
}

- (instancetype)init {
    return [self initWithRealmObject:[[RLMObject alloc] init]];
}

- (instancetype)initWithRealmObject:(RLMObject *)realmObject {
    self = [super init];
    if (self) {
        _primaryKey = [self primaryKeyForRealmObject:realmObject];
        _realmClass = realmObject.class;
        _realmURL = realmObject.realm.configuration.fileURL;
    }
    return self;
    
}

#pragma mark - 
#pragma mark - Containers

+ (NSArray *)arrayOfKeysFromResults:(RLMResults *)results {
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    for (RLMObject *result  in results) {
        [keys addObject:[SMWRealmKey keyWithRealmObject:result]];
    }
    return keys.copy;
}

#pragma mark -
#pragma mark - Read

- (RLMRealm *)objectsRealm {
    if (_realmURL && _realmURL.absoluteString.length > 0) {
        return [RLMRealm realmWithURL:_realmURL];
    }
    return [RLMRealm defaultRealm];
}

- (RLMObject *)realmObject {
    return [_realmClass objectInRealm:self.objectsRealm forPrimaryKey:_primaryKey];
}

- (void)readRealmObject:(void(^)(id object))block {
    // Perform the block
    block(self.realmObject);
}

#pragma mark -
#pragma mark - Update

- (void)updateRealmObject:(void(^)(id object, RLMRealm *realm))block {
    // Get the current object
    id obj = self.realmObject;
    RLMRealm *realm = ((RLMObject *)obj).realm;
    
    // Perform the block
    [realm beginWriteTransaction];
    block(obj, realm);
    [realm commitWriteTransaction];
}

#pragma mark -
#pragma mark - Delete

- (void)deleteRealmObject {
    [self updateRealmObject:^(id object, RLMRealm *realm) {
        [realm deleteObject:object];
    }];
}

#pragma mark -
#pragma mark - Utility

/// Get the current realm object's primary key
- (id)primaryKeyForRealmObject:(RLMObject *)realmObject {
    NSString *primaryKeyProperty = [realmObject.class primaryKey];
    id key = [realmObject valueForKey:primaryKeyProperty];
    return key;
}

- (BOOL)isEqualToKey:(id)object {
    SMWRealmKey *otherKey = (SMWRealmKey *)object;
    
    // Make sure both objects have primary keys
    if (!_primaryKey || !otherKey.primaryKey) {
        return NO;
    }
    
    // Make sure the primary keys are the same class
    if ([_primaryKey class] != [otherKey.primaryKey class]) {
        return NO;
    }
    
    // Check for any special isequal methods
    if ([_primaryKey class] == [NSString class]) {
        if (![_primaryKey isEqualToString:otherKey.primaryKey]) {
            return NO;
        }
    }
    
    return YES;
}

@end
