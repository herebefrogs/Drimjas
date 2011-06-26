//
//  MyInfo.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-06-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyInfo.h"


@implementation MyInfo

@dynamic businessNumber;
@dynamic fax;
@dynamic website;


- (void)awakeFromInsert {
	[super awakeFromInsert];
	
	self.subEntityName = @"MyInfo";
}

@end
