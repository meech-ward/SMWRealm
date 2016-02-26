//
//  SMWRealmPerson.h
//  SMWRealm
//
//  Created by Sam Meech Ward on 2015-10-12.
//  Copyright © 2015 Sam Meech-Ward. All rights reserved.
//

#import <Realm/Realm.h>

@interface SMWRealmPerson : RLMObject

@property NSString *key;
@property NSString *firstName;
@property NSString *lastName;
@property NSDate *birthday;

@end


RLM_ARRAY_TYPE(SMWRealmPerson)
