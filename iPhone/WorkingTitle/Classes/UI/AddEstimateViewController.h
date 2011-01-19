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
	UITextField *clientNameTextField;
	UITableViewCell *clientNameCell;

	EstimatesViewController *estimatesViewController;
}

@property (nonatomic, retain) IBOutlet UITextField *clientNameTextField;
@property (nonatomic, retain) IBOutlet UITableViewCell *clientNameCell;

@property (nonatomic, retain) IBOutlet EstimatesViewController *estimatesViewController;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
