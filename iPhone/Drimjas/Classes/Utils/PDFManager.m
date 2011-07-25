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
#import "PageInfo.h"


@implementation PDFManager


#pragma mark -
#pragma mark Internal utility messages implementation

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

+ (void)_pageInfo:(PageInfo *)pageInfo drawPageNumber:(NSInteger)pageNum {
	NSString* pageString = [NSString stringWithFormat:@"%@ %d", NSLocalizedString(@"Page", "Page number on footer of PDF"), pageNum];
	UIFont* theFont = [UIFont systemFontOfSize:12];
	CGSize maxSize = CGSizeMake(CGRectGetWidth(pageInfo.pageSize), 72);
	
	CGSize pageStringSize = [pageString sizeWithFont:theFont
								   constrainedToSize:maxSize
                                       lineBreakMode:UILineBreakModeClip];
	CGRect stringRect = CGRectMake(((CGRectGetWidth(pageInfo.pageSize) - pageStringSize.width) / 2.0),
								   720.0 + ((72.0 - pageStringSize.height) / 2.0) ,
								   pageStringSize.width,
								   pageStringSize.height);
	
	[pageString drawInRect:stringRect withFont:theFont];
}

+ (void)_pageInfo:(PageInfo *)pageInfo renderClientInfo:(ClientInfo *)clientInfo {
	NSArray *properties = [clientInfo nonEmptyProperties];

	// place all property names first on half content width, all content height
	pageInfo.maxWidth /= 2;
	for (KeyValue *pair in properties) {
		NSString *clientProperty = [NSString stringWithFormat:@"client.%@", pair.key];
		[pageInfo drawTextLeftAlign:NSLocalizedString(clientProperty, "Property name")];
	}

	// line up all property values vertically
	pageInfo.x += pageInfo.maxTextWidth + pageInfo.labelPadding;
	pageInfo.y = pageInfo.margin;
	pageInfo.maxWidth -= pageInfo.x;
	pageInfo.maxTextWidth = 0;
	for (KeyValue *pair in properties) {
		[pageInfo drawTextLeftAlign:pair.value];
	}

	pageInfo.x += pageInfo.maxTextWidth;
}

#pragma mark -
#pragma mark Public protocol implementation

+ (NSMutableData *)pdfDataForEstimate:(Estimate *)estimate {
	NSMutableData *pdfData = [[[NSMutableData alloc] initWithCapacity: 1024] autorelease];

	// start PDF data
	PageInfo *pageInfo = [[PageInfo alloc] init];
	UIGraphicsBeginPDFContextToData(pdfData, pageInfo.pageSize, [self pdfInfoForEstimate:estimate]);

	// open new page
	UIGraphicsBeginPDFPageWithInfo(pageInfo.pageSize, nil);

	[PDFManager _pageInfo:pageInfo renderClientInfo:estimate.clientInfo];
	[PDFManager _pageInfo:pageInfo drawPageNumber:1];

	// end PDF data
	UIGraphicsEndPDFContext();
	[pageInfo release];

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
