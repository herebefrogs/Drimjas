//
//  AddEstimateViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-01-18.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>
// Cells
#import "TextFieldTableViewController.h"

@class ContactInfosViewController;
@class Estimate;

@interface NewClientInfoViewController : TextFieldTableViewController {
	UIBarButtonItem *nextButton;
	UIBarButtonItem *saveButton;
	ContactInfosViewController *contactInfosViewController;

	Estimate *estimate;	// new estimate being created

	BOOL editMode;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, retain) IBOutlet ContactInfosViewController *contactInfosViewController;
@property (nonatomic, retain) Estimate *estimate;
@property (nonatomic, assign) BOOL editMode;

- (IBAction)next:(id)sender;
- (IBAction)save:(id)sender;

@end
