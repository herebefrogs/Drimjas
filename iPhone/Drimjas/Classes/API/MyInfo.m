//
//  MyInfo.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-06-26.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "MyInfo.h"
// API
#import "ClientInfo.h"
#import "ContactInfo.h"
#import "DataStore.h"

@implementation MyInfo

@dynamic fax;
@dynamic website;

- (NSString *)phone {
	return self.contactInfo.phone;
}

- (NSString *)email {
	return self.contactInfo.email;
}

- (void)awakeFromInsert {
	[super awakeFromInsert];
	
	self.subEntityName = @"MyInfo";
}

- (ContactInfo *)contactInfo {
	NSAssert([[self.contactInfos allObjects] count] > 0, @"No contact info created");
	NSAssert([[self.contactInfos allObjects] count] < 2, @"More than 1 contact info created");

	return (ContactInfo *)[[self.contactInfos allObjects] objectAtIndex:0];
}

+ (BOOL)isMyInfoSet {
	return StatusActive == [[[[DataStore defaultStore] myInfo] status] intValue];
}

- (NSArray *)allPropertyNames {
	return [NSArray arrayWithObjects:@"name", @"address1", @"address2", @"city", @"state", @"postalCode", @"country",
									 @"phone", @"fax", @"email", @"website", nil];
}

@end
