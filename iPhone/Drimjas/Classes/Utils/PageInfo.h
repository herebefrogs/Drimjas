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
	NSUInteger sectionPadding;	// vertical padding in points between 2 groups of lines

	CGRect contentRect;				// area where text can be rendered (typically page size with margins removed)
	NSUInteger x, y;				// current position in page
	NSUInteger maxWidth, maxHeight;	// current maximum area where text can be rendered (typically content rect with x & y removed)

	UIFont *plainFont;
	UIFont *boldFont;
	UIFont *bigBoldFont;
}

@property (nonatomic, readonly) CGRect pageSize;
@property (nonatomic, readonly) NSUInteger margin;
@property (nonatomic, readonly) NSUInteger linePadding;
@property (nonatomic, readonly) NSUInteger sectionPadding;
@property (nonatomic, assign) NSUInteger x;
@property (nonatomic, assign) NSUInteger y;
@property (nonatomic, assign) CGRect contentRect;
@property (nonatomic, assign) NSUInteger maxWidth;
@property (nonatomic, assign) NSUInteger maxHeight;
@property (nonatomic, readonly) CGSize maxSize;
@property (nonatomic, retain) UIFont *plainFont;
@property (nonatomic, retain) UIFont *boldFont;
@property (nonatomic, retain) UIFont *bigBoldFont;

- (CGSize)drawTextLeftAlign:(NSString *)text;
- (CGSize)drawTextLeftAlign:(NSString *)text withFont:(UIFont *)font;
- (CGSize)drawTextRightAlign:(NSString *)text;
- (CGSize)drawTextRightAlign:(NSString *)text withFont:(UIFont *)font;

@end