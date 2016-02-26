//
//  SMWRealmPerson.m
//  SMWRealm
//
//  Created by Sam Meech Ward on 2015-10-12.
//  Copyright © 2015 Sam Meech-Ward. All rights reserved.
//

#import "SMWRealmPerson.h"

@implementation SMWRealmPerson

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"birthday": [NSDate date],
             @"key" : uniqueKey()};
}

+ (NSString *)primaryKey {
    return @"key";
}

static NSString *uniqueKey() {
    // Setup a queue for thread saftey
    static dispatch_queue_t _syncQueue = NULL;
    if (_syncQueue == NULL) {
        _syncQueue = dispatch_queue_create("com.meech-ward.uniqueKeyQueue", NULL);
    }
    
    // Get the unique string
    __block NSString *string;
    dispatch_sync(_syncQueue, ^{
        string = [[NSUUID UUID] UUIDString];
    });
    
    return string;
}

@end
