//
//  AddEstimateViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EstimatesViewController;

@interface AddEstimateViewController : UITableViewController <UITextFieldDelegate> {
	// cannot be named 'navigationItem' as it gets masked by UIViewController's one
	IBOutlet UINavigationItem *navItem;
	
	IBOutlet UITextField *clientNameTextField;
	IBOutlet UITableViewCell *clientNameCell;

	IBOutlet EstimatesViewController *estimatesViewController;
}

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
