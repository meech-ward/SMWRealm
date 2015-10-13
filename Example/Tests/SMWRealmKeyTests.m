//
//  SMWRealmKeyTests.m
//  SMWRealm
//
//  Created by Sam Meech Ward on 2015-10-12.
//  Copyright © 2015 Sam Meech-Ward. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <SMWRealm/SMWRealm.h>
#import "SMWRealmPerson.h"

SpecBegin(SMWRealmKey)

describe(@"Realm key", ^{
    // Variables
    __block NSString *primaryKey;
    __block SMWRealmPerson *person;
    __block SMWRealmKey<SMWRealmPerson *> *personKey;
    // Constants
    NSString *const defaultFirstName = @"Sam";
    NSString *const defaultLastName = @"Meech-Ward";

    beforeEach(^{
        NSLog(@"bfore");
        // Create a new person and save it to realm
        person = [[SMWRealmPerson alloc] init];
        primaryKey = [[NSUUID UUID] UUIDString];
        person.key = primaryKey;
        person.firstName = defaultFirstName;
        person.lastName = defaultLastName;
        personKey = [SMWRealmKey createOrUpdateObject:person];
    });
    
    afterEach(^{
        NSLog(@"after");
        // Remove the person from realm
        [personKey deleteRealmObject];
    });
    
    
    
    context(@"when initialized", ^{
        
        it(@"represents the realm object that it is initialized from", ^{
            // Check that the key reresents the same realm object that created it
            [personKey readRealmObject:^(SMWRealmPerson *object) {
                expect(primaryKey).to.match(object.key);
                expect(defaultLastName).to.match(object.lastName);
                expect(defaultFirstName).to.match(object.firstName);
                NSLog(@"expect primary key");
            }];
        });
    
    });
    
    context(@"when editing and reading properties", ^{
    
        it(@"can read properties on a different thead", ^{
            waitUntil(^(DoneCallback done) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    [personKey readRealmObject:^(SMWRealmPerson *object) {
                        expect(defaultLastName).to.match(object.lastName);
                        expect(defaultFirstName).to.match(object.firstName);
                        NSLog(@"can read properties on a different thread");
                    }];
                    
                    done();
                });
            });
        });
        
        it(@"can write properties on a different thead", ^{
            waitUntil(^(DoneCallback done) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    
                    NSString *newFirstName = @"Max";
                    NSString *newLastName = @"Pattison";
                    
                    [personKey updateRealmObject:^(SMWRealmPerson *object, RLMRealm *realm) {
                        object.firstName = newFirstName;
                        object.lastName = newLastName;
                    }];
                    
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    
                        [personKey readRealmObject:^(SMWRealmPerson *object) {
                            expect(newFirstName).to.match(object.firstName);
                            expect(newLastName).to.match(object.lastName);
                            expect(defaultLastName).toNot.match(object.lastName);
                            expect(defaultFirstName).toNot.match(object.firstName);
                        }];
                        
                         done();
                    });
                });
            });
        });
        
    });
    
    it(@"can delete the realm object", ^{
        waitUntil(^(DoneCallback done) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                [personKey deleteRealmObject];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    [personKey readRealmObject:^(SMWRealmPerson * _Nullable object) {
                        expect(object).to.beNil();
                    }];
                    
                    done();
                });
            });
        });

    });
    
});

SpecEnd
