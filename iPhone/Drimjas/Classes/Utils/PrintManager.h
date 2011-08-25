//
//  PrintManager.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-02-06.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Estimate;
@class Contract;
@protocol PrintNotifyDelegate;


@interface PrintManager : NSObject {

}

+ (BOOL)isPrintingAvailable;
+ (void)printEstimate:(Estimate *)estimate withDelegate:(id<PrintNotifyDelegate>)delegate;
+ (void)printContract:(Contract *)contract withDelegate:(id<PrintNotifyDelegate>)delegate;

@end

@protocol PrintNotifyDelegate <NSObject>

- (void)printJobCompleted:(BOOL)completed withError:(NSError *)error;

@end
