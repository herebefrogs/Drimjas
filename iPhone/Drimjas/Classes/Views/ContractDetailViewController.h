//
//  ContractDetailViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-08-24.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
// Utils
#import "PrintManager.h"


@class Contract;

@interface ContractDetailViewController : UITableViewController <PrintNotifyDelegate, MFMailComposeViewControllerDelegate> {
	UIBarButtonItem *emailButton;
	UIBarButtonItem *printButton;
	UIBarButtonItem *spacerButton;

	Contract *contract;
	NSInteger indexFirstLineItem;
	NSInteger indexLastSection;
	NSArray *lineItemSelections;

    @private
    UIViewController *mailComposeViewController;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *emailButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *printButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *spacerButton;

@property (nonatomic, retain) Contract *contract;

- (IBAction)email:(id)sender;
- (IBAction)print:(id)sender;

@end
