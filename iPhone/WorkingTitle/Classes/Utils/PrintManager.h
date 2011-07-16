//
//  PrintManager.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-02-06.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Estimate;
@protocol PrintNotifyDelegate;


@interface PrintManager : NSObject {

}

+ (BOOL)isPrintingAvailable;
+ (void)printEstimate:(Estimate *)estimate withDelegate:(id<PrintNotifyDelegate>)delegate;

@end

@protocol PrintNotifyDelegate <NSObject>

- (void)printJobCompleted:(BOOL)completed withError:(NSError *)error;

@end
