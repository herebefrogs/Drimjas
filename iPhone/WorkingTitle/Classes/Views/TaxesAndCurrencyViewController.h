//
//  TaxesAndCurrencyViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-06-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
// Cells
#import "TextFieldTableViewController.h"

@class MyInfoViewController;
@class EstimateDetailViewController;

@interface TaxesAndCurrencyViewController : TextFieldTableViewController <NSFetchedResultsControllerDelegate> {
	UIBarButtonItem *nextButton;
	UIBarButtonItem *saveButton;
	MyInfoViewController *myInfoViewController;
	EstimateDetailViewController *estimateDetailViewController;

	NSFetchedResultsController *taxesAndCurrency;
	BOOL optionsMode;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, retain) IBOutlet MyInfoViewController *myInfoViewController;
@property (nonatomic, retain) IBOutlet EstimateDetailViewController *estimateDetailViewController;

@property (nonatomic, retain) NSFetchedResultsController *taxesAndCurrency;
@property (nonatomic, assign) BOOL optionsMode;

- (IBAction)next:(id)sender;
- (IBAction)save:(id)sender;

@end
