//
//  PDFManager.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-31.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PDFManager.h"
#import <CoreGraphics/CoreGraphics.h>
#import <CoreText/CoreText.h>
#import "Estimate.h"


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

+ (void)drawPageNumber:(NSInteger)pageNum {
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

#pragma mark -
#pragma mark Public protocol implementation

+ (NSMutableData *)getPDFDataForEstimate:(Estimate *)estimate {
	NSMutableData *pdfData = [[NSMutableData alloc] initWithCapacity: 1024];

	// prepare estimate text
	CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, (CFStringRef)estimate.clientName, NULL);
	if (currentText == NULL) {
		NSLog(@"Could not create the attributed string for the framesetter");
	} else {
		// prepare text formatter
		CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
		if (framesetter == NULL) {
			NSLog(@"Could not create the framesetter needed to lay out the atrributed string.");
		} else {
			// start PDF data
			UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil);

			CFRange currentRange = CFRangeMake(0, 0);
			NSInteger currentPage = 0;
			BOOL saved = NO;

			do {
				// open new page (Letter format)
				UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);

				// keep track of number of pages (to print it at the bottom of each page for example)
				currentPage++;
				[PDFManager drawPageNumber:currentPage];

				currentRange = [PDFManager renderPage:currentPage withTextRange:currentRange andFramesetter:framesetter];

				if (currentRange.location == CFAttributedStringGetLength((CFAttributedStringRef)currentText)) {
					saved = YES;
				}
			} while (!saved);

			// end PDF data
			UIGraphicsEndPDFContext();

			CFRelease(framesetter);
		}

		CFRelease(currentText);
	}

	return pdfData;
}

+ (BOOL)savePDFFileForEstimate:(Estimate *)estimate {
	NSString *pdfPath = [PDFManager getPDFPathForEstimate:estimate];
	NSData *pdfData = [PDFManager getPDFDataForEstimate:estimate];

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

@end
