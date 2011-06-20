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

@class ReviewEstimateViewController;

@interface TaxesAndCurrencyViewController : TextFieldTableViewController <NSFetchedResultsControllerDelegate> {
	UIBarButtonItem *nextButton;
	UIBarButtonItem *saveButton;
	ReviewEstimateViewController *reviewEstimateViewController;

	NSFetchedResultsController *taxesAndCurrency;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, retain) IBOutlet ReviewEstimateViewController *reviewEstimateViewController;

@property (nonatomic, retain) NSFetchedResultsController *taxesAndCurrency;

- (IBAction)next:(id)sender;
- (IBAction)save:(id)sender;

@end
