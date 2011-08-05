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
@synthesize sectionPadding;
@synthesize contentRect;
@synthesize x;
@synthesize y;
@synthesize maxWidth;
@synthesize maxHeight;
@synthesize plainFont;
@synthesize boldFont;
@synthesize bigBoldFont;


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
		self.plainFont = [UIFont systemFontOfSize:8];
		self.boldFont = [UIFont boldSystemFontOfSize:8];
		self.bigBoldFont = [UIFont boldSystemFontOfSize:10];

		pageSize = [PageInfo _initPageSize];
		margin = 72;					// 72 pt = 1 inch = 2.54 cm
		linePadding = 2;
		sectionPadding = plainFont.pointSize + 2*linePadding;

		self.contentRect = CGRectMake(margin, margin, CGRectGetWidth(pageSize) - 2*margin, CGRectGetHeight(pageSize) - 2*margin);
		self.x = contentRect.origin.x;
		self.y = contentRect.origin.y;
		self.maxWidth = CGRectGetWidth(contentRect);
		self.maxHeight = CGRectGetHeight(contentRect);
	}
	return self;
}

- (CGSize)maxSize {
	return CGSizeMake(maxWidth, maxHeight);
}

- (CGSize)drawTextLeftAlign:(NSString *)text {
	return [self drawTextLeftAlign:text withFont:plainFont];
}

- (CGSize)drawTextLeftAlign:(NSString *)text withFont:(UIFont*)font {
	NSAssert(font != nil, @"can't draw left align text with nil font");

	CGSize textSize = [text sizeWithFont:font constrainedToSize:self.maxSize lineBreakMode:UILineBreakModeWordWrap];

	CGRect textPath = CGRectMake(x, y, textSize.width, textSize.height);

	[text drawInRect:textPath withFont:font];

	return textSize;
}

- (CGSize)drawTextRightAlign:(NSString *)text {
	return [self drawTextRightAlign:text withFont:plainFont];
}

- (CGSize)drawTextRightAlign:(NSString *)text withFont:(UIFont *)font {
	NSAssert(font != nil, @"can't draw right align text with nil font");

	CGSize textSize = [text sizeWithFont:font constrainedToSize:self.maxSize lineBreakMode:UILineBreakModeWordWrap];

	NSUInteger xFromRight = x + self.maxSize.width - textSize.width;

	CGRect textPath = CGRectMake(xFromRight, y, textSize.width, textSize.height);

	[text drawInRect:textPath withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentRight];

	return textSize;
}


- (void)dealloc {
	[plainFont release];
	[boldFont release];
	[bigBoldFont release];
	[super dealloc];
}

@end

