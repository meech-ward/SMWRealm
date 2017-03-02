//
//  SMWRealmKeyContainerTests.m
//  SMWRealm
//
//  Created by Sam Meech Ward on 2015-10-29.
//  Copyright © 2015 Sam Meech-Ward. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <SMWRealm/SMWRealm.h>
#import "SMWRealmPerson.h"

SpecBegin(SMWRealmKeyContainers)

describe(@"Use containers with realm key", ^{
    
    __block RLMRealm *realm;
    
    beforeAll(^{
        
        // Create a new realm for the tests in this file
        RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
        NSString *lastComponent = [@"SMWRealmKeyContainers" stringByAppendingPathExtension:@"realm"];
        NSURL *url = config.fileURL;
        url = [url URLByDeletingLastPathComponent];
        url = [url URLByAppendingPathComponent:lastComponent];
        config.fileURL = url;
        
        // Set this as the configuration used for the default Realm
        [RLMRealmConfiguration setDefaultConfiguration:config];
        
        // Reference this new realm
        NSError *error;
        realm = [RLMRealm realmWithConfiguration:config error:&error];
        expect(error).to.equal(nil);
        expect(realm).notTo.equal(nil);
        
        // Remove all teh objects from this realm
        [realm transactionWithBlock:^{
            [realm deleteAllObjects];
        }];
    });
    
    afterAll(^{
        // Cleanup the realm
        [realm transactionWithBlock:^{
            [realm deleteAllObjects];
        }];
    });
    
    context(@"I have 100 realm person objects and I have queried them into a RLMResults object", ^{
        
        const int totalObjects = 2;
        __block RLMResults<SMWRealmPerson *> *people;
        beforeEach(^{
            // Create some objects
            for (int i = 0; i < totalObjects; ++i) {
                SMWRealmPerson *person = [[SMWRealmPerson alloc] initWithValue:@{@"firstName" : [NSString stringWithFormat:@"person: %i", i]}];
                [SMWRealmKey createOrUpdateObject:person inRealm:realm];
            }
            
            // Get those objects
            people = [SMWRealmPerson allObjectsInRealm:realm];
        });
        
        it(@"The Results: should contain all 100 people objects", ^{
            waitUntil(^(DoneCallback done) {
                expect(people.count).to.equal(totalObjects);
                done();
            });
            
        });
        
        describe(@"I get an array of those results as an array of realm keys", ^{
            
            __block NSArray<SMWRealmKey<SMWRealmPerson *> *> *peopleKeyArray;
            
            beforeEach(^{
                peopleKeyArray = [SMWRealmKey arrayOfKeysFromResults:people];
            });
            
            it(@"The Array: should contain key values for all the people in the RLMResults", ^{
                expect(peopleKeyArray.count).to.equal(people.count);
                
                [peopleKeyArray enumerateObjectsUsingBlock:^(SMWRealmKey<SMWRealmPerson *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    // Get the person at teh same index from the people array
                    SMWRealmPerson *person = people[idx];
                
                    [obj readRealmObject:^(SMWRealmPerson * _Nullable object) {
                        expect(object.firstName).to.equal(person.firstName);
                    }];
                }];
            });
            
        });
        
    });
    
});


SpecEnd
