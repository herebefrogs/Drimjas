// 
//  Estimate.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-03-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Estimate.h"
// API
#import "ClientInformation.h"
#import "DataStore.h"

@implementation Estimate 

@dynamic number;
@dynamic date;
@dynamic clientInfo;

@synthesize callbackBlock;

#pragma mark -
#pragma mark Public methods stack

- (NSString *)orderNumber {
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"YYYYMMdd"];

	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setFormatWidth:3];
	[numberFormatter setPaddingCharacter:@"0"];

	NSString *orderNumber = [NSString stringWithFormat:@"%@%@",
							 [dateFormat stringFromDate:self.date],
							 [numberFormatter stringFromNumber:self.number]];

	[dateFormat release];
	[numberFormatter release];

	return orderNumber;
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
	[self calculateNumber:[[DataStore defaultStore] estimates]];
}

#pragma mark -
#pragma mark Memory management stack

- (void)dealloc {
	[callbackBlock release];
	[super dealloc];
}

@end
