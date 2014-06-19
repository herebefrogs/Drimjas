//
//  AddEstimateLineItemsViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-05-01.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  GPLv3
//

#import <UIKit/UIKit.h>
// Cells
#import "TextFieldTableViewController.h"

@class LineItemsViewController;
@class EstimateDetailViewController;
@class TaxesAndCurrencyViewController;
@class MyInfoViewController;
@class Estimate;
@class Invoice;

@interface AddEstimateLineItemsViewController : TextFieldTableViewController <NSFetchedResultsControllerDelegate> {
	UIBarButtonItem *nextButton;
	UIBarButtonItem *saveButton;
	LineItemsViewController *lineItemsViewController;
	EstimateDetailViewController *estimateDetailViewController;
	TaxesAndCurrencyViewController *taxesAndCurrencyViewController;
	MyInfoViewController *myInfoViewController;

	NSFetchedResultsController *lineItemSelections;
	Estimate *estimate;
	Invoice *invoice;

	BOOL editMode;
}

@property (nonatomic, strong) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, strong) IBOutlet LineItemsViewController *lineItemsViewController;
@property (nonatomic, strong) IBOutlet EstimateDetailViewController *estimateDetailViewController;
@property (nonatomic, strong) IBOutlet TaxesAndCurrencyViewController *taxesAndCurrencyViewController;
@property (nonatomic, strong) IBOutlet MyInfoViewController *myInfoViewController;

@property (nonatomic, strong) NSFetchedResultsController *lineItemSelections;
@property (nonatomic, strong) Estimate *estimate;
@property (nonatomic, strong) Invoice *invoice;
@property (nonatomic, assign) BOOL editMode;

- (IBAction)next:(id)sender;
- (IBAction)save:(id)sender;

@end
