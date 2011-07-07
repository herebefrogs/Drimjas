//
//  NewLineItemViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-05-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
// Cells
#import "TextFieldTableViewController.h"


@class LineItem;
@class LineItemSelection;


@interface NewLineItemViewController : TextFieldTableViewController {
	UIBarButtonItem *addButton;

	LineItem *lineItem;						// Line Item being created
	LineItemSelection *lineItemSelection;	// Line Item Selection being added to an Estimate
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *addButton;
@property (nonatomic, retain) LineItem *lineItem;
@property (nonatomic, retain) LineItemSelection *lineItemSelection;

- (IBAction)add:(id)sender;

@end
