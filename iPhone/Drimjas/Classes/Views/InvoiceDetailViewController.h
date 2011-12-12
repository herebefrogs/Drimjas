//
//  InvoiceDetailViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-12-05.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>
// Cells
#import "DetailTableViewController.h"

@class Invoice;
@class AddEstimateLineItemsViewController;

@interface InvoiceDetailViewController : DetailTableViewController {
    Invoice *invoice;
    AddEstimateLineItemsViewController *lineItemSelectionsViewController;

    @private
    NSInteger indexFirstLineItem;
	NSInteger indexLastSection;
	NSArray *lineItemSelections;
}

@property (nonatomic, strong) Invoice *invoice;
@property (nonatomic, strong) IBOutlet AddEstimateLineItemsViewController *lineItemSelectionsViewController;

@end
