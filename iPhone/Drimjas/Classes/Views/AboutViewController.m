//
//  AboutViewController.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-08-27.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  GPLv3
//

#import "AboutViewController.h"
#import "DrimjasInfo.h"


@interface AboutViewController ()

- (void)centerContent;

@end


@implementation AboutViewController

@synthesize logo;
@synthesize info;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = NSLocalizedString(@"About", "AboutViewController Navigation Title");

    self.info.text = [NSString stringWithFormat:NSLocalizedString(@"AboutViewController.info", "AboutViewController Info"),
                      [DrimjasInfo version]];
}

- (void)viewWillAppear:(BOOL)animated {
    [self centerContent];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    [self centerContent];
}

- (void)centerContent {
    CGFloat logoY = (self.view.bounds.size.height - (self.logo.bounds.size.height + self.info.bounds.size.height)) / 2;

    self.logo.frame = CGRectMake((self.view.bounds.size.width - self.logo.bounds.size.width) / 2,
                                 logoY,
                                 self.logo.bounds.size.width,
                                 self.logo.bounds.size.height);

    self.info.frame = CGRectMake((self.view.bounds.size.width - self.info.bounds.size.width) / 2,
                                 logoY + self.logo.bounds.size.height,
                                 self.info.bounds.size.width,
                                 self.info.bounds.size.height);

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.logo = nil;
    self.info = nil;
}



@end
