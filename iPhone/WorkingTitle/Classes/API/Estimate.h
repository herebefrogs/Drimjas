//
//  Estimate.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-02-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

typedef void (^EstimateSavedCallback)();

@interface Estimate :  NSManagedObject {
	EstimateSavedCallback callbackBlock;
}

@property (nonatomic, retain) NSString *clientName;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSNumber *number;
@property (nonatomic, retain, readonly) NSString *orderNumber;

@property (nonatomic, copy) EstimateSavedCallback callbackBlock;

- (void)calculateNumber:(NSArray *)estimates;

@end