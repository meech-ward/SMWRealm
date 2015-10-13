//
//  SMWViewController.m
//  SMWRealm
//
//  Created by Sam Meech-Ward on 10/12/2015.
//  Copyright (c) 2015 Sam Meech-Ward. All rights reserved.
//

#import "SMWViewController.h"
#import <SMWRealm/SMWRealm.h>
#import "SMWRealmPerson.h"

@interface SMWViewController ()

/// Displays the user's full name.
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation SMWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self realm];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)realm {
    // Create a new person object
    SMWRealmPerson *person = [[SMWRealmPerson alloc] init];
    person.key = [[NSUUID UUID] UUIDString];
    
    // Save it to the default realm
    SMWRealmKey<SMWRealmPerson *> *personKey = [SMWRealmKey createOrUpdateObject:person inRealm:[RLMRealm defaultRealm]];
    // Use this personKey object to represent the person accross different threads
    
    NSLog(@"Current Thread: %@", [NSThread currentThread]);
    
    // Update the person's name on a background queue
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [personKey updateRealmObject:^(SMWRealmPerson *object, RLMRealm *realm) {
            object.firstName = @"First";
            object.lastName = @"Last";
        }];
        NSLog(@"Current Thread: %@", [NSThread currentThread]);
        
        // Read the properies back on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [personKey readRealmObject:^(SMWRealmPerson *object) {
                NSString *fullName = [NSString stringWithFormat:@"%@ %@", object.firstName, object.lastName];
                self.nameLabel.text = fullName;
            }];
            NSLog(@"Current Thread: %@", [NSThread currentThread]);
            
            // Delete the object on a background thread
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                [personKey deleteRealmObject];
                NSLog(@"Current Thread: %@", [NSThread currentThread]);
                
                // Make sure the object was deleted
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSLog(@"Current Thread: %@", [NSThread currentThread]);
                    [personKey readRealmObject:^(SMWRealmPerson *object) {
                        if (!object) {
                            NSLog(@"Sucessfully deleted person");
                        }
                    }];
                });
                
            });
        });
        
    });
}

@end
