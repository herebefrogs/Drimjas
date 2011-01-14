//
//  Estimate.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Estimate : NSObject {
	NSString *clientName;
}

@property (nonatomic, retain) NSString *clientName;

- (id)initWithClientName:(NSString *)newClientName;

@end
