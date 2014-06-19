//
//  KeyValue.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-07-21.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  GPLv3
//

#import "KeyValue.h"


@implementation KeyValue

@synthesize key;
@synthesize value;

- (id)initWithKey:(id)newKey value:(id)newValue {
	self = [super init];
	if (self) {
		self.key = newKey;
		self.value = newValue;
	}
	return self;
}

@end
