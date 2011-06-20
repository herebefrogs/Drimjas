//
//  Tax.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-06-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "BaseObject.h"


@interface Tax : BaseObject {
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *percent;

@end



