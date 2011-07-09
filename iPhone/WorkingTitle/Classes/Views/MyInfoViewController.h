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

@class EstimateDetailViewController;
@class MyInfo;

@interface MyInfoViewController : TextFieldTableViewController <UITextFieldDelegate> {
	UIBarButtonItem *saveButton;
	EstimateDetailViewController *estimateDetailViewController;

	MyInfo *myInfo;
	BOOL optionsMode;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, retain) IBOutlet EstimateDetailViewController *estimateDetailViewController;

@property (nonatomic, retain) MyInfo *myInfo;
@property (nonatomic, assign) BOOL optionsMode;

- (IBAction)save:(id)sender;

@end
