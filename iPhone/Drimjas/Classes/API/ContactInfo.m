// 
//  ContactInfo.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-04-02.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "ContactInfo.h"
// API
#import "ClientInfo.h"


@implementation ContactInfo

@dynamic name;
@dynamic phone;
@dynamic email;
@dynamic clientInfo;


- (void) awakeFromInsert {
	[super awakeFromInsert];
	
	self.subEntityName = @"ContactInfo";
}

- (NSInteger)numSetProperties {
	NSArray *properties = [NSArray arrayWithObjects:@"name", @"phone", @"email", nil];
	
	NSInteger count = 0;
	for (NSString *property in properties) {
		NSString *value = [self valueForKey:property];
		if (value.length > 0) {
			count++;
		}
	}
	
	return count;
}

- (NSString *)getSetPropertyWithIndex:(NSInteger)index {
	NSArray *properties = [NSArray arrayWithObjects:@"name", @"phone", @"email", nil];
	
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

@end
