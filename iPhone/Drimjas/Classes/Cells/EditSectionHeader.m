//
//  EditSectionHeader.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-06-05.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "EditSectionHeader.h"


@implementation EditSectionHeader

@synthesize header;
@synthesize edit;

- (void)dealloc {
	[header release];
	[edit release];
    [super dealloc];
}


@end
