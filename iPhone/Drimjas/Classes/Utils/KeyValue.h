//
//  KeyValue.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-07-21.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  Apache 2 License
//

#import <Foundation/Foundation.h>


@interface KeyValue : NSObject {
	id key;
	id value;
}

- initWithKey:(id)newKey value:(id)newValue;
@property (nonatomic, strong) id key;
@property (nonatomic, strong) id value;

@end
