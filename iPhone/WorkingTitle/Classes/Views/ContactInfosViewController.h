//
//  ContactInfosViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-04-02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
// Cells
#import "TextFieldTableViewController.h"

@class AddEstimateLineItemsViewController;
@class ClientInfo;

@interface ContactInfosViewController : TextFieldTableViewController <NSFetchedResultsControllerDelegate> {
	UIBarButtonItem *nextButton;
	AddEstimateLineItemsViewController *lineItemsSelectionViewController;

	NSFetchedResultsController *contactInfos;
	ClientInfo *clientInfo;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, retain) IBOutlet AddEstimateLineItemsViewController *lineItemsSelectionViewController;
@property (nonatomic, retain) NSFetchedResultsController *contactInfos;
@property (nonatomic, retain) ClientInfo *clientInfo;


- (IBAction)next:(id)sender;

@end
