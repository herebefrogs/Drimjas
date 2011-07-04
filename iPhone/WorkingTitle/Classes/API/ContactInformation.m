// 
//  ContactInformation.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-04-02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactInformation.h"
// API
#import "ClientInformation.h"
// Objective-C


@implementation ContactInformation 

@dynamic name;
@dynamic phone;
@dynamic email;
@dynamic clientInfo;

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
