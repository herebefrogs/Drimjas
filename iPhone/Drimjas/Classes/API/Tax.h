//
//  Tax.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-06-19.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "IndexedObject.h"


@interface Tax : IndexedObject {
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *percent;
@property (nonatomic, strong) NSString *taxNumber;

- (NSNumber *)costForSubTotal:(NSNumber *)subTotal;
+ (BOOL)isReadyStatus;

@end



