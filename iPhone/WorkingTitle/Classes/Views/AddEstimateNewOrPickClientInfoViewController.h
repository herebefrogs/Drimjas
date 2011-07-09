//
//  AddEstimateNewOrPickViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-04-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddEstimateNewClientInfoViewController;
@class ClientInfosViewController;

@interface AddEstimateNewOrPickClientInfoViewController : UITableViewController {
	AddEstimateNewClientInfoViewController *newClientInfoViewController;
	ClientInfosViewController *clientInfosViewController;
}

@property (nonatomic, retain) IBOutlet AddEstimateNewClientInfoViewController *newClientInfoViewController;
@property (nonatomic, retain) IBOutlet ClientInfosViewController *clientInfosViewController;

- (IBAction)cancel:(id)sender;

@end
