//
//  ClientInformation.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-03-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Estimate;

@interface ClientInformation :  NSManagedObject {
}

@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *address1;
@property (nonatomic, retain) NSString *postalCode;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *address2;
@property (nonatomic, retain) NSSet *estimates;

@end


@interface ClientInformation (CoreDataGeneratedAccessors)
- (void)addEstimatesObject:(Estimate *)value;
- (void)removeEstimatesObject:(Estimate *)value;
- (void)addEstimates:(NSSet *)value;
- (void)removeEstimates:(NSSet *)value;

@end