//
//  MyInfoViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-06-26.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>
// Cells
#import "TextFieldTableViewController.h"

@class EstimateDetailViewController;
@class ProfessionsViewController;
@class MyInfo;

@interface MyInfoViewController : TextFieldTableViewController <UITextFieldDelegate> {
	UIBarButtonItem *saveButton;
	EstimateDetailViewController *estimateDetailViewController;
    ProfessionsViewController *professionsViewController;

	MyInfo *myInfo;
	BOOL optionsMode;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, retain) IBOutlet EstimateDetailViewController *estimateDetailViewController;
@property (nonatomic, retain) IBOutlet ProfessionsViewController *professionsViewController;

@property (nonatomic, retain) MyInfo *myInfo;
@property (nonatomic, assign) BOOL optionsMode;

- (IBAction)save:(id)sender;

@end
