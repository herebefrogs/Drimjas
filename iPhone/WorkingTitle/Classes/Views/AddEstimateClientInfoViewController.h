//
//  AddEstimateViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextFieldCell;
@class Estimate;

@interface AddEstimateClientInfoViewController : UITableViewController <UITextFieldDelegate> {
	TextFieldCell *textFieldCell;

	Estimate *estimate;	// new estimate being created
}

@property (nonatomic, retain) IBOutlet TextFieldCell *textFieldCell;

@property (nonatomic, retain) Estimate *estimate;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
