//
//  OptionsViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-06-17.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  Apache 2 License
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

@property (nonatomic, strong) IBOutlet ClientInfosViewController *clientInfosViewController;
@property (nonatomic, strong) IBOutlet LineItemsViewController *lineItemsViewController;
@property (nonatomic, strong) IBOutlet TaxesAndCurrencyViewController *taxesAndCurrencyViewController;
@property (nonatomic, strong) IBOutlet MyInfoViewController *myInfoViewController;
@property (nonatomic, strong) IBOutlet AboutViewController *aboutViewController;

@end
