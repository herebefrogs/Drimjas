//
//  AboutViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-08-27.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  GPLv3
//

#import <UIKit/UIKit.h>


@interface AboutViewController : UIViewController {
    UIImageView *logo;
    UITextView *info;
}

@property (nonatomic, strong) IBOutlet UIImageView *logo;
@property (nonatomic, strong) IBOutlet UITextView *info;

@end
