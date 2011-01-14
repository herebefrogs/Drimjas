//
//  Estimate.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Estimate.h"


@implementation Estimate

@synthesize clientName;

- (id) initWithClientName:(NSString *)newClientName {
	self = [super init];
	if (self) {
		self.clientName = newClientName;
	}
	return self;
}

- (void)dealloc {
	[clientName release];
	[super dealloc];
}

@end
