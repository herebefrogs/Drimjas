//
//  ContactInfo.h
//  Drimjas
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

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) ClientInfo *clientInfo;

@property (weak, nonatomic, readonly) NSArray *nonEmptyProperties;
@property (nonatomic, readonly) NSInteger countNonEmptyProperties;
- (NSString *)nonEmptyPropertyWithIndex:(NSInteger)index;

@property (weak, nonatomic, readonly) NSString *toRecipient;

@end