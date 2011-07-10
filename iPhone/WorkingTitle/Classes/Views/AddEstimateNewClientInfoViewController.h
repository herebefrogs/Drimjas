//
//  AddEstimateViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
// Cells
#import "TextFieldTableViewController.h"

@class ContactInfosViewController;
@class Estimate;

@interface AddEstimateNewClientInfoViewController : TextFieldTableViewController {
	UIBarButtonItem *nextButton;
	ContactInfosViewController *contactInfosViewController;

	Estimate *estimate;	// new estimate being created
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, retain) IBOutlet ContactInfosViewController *contactInfosViewController;

@property (nonatomic, retain) Estimate *estimate;

- (IBAction)next:(id)sender;

@end
