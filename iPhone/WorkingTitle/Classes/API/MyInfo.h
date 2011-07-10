//
//  MyInfo.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-06-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ClientInfo.h"

@class ContactInfo;

@interface MyInfo : ClientInfo {
}

@property (nonatomic, retain) NSString *businessNumber;
@property (nonatomic, retain) NSString *fax;
@property (nonatomic, retain) NSString *website;
@property (nonatomic, readonly) ContactInfo* contactInfo;

+ (BOOL)isMyInfoSet;

@end



