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
#import "ContactInfo.h"
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

+ (CGSize)_pageInfo:(PageInfo *)pageInfo renderClientInfo:(ClientInfo *)clientInfo {
	CGFloat oneEight = CGRectGetWidth(pageInfo.bounds) / 8;
	CGFloat sevenSixteenth = CGRectGetWidth(pageInfo.bounds) / 16 * 7;
	CGFloat usedWidth = 0.0;

	// place all property names first on half content width, all content height
	pageInfo.y = pageInfo.bounds.origin.y;

	for (KeyValue *pair in [clientInfo nonEmptyProperties]) {
		pageInfo.x = pageInfo.bounds.origin.x;
		pageInfo.maxWidth = oneEight;

		NSString *clientProperty = [NSString stringWithFormat:@"client.%@", pair.key];
		CGSize labelSize = [pageInfo drawTextLeftAlign:NSLocalizedString(clientProperty, "Property name")];

		pageInfo.x += oneEight;
		pageInfo.maxWidth = sevenSixteenth;

		CGSize infoSize = [pageInfo drawTextLeftAlign:pair.value];

		CGFloat lineOffset = MAX(labelSize.height, infoSize.height) + pageInfo.linePadding;
		pageInfo.y += lineOffset;
		usedWidth = MAX(usedWidth, oneEight + infoSize.width);
	}

	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
	for (ContactInfo *contactInfo in [clientInfo.contactInfos sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]) {
		pageInfo.y += pageInfo.sectionPadding;
		
		for (KeyValue *pair in [contactInfo nonEmptyProperties]) {
			pageInfo.x = pageInfo.bounds.origin.x;
			pageInfo.maxWidth = oneEight;

			NSString *contactKey = [NSString stringWithFormat:@"contact.%@", pair.key];
			CGSize labelSize = [pageInfo drawTextLeftAlign:NSLocalizedString(contactKey, "Property name")];

			pageInfo.x += oneEight;
			pageInfo.maxWidth = sevenSixteenth;

			CGSize infoSize = [pageInfo drawTextLeftAlign:pair.value];

			pageInfo.y += MAX(labelSize.height, infoSize.height) + pageInfo.linePadding;;
			usedWidth = MAX(usedWidth, oneEight + infoSize.width);
		}
	}

	CGFloat usedHeight = pageInfo.y - pageInfo.bounds.origin.y;
	return CGSizeMake(usedWidth, usedHeight);
}

+ (CGSize)_pageInfo:(PageInfo *)pageInfo renderMyInfo:(MyInfo *)myInfo {
	CGFloat sevenSixteenth = CGRectGetWidth(pageInfo.bounds) / 16 * 7;
	CGFloat oneHeight = CGRectGetWidth(pageInfo.bounds) / 8;
	CGFloat usedWidth = 0.0;

	pageInfo.x = pageInfo.bounds.origin.x + oneHeight + sevenSixteenth;
	pageInfo.y = pageInfo.bounds.origin.y;

	BOOL insert1stOffset = YES;
	BOOL insert2ndOffset = YES;

	for (KeyValue *pair in [myInfo nonEmptyProperties]) {
		BOOL insertOffset = NO;

		if ([pair.key isEqualToString:@"phone"] || (insert1stOffset && [pair.key isEqualToString:@"fax"])) {
			insert1stOffset = NO;
			insertOffset = YES;
		}
		else if ([pair.key isEqualToString:@"email"] || (insert2ndOffset && [pair.key isEqualToString:@"website"])) {
			insert2ndOffset = NO;
			insertOffset = YES;
		}
		if (insertOffset) {
			pageInfo.y += pageInfo.sectionPadding;
			insertOffset = NO;
		}

		CGSize infoSize = [pageInfo drawTextRightAlign:pair.value
											  withFont:([pair.key isEqualToString:@"name"] ? pageInfo.bigBoldFont : pageInfo.plainFont)];

		pageInfo.y += infoSize.height + pageInfo.linePadding;
		usedWidth = MAX(usedWidth, infoSize.width);
	}

	CGFloat usedHeight = pageInfo.y - pageInfo.bounds.origin.y;
	return CGSizeMake(usedWidth, usedHeight);
}

