//
//  EmailManager.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-02-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@class Estimate;
@protocol MailNotifyDelegate;


@interface EmailManager : NSObject <MFMailComposeViewControllerDelegate> {
	UIViewController<MailNotifyDelegate> *_delegate;
}

+ (BOOL)isMailAvailable;
+ (void)mailEstimate:(Estimate *)estimate withDelegate:(UIViewController<MailNotifyDelegate>*)delegate;

@end

// FIXME should be a UIViewController so we can call present/dismissModal...
@protocol MailNotifyDelegate <NSObject>

- (void)mailSent:(MFMailComposeResult)result withError:(NSError *)error;

@end
