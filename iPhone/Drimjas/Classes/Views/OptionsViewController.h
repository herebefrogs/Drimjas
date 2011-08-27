//
//  OptionsViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-06-17.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClientInfosViewController;
@class LineItemsViewController;
@class MyInfoViewController;
@class TaxesAndCurrencyViewController;
@class AboutViewController;

@interface OptionsViewController : UITableViewController {
	ClientInfosViewController *clientInfoViewController;
	LineItemsViewController *lineItemsViewController;
	TaxesAndCurrencyViewController *taxesAndCurrencyViewController;
	MyInfoViewController *myInfoViewController;
	AboutViewController *aboutViewController;
}

@property (nonatomic, retain) IBOutlet ClientInfosViewController *clientInfosViewController;
@property (nonatomic, retain) IBOutlet LineItemsViewController *lineItemsViewController;
@property (nonatomic, retain) IBOutlet TaxesAndCurrencyViewController *taxesAndCurrencyViewController;
@property (nonatomic, retain) IBOutlet MyInfoViewController *myInfoViewController;
@property (nonatomic, retain) IBOutlet AboutViewController *aboutViewController;

@end
