//
//  AddEstimateLineItemsViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-05-01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
// Cells
#import "TextFieldTableViewController.h"

@class Estimate;

@interface AddEstimateLineItemsViewController : TextFieldTableViewController <NSFetchedResultsControllerDelegate> {
	UIBarButtonItem *nextButton;

	NSFetchedResultsController *lineItemSelections;
	Estimate *estimate;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;

@property (nonatomic, retain) NSFetchedResultsController *lineItemSelections;
@property (nonatomic, retain) Estimate *estimate;

- (IBAction)next:(id)sender;

@end
