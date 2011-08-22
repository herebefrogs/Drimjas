// 
//  BaseObject.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-04-25.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "BaseObject.h"


@implementation BaseObject 

@dynamic subEntityName;
@dynamic status;

@dynamic isReady;
@synthesize isPersistent;

- (void)awakeFromInsert {
	self.isPersistent = NO;
}

- (void)awakeFromFetch {
	self.isPersistent = YES;
}

- (void)didSave {
	isPersistent = YES;
}

- (void)willSave {
	// update status just before being persisted to disk
	[self refreshStatus];
}

- (void)refreshStatus {
	// NOTE: if object is being deleted, change its status to Draft regardless of whether its requirements
	// are satisfied or not so that objects which depend on it can update their status correctly
	NSNumber *newStatus = [NSNumber numberWithInt:(self.isReady) && ![self isDeleted] ? StatusReady : StatusDraft];

	if (![self.status isEqualToNumber:newStatus]) {
		// only update status if different to avoid an infinite "willSave" notification loop
		self.status = newStatus;
	}
}

@end
