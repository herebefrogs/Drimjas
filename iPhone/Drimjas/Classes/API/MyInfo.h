//
//  MyInfo.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-06-26.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ClientInfo.h"

@class ContactInfo;

@interface MyInfo : ClientInfo {
}

@property (nonatomic, retain) NSString *fax;
@property (nonatomic, retain) NSString *website;
@property (nonatomic, readonly) ContactInfo* contactInfo;

@property (nonatomic, readonly) NSString *phone;
@property (nonatomic, readonly) NSString *email;

+ (BOOL)isMyInfoSet;

@end



