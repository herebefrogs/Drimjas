//
//  ClientInfoDetailViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-05-01.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClientInfo;
@class AddEstimateLineItemsViewController;

@interface ClientInfoDetailViewController : UITableViewController {
	UIBarButtonItem *deleteButton;
	UIBarButtonItem *nextButton;
	AddEstimateLineItemsViewController *lineItemsViewController;
	ClientInfo *clientInfo;

	BOOL optionsMode;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *deleteButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, retain) IBOutlet AddEstimateLineItemsViewController *lineItemsViewController;
@property (nonatomic, retain) ClientInfo *clientInfo;
@property (nonatomic, assign) BOOL optionsMode;

- (IBAction)delete:(id)sender;
- (IBAction)next:(id)sender;

@end
