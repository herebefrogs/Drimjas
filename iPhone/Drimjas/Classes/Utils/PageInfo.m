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
@synthesize pageNo;
@synthesize margin;
@synthesize linePadding;
@synthesize sectionPadding;
@synthesize bounds;
@synthesize x;
@synthesize y;
@synthesize maxWidth;
@synthesize maxHeight;
@synthesize plainFont;
@synthesize boldFont;
@synthesize bigBoldFont;
@synthesize labelWidth;
@synthesize clientOrMyInfoWidth;


+ (CGRect)_initPageSize {
	NSString *countryCode = [[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleCountryCode];

	// assumes United States and Canada are on Letter paper
	// while the rest of the world is on ISO A4 paper
	if ([countryCode isEqualToString:@"US"] || [countryCode isEqualToString:@"CA"]) {
		return CGRectMake(0.0, 0.0, 612.0, 792.0);
	} else {
		// A4 approximation based on 72pt/inch and 25.4mm/inch
		return CGRectMake(0.0, 0.0, 595.0, 842.0);
	}
}


- (id)init {
	self = [super init];
	if (self) {
		self.plainFont = [UIFont systemFontOfSize:8];
		self.boldFont = [UIFont boldSystemFontOfSize:8];
		self.bigBoldFont = [UIFont boldSystemFontOfSize:10];

		pageSize = [PageInfo _initPageSize];
		pageNo = 1;
		margin = 72.0;					// 72 pt = 1 inch = 2.54 cm
		linePadding = 2.0;
		sectionPadding = plainFont.pointSize + 2*linePadding;
		tablePadding = 0.0;

		bounds = CGRectMake(margin, margin, CGRectGetWidth(pageSize) - 2*margin, CGRectGetHeight(pageSize) - 2*margin);
		self.x = bounds.origin.x;
		self.y = bounds.origin.y;

		labelWidth = CGRectGetWidth(bounds) / 8;
		clientOrMyInfoWidth = CGRectGetWidth(bounds) * 7 / 16;
	}
	return self;
}

- (void)setX:(CGFloat)newX {
	x = newX;
	self.maxWidth = bounds.origin.x + CGRectGetWidth(bounds) - x;
}

- (void)setY:(CGFloat)newY {
	y = newY;
	self.maxHeight = bounds.origin.y + CGRectGetHeight(bounds) - y;
}

- (void)setMaxHeight:(CGFloat)newHeight {
	if (newHeight < 0) {
		// we've run out of height on this page, open a new one
		[self openNewPage];
		// reset y & height
		self.y = bounds.origin.y;
	}
	else {
		maxHeight = newHeight;
	}
}

- (CGSize)maxSize {
	CGFloat padding = 2*tablePadding;
	return CGSizeMake(maxWidth - padding, maxHeight - padding);
}

- (NSUInteger)openNewPage {
	UIGraphicsBeginPDFPage();
	return ++pageNo;
}

- (CGSize)drawTextLeftJustified:(NSString *)text {
	return [self drawTextLeftJustified:text font:plainFont];
}

- (CGSize)drawTextLeftJustified:(NSString *)text padding:(CGFloat)padding {
	return [self drawTextLeftJustified:text font:plainFont padding:padding];
}

- (CGSize)drawTextLeftJustified:(NSString *)text font:(UIFont *)font {
	return [self drawTextLeftJustified:text font:font padding: 0.0];
}

- (CGSize)drawTextLeftJustified:(NSString *)text font:(UIFont *)font padding:(CGFloat)padding {
	NSAssert(font != nil, @"can't draw left justified text with nil font");
	
	tablePadding = padding;

	CGSize textSize = [text sizeWithFont:font constrainedToSize:self.maxSize lineBreakMode:UILineBreakModeWordWrap];

	CGRect textPath = CGRectMake(x + tablePadding, y + tablePadding, textSize.width, textSize.height);

	[text drawInRect:textPath withFont:font];

	return textSize;
}

- (CGSize)drawTextRightJustified:(NSString *)text {
	return [self drawTextRightJustified:text font:plainFont];
}

- (CGSize)drawTextRightJustified:(NSString *)text padding:(CGFloat)padding {
	return [self drawTextRightJustified:text font:plainFont padding:padding];
}

- (CGSize)drawTextRightJustified:(NSString *)text font:(UIFont *)font {
	return [self drawTextRightJustified:text font:font padding:0.0];
}

- (CGSize)drawTextRightJustified:(NSString *)text font:(UIFont *)font padding:(CGFloat)padding {
	NSAssert(font != nil, @"can't draw right justified text with nil font");

	tablePadding = padding;

	CGSize textSize = [text sizeWithFont:font constrainedToSize:self.maxSize lineBreakMode:UILineBreakModeWordWrap];

	CGFloat xFromRight = x + self.maxWidth - textSize.width;

	CGRect textPath = CGRectMake(xFromRight - tablePadding, y + tablePadding, textSize.width, textSize.height);

	[text drawInRect:textPath withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentRight];

	return textSize;
}

- (CGSize)drawTextMiddleJustified:(NSString *)text {
	return [self drawTextMiddleJustified:text font:plainFont];
}

- (CGSize)drawTextMiddleJustified:(NSString *)text padding:(CGFloat)padding {
	return [self drawTextMiddleJustified:text font:plainFont padding:padding];
}

- (CGSize)drawTextMiddleJustified:(NSString *)text font:(UIFont *)font {
	return [self drawTextMiddleJustified:text font:font padding:0.0];
}

- (CGSize)drawTextMiddleJustified:(NSString *)text font:(UIFont *)font padding:(CGFloat)padding {
	NSAssert(font != nil, @"can't draw middle justified text with nil font");

	tablePadding = padding;

	CGSize textSize = [text sizeWithFont:font constrainedToSize:self.maxSize lineBreakMode:UILineBreakModeWordWrap];

	CGFloat xFromLeft = x + (self.maxWidth - textSize.width) / 2;

	CGRect textPath = CGRectMake(xFromLeft, y + tablePadding, textSize.width, textSize.height);

	[text drawInRect:textPath withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];

	return textSize;
}




@end

