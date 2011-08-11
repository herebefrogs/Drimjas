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
	NSUInteger pageNo;			// current page number

	CGFloat margin;				// margins in points around drawable area of page
	CGFloat linePadding;		// vertical padding in points between 2 lines
	CGFloat sectionPadding;		// vertical padding in points between 2 groups of lines
	CGFloat tablePadding;		// top/bottom/left/right padding inside a table cell

	CGRect bounds;				// area where text can be rendered (typically page size with margins removed)
	CGFloat x, y;				// current position in page
	CGFloat maxWidth, maxHeight;	// current maximum area where text can be rendered (typically content rect with x & y removed)

	UIFont *plainFont;
	UIFont *boldFont;
	UIFont *bigBoldFont;

	CGFloat labelWidth;				// base width for client/contact info labels
	CGFloat clientOrMyInfoWidth;	// base width for client/contact/my info values
}

@property (nonatomic, readonly) CGRect pageSize;
@property (nonatomic, readonly) NSUInteger pageNo;
@property (nonatomic, readonly) CGFloat margin;
@property (nonatomic, readonly) CGFloat linePadding;
@property (nonatomic, readonly) CGFloat sectionPadding;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGRect bounds;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, readonly) CGSize maxSize;
@property (nonatomic, retain) UIFont *plainFont;
@property (nonatomic, retain) UIFont *boldFont;
@property (nonatomic, retain) UIFont *bigBoldFont;
@property (nonatomic, readonly) CGFloat labelWidth;
@property (nonatomic, readonly) CGFloat clientOrMyInfoWidth;

- (NSUInteger)openNewPage;

- (CGSize)drawTextLeftJustified:(NSString *)text;
- (CGSize)drawTextLeftJustified:(NSString *)text padding:(CGFloat)padding;
- (CGSize)drawTextLeftJustified:(NSString *)text font:(UIFont *)font;
- (CGSize)drawTextLeftJustified:(NSString *)text font:(UIFont *)font padding:(CGFloat)padding;

- (CGSize)drawTextRightJustified:(NSString *)text;
- (CGSize)drawTextRightJustified:(NSString *)text padding:(CGFloat)padding;
- (CGSize)drawTextRightJustified:(NSString *)text font:(UIFont *)font;
- (CGSize)drawTextRightJustified:(NSString *)text font:(UIFont *)font padding:(CGFloat)padding;

- (CGSize)drawTextMiddleJustified:(NSString *)text;
- (CGSize)drawTextMiddleJustified:(NSString *)text padding:(CGFloat)padding;
- (CGSize)drawTextMiddleJustified:(NSString *)text font:(UIFont *)font;
- (CGSize)drawTextMiddleJustified:(NSString *)text font:(UIFont *)font padding:(CGFloat)padding;

@end