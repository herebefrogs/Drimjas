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

@class Currency;
@class ReviewEstimateViewController;

@interface TaxesAndCurrencyViewController : TextFieldTableViewController {
	UIBarButtonItem *nextButton;
	UIBarButtonItem *saveButton;
	ReviewEstimateViewController *reviewEstimateViewController;

	Currency *currency;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, retain) IBOutlet ReviewEstimateViewController *reviewEstimateViewController;

@property (nonatomic, retain) IBOutlet Currency *currency;

- (IBAction)next:(id)sender;
- (IBAction)save:(id)sender;

@end
