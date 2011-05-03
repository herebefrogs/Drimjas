// 
//  ClientInformation.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-03-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ClientInformation.h"
// API
#import "Estimate.h"
#import "ContactInformation.h"

@implementation ClientInformation 

@dynamic name;
@dynamic address1;
@dynamic address2;
@dynamic city;
@dynamic state;
@dynamic postalCode;
@dynamic country;
@dynamic contactInfos;
@dynamic estimates;

#pragma mark -
#pragma mark Public methods stack

+ (BOOL)isNameValid:(NSString *)name {
	return (name != nil && name.length > 0);
}

- (NSInteger)numSetProperties {
	NSInteger count = 0;
	if (self.name != nil && self.name.length > 0) {
		count++;
	}
	if (self.address1 != nil && self.address1.length > 0) {
		count++;
	}
	if (self.address2 != nil && self.address2.length > 0) {
		count++;
	}
	if (self.city != nil && self.city.length > 0) {
		count++;
	}
	if (self.state != nil && self.state.length > 0) {
		count++;
	}
	if (self.postalCode != nil && self.postalCode.length > 0) {
		count++;
	}
	if (self.country != nil && self.country.length > 0) {
		count++;
	}
	return count;
}

- (NSString *)getSetPropertyWithIndex:(NSInteger)index {
	if (self.name != nil && self.name.length > 0) {
		if (index == 0) {
			return self.name;
		}
		index--;
	}
	if (self.address1 != nil && self.address1.length > 0) {
		if (index == 0) {
			return self.address1;
		}
		index--;
	}
	if (self.address2 != nil && self.address2.length > 0) {
		if (index == 0) {
			return self.address2;
		}
		index--;
	}
	if (self.city != nil && self.city.length > 0) {
		if (index == 0) {
			return self.city;
		}
		index--;
	}
	if (self.state != nil && self.state.length > 0) {
		if (index == 0) {
			return self.state;
		}
		index--;
	}
	if (self.postalCode != nil && self.postalCode.length > 0) {
		if (index == 0) {
			return self.postalCode;
		}
		index--;
	}
	if (self.country != nil && self.country.length > 0) {
		if (index == 0) {
			return self.country;
		}
		index--;
	}
	return nil;
}

@end
