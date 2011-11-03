//
//  LineItemsViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-05-10.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LineItemSelection;
@class NewLineItemViewController;

@interface LineItemsViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NewLineItemViewController *aNewLineItemViewController;

	NSFetchedResultsController *lineItems;
	LineItemSelection *lineItemSelection;

	BOOL optionsMode;
}

@property (nonatomic, strong) IBOutlet NewLineItemViewController *aNewLineItemViewController;
@property (nonatomic, strong) NSFetchedResultsController *lineItems;
@property (nonatomic, strong) LineItemSelection *lineItemSelection;
@property (nonatomic, assign) BOOL optionsMode;

@end
