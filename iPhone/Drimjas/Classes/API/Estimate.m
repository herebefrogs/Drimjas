// 
//  Estimate.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-03-27.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "Estimate.h"
// API
#import "ClientInfo.h"
#import "Contract.h"
#import "DataStore.h"
#import "LineItem.h"
#import "LineItemSelection.h"
#import "Tax.h"

@implementation Estimate 

@dynamic number;
@dynamic date;
@dynamic clientInfo;
@dynamic lineItems;
@dynamic contract;

#pragma mark -
#pragma mark Public methods stack

- (NSString *)monthYear {
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"MMMM YYYY"];

	NSString *monthYear = [dateFormat stringFromDate:self.date];

	return monthYear;
}

- (NSString *)orderNumber {
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"YYYYMMdd"];

	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setFormatWidth:3];
	[numberFormatter setPaddingCharacter:@"0"];

	NSString *orderNumber = [NSString stringWithFormat:@"%@%@",
							 [dateFormat stringFromDate:self.date],
							 [numberFormatter stringFromNumber:self.number]];


	return orderNumber;
}

- (NSNumber *)subTotal {
	CGFloat subTotal = 0;

	for (LineItemSelection *lineItem in self.lineItems) {
		// S & H is handled in total
		if ([lineItem.lineItem.name isEqualToString:NSLocalizedString(@"Shipping & Handling","")]) {
			continue;
		}
		subTotal += [lineItem.cost floatValue];
	}

	return [NSNumber numberWithFloat:subTotal];
}

- (NSNumber *)total {
	CGFloat total = 0;
	NSNumber *subTotal = self.subTotal;

	for (Tax *tax in [[DataStore defaultStore] taxes]) {
		total += [[tax costForSubTotal:subTotal] floatValue];
	}

	total += [self.shippingAndHandlingCost floatValue];

	total += [subTotal floatValue];

	return [NSNumber numberWithFloat:total];
}

- (NSNumber *)shippingAndHandlingCost {
	for (LineItemSelection *lineItem in self.lineItems) {
		if ([lineItem.lineItem.name isEqualToString:NSLocalizedString(@"Shipping & Handling", "")]) {
			return lineItem.cost;
		}
	}
	return [NSNumber numberWithInt:0];
}

#pragma mark -
#pragma mark Private methods stack

- (void)calculateNumber:(NSArray *)estimates {
	// number of estimates on given date
	__block NSUInteger count = 0;

	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSUInteger unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;

	NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:self.date];

	[estimates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		Estimate *estimate = (Estimate *)obj;
		NSDateComponents *estimateDateComponents = [calendar components:unitFlags fromDate:estimate.date];

		// same date
		if (dateComponents.year == estimateDateComponents.year
			&& dateComponents.month == estimateDateComponents.month
			&& dateComponents.day == estimateDateComponents.day) {

			// only keep the highest estimate number
			NSUInteger estimateNumber = [estimate.number intValue];
			if (estimateNumber > count) {
				count = estimateNumber;
			};
		}
		// from now on, all estimates will be older than date
		else if (dateComponents.year > estimateDateComponents.year
				 || (dateComponents.year == estimateDateComponents.year
					 && dateComponents.month > estimateDateComponents.month)
				 || (dateComponents.year == estimateDateComponents.year
					 && dateComponents.month == estimateDateComponents.month
					 && dateComponents.day > estimateDateComponents.day)) {
					 *stop = YES;
				 }
		// if date is older than estimate, continue
	}];

	self.number = [NSNumber numberWithInt:count + 1];
}

- (void) awakeFromInsert {
	[super awakeFromInsert];
	// initialize date & number values upon creation
	self.date = [NSDate date];
	[self calculateNumber:[[[DataStore defaultStore] estimatesFetchedResultsController] fetchedObjects]];
}

- (BOOL)isReady {
	if (self.clientInfo.isReady) {
		for (LineItemSelection *lineItem in self.lineItems) {
			if (lineItem.isReady) {
				return YES;
			}
		}
	}
	return NO;
}

- (void)refreshStatus {
	// NOTE: don't bother refreshing status of an Estimate scheduled for deletion as nothing depends on it
	if (![self isDeleted]) {
		[super refreshStatus];
	}
}


@end
