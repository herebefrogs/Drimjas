//
//  AddEstimateViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Estimate;

@interface AddEstimateClientInfoViewController : UITableViewController <UITextFieldDelegate> {
	UITextField *clientNameTextField;
	UITableViewCell *clientNameCell;

	Estimate *estimate;	// new estimate being created
}

@property (nonatomic, retain) IBOutlet UITextField *clientNameTextField;
@property (nonatomic, retain) IBOutlet UITableViewCell *clientNameCell;

@property (nonatomic, retain) Estimate *estimate;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
