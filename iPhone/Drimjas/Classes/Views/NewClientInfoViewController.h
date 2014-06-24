//
//  AddEstimateViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-01-18.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  Apache 2 License
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

@property (nonatomic, strong) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, strong) IBOutlet ContactInfosViewController *contactInfosViewController;
@property (nonatomic, strong) Estimate *estimate;
@property (nonatomic, assign) BOOL editMode;

- (IBAction)next:(id)sender;
- (IBAction)save:(id)sender;

@end
