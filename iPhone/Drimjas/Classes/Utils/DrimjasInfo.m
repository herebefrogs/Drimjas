//
//  DrimjasInfo.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-07-19.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  Apache 2 License
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
