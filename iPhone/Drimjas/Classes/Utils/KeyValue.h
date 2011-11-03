//
//  KeyValue.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-07-21.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
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
