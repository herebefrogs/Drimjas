// 
//  ClientInfo.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-03-27.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "ClientInfo.h"

// API
#import "Estimate.h"
#import "ContactInfo.h"

@implementation ClientInfo 

@dynamic name;
@dynamic address1;
@dynamic address2;
@dynamic city;
@dynamic state;
@dynamic postalCode;
@dynamic country;
@dynamic contactInfos;
@dynamic estimates;


- (void)awakeFromInsert {
	[super awakeFromInsert];
	
	self.subEntityName = @"ClientInfo";
}

#pragma mark -
#pragma mark Public methods stack

+ (BOOL)isNameValid:(NSString *)name {
	return (name.length > 0);
}

- (NSInteger)numSetProperties {	
	NSArray *properties = [NSArray arrayWithObjects:@"name", @"address1", @"address2", @"city", @"state", @"postalCode", @"country", nil];

	NSInteger count = 0;
	for (NSString *property in properties) {
		NSString *value = [self valueForKey:property];
		if (value.length > 0) {
			count++;
		}
	}

	return count;
}

- (NSString *)getSetPropertyWithIndex:(NSUInteger)index {
	NSArray *properties = [NSArray arrayWithObjects:@"name", @"address1", @"address2", @"city", @"state", @"postalCode", @"country", nil];

	for (NSString *property in properties) {
		NSString *value = [self valueForKey:property];
		if (value.length > 0) {
			if (index == 0) {
				return value;
			}
			index--;
		}
	}

	return nil;
}

- (ContactInfo *)contactInfoAtIndex:(NSUInteger)index {
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
	ContactInfo *contactInfo = (ContactInfo *)[[self.contactInfos sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] objectAtIndex:index];
	[sortDescriptor release];

	return contactInfo;
}

- (void)bindContactInfo:(ContactInfo *)contactInfo {
	contactInfo.clientInfo = self;
	[self addContactInfosObject:contactInfo];
}

- (void)unbindContactInfo:(ContactInfo *)contactInfo {
	NSAssert(contactInfo.clientInfo == self, @"can't unbind ContactInfo which isn't bound to ClientInfo");

	contactInfo.clientInfo = nil;
	[self removeContactInfosObject:contactInfo];
}


@end
