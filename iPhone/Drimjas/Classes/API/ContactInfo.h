//
//  ContactInfo.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-04-02.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <CoreData/CoreData.h>
// API
#import "IndexedObject.h"

@class ClientInfo;

@interface ContactInfo : IndexedObject {
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) ClientInfo *clientInfo;

- (NSInteger)numSetProperties;
- (NSString *)getSetPropertyWithIndex:(NSInteger)index;

@end