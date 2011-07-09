//
//  AddEstimateLineItemsViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-05-01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
// Cells
#import "TextFieldTableViewController.h"

@class LineItemsViewController;
@class EstimateDetailViewController;
@class TaxesAndCurrencyViewController;
@class MyInfoViewController;
@class Estimate;

@interface AddEstimateLineItemsViewController : TextFieldTableViewController <NSFetchedResultsControllerDelegate> {
	UIBarButtonItem *nextButton;
	UIBarButtonItem *saveButton;
	LineItemsViewController *lineItemsViewController;
	EstimateDetailViewController *estimateDetailViewController;
	TaxesAndCurrencyViewController *taxesAndCurrencyViewController;
	MyInfoViewController *myInfoViewController;

	NSFetchedResultsController *lineItemSelections;
	Estimate *estimate;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, retain) IBOutlet LineItemsViewController *lineItemsViewController;
@property (nonatomic, retain) IBOutlet EstimateDetailViewController *estimateDetailViewController;
@property (nonatomic, retain) IBOutlet TaxesAndCurrencyViewController *taxesAndCurrencyViewController;
@property (nonatomic, retain) IBOutlet MyInfoViewController *myInfoViewController;

@property (nonatomic, retain) NSFetchedResultsController *lineItemSelections;
@property (nonatomic, retain) Estimate *estimate;

- (IBAction)next:(id)sender;
- (IBAction)save:(id)sender;

@end
