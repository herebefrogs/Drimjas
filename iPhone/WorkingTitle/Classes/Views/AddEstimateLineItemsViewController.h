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

@class AddEstimatePickLineItemViewController;
@class Estimate;

@interface AddEstimateLineItemsViewController : TextFieldTableViewController <NSFetchedResultsControllerDelegate> {
	UIBarButtonItem *nextButton;
	AddEstimatePickLineItemViewController *pickLineItemViewController;

	NSFetchedResultsController *lineItemSelections;
	Estimate *estimate;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, retain) IBOutlet AddEstimatePickLineItemViewController *pickLineItemViewController;

@property (nonatomic, retain) NSFetchedResultsController *lineItemSelections;
@property (nonatomic, retain) Estimate *estimate;

- (IBAction)next:(id)sender;

@end
