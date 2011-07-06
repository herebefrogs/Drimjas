//
//  OptionsViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-06-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyInfoViewController;
@class TaxesAndCurrencyViewController;

@interface OptionsViewController : UITableViewController {
	MyInfoViewController *myInfoViewController;
	TaxesAndCurrencyViewController *taxesAndCurrencyViewController;
}

@property (nonatomic, retain) IBOutlet MyInfoViewController *myInfoViewController;
@property (nonatomic, retain) IBOutlet TaxesAndCurrencyViewController *taxesAndCurrencyViewController;

@end
