//
//  PrintManager.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-02-06.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  Apache 2 License
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Estimate;
@class Contract;
@class Invoice;

@protocol PrintNotifyDelegate <NSObject>

@optional
- (void)printJobCompleted:(BOOL)completed withError:(NSError *)error;

@end


@interface PrintManager : NSObject {

}

+ (BOOL)isPrintingAvailable;
+ (void)printEstimate:(Estimate *)estimate withDelegate:(id<PrintNotifyDelegate>)delegate;
+ (void)printContract:(Contract *)contract withDelegate:(id<PrintNotifyDelegate>)delegate;
+ (void)printInvoice:(Invoice *)contract withDelegate:(id<PrintNotifyDelegate>)delegate;

@end

