//
//  MyInfo.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-06-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyInfo.h"
// API
#import "ClientInformation.h"
#import "ContactInformation.h"
#import "DataStore.h"

@implementation MyInfo

@dynamic businessNumber;
@dynamic fax;
@dynamic website;


- (void)awakeFromInsert {
	[super awakeFromInsert];
	
	self.subEntityName = @"MyInfo";
}

- (ContactInformation *)contactInfo {
	NSAssert([[self.contactInfos allObjects] count] > 0, @"No contact info created");
	NSAssert([[self.contactInfos allObjects] count] < 2, @"More than 1 contact info created");

	return (ContactInformation *)[[self.contactInfos allObjects] objectAtIndex:0];
}

+ (BOOL)isMyInfoSet {
	return StatusActive == [[[[DataStore defaultStore] myInfo] status] intValue];
}

@end
