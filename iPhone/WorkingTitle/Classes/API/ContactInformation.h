//
//  ContactInformation.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-04-02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
// API
#import "BaseObject.h"

@class ClientInformation;

@interface ContactInformation : BaseObject {
}

@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) ClientInformation *clientInfo;

@end