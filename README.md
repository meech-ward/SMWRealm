# SMWRealm

[![CI Status](https://img.shields.io/travis/meech-ward/SMWRealm.svg)](https://travis-ci.org/meech-ward/SMWRealm)
[![Version](https://img.shields.io/cocoapods/v/SMWRealm.svg?style=flat)](http://cocoapods.org/pods/SMWRealm)
[![License](https://img.shields.io/cocoapods/l/SMWRealm.svg?style=flat)](http://cocoapods.org/pods/SMWRealm)
[![Platform](https://img.shields.io/cocoapods/p/SMWRealm.svg?style=flat)](http://cocoapods.org/pods/SMWRealm)



SMWRealm makes it even easier to create, read, update, and delete RLMObjects from different threads. 
Simply pass around the SMWRealmKey object betweeen different threads, and use its methods to communicate with its RLMObject.
This takes the thinking out of mulithreading with Realm.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

SMWRealm requires iOS 7.0 and above or OS X 10.9 and above.

SMWRealm also requires the thirdy-party open source library [Realm](https://realm.io/)

## Examples

To run the example project run ```git clone https://github.com/meech-ward/SMWRealm.git```  
Then open the Example directory and run ```pod install```  
Now you can open and run the project in Example/SMWRealm.xcworkspace.

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

``` objective-c
Person *person = [[Person alloc] init];
person.firstName = @"Sam";
person.lastName = @"Meech-Ward";
```  
Then save to a realm using the SMWRealmKey object  
``` objective-c
RLMRealm *realm = [RLMRealm defaultRealm];
SMWRealmKey<Person *> *personKey = [SMWRealmKey createOrUpdateObject:person inRealm:realm];
```   
Now you can pass this SMWRealmKey object around different threads and use its methods to read and update the RLMObject.  
``` objective-c
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
  [personKey updateRealmObject:^(SMWRealmPerson *object, RLMRealm *realm) {
    object.firstName = @"New First Name";
    object.lastName = @"New Last Name";
  }];
});
```

#### SMWRealmKey methods  
``` objective-c
- (instancetype)initWithRealmObject:(RLMObject *)realmObject;
- (void)readRealmObject:(void(^)(RLMObjectType _Nullable object))block;
- (void)updateRealmObject:(void(^)(RLMObjectType _Nullable object, RLMRealm * _Nullable realm))block;
- (void)deleteRealmObject;
- (BOOL)isEqualToKey:(nullable id)object;
```  

When deleting related objects, it's convenient to use the update function  
``` objective-c
[key updateRealmObject:^(Person * _Nullable object, RLMRealm * _Nullable realm) {
    Dog *dog = person.dog;
    [realm deleteObjects:@[person, dog]];
}];
```

