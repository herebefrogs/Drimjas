//
//  InvoiceDetailViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-12-05.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Invoice;

@interface InvoiceDetailViewController : UITableViewController {
    Invoice *invoice;

    @private
    NSInteger indexFirstLineItem;
	NSInteger indexLastSection;
	NSArray *lineItemSelections;
}

@property (nonatomic, strong) Invoice *invoice;

@end
