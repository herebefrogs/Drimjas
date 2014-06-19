//
//  CurrenciesViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-10-11.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  GPLv3
//

#import <UIKit/UIKit.h>

@class Currency;

@interface CurrenciesViewController : UITableViewController {
@private
    NSArray *currencyCodes;
    Currency *currency;
}

@property (nonatomic, strong) Currency *currency;

@end
