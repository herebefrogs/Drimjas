//
//  LineItem.h
//  Drimjas
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

@property (nonatomic, strong) NSNumber *defaults;
@property (nonatomic, strong) NSString *desc;		// cannot be named "description" as it collides with NSObject no-argument message
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSSet *lineItemSelections;

@end


@interface LineItem (CoreDataGeneratedAccessors)
- (void)addLineItemSelectionsObject:(LineItemSelection *)value;
- (void)removeLineItemSelectionsObject:(LineItemSelection *)value;
- (void)addLineItemSelections:(NSSet *)value;
- (void)removeLineItemSelections:(NSSet *)value;

@end