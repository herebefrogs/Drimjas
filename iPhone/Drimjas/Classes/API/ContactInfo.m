// 
//  ContactInfo.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-04-02.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  GPLv3
//

#import "ContactInfo.h"
// API
#import "ClientInfo.h"
#import "KeyValue.h"


@implementation ContactInfo

@dynamic name;
@dynamic phone;
@dynamic email;
@dynamic clientInfo;


- (void)awakeFromInsert {
	[super awakeFromInsert];
	
	self.subEntityName = @"ContactInfo";
}

- (BOOL)isReady {
	return (self.email.length > 0);
}

- (void)refreshStatus {
	NSNumber *oldStatus = self.status;

	[super refreshStatus];

	if (![oldStatus isEqualToNumber:self.status]) {
		// notify underlying ClientInfo of the status change
		[self.clientInfo refreshStatus];
	}

}

- (NSArray *)allPropertyNames {
	return [NSArray arrayWithObjects:@"name", @"phone", @"email", nil];
}

#pragma mark -
#pragma mark Public methods stack

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

- (NSString *)nonEmptyPropertyWithIndex:(NSInteger)index {
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

- (NSString *)toRecipient {
	if (self.email.length > 0) {
		if (self.name.length > 0) {
			return [NSString stringWithFormat:@"%@ <%@>", self.name, self.email];
		}
		else {
			return self.email;
		}
	}
	return nil;
}

@end
