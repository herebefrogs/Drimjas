//
//  Currency.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-06-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "IndexedObject.h"


@interface Currency : IndexedObject {
}

@property (nonatomic, retain) NSString *isoCode;

+ (BOOL)isCurrencySet;

@end
