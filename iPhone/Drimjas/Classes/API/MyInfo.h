//
//  MyInfo.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-06-26.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  Apache 2 License
//

#import <CoreData/CoreData.h>
#import "ClientInfo.h"

@class ContactInfo;

@interface MyInfo : ClientInfo {
}

@property (nonatomic, strong) NSString *fax;
@property (nonatomic, strong) NSString *profession;
@property (nonatomic, strong) NSString *website;
@property (weak, nonatomic, readonly) ContactInfo* contactInfo;

@property (weak, nonatomic, readonly) NSString *phone;
@property (weak, nonatomic, readonly) NSString *email;

+ (BOOL)isReadyForEstimate;
+ (BOOL)isReadyForContract;

@end



