//
//  EstimateDetailViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
// Utils
#import "EmailManager.h"
#import "PrintManager.h"


@class Estimate;
@class EditSectionHeader;
@class AddEstimateLineItemsViewController;

@interface EstimateDetailViewController : UITableViewController <PrintNotifyDelegate, MailNotifyDelegate> {
	UIBarButtonItem *emailButton;
	UIBarButtonItem *printButton;
	UIBarButtonItem *spacerButton;

	EditSectionHeader *editSectionHeader;

	AddEstimateLineItemsViewController *lineItemSelectionsViewController;

	Estimate *estimate;
	NSInteger indexFirstLineItem;
	NSInteger indexLastSection;
	NSArray *lineItemSelections;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *emailButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *printButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *spacerButton;
@property (nonatomic, retain) IBOutlet EditSectionHeader *editSectionHeader;
@property (nonatomic, retain) IBOutlet AddEstimateLineItemsViewController *lineItemSelectionsViewController;
@property (nonatomic, retain) Estimate *estimate;

- (IBAction)email:(id)sender;
- (IBAction)print:(id)sender;
- (IBAction)modify:(id)sender;

@end