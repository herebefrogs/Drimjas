//
//  DrimjasInfo.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-07-19.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "DrimjasInfo.h"


@implementation DrimjasInfo

+ (NSString *)displayName {
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+ (NSString *)version {
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)title {
	return [NSString stringWithFormat:@"%@ %@",
				[self displayName],
				[self version]];
}

@end
