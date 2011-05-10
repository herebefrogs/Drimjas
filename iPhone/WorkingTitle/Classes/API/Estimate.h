//
//  Estimate.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-03-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
// API
#import "BaseObject.h"

@class ClientInformation;
@class LineItemSelection;

typedef void (^EstimateSavedCallback)();

@interface Estimate : BaseObject {
	EstimateSavedCallback callbackBlock;
}

@property (nonatomic, retain) NSNumber *number;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) ClientInformation *clientInfo;
@property (nonatomic, retain) NSSet *lineItems;
@property (nonatomic, copy) EstimateSavedCallback callbackBlock;

- (NSString *)orderNumber;
- (BOOL)isEmpty;

@end


@interface Estimate (CoreDataGeneratedAccessors)
- (void)addLineItemsObject:(LineItemSelection *)value;
- (void)removeLineItemsObject:(LineItemSelection *)value;
- (void)addLineItems:(NSSet *)value;
- (void)removeLineItems:(NSSet *)value;

@end