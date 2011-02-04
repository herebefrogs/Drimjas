//
//  PrintManager.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-02-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Estimate;

@interface PrintManager : NSObject {

}

+ (void)printEstimate:(Estimate *)estimate withHandlerWhenDone:(UIPrintInteractionCompletionHandler)handler;

@end
