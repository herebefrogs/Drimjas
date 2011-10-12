//
//  TaxesAndCurrencyViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-06-15.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>
// Cells
#import "TextFieldTableViewController.h"

@class CurrenciesViewController;
@class MyInfoViewController;
@class EstimateDetailViewController;

@interface TaxesAndCurrencyViewController : TextFieldTableViewController <NSFetchedResultsControllerDelegate> {
	UIBarButtonItem *nextButton;
	UIBarButtonItem *saveButton;
    CurrenciesViewController *currenciesViewController;
	MyInfoViewController *myInfoViewController;
	EstimateDetailViewController *estimateDetailViewController;

	NSFetchedResultsController *taxesAndCurrency;
	BOOL optionsMode;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, retain) IBOutlet CurrenciesViewController *currenciesViewController;
@property (nonatomic, retain) IBOutlet MyInfoViewController *myInfoViewController;
@property (nonatomic, retain) IBOutlet EstimateDetailViewController *estimateDetailViewController;

@property (nonatomic, retain) NSFetchedResultsController *taxesAndCurrency;
@property (nonatomic, assign) BOOL optionsMode;

- (IBAction)next:(id)sender;
- (IBAction)save:(id)sender;

@end
