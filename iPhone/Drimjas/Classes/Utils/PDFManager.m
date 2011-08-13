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
#import "Currency.h"
#import "DataStore.h"
#import "Estimate.h"
#import "KeyValue.h"
#import "LineItemSelection.h"
#import "LineItem.h"
#import "MyInfo.h"
#import "Tax.h"
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

typedef enum {
	LabelX = 0,
	LabelWidth,
	ClientInfoX,
	ClientInfoWidth,
	MyInfoX,
	MyInfoWidth
} HeaderXAndWidth;

+ (NSArray *)_pageInfo:(PageInfo *)pageInfo headerColumnsWidthForClient:(ClientInfo *)clientInfo myInfo:(MyInfo *)myInfo {
	CGFloat labelMax = 0.0;
	CGFloat clientInfoMax = 0.0;
	CGFloat myInfoMax = 0.0;

	// calculate the maximun width taken by client info labels & values if we had no width limit
	for (KeyValue *pair in [clientInfo nonEmptyProperties]) {
		NSString *text = [NSString stringWithFormat:@"client.%@", pair.key];
		CGSize textSize = [NSLocalizedString(text, "Property Name") sizeWithFont:pageInfo.plainFont];

		labelMax = MAX(textSize.width, labelMax);

		textSize = [pair.value sizeWithFont:pageInfo.plainFont];

		clientInfoMax = MAX(textSize.width, clientInfoMax);
	}
	// calculate the maximun width taken by contact info labels & values if we had no width limit
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
	for (ContactInfo *contactInfo in [clientInfo.contactInfos sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]) {
		for (KeyValue *pair in [contactInfo nonEmptyProperties]) {
			NSString *text = [NSString stringWithFormat:@"contact.%@", pair.key];
			CGSize textSize = [NSLocalizedString(text, "Property Name") sizeWithFont:pageInfo.plainFont];

			labelMax = MAX(textSize.width, labelMax);

			textSize = [pair.value sizeWithFont:pageInfo.plainFont];

			clientInfoMax = MAX(textSize.width, clientInfoMax);
		}
	}
	[sortDescriptor release];

	// provision some extra space between label and client info
	labelMax += 2 * pageInfo.linePadding;

	for (KeyValue *pair in [myInfo nonEmptyProperties]) {
		CGSize textSize = [pair.value sizeWithFont:([pair.key isEqualToString:@"name"] ? pageInfo.bigBoldFont : pageInfo.plainFont)];

		myInfoMax = MAX(textSize.width, myInfoMax);
	}

	// calculate best actual width for each 3 columns
	BOOL labelFits = (labelMax <= pageInfo.labelWidth);
	BOOL clientInfoFits = (clientInfoMax <= pageInfo.clientOrMyInfoWidth);
	BOOL myInfoFits = (myInfoMax <= pageInfo.clientOrMyInfoWidth);

	CGFloat labelWidth = 0.0;
	CGFloat clientInfoWidth = 0.0;
	CGFloat myInfoWidth = 0.0;

	// all fits so nothing to do
	if (labelFits && clientInfoFits && myInfoFits) {
		labelWidth = pageInfo.labelWidth;
		clientInfoWidth = pageInfo.clientOrMyInfoWidth;
		myInfoWidth = pageInfo.clientOrMyInfoWidth;
	}
	// only one doesn't fit, so take as much unused space from the other two
	else if (labelFits && clientInfoFits && !myInfoFits) {
		labelWidth = labelMax;
		clientInfoWidth = clientInfoMax;
		myInfoWidth = CGRectGetWidth(pageInfo.bounds) - labelWidth - clientInfoWidth;
	}
	else if (labelFits && !clientInfoFits && myInfoFits) {
		labelWidth = labelMax;
		myInfoWidth = myInfoMax;
		clientInfoWidth = CGRectGetWidth(pageInfo.bounds) - labelWidth - myInfoWidth;
	}
	else if (!labelFits && clientInfoFits && myInfoFits) {
		clientInfoWidth = clientInfoMax;
		myInfoWidth = myInfoMax;
		labelWidth = CGRectGetWidth(pageInfo.bounds) - clientInfoWidth - myInfoWidth;
	}
	// only one fits, so divide unused space between the other two
	else if (labelFits && !clientInfoFits && !myInfoFits) {
		labelWidth = labelMax;
		// divide equaly
		clientInfoWidth = (CGRectGetWidth(pageInfo.bounds) - labelWidth) / 2;
		myInfoWidth = clientInfoWidth;
	}
	else if (!labelFits && clientInfoFits && !myInfoFits) {
		clientInfoWidth = clientInfoMax;
		// enforce original ratio
		labelWidth = pageInfo.labelWidth;
		myInfoWidth = CGRectGetWidth(pageInfo.bounds) - labelWidth - clientInfoWidth;
	}
	else if (myInfoWidth != 0.0) {
		myInfoWidth = myInfoMax;
		// enforce original ratio
		labelWidth = pageInfo.labelWidth;
		clientInfoWidth = CGRectGetWidth(pageInfo.bounds) - labelWidth - myInfoWidth;
	}
	// they all don't fit so they will all be clipped
	else {
		labelWidth = pageInfo.labelWidth;
		clientInfoWidth = pageInfo.clientOrMyInfoWidth;
		myInfoWidth = pageInfo.clientOrMyInfoWidth;
	}

	return [NSArray arrayWithObjects:[NSNumber numberWithFloat:pageInfo.bounds.origin.x],
								     [NSNumber numberWithFloat:labelWidth],
									 [NSNumber numberWithFloat:pageInfo.bounds.origin.x + labelWidth],
									 [NSNumber numberWithFloat:clientInfoWidth],
									 [NSNumber numberWithFloat:pageInfo.bounds.origin.x + labelWidth + clientInfoWidth],
									 [NSNumber numberWithFloat:myInfoWidth],
									 nil];
}

