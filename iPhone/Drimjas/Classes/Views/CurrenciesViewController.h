//
//  CurrenciesViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-10-11.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Currency.h"

@interface CurrenciesViewController : UITableViewController {
@private
    NSArray *currencyCodes;
    Currency *currency;
}

@property (nonatomic, retain) Currency *currency;

@end