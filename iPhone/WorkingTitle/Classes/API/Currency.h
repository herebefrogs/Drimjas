//
//  Currency.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-06-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "BaseObject.h"


@interface Currency : BaseObject {
}

@property (nonatomic, retain) NSString *isoCode;

@end