+ (CGFloat)_pageInfo:(PageInfo *)pageInfo renderClientInfo:(ClientInfo *)clientInfo xAndWidths:(NSArray *)xAndWidths {
	NSAssert(xAndWidths.count >= ClientInfoWidth + 1, @"Not enough x and width data to render client info");

	CGFloat labelX = [[xAndWidths objectAtIndex:LabelX] floatValue];
	CGFloat labelWidth = [[xAndWidths objectAtIndex:LabelWidth] floatValue];
	CGFloat clientInfoX = [[xAndWidths objectAtIndex:ClientInfoX] floatValue];
	CGFloat clientInfoWidth = [[xAndWidths objectAtIndex:ClientInfoWidth] floatValue];

	// place all property names first on half content width, all content height
	pageInfo.y = pageInfo.bounds.origin.y;

	for (KeyValue *pair in [clientInfo nonEmptyProperties]) {
		pageInfo.x = labelX;
		pageInfo.maxWidth = labelWidth;

		NSString *clientProperty = [NSString stringWithFormat:@"client.%@", pair.key];
		CGSize labelSize = [pageInfo drawTextLeftJustified:NSLocalizedString(clientProperty, "Property name")];

		pageInfo.x = clientInfoX;
		pageInfo.maxWidth = clientInfoWidth;

		CGSize infoSize = [pageInfo drawTextLeftJustified:pair.value];

		CGFloat lineOffset = MAX(labelSize.height, infoSize.height) + pageInfo.linePadding;
		pageInfo.y += lineOffset;
	}

	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
	for (ContactInfo *contactInfo in [clientInfo.contactInfos sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]) {
		pageInfo.y += pageInfo.sectionPadding;
		
		for (KeyValue *pair in [contactInfo nonEmptyProperties]) {
			pageInfo.x = labelX;
			pageInfo.maxWidth = labelWidth;

			NSString *contactKey = [NSString stringWithFormat:@"contact.%@", pair.key];
			CGSize labelSize = [pageInfo drawTextLeftJustified:NSLocalizedString(contactKey, "Property name")];

			pageInfo.x = clientInfoX;
			pageInfo.maxWidth = clientInfoWidth;

			CGSize infoSize = [pageInfo drawTextLeftJustified:pair.value];

			pageInfo.y += MAX(labelSize.height, infoSize.height) + pageInfo.linePadding;;
		}
	}
	[sortDescriptor release];

	return pageInfo.y;
}

+ (CGFloat)_pageInfo:(PageInfo *)pageInfo renderMyInfo:(MyInfo *)myInfo xAndWidths:(NSArray *)xAndWidths {
	NSAssert(xAndWidths.count == MyInfoWidth + 1, @"Not enough x and width data to render my info");

	CGFloat myInfoX = [[xAndWidths objectAtIndex:MyInfoX] floatValue];

	pageInfo.x = myInfoX;
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

		CGSize infoSize = [pageInfo drawTextRightJustified:pair.value
											  font:([pair.key isEqualToString:@"name"] ? pageInfo.bigBoldFont : pageInfo.plainFont)];

		pageInfo.y += infoSize.height + pageInfo.linePadding;
	}

	return pageInfo.y;
}

+ (void)_pageInfo:(PageInfo *)pageInfo renderDate:(NSDate *)date {
	pageInfo.x = pageInfo.bounds.origin.x;

	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	// TODO should find similar pattern from user's Region Settings so its localized
	[dateFormat setDateFormat:@"EEEE MMMM dd, YYYY"];
	NSString *estimateDate = [dateFormat stringFromDate:date];
	[dateFormat release];

	CGSize dateSize = [pageInfo drawTextRightJustified:estimateDate];
	pageInfo.y += dateSize.height + pageInfo.linePadding;
}

