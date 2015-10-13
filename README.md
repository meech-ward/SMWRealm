# SMWRealm

[![CI Status](http://img.shields.io/travis/Sam Meech-Ward/SMWRealm.svg?style=flat)](https://travis-ci.org/Sam Meech-Ward/SMWRealm)
[![Version](https://img.shields.io/cocoapods/v/SMWRealm.svg?style=flat)](http://cocoapods.org/pods/SMWRealm)
[![License](https://img.shields.io/cocoapods/l/SMWRealm.svg?style=flat)](http://cocoapods.org/pods/SMWRealm)
[![Platform](https://img.shields.io/cocoapods/p/SMWRealm.svg?style=flat)](http://cocoapods.org/pods/SMWRealm)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

SMWRealm requires iOS 7.0 and above or OS X 10.9 and above.

SMWRealm also requires the thirdy-party open source library [Realm](https://realm.io/)

## Installation

SMWRealm is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SMWRealm"
```

## Author

Sam Meech-Ward, sam@meech-ward.com

## License

SMWRealm is available under the MIT license. See the LICENSE file for more info.

## How to use

Any RLMObject that uses the SMWRealmKey must have a valid primary key.

Import the SMWRealm header


    #import <SMWRealm/SMWRealm.h>

Setup your RLMObject as normal.

    Person *person = [[Person alloc] init];
    person.firstName = @"Sam";
    person.lastName = @"Meech-Ward";
Then save to a realm using the smw save method which returns a realm key object

    RLMRealm *realm = [RLMRealm defaultRealm];
    SMWRealmKey<Person *> *personKey = [person smw_createOrUpdateInRealm:realm];
Now you can pass this SMWRealmKey object around different threads and use its methods to read and update the RLMObject.

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
      [personKey updateRealmObject:^(SMWRealmPerson *object, RLMRealm *realm) {
        object.firstName = @"New First Name";
        object.lastName = @"New Last Name";
      }];
    });


#### SMWRealmKey methods

    - (instancetype)initWithRealmObject:(RLMObject *)realmObject;
    - (void)readRealmObject:(void(^)(RLMObjectType _Nullable object))block;
    - (void)updateRealmObject:(void(^)(RLMObjectType _Nullable object, RLMRealm * _Nullable realm))block;
    - (void)deleteRealmObject;
    - (BOOL)isEqualToKey:(nullable id)object;
