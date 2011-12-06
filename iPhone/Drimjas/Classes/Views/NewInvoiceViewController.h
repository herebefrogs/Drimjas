//
//  NewInvoiceViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-12-02.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InvoiceDetailViewController;

@interface NewInvoiceViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    InvoiceDetailViewController *invoiceDetailViewController;
    NSFetchedResultsController *contracts;
}

@property (nonatomic, strong) IBOutlet InvoiceDetailViewController *invoiceDetailViewController;
@property (nonatomic, strong) NSFetchedResultsController *contracts;

@end
