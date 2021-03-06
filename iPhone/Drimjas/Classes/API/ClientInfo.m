// 
//  ClientInfo.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-03-27.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  Apache 2 License
//

#import "ClientInfo.h"

// API
#import "ContactInfo.h"
#import "Estimate.h"
#import "KeyValue.h"

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

- (BOOL)isReady {
	if (self.name.length > 0) {
		for (ContactInfo* contactInfo in self.contactInfos) {
			if (contactInfo.isReady) {
				return YES;
			}
		}
	}
	return NO;
}

- (void)refreshStatus {
	NSNumber *oldStatus = self.status;

	[super refreshStatus];

	if (![oldStatus isEqualToNumber:self.status]) {
		// notify all underlying Estimates of the status change
		for (Estimate *estimate in self.estimates) {
			[estimate refreshStatus];
		}
	}

}

- (NSArray *)allPropertyNames {
	return [NSArray arrayWithObjects:@"name", @"address1", @"address2", @"city", @"state", @"postalCode", @"country", nil];
}

#pragma mark -
#pragma mark Public methods stack

- (BOOL)shouldBeDeleted {
	// if client has never been saved before (it's still a stub associated to a stub estimate)
	// or if in Draft state and associated to only 1 estimate or none (it won't be selectable
	// from existing clients screen or any other estimate)
	return (!self.isPersistent) || (!self.isReady && [[self valueForKeyPath:@"estimates.@count"] intValue] <= 1);
}

- (NSArray *)nonEmptyProperties {
	NSMutableArray *nonEmptyProperties = [NSMutableArray arrayWithCapacity:1];

	for (NSString *property in [self allPropertyNames]) {
		NSString *value = [self valueForKey:property];
		if (value.length > 0) {
			KeyValue *pair = [[KeyValue alloc] initWithKey:property value:value];
			[nonEmptyProperties addObject:pair];
		}
	}

	return nonEmptyProperties;
}

- (NSInteger)countNonEmptyProperties {
	NSInteger count = 0;

	for (NSString *property in [self allPropertyNames]) {
		NSString *value = [self valueForKey:property];
		if (value.length > 0) {
			count++;
		}
	}

	return count;
}

- (NSString *)nonEmptyPropertyWithIndex:(NSUInteger)index {
	for (NSString *property in [self allPropertyNames]) {
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
	// TODO keep in a transient property and refresh when (un)binding ContactInfo?
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
	ContactInfo *contactInfo = (ContactInfo *)[[self.contactInfos sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] objectAtIndex:index];

	return contactInfo;
}

- (void)bindContactInfo:(ContactInfo *)contactInfo {
	NSAssert(contactInfo, @"can't bind empty ContactInfo");

	contactInfo.clientInfo = self;
	[self addContactInfosObject:contactInfo];
	[self refreshStatus];
}

- (void)unbindContactInfo:(ContactInfo *)contactInfo {
	NSAssert(contactInfo, @"can't unbind empty ContactInfo");
	NSAssert(contactInfo.clientInfo == self, @"can't unbind ContactInfo which isn't bound to ClientInfo");

	contactInfo.clientInfo = nil;
	[self removeContactInfosObject:contactInfo];
	[self refreshStatus];
}

- (NSArray *)toRecipients {
	NSMutableArray *recipients = [NSMutableArray arrayWithCapacity:1];

	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
	for (ContactInfo *contact in [self.contactInfos sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]) {
		NSString *recipient = contact.toRecipient;
		if (recipient) {
			[recipients addObject:recipient];
		}
	}

	return recipients;
}

@end