+ (CGSize)_pageInfo:(PageInfo *)pageInfo renderDate:(NSDate *)date atHeight:(CGFloat)height {
	pageInfo.x = pageInfo.bounds.origin.x;
	pageInfo.y = pageInfo.bounds.origin.y + height;

	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	// TODO should find similar pattern from user's Region Settings so its localized
	[dateFormat setDateFormat:@"EEEE MMMM dd, YYYY"];
	NSString *estimateDate = [dateFormat stringFromDate:date];
	[dateFormat release];

	return [pageInfo drawTextRightAlign:estimateDate];
}

+ (CGSize)_pageInfo:(PageInfo *)pageInfo renderBusinessNo:(NSString *)businessNo atHeight:(CGFloat)height {
	pageInfo.x = pageInfo.bounds.origin.x;
	pageInfo.y = pageInfo.bounds.origin.y + height;

	return [pageInfo drawTextRightAlign:businessNo];
}

+ (CGSize)_pageInfo:(PageInfo *)pageInfo renderOrderNo:(NSString *)orderNo atHeight:(CGFloat)height {
	pageInfo.x = pageInfo.bounds.origin.x;
	pageInfo.y = pageInfo.bounds.origin.y + height;

	return [pageInfo drawTextLeftAlign:[NSString stringWithFormat:@"%@ #%@",
												NSLocalizedString(@"Purchase Order", "Purchase Order label in PDF"),
												orderNo]
							  withFont:pageInfo.bigBoldFont];
}

#pragma mark -
#pragma mark Public protocol implementation

+ (NSMutableData *)pdfDataForEstimate:(Estimate *)estimate {
	NSMutableData *pdfData = [[[NSMutableData alloc] initWithCapacity: 1024] autorelease];

	// start PDF data
	PageInfo *pageInfo = [[PageInfo alloc] init];
	UIGraphicsBeginPDFContextToData(pdfData, pageInfo.pageSize, [self pdfInfoForEstimate:estimate]);

	// open new page
	UIGraphicsBeginPDFPage();

	MyInfo *myInfo = [[DataStore defaultStore] myInfo];

	// render client+contact info & my info side by side
	CGSize mySize = [PDFManager _pageInfo:pageInfo renderMyInfo:myInfo];
	CGSize clientSize = [PDFManager _pageInfo:pageInfo renderClientInfo:estimate.clientInfo];

	// render estimate date & business number
	CGFloat height = pageInfo.pageNo == 1 ? MAX(clientSize.height, mySize.height) + pageInfo.sectionPadding : clientSize.height;
	CGSize lastSize = [PDFManager _pageInfo:pageInfo renderDate:estimate.date atHeight:height];

	height += lastSize.height;
	lastSize = [PDFManager _pageInfo:pageInfo renderBusinessNo:myInfo.businessNumber atHeight:height];

	// render horizontal line
	height += lastSize.height + pageInfo.linePadding;
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextBeginPath(context);
	CGContextSetLineWidth(context, 1.5);
	CGContextMoveToPoint(context, pageInfo.bounds.origin.x, pageInfo.bounds.origin.y + height);
	CGContextAddLineToPoint(context, pageInfo.bounds.origin.x + CGRectGetWidth(pageInfo.bounds), pageInfo.bounds.origin.y + height);
	CGContextClosePath(context);
	CGContextStrokePath(context);

	// render order number
	height += pageInfo.sectionPadding;
	lastSize = [PDFManager _pageInfo:pageInfo renderOrderNo:estimate.orderNumber atHeight:height];
	
	// render line items

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
