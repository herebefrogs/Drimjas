//
//  ClientInfo.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-03-27.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  Apache 2 License
//

#import <CoreData/CoreData.h>
// API
#import "BaseObject.h"

@class Estimate;
@class ContactInfo;

@interface ClientInfo : BaseObject {
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address1;
@property (nonatomic, strong) NSString *address2;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *postalCode;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSSet *contactInfos;
@property (nonatomic, strong) NSSet *estimates;

@property (weak, nonatomic, readonly) NSArray *nonEmptyProperties;
@property (nonatomic, readonly) NSInteger countNonEmptyProperties;
- (NSString *)nonEmptyPropertyWithIndex:(NSUInteger)index;

- (ContactInfo *)contactInfoAtIndex:(NSUInteger)index;
- (void)bindContactInfo:(ContactInfo *)contactInfo;
- (void)unbindContactInfo:(ContactInfo *)contactInfo;

@property (weak, nonatomic, readonly) NSArray *toRecipients;
@property (nonatomic, readonly) BOOL shouldBeDeleted;

@end


@interface ClientInfo (CoreDataGeneratedAccessors)

- (void)addContactInfosObject:(ContactInfo *)value;
- (void)removeContactInfosObject:(ContactInfo *)value;
- (void)addContactInfos:(NSSet *)value;
- (void)removeContactInfos:(NSSet *)value;

- (void)addEstimatesObject:(Estimate *)value;
- (void)removeEstimatesObject:(Estimate *)value;
- (void)addEstimates:(NSSet *)value;
- (void)removeEstimates:(NSSet *)value;

@end