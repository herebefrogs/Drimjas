//
//  TextFieldCell.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-03-27.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TextFieldCell : UITableViewCell {
	UITextField *textField;
}

@property (nonatomic, strong) IBOutlet UITextField *textField;

@end
