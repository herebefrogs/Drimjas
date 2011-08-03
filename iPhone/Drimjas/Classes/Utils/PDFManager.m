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
	NSUInteger oneEight = CGRectGetWidth(pageInfo.contentRect) / 8;
	NSUInteger sevenSixteenth = CGRectGetWidth(pageInfo.contentRect) / 16 * 7;
	NSUInteger maxWidth = 0;

	// place all property names first on half content width, all content height
	pageInfo.y = pageInfo.contentRect.origin.y;
	pageInfo.maxHeight = CGRectGetHeight(pageInfo.contentRect);

	for (KeyValue *pair in [clientInfo nonEmptyProperties]) {
		pageInfo.x = pageInfo.contentRect.origin.x;
		pageInfo.maxWidth = oneEight;

		NSString *clientProperty = [NSString stringWithFormat:@"client.%@", pair.key];
		CGSize labelSize = [pageInfo drawTextLeftAlign:NSLocalizedString(clientProperty, "Property name")];

		pageInfo.x += oneEight;
		pageInfo.maxWidth = sevenSixteenth;

		CGSize infoSize = [pageInfo drawTextLeftAlign:pair.value];

		NSUInteger lineOffset = MAX(labelSize.height, infoSize.height) + pageInfo.linePadding;
		pageInfo.y += lineOffset;
		pageInfo.maxHeight -= lineOffset;
		maxWidth = MAX(maxWidth, oneEight + infoSize.width);
	}

	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
	for (ContactInfo *contactInfo in [clientInfo.contactInfos sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]) {
		pageInfo.y += pageInfo.sectionPadding;
		pageInfo.maxHeight -= pageInfo.sectionPadding;
		
		for (KeyValue *pair in [contactInfo nonEmptyProperties]) {
			pageInfo.x = pageInfo.contentRect.origin.x;
			pageInfo.maxWidth = oneEight;

			NSString *contactKey = [NSString stringWithFormat:@"contact.%@", pair.key];
			CGSize labelSize = [pageInfo drawTextLeftAlign:NSLocalizedString(contactKey, "Property name")];

			pageInfo.x += oneEight;
			pageInfo.maxWidth = sevenSixteenth;

			CGSize infoSize = [pageInfo drawTextLeftAlign:pair.value];

			NSUInteger lineOffset = MAX(labelSize.height, infoSize.height) + pageInfo.linePadding;
			pageInfo.y += lineOffset;
			pageInfo.maxHeight -= lineOffset;
			maxWidth = MAX(maxWidth, oneEight + infoSize.width);
		}
	}

	return CGSizeMake(maxWidth,
					  CGRectGetHeight(pageInfo.contentRect) - pageInfo.maxHeight);
}

+ (CGSize)_pageInfo:(PageInfo *)pageInfo renderMyInfo:(MyInfo *)myInfo {
	NSUInteger sevenSixteenth = CGRectGetWidth(pageInfo.contentRect) / 16 * 7;
	NSUInteger maxWidth = 0;

	pageInfo.x = pageInfo.contentRect.origin.x + CGRectGetWidth(pageInfo.contentRect) / 16 * 9;
	pageInfo.y = pageInfo.contentRect.origin.y;
	pageInfo.maxWidth = sevenSixteenth;
	pageInfo.maxHeight = CGRectGetHeight(pageInfo.contentRect);

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
			pageInfo.maxHeight -= pageInfo.sectionPadding;
			insertOffset = NO;
		}

		CGSize infoSize = [pageInfo drawTextRightAlign:pair.value
											  withFont:([pair.key isEqualToString:@"name"] ? pageInfo.boldFont : pageInfo.plainFont)];

		NSUInteger lineOffset = infoSize.height + pageInfo.linePadding;
		pageInfo.y += lineOffset;
		pageInfo.maxHeight -= lineOffset;
		maxWidth = MAX(maxWidth, infoSize.width);
	}

	return CGSizeMake(maxWidth,
					  CGRectGetHeight(pageInfo.contentRect) - pageInfo.maxHeight);
}

+ (CGSize)_pageInfo:(PageInfo *)pageInfo renderDate:(NSDate *)date atHeight:(NSUInteger)height {
	pageInfo.x = pageInfo.contentRect.origin.x;
	pageInfo.y = pageInfo.contentRect.origin.y + height;
	pageInfo.maxWidth = CGRectGetWidth(pageInfo.contentRect);
	pageInfo.maxHeight = CGRectGetHeight(pageInfo.contentRect) - height + pageInfo.sectionPadding;

	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	// TODO should find similar pattern from user's Region Settings so its localized
	[dateFormat setDateFormat:@"EEEE MMMM dd, YYYY"];
	NSString *estimateDate = [dateFormat stringFromDate:date];
	[dateFormat release];

	return [pageInfo drawTextRightAlign:estimateDate];
}

+ (CGSize)_pageInfo:(PageInfo *)pageInfo renderBusinessNo:(NSString *)businessNo atHeight:(CGFloat)height {
	pageInfo.x = pageInfo.contentRect.origin.x;
	pageInfo.y = pageInfo.contentRect.origin.y + height;
	pageInfo.maxWidth = CGRectGetWidth(pageInfo.contentRect);
	pageInfo.maxHeight = CGRectGetHeight(pageInfo.contentRect) - height + pageInfo.sectionPadding;

	return [pageInfo drawTextRightAlign:businessNo];
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

	CGSize clientSize = [PDFManager _pageInfo:pageInfo renderClientInfo:estimate.clientInfo];
	CGSize mySize = [PDFManager _pageInfo:pageInfo renderMyInfo:[[DataStore defaultStore] myInfo]];

	CGFloat height = MAX(clientSize.height, mySize.height) + pageInfo.sectionPadding;
	CGSize dateSize = [PDFManager _pageInfo:pageInfo renderDate:estimate.date atHeight:height];

	height += dateSize.height;
	[PDFManager _pageInfo:pageInfo renderBusinessNo:[[[DataStore defaultStore] myInfo] businessNumber] atHeight:height];

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
