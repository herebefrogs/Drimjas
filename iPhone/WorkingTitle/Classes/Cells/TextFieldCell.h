//
//  TextFieldCell.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-03-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TextFieldCell : UITableViewCell {
	UITextField *textField;
}

@property (nonatomic, retain) IBOutlet UITextField *textField;

@end
