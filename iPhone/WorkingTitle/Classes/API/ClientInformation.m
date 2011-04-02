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

@end
