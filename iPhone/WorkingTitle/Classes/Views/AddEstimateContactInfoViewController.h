//
//  AddEstimateContactInfoViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-04-02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
// Cells
#import "TextFieldTableViewController.h"

@class AddEstimateLineItemsViewController;

@interface AddEstimateContactInfoViewController : TextFieldTableViewController {
	UIBarButtonItem *nextButton;
	AddEstimateLineItemsViewController *lineItemsViewController;

	NSMutableArray *contactInfos; // ordered contact infos being created
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, retain) IBOutlet AddEstimateLineItemsViewController *lineItemsViewController;
@property (nonatomic, retain) NSMutableArray *contactInfos;

- (IBAction)next:(id)sender;

@end
