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
@class PDFViewController;

@interface EstimateDetailViewController : UITableViewController <PrintNotifyDelegate, MFMailComposeViewControllerDelegate> {
	UIBarButtonItem *emailButton;
	UIBarButtonItem *printButton;
    UIBarButtonItem *pdfButton;
	UIBarButtonItem *spacerButton;

	EditSectionHeader *editSectionHeader;

	AddEstimateLineItemsViewController *lineItemSelectionsViewController;
	ContactInfosViewController *contactInfosViewController;
	NewClientInfoViewController *aNewClientInfoViewController;
    PDFViewController *pdfViewController;

	Estimate *estimate;
	NSInteger indexFirstLineItem;
	NSInteger indexLastSection;
	NSArray *lineItemSelections;
@private
    UIViewController* mailComposeViewController;
}

@property (nonatomic, strong) IBOutlet UIBarButtonItem *emailButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *printButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *pdfButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *spacerButton;
@property (nonatomic, strong) IBOutlet EditSectionHeader *editSectionHeader;
@property (nonatomic, strong) IBOutlet AddEstimateLineItemsViewController *lineItemSelectionsViewController;
@property (nonatomic, strong) IBOutlet ContactInfosViewController *contactInfosViewController;
@property (nonatomic, strong) IBOutlet NewClientInfoViewController *aNewClientInfoViewController;
@property (nonatomic, strong) IBOutlet PDFViewController *pdfViewController;
@property (nonatomic, strong) Estimate *estimate;

- (IBAction)email:(id)sender;
- (IBAction)print:(id)sender;
- (IBAction)view:(id)sender;
- (IBAction)modify:(id)sender;

@end
