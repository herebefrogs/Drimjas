//
//  MyInfoViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-06-26.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  Apache 2 License
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

@property (nonatomic, strong) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, strong) IBOutlet EstimateDetailViewController *estimateDetailViewController;
@property (nonatomic, strong) IBOutlet ProfessionsViewController *professionsViewController;

@property (nonatomic, strong) MyInfo *myInfo;
@property (nonatomic, assign) BOOL optionsMode;

- (IBAction)save:(id)sender;

@end
