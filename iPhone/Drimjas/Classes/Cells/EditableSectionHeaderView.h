//
//  EditSectionHeader.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-06-05.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  GPLv3
//

#import <UIKit/UIKit.h>


@interface EditableSectionHeaderView : UIView {
	UILabel *header;
	UIButton *edit;
}

@property (nonatomic, strong) IBOutlet UILabel* header;
@property (nonatomic, strong) IBOutlet UIButton* edit;

@end