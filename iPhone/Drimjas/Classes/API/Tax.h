//
//  Tax.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-06-19.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  GPLv3
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



