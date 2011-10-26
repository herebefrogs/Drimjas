//
//  EstimateDetailViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-01-17.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
// Utils
#import "PrintManager.h"


@class Estimate;
@class EditSectionHeader;
@class AddEstimateLineItemsViewController;
@class ContactInfosViewController;
@class NewClientInfoViewController;

@interface EstimateDetailViewController : UITableViewController <PrintNotifyDelegate, MFMailComposeViewControllerDelegate> {
	UIBarButtonItem *emailButton;
	UIBarButtonItem *printButton;
	UIBarButtonItem *spacerButton;

	EditSectionHeader *editSectionHeader;

	AddEstimateLineItemsViewController *lineItemSelectionsViewController;
	ContactInfosViewController *contactInfosViewController;
	NewClientInfoViewController *aNewClientInfoViewController;

	Estimate *estimate;
	NSInteger indexFirstLineItem;
	NSInteger indexLastSection;
	NSArray *lineItemSelections;
@private
    UIViewController* mailComposeViewController;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *emailButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *printButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *spacerButton;
@property (nonatomic, retain) IBOutlet EditSectionHeader *editSectionHeader;
@property (nonatomic, retain) IBOutlet AddEstimateLineItemsViewController *lineItemSelectionsViewController;
@property (nonatomic, retain) IBOutlet ContactInfosViewController *contactInfosViewController;
@property (nonatomic, retain) IBOutlet NewClientInfoViewController *aNewClientInfoViewController;
@property (nonatomic, retain) Estimate *estimate;

- (IBAction)email:(id)sender;
- (IBAction)print:(id)sender;
- (IBAction)modify:(id)sender;

@end
