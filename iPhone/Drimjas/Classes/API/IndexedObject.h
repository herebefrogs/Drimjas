//
//  IndexedObject.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-06-22.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  Apache 2 License
//

#import <CoreData/CoreData.h>
#import "BaseObject.h"


@interface IndexedObject : BaseObject {
}

@property (nonatomic, strong) NSNumber *index;

@end



