//
//  AboutViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-08-27.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutViewController : UIViewController {
    UIImageView *logo;
    UITextView *info;
}

@property (nonatomic, strong) IBOutlet UIImageView *logo;
@property (nonatomic, strong) IBOutlet UITextView *info;

@end
