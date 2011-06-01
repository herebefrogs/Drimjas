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
	NSInteger count = 0;

	if (self.name.length > 0) {
		count++;
	}
	if (self.phone.length > 0) {
		count++;
	}
	if (self.email.length > 0) {
		count++;
	}

	return count;
}

- (NSString *)getSetPropertyWithIndex:(NSInteger)index {
	if (self.name.length > 0) {
		if (index == 0) {
			return self.name;
		}
		index--;
	}
	if (self.phone.length > 0) {
		if (index == 0) {
			return self.phone;
		}
		index--;
	}
	if (self.email.length > 0) {
		if (index == 0) {
			return self.email;
		}
		index--;
	}
	return nil;
}

@end
