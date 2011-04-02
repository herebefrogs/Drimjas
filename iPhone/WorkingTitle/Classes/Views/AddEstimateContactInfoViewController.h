//
//  AddEstimateContactInfoViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-04-02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
// Cells
#import "TextFieldTableViewController.h"

@class Estimate;

@interface AddEstimateContactInfoViewController : TextFieldTableViewController {
	UIBarButtonItem *saveButton;

	Estimate *estimate;	// new estimate being created
	NSMutableArray *contactInfos; // ordered contact infos being created
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveButton;

@property (nonatomic, retain) Estimate *estimate;
@property (nonatomic, retain) NSMutableArray *contactInfos;

- (IBAction)save:(id)sender;

@end
