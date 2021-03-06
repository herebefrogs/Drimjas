//
//  ClientInfoDetailViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-05-01.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  Apache 2 License
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

@property (nonatomic, strong) IBOutlet UIBarButtonItem *deleteButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, strong) IBOutlet AddEstimateLineItemsViewController *lineItemsViewController;
@property (nonatomic, strong) ClientInfo *clientInfo;
@property (nonatomic, assign) BOOL optionsMode;

- (IBAction)delete:(id)sender;
- (IBAction)next:(id)sender;

@end
