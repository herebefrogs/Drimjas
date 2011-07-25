//
//  PageInfo.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-07-24.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PageInfo : NSObject {
	CGRect pageSize;			// page format (Letter or A4) best fitting user's Region Format setting (margin including)

	NSUInteger margin;			// margins in points around drawable area of page
	NSUInteger linePadding;		// vertical padding in points between 2 lines
	NSUInteger labelPadding;	// horizontal padding in points between label & value columns

	CGRect contentRect;				// area where text can be rendered (typically page size with margins removed)
	NSUInteger x, y;				// current position in page
	NSUInteger maxWidth, maxHeight;	// current maximum area where text can be rendered (typically content rect with x & y removed)
	NSUInteger maxTextWidth, maxtTextHeight; // maximume width & height encountered in a text rendered so far

	UIFont *plainFont;
	UIFont *boldFont;
}

@property (nonatomic, readonly) CGRect pageSize;
@property (nonatomic, readonly) NSUInteger margin;
@property (nonatomic, readonly) NSUInteger linePadding;
@property (nonatomic, readonly) NSUInteger labelPadding;
@property (nonatomic, assign) NSUInteger x;
@property (nonatomic, assign) NSUInteger y;
@property (nonatomic, assign) CGRect contentRect;
@property (nonatomic, assign) NSUInteger maxWidth;
@property (nonatomic, assign) NSUInteger maxHeight;
@property (nonatomic, readonly) CGSize maxSize;
@property (nonatomic, assign) NSUInteger maxTextWidth;
@property (nonatomic, assign) NSUInteger maxTextHeight;
@property (nonatomic, retain) UIFont *plainFont;
@property (nonatomic, retain) UIFont *boldFont;

- (void)drawTextLeftAlign:(NSString *)text;

@end