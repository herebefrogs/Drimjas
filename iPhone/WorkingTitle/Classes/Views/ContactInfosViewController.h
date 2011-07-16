//
//  ContactInfosViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-04-02.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>
// Cells
#import "TextFieldTableViewController.h"

@class AddEstimateLineItemsViewController;
@class ClientInfo;

@interface ContactInfosViewController : TextFieldTableViewController <NSFetchedResultsControllerDelegate> {
	UIBarButtonItem *nextButton;
	UIBarButtonItem *saveButton;
	AddEstimateLineItemsViewController *lineItemsSelectionViewController;

	NSFetchedResultsController *contactInfos;
	ClientInfo *clientInfo;

	BOOL editMode;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, retain) IBOutlet AddEstimateLineItemsViewController *lineItemsSelectionViewController;
@property (nonatomic, retain) NSFetchedResultsController *contactInfos;
@property (nonatomic, retain) ClientInfo *clientInfo;
@property (nonatomic, assign) BOOL editMode;


- (IBAction)next:(id)sender;
- (IBAction)save:(id)sender;

@end
