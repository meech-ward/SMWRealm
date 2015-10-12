//
//  RLMObject+SMWRealmKey.m
//  Pods
//
//  Created by Sam Meech Ward on 2015-10-12.
//
//

#import "RLMObject+SMWRealmKey.h"

@implementation RLMObject (SMWRealmKey)


#pragma mark -
#pragma mark - Create or Update

- (SMWRealmKey *)smw_createOrUpdate {
    return [self smw_createOrUpdateInRealm:[RLMRealm defaultRealm]];
}

- (SMWRealmKey *)smw_createOrUpdateInRealm:(RLMRealm *)realm {
    // Create or update this object
    [realm beginWriteTransaction];
    [self.class createOrUpdateInRealm:realm withValue:self];
    [realm commitWriteTransaction];
    
    // Create a new realm key object for this object
    SMWRealmKey *realmKey = [[SMWRealmKey alloc] initWithRealmObject:self];
    return realmKey;
}

@end
