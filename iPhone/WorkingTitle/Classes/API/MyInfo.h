//
//  MyInfo.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-06-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ClientInformation.h"


@interface MyInfo : ClientInformation {
}

@property (nonatomic, retain) NSString *businessNumber;
@property (nonatomic, retain) NSString *fax;
@property (nonatomic, retain) NSString *website;

@end



