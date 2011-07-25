//
//  PageInfo.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-07-24.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "PageInfo.h"


@implementation PageInfo


@synthesize pageSize;
@synthesize margin;
@synthesize linePadding;
@synthesize labelPadding;
@synthesize contentRect;
@synthesize x;
@synthesize y;
@synthesize maxWidth;
@synthesize maxHeight;
@synthesize maxTextWidth;
@synthesize maxTextHeight;
@synthesize plainFont;
@synthesize boldFont;


+ (CGRect)_initPageSize {
	NSString *countryCode = [[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleCountryCode];

	// assumes United States and Canada are on Letter paper
	// while the rest of the world is on ISO A4 paper
	if ([countryCode isEqualToString:@"US"] || [countryCode isEqualToString:@"CA"]) {
		return CGRectMake(0, 0, 612, 792);
	} else {
		// A4 approximation based on 72pt/inch and 25.4mm/inch
		return CGRectMake(0, 0, 595, 842);
	}
}


- (id)init {
	self = [super init];
	if (self) {
		pageSize = [PageInfo _initPageSize];
		margin = 72;					// 72 pt = 1 inch = 2.54 cm
		linePadding = 2;
		labelPadding = 10;

		self.contentRect = CGRectMake(margin, margin, CGRectGetWidth(pageSize), CGRectGetHeight(pageSize));
		self.x = margin;
		self.y = margin;
		self.maxWidth = CGRectGetWidth(contentRect);
		self.maxHeight = CGRectGetHeight(contentRect);
		self.maxTextWidth = 0;
		self.maxTextHeight = 0;

		self.plainFont = [UIFont systemFontOfSize:10];
		self.boldFont = [UIFont boldSystemFontOfSize:10];
	}
	return self;
}

- (CGSize)maxSize {
	return CGSizeMake(maxWidth, maxHeight);
}

- (void)drawTextLeftAlign:(NSString *)text {
	CGSize textSize = [text sizeWithFont:plainFont constrainedToSize:self.maxSize lineBreakMode:UILineBreakModeTailTruncation];

	CGRect textPath = CGRectMake(x, y, textSize.width, textSize.height);

	[text drawInRect:textPath withFont:plainFont];

	y += textSize.height + linePadding;
	maxHeight -= textSize.height + linePadding;

	maxTextWidth = MAX(maxTextWidth, textSize.width);
	maxTextHeight = MAX(maxTextHeight, textSize.height);
}



- (void)dealloc {
	[plainFont release];
	[boldFont release];
	[super dealloc];
}

@end

