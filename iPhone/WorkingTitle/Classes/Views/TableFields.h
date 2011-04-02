//
//  TableFields.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-04-02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TableFields

typedef enum {
	ClientInfoFieldName = 0,
	ClientInfoFieldAddress1,
	ClientInfoFieldAddress2,
	ClientInfoFieldCity,
	ClientInfoFieldState,
	ClientInfoFieldPostalCode,
	ClientInfoFieldCountry,

	numClientInfoField
} ClientInfoField;

typedef enum {
	ContactInfoFieldName = 0,
	ContactInfoFieldPhone,
	ContactInfoFieldEmail,

	numContactInfoField
} ContactInfoField;


@end
