//
//  ClientInfoDetailViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-05-01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClientInfo;
@class AddEstimateLineItemsViewController;

@interface ClientInfoDetailViewController : UITableViewController {
	UIBarButtonItem *nextButton;
	AddEstimateLineItemsViewController *lineItemsViewController;
	ClientInfo *clientInfo;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, retain) IBOutlet AddEstimateLineItemsViewController *lineItemsViewController;
@property (nonatomic, retain) ClientInfo *clientInfo;

- (IBAction)next:(id)sender;

@end
