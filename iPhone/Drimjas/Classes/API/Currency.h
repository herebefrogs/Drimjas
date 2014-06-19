//
//  Currency.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-06-15.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  GPLv3
//

#import <CoreData/CoreData.h>
#import "IndexedObject.h"


@interface Currency : IndexedObject {
}

@property (nonatomic, strong) NSString *isoCode;

+ (BOOL)isReadyStatus;

@end
