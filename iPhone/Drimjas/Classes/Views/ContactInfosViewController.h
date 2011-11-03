//
//  ContactInfosViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-04-02.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>
// Cells
#import "TextFieldTableViewController.h"

@class AddEstimateLineItemsViewController;
@class Estimate;

@interface ContactInfosViewController : TextFieldTableViewController <NSFetchedResultsControllerDelegate> {
	UIBarButtonItem *nextButton;
	UIBarButtonItem *saveButton;
	AddEstimateLineItemsViewController *lineItemsSelectionViewController;

	NSFetchedResultsController *contactInfos;
	Estimate *estimate;

	BOOL editMode;
}

@property (nonatomic, strong) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, strong) IBOutlet AddEstimateLineItemsViewController *lineItemsSelectionViewController;
@property (nonatomic, strong) NSFetchedResultsController *contactInfos;
@property (nonatomic, strong) Estimate *estimate;
@property (nonatomic, assign) BOOL editMode;


- (IBAction)next:(id)sender;
- (IBAction)save:(id)sender;

@end
