//
//  EmailManager.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-02-11.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class Estimate;
@class Contract;
@class Invoice;


@interface EmailManager : NSObject

+ (BOOL)isMailAvailable;
+ (UIViewController *)mailComposeViewControllerWithDelegate:(id<MFMailComposeViewControllerDelegate>)delegate
                                                forEstimate:(Estimate *)estimate;
+ (UIViewController *)mailComposeViewControllerWithDelegate:(id<MFMailComposeViewControllerDelegate>)delegate
                                                forContract:(Contract *)contract;
+ (UIViewController *)mailComposeViewControllerWithDelegate:(id<MFMailComposeViewControllerDelegate>)delegate
                                                 forInvoice:(Invoice *)invoice;

@end