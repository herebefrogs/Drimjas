//
//  TextFieldCell.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-03-27.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  Apache 2 License
//

#import <UIKit/UIKit.h>


@interface TextFieldCell : UITableViewCell {
	UITextField *textField;
}

@property (nonatomic, strong) IBOutlet UITextField *textField;

@end
