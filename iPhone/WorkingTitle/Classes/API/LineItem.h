//
//  LineItem.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-05-10.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <CoreData/CoreData.h>
// API
#import "BaseObject.h"

@class LineItemSelection;

@interface LineItem : BaseObject {
}

@property (nonatomic, retain) NSNumber *preset;
@property (nonatomic, retain) NSString *details;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSSet *lineItemSelections;

- (BOOL)isValid;	// return whether or not the minimal required fields have been set

@end


@interface LineItem (CoreDataGeneratedAccessors)
- (void)addLineItemSelectionsObject:(LineItemSelection *)value;
- (void)removeLineItemSelectionsObject:(LineItemSelection *)value;
- (void)addLineItemSelections:(NSSet *)value;
- (void)removeLineItemSelections:(NSSet *)value;

@end