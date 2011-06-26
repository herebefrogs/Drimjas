//
//  MyInfoViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-06-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
// Cells
#import "TextFieldTableViewController.h"

@class ReviewEstimateViewController;
@class MyInfo;

@interface MyInfoViewController : TextFieldTableViewController <UITextFieldDelegate> {
	UIBarButtonItem *saveButton;
	ReviewEstimateViewController *reviewEstimateViewController;

	MyInfo *myInfo;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, retain) IBOutlet ReviewEstimateViewController *reviewEstimateViewController;

@property (nonatomic, retain) MyInfo *myInfo;

- (IBAction)save:(id)sender;

@end
