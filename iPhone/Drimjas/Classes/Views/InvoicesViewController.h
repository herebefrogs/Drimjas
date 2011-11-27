//
//  InvoicesViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-11-27.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InvoiceCell;

@interface InvoicesViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    InvoiceCell *invoiceCell;

    NSFetchedResultsController *invoices;
}

@property (nonatomic, strong) IBOutlet InvoiceCell *invoiceCell;
@property (nonatomic, strong) NSFetchedResultsController *invoices;

- (IBAction)add:(id)sender;

@end
