//
//  LineItemsViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-05-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LineItemSelection;
@class NewLineItemViewController;

@interface LineItemsViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NewLineItemViewController *newLineItemViewController;

	NSFetchedResultsController *lineItems;
	LineItemSelection *lineItemSelection;

	BOOL optionsMode;
}

@property (nonatomic, retain) IBOutlet NewLineItemViewController *newLineItemViewController;
@property (nonatomic, retain) NSFetchedResultsController *lineItems;
@property (nonatomic, retain) LineItemSelection *lineItemSelection;
@property (nonatomic, assign) BOOL optionsMode;

@end
