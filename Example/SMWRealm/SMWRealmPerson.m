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
    return @{@"firstName": @"",
             @"lastName": @""};
}

+ (NSString *)primaryKey {
    return @"key";
}

@end
