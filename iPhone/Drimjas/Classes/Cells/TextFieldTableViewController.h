//
//  TextFieldTableViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-04-06.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextFieldCell;

@interface TextFieldTableViewController : UITableViewController <UITextFieldDelegate> {
	TextFieldCell *textFieldCell;
	UITextField *lastTextFieldEdited;
}


@property (nonatomic, retain) IBOutlet TextFieldCell *textFieldCell;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
