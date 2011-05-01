//
//  AddEstimateReviewClientInfoViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-05-01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClientInformation;
@class AddEstimateLineItemsViewController;

@interface AddEstimateReviewClientInfoViewController : UITableViewController {
	UIBarButtonItem *nextButton;
	AddEstimateLineItemsViewController *lineItemsViewController;
	ClientInformation *clientInfo;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, retain) IBOutlet AddEstimateLineItemsViewController *lineItemsViewController;
@property (nonatomic, retain) ClientInformation *clientInfo;

- (IBAction)next:(id)sender;

@end