+ (void)_pageInfo:(PageInfo *)pageInfo renderTaxNos:(NSArray *)taxes {
	pageInfo.x = pageInfo.bounds.origin.x;

	for (Tax *tax in taxes) {
		CGSize taxSize = [pageInfo drawTextRightJustified:[NSString stringWithFormat:@"%@ #%@", tax.name, tax.taxNumber]];

		pageInfo.y += taxSize.height + pageInfo.linePadding;
	}
}

+ (void)_pageInfo:(PageInfo *)pageInfo renderOrderNo:(NSString *)orderNo {
	pageInfo.x = pageInfo.bounds.origin.x;

	CGSize noSize = [pageInfo drawTextLeftJustified:[NSString stringWithFormat:@"%@ #%@",
													 NSLocalizedString(@"Purchase Order", "Purchase Order label in PDF"),
													 orderNo]
											   font:pageInfo.bigBoldFont];
	pageInfo.y += noSize.height + pageInfo.sectionPadding;
}

typedef enum {
	NameX = 0,
	NameWidth,
	DescriptionX,
	DescriptionWidth,
	UnitCostX,
	UnitCostWidth,
	QuantityX,
	QuantityWidth,
	CostX,
	CostWidth
} LineItemsXAndWidth;

+ (NSArray *)_pageInfo:(PageInfo *)pageInfo tableColumnsWidthForEstimate:(Estimate *)estimate {
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
	NSArray *lineItems = [estimate.lineItems sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	[sortDescriptor release];

	CGFloat nameMax = 0.0;
	CGFloat descriptionMax = 0.0;
	CGFloat unitCostMax = 0.0;
	CGFloat quantityMax = 0.0;
	CGFloat	costMax = 0.0;

	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setCurrencyCode:[[[DataStore defaultStore] currency] isoCode]];

	// calculate the maximum width taken by each column if we had no width limitation
	for (LineItemSelection *lineItem in lineItems) {
		// skip H&S handled separately at the end of the PDF
		if ([lineItem.lineItem.name isEqualToString:NSLocalizedString(@"Handling & Shipping", "")]) {
			continue;
		}

		CGSize textSize = [lineItem.lineItem.name sizeWithFont:pageInfo.plainFont];
		nameMax = MAX(nameMax, textSize.width);

		textSize = [lineItem.details sizeWithFont:pageInfo.plainFont];
		descriptionMax = MAX(descriptionMax, textSize.width);

		[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		NSNumber *value = lineItem.unitCost ? lineItem.unitCost : [NSNumber numberWithFloat:0.0];
		textSize = [[numberFormatter stringFromNumber:value] sizeWithFont:pageInfo.plainFont];
		unitCostMax = MAX(unitCostMax, textSize.width);

		textSize = [[numberFormatter stringFromNumber:lineItem.cost] sizeWithFont:pageInfo.plainFont];
		costMax = MAX(costMax, textSize.width);

		[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];		
		value = lineItem.quantity ? lineItem.quantity : [NSNumber numberWithFloat:0.0];
		textSize = [[numberFormatter stringFromNumber:value] sizeWithFont:pageInfo.plainFont];
		quantityMax = MAX(quantityMax, textSize.width);
	}

	// calculate the maximum width taken by each column header
	CGSize textSize = [NSLocalizedString(@"Cost","") sizeWithFont:pageInfo.boldFont];
	costMax = MAX(costMax, textSize.width);

	textSize = [NSLocalizedString(@"Quantity","") sizeWithFont:pageInfo.boldFont];
	quantityMax = MAX(quantityMax, textSize.width);

	textSize = [NSLocalizedString(@"Unit Cost","") sizeWithFont:pageInfo.boldFont];
	unitCostMax = MAX(unitCostMax, textSize.width);

	textSize = [NSLocalizedString(@"Description","") sizeWithFont:pageInfo.boldFont];
	descriptionMax = MAX(descriptionMax, textSize.width);

	textSize = [NSLocalizedString(@"Item","") sizeWithFont:pageInfo.boldFont];
	nameMax = MAX(nameMax, textSize.width);

	// calculate the maximum width taken by sub total, taxes, h&s and total values
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	NSNumber *subTotal = estimate.subTotal;
	textSize = [[numberFormatter stringFromNumber:subTotal] sizeWithFont:pageInfo.plainFont];
	costMax = MAX(costMax, textSize.width);

	for (Tax *tax in [[DataStore defaultStore] taxes]) {
		textSize = [[numberFormatter stringFromNumber:[tax costForSubTotal:subTotal]] sizeWithFont:pageInfo.plainFont];
		costMax = MAX(costMax, textSize.width);
	}

	textSize = [[numberFormatter stringFromNumber:estimate.handlingAndShippingCost] sizeWithFont:pageInfo.plainFont];
	costMax = MAX(costMax, textSize.width);

	textSize = [[numberFormatter stringFromNumber:estimate.total] sizeWithFont:pageInfo.plainFont];
	costMax = MAX(costMax, textSize.width);

	[numberFormatter release];

	// provision some space for padding on both side
	CGFloat costWidth = costMax + 2 * pageInfo.linePadding;
	CGFloat quantityWidth = quantityMax + 2 * pageInfo.linePadding;
	CGFloat unitCostWidth = unitCostMax + 2 * pageInfo.linePadding;
	CGFloat descriptionWidth = descriptionMax + 2 * pageInfo.linePadding;
	CGFloat nameWidth = nameMax + 2 * pageInfo.linePadding;

	CGFloat remainingWidth = CGRectGetWidth(pageInfo.bounds) - nameWidth - descriptionWidth - unitCostWidth - quantityWidth - costWidth;
	if (remainingWidth > 0) {
		// distribute remaining space evenly
		CGFloat extra = remainingWidth / 5;
		nameWidth += extra;
		descriptionWidth += extra;
		unitCostWidth += extra;
		quantityWidth += extra;
		costWidth += extra;
	}
	else {
		// some wrapping must occur; spare unit cost, quantity and cost as nobody likes numbers that wrap
		CGFloat remainingWidth = CGRectGetWidth(pageInfo.bounds) - unitCostWidth - quantityWidth - costWidth;

		CGFloat idealNameWidth = remainingWidth / 3;
		CGFloat idealDescWidth = remainingWidth * 2 / 3;
		// arbitrarily decide that if none fit in 1/3 & 2/3 of the remaining space, both gets wrapped
		if (nameWidth > idealNameWidth && descriptionWidth > idealDescWidth) {
			nameWidth = idealNameWidth;
			descriptionWidth = idealDescWidth;
		}
		// otherwise grant the other all the remaining space to limit wrapping as much as possible
		else if (nameWidth < idealNameWidth) {
			descriptionWidth = remainingWidth - nameWidth;
		}
		else {
			nameWidth = remainingWidth - descriptionWidth;
		}
	}

	return [NSArray arrayWithObjects:
			[NSNumber numberWithFloat:pageInfo.bounds.origin.x],
			[NSNumber numberWithFloat:nameWidth],
			[NSNumber numberWithFloat:pageInfo.bounds.origin.x + nameWidth],
			[NSNumber numberWithFloat:descriptionWidth],
			[NSNumber numberWithFloat:pageInfo.bounds.origin.x + nameWidth + descriptionWidth],
			[NSNumber numberWithFloat:unitCostWidth],
			[NSNumber numberWithFloat:pageInfo.bounds.origin.x + nameWidth + descriptionWidth + unitCostWidth],
			[NSNumber numberWithFloat:quantityWidth],
			[NSNumber numberWithFloat:pageInfo.bounds.origin.x + nameWidth + descriptionWidth + unitCostWidth + quantityWidth],
			[NSNumber numberWithFloat:costWidth],
			nil
		   ];
}


+ (void)_pageInfo:(PageInfo *)pageInfo renderLineItems:(NSSet *)lineItemsSet xAndWidths:(NSArray *)xAndWidths {
	NSAssert(xAndWidths.count == CostWidth + 1, @"Not enough x and width data to render line items");

	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
	NSArray *lineItems = [lineItemsSet sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	[sortDescriptor release];

	CGFloat nameX = [[xAndWidths objectAtIndex:NameX] floatValue];
	CGFloat nameWidth = [[xAndWidths objectAtIndex:NameWidth] floatValue];
	CGFloat descriptionX = [[xAndWidths objectAtIndex:DescriptionX] floatValue];
	CGFloat descriptionWidth = [[xAndWidths objectAtIndex:DescriptionWidth] floatValue];
	CGFloat unitCostX = [[xAndWidths objectAtIndex:UnitCostX] floatValue];
	CGFloat unitCostWidth = [[xAndWidths objectAtIndex:UnitCostWidth] floatValue];
	CGFloat quantityX = [[xAndWidths objectAtIndex:QuantityX] floatValue];
	CGFloat quantityWidth = [[xAndWidths objectAtIndex:QuantityWidth] floatValue];
	CGFloat costX = [[xAndWidths objectAtIndex:CostX] floatValue];
	CGFloat costWidth = [[xAndWidths objectAtIndex:CostWidth] floatValue];

	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setCurrencyCode:[[[DataStore defaultStore] currency] isoCode]];

	// render table header
	pageInfo.x = nameX;
	pageInfo.maxWidth = nameWidth;
	CGSize textSize = [pageInfo drawTextMiddleJustified:NSLocalizedString(@"Item","") font:pageInfo.boldFont padding:pageInfo.linePadding];
	CGFloat maxRowHeight = textSize.height + 2 * pageInfo.linePadding;

	pageInfo.x = descriptionX;
	pageInfo.maxWidth = descriptionWidth;
	textSize = [pageInfo drawTextMiddleJustified:NSLocalizedString(@"Description","") font:pageInfo.boldFont padding:pageInfo.linePadding];
	maxRowHeight = MAX(maxRowHeight, textSize.height + 2 * pageInfo.linePadding);

	pageInfo.x = unitCostX;
	pageInfo.maxWidth = unitCostWidth;
	textSize = [pageInfo drawTextMiddleJustified:NSLocalizedString(@"Unit Cost","") font:pageInfo.boldFont padding:pageInfo.linePadding];
	maxRowHeight = MAX(maxRowHeight, textSize.height + 2 * pageInfo.linePadding);

	pageInfo.x = quantityX;
	pageInfo.maxWidth = quantityWidth;
	textSize = [pageInfo drawTextMiddleJustified:NSLocalizedString(@"Quantity","") font:pageInfo.boldFont padding:pageInfo.linePadding];
	maxRowHeight = MAX(maxRowHeight, textSize.height + 2 * pageInfo.linePadding);

	pageInfo.x = costX;
	pageInfo.maxWidth = costWidth;
	textSize = [pageInfo drawTextMiddleJustified:NSLocalizedString(@"Cost","") font:pageInfo.boldFont padding:pageInfo.linePadding];
	maxRowHeight = MAX(maxRowHeight, textSize.height + 2 * pageInfo.linePadding);

	// render row frame
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextBeginPath(context);
	CGContextSetLineWidth(context, 0.5);
	CGContextMoveToPoint(context, pageInfo.bounds.origin.x, pageInfo.y);
	CGContextAddLineToPoint(context, pageInfo.bounds.origin.x + CGRectGetWidth(pageInfo.bounds), pageInfo.y);
	CGContextAddLineToPoint(context, pageInfo.bounds.origin.x + CGRectGetWidth(pageInfo.bounds), pageInfo.y + maxRowHeight);
	CGContextAddLineToPoint(context, pageInfo.bounds.origin.x, pageInfo.y + maxRowHeight);
	CGContextClosePath(context);
	CGContextStrokePath(context);

	// render individual columns
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, descriptionX, pageInfo.y);
	CGContextAddLineToPoint(context, descriptionX, pageInfo.y + maxRowHeight);
	CGContextClosePath(context);
	CGContextStrokePath(context);

	CGContextBeginPath(context);
	CGContextMoveToPoint(context, unitCostX, pageInfo.y);
	CGContextAddLineToPoint(context, unitCostX, pageInfo.y + maxRowHeight);
	CGContextClosePath(context);
	CGContextStrokePath(context);

	CGContextBeginPath(context);
	CGContextMoveToPoint(context, costX, pageInfo.y);
	CGContextAddLineToPoint(context, costX, pageInfo.y + maxRowHeight);
	CGContextClosePath(context);
	CGContextStrokePath(context);

	CGContextBeginPath(context);
	CGContextMoveToPoint(context, quantityX, pageInfo.y);
	CGContextAddLineToPoint(context, quantityX, pageInfo.y + maxRowHeight);
	CGContextClosePath(context);
	CGContextStrokePath(context);

	pageInfo.y += maxRowHeight;

	// render each line item in a row
	for (LineItemSelection *lineItem in lineItems) {
		// skip H&S handled separately at the end of the PDF
		if ([lineItem.lineItem.name isEqualToString:NSLocalizedString(@"Handling & Shipping", "")]) {
			continue;
		}

		// calculate the maximum row height before drawing any text if we had no limit (only name & description
		// columns can wrap on multiple lines so it's safe to ignore unit cost, quantity and cost)
		CGFloat currentHeight = pageInfo.maxHeight;
		pageInfo.maxHeight = CGRectGetHeight(pageInfo.bounds);
		pageInfo.x = nameX;
		pageInfo.maxWidth = nameWidth;
		textSize = [lineItem.lineItem.name  sizeWithFont:pageInfo.plainFont constrainedToSize:pageInfo.maxSize lineBreakMode:UILineBreakModeWordWrap];
		maxRowHeight = textSize.height + 2 * pageInfo.linePadding;

		pageInfo.x = descriptionX;
		pageInfo.maxWidth = descriptionWidth;
		textSize = [lineItem.details sizeWithFont:pageInfo.plainFont constrainedToSize:pageInfo.maxSize lineBreakMode:UILineBreakModeWordWrap];
		maxRowHeight = MAX(maxRowHeight, textSize.height + 2 * pageInfo.linePadding);
		pageInfo.maxHeight = currentHeight;

		// skip to the next page if there isn't enough height left on the current one to draw the entire line
		if (pageInfo.maxHeight < maxRowHeight) {
			[pageInfo openNewPage];
			pageInfo.y = pageInfo.bounds.origin.y;
		}

		pageInfo.x = nameX;
		pageInfo.maxWidth = nameWidth;
		[pageInfo drawTextLeftJustified:lineItem.lineItem.name padding:pageInfo.linePadding];

		pageInfo.x = descriptionX;
		pageInfo.maxWidth = descriptionWidth;
		[pageInfo drawTextLeftJustified:lineItem.details padding:pageInfo.linePadding];

		pageInfo.x = unitCostX;
		pageInfo.maxWidth = unitCostWidth;
		[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		NSNumber *value = lineItem.unitCost ? lineItem.unitCost : [NSNumber numberWithFloat:0.0];
		textSize = [pageInfo drawTextRightJustified:[numberFormatter stringFromNumber:value] padding:pageInfo.linePadding];

		pageInfo.x = quantityX;
		pageInfo.maxWidth = quantityWidth;
		[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		value = lineItem.quantity ? lineItem.quantity : [NSNumber numberWithFloat:0.0];
		textSize = [pageInfo drawTextMiddleJustified:[numberFormatter stringFromNumber:value] padding:pageInfo.linePadding];

		pageInfo.x = costX;
		pageInfo.maxWidth = costWidth;
		[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		textSize = [pageInfo drawTextRightJustified:[numberFormatter stringFromNumber:lineItem.cost] padding:pageInfo.linePadding];

		// render row frame
		CGContextBeginPath(context);
		CGContextSetLineWidth(context, 0.5);
		CGContextMoveToPoint(context, pageInfo.bounds.origin.x, pageInfo.y);
		CGContextAddLineToPoint(context, pageInfo.bounds.origin.x + CGRectGetWidth(pageInfo.bounds), pageInfo.y);
		CGContextAddLineToPoint(context, pageInfo.bounds.origin.x + CGRectGetWidth(pageInfo.bounds), pageInfo.y + maxRowHeight);
		CGContextAddLineToPoint(context, pageInfo.bounds.origin.x, pageInfo.y + maxRowHeight);
		CGContextClosePath(context);
		CGContextStrokePath(context);

		// render individual columns
		CGContextBeginPath(context);
		CGContextMoveToPoint(context, descriptionX, pageInfo.y);
		CGContextAddLineToPoint(context, descriptionX, pageInfo.y + maxRowHeight);
		CGContextClosePath(context);
		CGContextStrokePath(context);

		CGContextBeginPath(context);
		CGContextMoveToPoint(context, unitCostX, pageInfo.y);
		CGContextAddLineToPoint(context, unitCostX, pageInfo.y + maxRowHeight);
		CGContextClosePath(context);
		CGContextStrokePath(context);

		CGContextBeginPath(context);
		CGContextMoveToPoint(context, costX, pageInfo.y);
		CGContextAddLineToPoint(context, costX, pageInfo.y + maxRowHeight);
		CGContextClosePath(context);
		CGContextStrokePath(context);

		CGContextBeginPath(context);
		CGContextMoveToPoint(context, quantityX, pageInfo.y);
		CGContextAddLineToPoint(context, quantityX, pageInfo.y + maxRowHeight);
		CGContextClosePath(context);
		CGContextStrokePath(context);

		pageInfo.y += maxRowHeight;
	}
	[numberFormatter release];
}

+ (void)_pageInfo:(PageInfo *)pageInfo renderTotalsAndTaxes:(Estimate *)estimate xAndWidths:(NSArray *)xAndWidths {
	NSAssert(xAndWidths.count == CostWidth + 1, @"Not enough x and width data to render totals and taxes");

	CGFloat unitCostX = [[xAndWidths objectAtIndex:UnitCostX] floatValue];
	CGFloat unitCostWidth = [[xAndWidths objectAtIndex:UnitCostWidth] floatValue];
	CGFloat quantityX = [[xAndWidths objectAtIndex:QuantityX] floatValue];
	CGFloat quantityWidth = [[xAndWidths objectAtIndex:QuantityWidth] floatValue];
	CGFloat costX = [[xAndWidths objectAtIndex:CostX] floatValue];
	CGFloat costWidth = [[xAndWidths objectAtIndex:CostWidth] floatValue];

	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setCurrencyCode:[[[DataStore defaultStore] currency] isoCode]];
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];

	NSNumber *subTotal = estimate.subTotal;
	NSArray *taxes = [[DataStore defaultStore] taxes];

	// calculate the maximum width of sub total, taxes, h&s and total labels
	CGSize textSize = [NSLocalizedString(@"SUBTOTAL","") sizeWithFont:pageInfo.boldFont];
	CGFloat labelWidth = textSize.width;
	for (Tax *tax in taxes) {
		textSize = [tax.name sizeWithFont:pageInfo.boldFont];
		labelWidth = MAX(labelWidth, textSize.width);
	}
	textSize = [NSLocalizedString(@"H & S","") sizeWithFont:pageInfo.boldFont];
	labelWidth = MAX(labelWidth, textSize.width);
	textSize = [NSLocalizedString(@"TOTAL","") sizeWithFont:pageInfo.boldFont];
	labelWidth = MAX(labelWidth, textSize.width);
	// provision some space for padding on both side
	labelWidth += 2 * pageInfo.linePadding;
	CGFloat labelX = costX - labelWidth;

	// adjust label width to align with quantity or unit cost column if label fits
	if (labelWidth < quantityWidth) {
		labelX = quantityX;
		labelWidth = quantityWidth;
	}
	else if (labelWidth < (unitCostWidth + quantityWidth)) {
		labelX = unitCostX;
		labelWidth = unitCostWidth + quantityWidth;
	}

	// render sub total
	pageInfo.x = labelX;
	pageInfo.maxWidth = labelWidth;
	[pageInfo drawTextMiddleJustified:NSLocalizedString(@"SUBTOTAL","") font:pageInfo.boldFont padding:pageInfo.linePadding];
	pageInfo.x = costX;
	pageInfo.maxWidth = costWidth;
	textSize = [pageInfo drawTextRightJustified:[numberFormatter stringFromNumber:subTotal] padding:pageInfo.linePadding];
	CGFloat maxRowHeight = textSize.height + 2 * pageInfo.linePadding;

	// render row frame
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextBeginPath(context);
	CGContextSetLineWidth(context, 0.5);
	CGContextMoveToPoint(context, labelX, pageInfo.y);
	CGContextAddLineToPoint(context, pageInfo.bounds.origin.x + CGRectGetWidth(pageInfo.bounds), pageInfo.y);
	CGContextAddLineToPoint(context, pageInfo.bounds.origin.x + CGRectGetWidth(pageInfo.bounds), pageInfo.y + maxRowHeight);
	CGContextAddLineToPoint(context, labelX, pageInfo.y + maxRowHeight);
	CGContextClosePath(context);
	CGContextStrokePath(context);

	CGContextBeginPath(context);
	CGContextMoveToPoint(context, costX, pageInfo.y);
	CGContextAddLineToPoint(context, costX, pageInfo.y + maxRowHeight);
	CGContextClosePath(context);
	CGContextStrokePath(context);

	pageInfo.y += maxRowHeight;

	// render taxes
	for (Tax *tax in taxes) {
		pageInfo.x = labelX;
		pageInfo.maxWidth = labelWidth;
		[pageInfo drawTextMiddleJustified:tax.name font:pageInfo.boldFont padding:pageInfo.linePadding];
		pageInfo.x = costX;
		pageInfo.maxWidth = costWidth;
		textSize = [pageInfo drawTextRightJustified:[numberFormatter stringFromNumber:[tax costForSubTotal:subTotal]] padding:pageInfo.linePadding];
		maxRowHeight = textSize.height + 2 * pageInfo.linePadding;

		// render row frame
		CGContextBeginPath(context);
		CGContextSetLineWidth(context, 0.5);
		CGContextMoveToPoint(context, labelX, pageInfo.y);
		CGContextAddLineToPoint(context, pageInfo.bounds.origin.x + CGRectGetWidth(pageInfo.bounds), pageInfo.y);
		CGContextAddLineToPoint(context, pageInfo.bounds.origin.x + CGRectGetWidth(pageInfo.bounds), pageInfo.y + maxRowHeight);
		CGContextAddLineToPoint(context, labelX, pageInfo.y + maxRowHeight);
		CGContextClosePath(context);
		CGContextStrokePath(context);

		CGContextBeginPath(context);
		CGContextMoveToPoint(context, costX, pageInfo.y);
		CGContextAddLineToPoint(context, costX, pageInfo.y + maxRowHeight);
		CGContextClosePath(context);
		CGContextStrokePath(context);

		pageInfo.y += maxRowHeight;
	}

	pageInfo.y += 6 * pageInfo.linePadding;

	// render h&s
	pageInfo.x = labelX;
	pageInfo.maxWidth = labelWidth;
	[pageInfo drawTextMiddleJustified:NSLocalizedString(@"H & S","") font:pageInfo.boldFont padding:pageInfo.linePadding];
	pageInfo.x = costX;
	pageInfo.maxWidth = costWidth;
	textSize = [pageInfo drawTextRightJustified:[numberFormatter stringFromNumber:estimate.handlingAndShippingCost] padding:pageInfo.linePadding];
	maxRowHeight = textSize.height + 2 * pageInfo.linePadding;

	// render row frame
	CGContextBeginPath(context);
	CGContextSetLineWidth(context, 0.5);
	CGContextMoveToPoint(context, labelX, pageInfo.y);
	CGContextAddLineToPoint(context, pageInfo.bounds.origin.x + CGRectGetWidth(pageInfo.bounds), pageInfo.y);
	CGContextAddLineToPoint(context, pageInfo.bounds.origin.x + CGRectGetWidth(pageInfo.bounds), pageInfo.y + maxRowHeight);
	CGContextAddLineToPoint(context, labelX, pageInfo.y + maxRowHeight);
	CGContextClosePath(context);
	CGContextStrokePath(context);

	CGContextBeginPath(context);
	CGContextMoveToPoint(context, costX, pageInfo.y);
	CGContextAddLineToPoint(context, costX, pageInfo.y + maxRowHeight);
	CGContextClosePath(context);
	CGContextStrokePath(context);

	pageInfo.y += maxRowHeight + 6 * pageInfo.linePadding;

	// render total
	pageInfo.x = labelX;
	pageInfo.maxWidth = labelWidth;
	[pageInfo drawTextMiddleJustified:NSLocalizedString(@"TOTAL","") font:pageInfo.boldFont padding:pageInfo.linePadding];
	pageInfo.x = costX;
	pageInfo.maxWidth = costWidth;
	textSize = [pageInfo drawTextRightJustified:[numberFormatter stringFromNumber:estimate.total] padding:pageInfo.linePadding];
	maxRowHeight = textSize.height + 2 * pageInfo.linePadding;

	// render row frame
	CGContextBeginPath(context);
	CGContextSetLineWidth(context, 0.5);
	CGContextMoveToPoint(context, labelX, pageInfo.y);
	CGContextAddLineToPoint(context, pageInfo.bounds.origin.x + CGRectGetWidth(pageInfo.bounds), pageInfo.y);
	CGContextAddLineToPoint(context, pageInfo.bounds.origin.x + CGRectGetWidth(pageInfo.bounds), pageInfo.y + maxRowHeight);
	CGContextAddLineToPoint(context, labelX, pageInfo.y + maxRowHeight);
	CGContextClosePath(context);
	CGContextStrokePath(context);

	CGContextBeginPath(context);
	CGContextMoveToPoint(context, costX, pageInfo.y);
	CGContextAddLineToPoint(context, costX, pageInfo.y + maxRowHeight);
	CGContextClosePath(context);
	CGContextStrokePath(context);

	pageInfo.y += maxRowHeight;

	[numberFormatter release];
}

+ (void)_renderPDFFooter:(PageInfo *)pageInfo {
	pageInfo.x = pageInfo.bounds.origin.x;
	CGSize textSize = [pageInfo drawTextMiddleJustified:NSLocalizedString(@"If you have any questions, please don't hesitate to contact us!","") font:pageInfo.boldFont];

	pageInfo.y += textSize.height + 6 * pageInfo.linePadding;
	textSize = [pageInfo drawTextMiddleJustified:NSLocalizedString(@"Thank you for your business.","") font:pageInfo.boldFont];

	pageInfo.y += textSize.height + 6 * pageInfo.linePadding;
	[pageInfo drawTextLeftJustified:NSLocalizedString(@"Notes:","") font:pageInfo.boldFont];
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

	NSArray *xAndWidths = [PDFManager _pageInfo:pageInfo headerColumnsWidthForClient:estimate.clientInfo myInfo:myInfo];

	// render client+contact info & my info side by side
	CGFloat myY = [PDFManager _pageInfo:pageInfo renderMyInfo:myInfo xAndWidths:xAndWidths];
	CGFloat clientY = [PDFManager _pageInfo:pageInfo renderClientInfo:estimate.clientInfo xAndWidths:xAndWidths];

	// render estimate date & business number
	pageInfo.y = pageInfo.pageNo == 1 && myY > clientY ? myY + pageInfo.sectionPadding : clientY;
	[PDFManager _pageInfo:pageInfo renderDate:estimate.date];
	[PDFManager _pageInfo:pageInfo renderTaxNos:[[DataStore defaultStore] taxes]];

	// render horizontal line
	pageInfo.y += pageInfo.linePadding;
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextBeginPath(context);
	CGContextSetLineWidth(context, 1.5);
	CGContextMoveToPoint(context, pageInfo.bounds.origin.x, pageInfo.y);
	CGContextAddLineToPoint(context, pageInfo.bounds.origin.x + CGRectGetWidth(pageInfo.bounds), pageInfo.y);
	CGContextClosePath(context);
	CGContextStrokePath(context);

	// render order number
	pageInfo.y += pageInfo.sectionPadding;
	[PDFManager _pageInfo:pageInfo renderOrderNo:estimate.orderNumber];
	
	// render line items table
	xAndWidths = [PDFManager _pageInfo:pageInfo tableColumnsWidthForEstimate:estimate];

	pageInfo.y += pageInfo.sectionPadding;
	[PDFManager _pageInfo:pageInfo renderLineItems:estimate.lineItems xAndWidths:xAndWidths];
	pageInfo.y += 6 * pageInfo.linePadding;
	[PDFManager _pageInfo:pageInfo renderTotalsAndTaxes:estimate xAndWidths:xAndWidths];

	// render PDF footer
	pageInfo.y += pageInfo.sectionPadding;
	[PDFManager _renderPDFFooter:pageInfo];

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
