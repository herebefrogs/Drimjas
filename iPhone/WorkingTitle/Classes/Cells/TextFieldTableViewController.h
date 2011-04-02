//
//  TextFieldTableViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-04-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextFieldCell;

@interface TextFieldTableViewController : UITableViewController <UITextFieldDelegate> {
	TextFieldCell *textFieldCell;
	UITextField *lastTextFieldEdited;
}


@property (nonatomic, retain) IBOutlet TextFieldCell *textFieldCell;

- (BOOL)requiredFieldsProvided:(UITextField *)textField;

@end
