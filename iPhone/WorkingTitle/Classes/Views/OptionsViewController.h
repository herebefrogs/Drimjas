//
//  OptionsViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-06-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClientInfosViewController;
@class LineItemsViewController;
@class MyInfoViewController;
@class TaxesAndCurrencyViewController;

@interface OptionsViewController : UITableViewController {
	ClientInfosViewController *clientInfoViewController;
	LineItemsViewController *lineItemsViewController;
	TaxesAndCurrencyViewController *taxesAndCurrencyViewController;
	MyInfoViewController *myInfoViewController;
}

@property (nonatomic, retain) IBOutlet ClientInfosViewController *clientInfosViewController;
@property (nonatomic, retain) IBOutlet LineItemsViewController *lineItemsViewController;
@property (nonatomic, retain) IBOutlet TaxesAndCurrencyViewController *taxesAndCurrencyViewController;
@property (nonatomic, retain) IBOutlet MyInfoViewController *myInfoViewController;

@end
