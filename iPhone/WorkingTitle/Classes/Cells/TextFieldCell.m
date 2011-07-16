//
//  TextFieldCell.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-03-27.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "TextFieldCell.h"


@implementation TextFieldCell

@synthesize textField;

- (void)dealloc {
	[textField release];
    [super dealloc];
}


@end
