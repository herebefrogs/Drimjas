//
//  ClientInfo.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-03-27.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <CoreData/CoreData.h>
// API
#import "BaseObject.h"

@class Estimate;
@class ContactInfo;

@interface ClientInfo : BaseObject {
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *address1;
@property (nonatomic, retain) NSString *address2;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *postalCode;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSSet *contactInfos;
@property (nonatomic, retain) NSSet *estimates;

@property (nonatomic, readonly) NSArray *nonEmptyProperties;
@property (nonatomic, readonly) NSInteger countNonEmptyProperties;
- (NSString *)nonEmptyPropertyWithIndex:(NSUInteger)index;

- (ContactInfo *)contactInfoAtIndex:(NSUInteger)index;
- (void)bindContactInfo:(ContactInfo *)contactInfo;
- (void)unbindContactInfo:(ContactInfo *)contactInfo;

@property (nonatomic, readonly) NSArray *toRecipients;
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