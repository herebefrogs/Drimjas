// 
//  Estimate.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-02-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Estimate.h"


@implementation Estimate 

@dynamic clientName;
@dynamic date;
@dynamic number;

@synthesize callbackBlock;

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


- (void)calculateNumber:(NSArray *)estimates {
	// number of estimates on given date
	__block NSInteger count = 0;

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

- (void)dealloc {
	[callbackBlock release];
	[super dealloc];
}

@end
