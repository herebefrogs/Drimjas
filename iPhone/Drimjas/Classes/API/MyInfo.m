//
//  MyInfo.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-06-26.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  GPLv3
//

#import "MyInfo.h"
// API
#import "ClientInfo.h"
#import "ContactInfo.h"
#import "DataStore.h"

@implementation MyInfo

@dynamic fax;
@dynamic profession;
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

- (BOOL)isReady {
	return (self.name.length > 0) && (self.email.length > 0);
}

+ (BOOL)isReadyForEstimate {
	return [[[DataStore defaultStore] myInfo] isReady];
}

+ (BOOL)isReadyForContract {
    MyInfo *myInfo = [[DataStore defaultStore] myInfo];
	return [myInfo isReady] && (myInfo.profession.length > 0);
}


- (ContactInfo *)contactInfo {
	NSAssert([[self.contactInfos allObjects] count] > 0, @"No contact info created");
	NSAssert([[self.contactInfos allObjects] count] < 2, @"More than 1 contact info created");

	return (ContactInfo *)[[self.contactInfos allObjects] objectAtIndex:0];
}

- (NSArray *)allPropertyNames {
    // leave aside "profession" since it doesn't appear on any PDF
	return [NSArray arrayWithObjects:@"name", @"address1", @"address2", @"city", @"state", @"postalCode", @"country",
									 @"phone", @"fax", @"email", @"website", nil];
}

@end
