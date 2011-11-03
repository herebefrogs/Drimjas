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

@property (nonatomic, strong) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, strong) IBOutlet CurrenciesViewController *currenciesViewController;
@property (nonatomic, strong) IBOutlet MyInfoViewController *myInfoViewController;
@property (nonatomic, strong) IBOutlet EstimateDetailViewController *estimateDetailViewController;

@property (nonatomic, strong) NSFetchedResultsController *taxesAndCurrency;
@property (nonatomic, assign) BOOL optionsMode;

- (IBAction)next:(id)sender;
- (IBAction)save:(id)sender;

@end
