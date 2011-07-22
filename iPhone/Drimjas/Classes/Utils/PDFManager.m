//
//  PDFManager.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-01-31.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "PDFManager.h"
#import <CoreGraphics/CoreGraphics.h>
#import <CoreText/CoreText.h>
// API
#import "ClientInfo.h"
#import "DataStore.h"
#import "Estimate.h"
#import "KeyValue.h"
#import "MyInfo.h"
// Utils
#import "DrimjasInfo.h"

@implementation PDFManager


NSUInteger MARGIN = 72;				// 72 pt = 1 inch = 2.54 cm
NSUInteger PLAIN_FONT_SIZE = 10;
NSUInteger LINE_PADDING = 2;		// vertical padding between 2 lines
NSUInteger LABEL_PADDING = 10;		// horizontal padding between key & value columns

#pragma mark -
#pragma mark Internal utility messages implementation

+ (CGRect)paperSizeForUserLocale {
	NSString *countryCode = [[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleCountryCode];
	NSLog(@"country code: %@", countryCode);

	// assumes United States and Canada are on Letter paper
	// while the rest of the world is on ISO A4 paper
	if ([countryCode isEqualToString:@"US"] || [countryCode isEqualToString:@"CA"]) {
		return CGRectMake(0, 0, 612, 792);
	} else {
		// approximation based on 72pt/inch and 25.4mm/inch
		return CGRectMake(0, 0, 595, 842);
	}
}

// Use Core Text to draw the text in a frame on the page.
+ (CFRange)renderPage:(NSInteger)pageNum withTextRange:(CFRange)currentRange
	   andFramesetter:(CTFramesetterRef)framesetter {

	// Get the graphics context.
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
	
	// Put the text matrix into a known state. This ensures
	// that no old scaling factors are left in place.
	CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
	
	// Create a path object to enclose the text. Use 72 point
	// margins all around the text.
	CGRect    frameRect = CGRectMake(72, 72, 468, 648);
	CGMutablePathRef framePath = CGPathCreateMutable();
	CGPathAddRect(framePath, NULL, frameRect);
	
	// Get the frame that will do the rendering.
	// The currentRange variable specifies only the starting point. The framesetter
	// lays out as much text as will fit into the frame.
	CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
	CGPathRelease(framePath);
	
	// Core Text draws from the bottom-left corner up, so flip
	// the current transform prior to drawing.
	CGContextTranslateCTM(currentContext, 0, 792);
	CGContextScaleCTM(currentContext, 1.0, -1.0);
	
	// Draw the frame.
	CTFrameDraw(frameRef, currentContext);
	
	// Update the current range based on what was drawn.
	currentRange = CTFrameGetVisibleStringRange(frameRef);
	currentRange.location += currentRange.length;
	currentRange.length = 0;
	CFRelease(frameRef);
	
	return currentRange;
}

+ (void)_drawPageNumber:(NSInteger)pageNum {
	NSString* pageString = [NSString stringWithFormat:@"Page %d", pageNum];
	UIFont* theFont = [UIFont systemFontOfSize:12];
	CGSize maxSize = CGSizeMake(612, 72);
	
	CGSize pageStringSize = [pageString sizeWithFont:theFont
								   constrainedToSize:maxSize
                                       lineBreakMode:UILineBreakModeClip];
	CGRect stringRect = CGRectMake(((612.0 - pageStringSize.width) / 2.0),
								   720.0 + ((72.0 - pageStringSize.height) / 2.0) ,
								   pageStringSize.width,
								   pageStringSize.height);
	
	[pageString drawInRect:stringRect withFont:theFont];
}

+ (CGPoint)_renderClientInfo:(ClientInfo *)clientInfo withPage:(CGRect)page {
	UIFont *plainFont = [UIFont systemFontOfSize:PLAIN_FONT_SIZE];

	NSUInteger x = MARGIN;
	NSUInteger y = MARGIN;
	NSUInteger maxKeyWidth = 0;
	NSUInteger maxHeight = PLAIN_FONT_SIZE + LINE_PADDING;
	// no wider than half the page (margins not included), no taller than 1 margin
	CGSize maxSize = CGSizeMake(CGRectGetWidth(page)/2 - MARGIN, maxHeight);

	NSArray *properties = [clientInfo nonEmptyProperties];
	// place all property names first
	for (KeyValue *pair in properties) {
		NSString *clientProperty = [NSString stringWithFormat:@"client.%@", pair.key];
		NSString *text = NSLocalizedString(clientProperty, "Property name");

		CGSize textSize = [text sizeWithFont:plainFont constrainedToSize:maxSize lineBreakMode:UILineBreakModeTailTruncation];

		CGRect textPath = CGRectMake(x, y, textSize.width, textSize.height);

		[text drawInRect:textPath withFont:plainFont];

		y += textSize.height + LINE_PADDING;
		maxKeyWidth = MAX(maxKeyWidth, textSize.width);
	}

	x += maxKeyWidth + LABEL_PADDING;
	y = MARGIN;
	NSUInteger maxValueWidth = 0;
	// line up all property values vertically
	maxSize.width -= x;
	for (KeyValue *pair in properties) {
		NSString *text = pair.value;
		// TODO put this in a method
		CGSize textSize = [text sizeWithFont:plainFont constrainedToSize:maxSize lineBreakMode:UILineBreakModeTailTruncation];

		CGRect textPath = CGRectMake(x, y, textSize.width, textSize.height);

		[text drawInRect:textPath withFont:plainFont];

		y += textSize.height + LINE_PADDING;
		maxValueWidth = MAX(maxValueWidth, textSize.width);
	}

	return CGPointMake(x + maxValueWidth, y);
}

#pragma mark -
#pragma mark Public protocol implementation

+ (NSMutableData *)pdfDataForEstimate:(Estimate *)estimate {
	NSMutableData *pdfData = [[[NSMutableData alloc] initWithCapacity: 1024] autorelease];

	CGRect page = [self paperSizeForUserLocale];
	// start PDF data
	UIGraphicsBeginPDFContextToData(pdfData, page, [self pdfInfoForEstimate:estimate]);

	// open new page
	UIGraphicsBeginPDFPageWithInfo(page, nil);

	[PDFManager _renderClientInfo:estimate.clientInfo withPage:page];
	[PDFManager _drawPageNumber:1];

	// end PDF data
	UIGraphicsEndPDFContext();

	return pdfData;
}

+ (BOOL)savePDFFileForEstimate:(Estimate *)estimate {
	NSString *pdfPath = [PDFManager getPDFPathForEstimate:estimate];
	NSData *pdfData = [[PDFManager pdfDataForEstimate:estimate] retain];

	BOOL written = [pdfData writeToFile:pdfPath atomically:NO];
	[pdfData release];

	return written;
}

+ (NSString *)getPDFNameForEstimate:(Estimate *)estimate {
	return [NSString stringWithFormat:@"%@-%@.pdf",
				estimate.orderNumber,
				NSLocalizedString(@"Estimate", @"Estimate PDF Filename")];
}

+ (NSString *)getPDFPathForEstimate:(Estimate *)estimate {
	// locate application's Documents directory
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* path = [paths objectAtIndex:0];

	// replace Documents by application's tmp directory
	path = [[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"tmp"];

	return [path stringByAppendingPathComponent:[PDFManager getPDFNameForEstimate:estimate]];
				
}

+ (NSString *)pdfTitleForEstimate:(Estimate *)estimate {
	return [NSString stringWithFormat:@"%@ #%@",
				NSLocalizedString(@"Estimate", @"Estimate PDF Title"),
			estimate.orderNumber];
}

+ (NSDictionary *)pdfInfoForEstimate:(Estimate *)estimate {
	DataStore *dataStore = [DataStore defaultStore];

	return [NSDictionary dictionaryWithObjectsAndKeys:
				[[dataStore myInfo] name], kCGPDFContextAuthor,
				[DrimjasInfo title], kCGPDFContextCreator,
				[self pdfTitleForEstimate:estimate], kCGPDFContextTitle,
				nil];
}

@end
