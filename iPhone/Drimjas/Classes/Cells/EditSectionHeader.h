//
//  EditSectionHeader.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-06-05.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditSectionHeader : UIView {
	UILabel *header;
	UIButton *edit;
}

@property (nonatomic, retain) IBOutlet UILabel* header;
@property (nonatomic, retain) IBOutlet UIButton* edit;

@end
