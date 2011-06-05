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
	ReviewEstimateSectionOrderNumber = 0,
	ReviewEstimateSectionClientInfo,
	ReviewEstimateSectionContactInfo,
} ReviewEstimateSection;

typedef enum {
	NewClientInfoSection = 0,
	PickClientInfoSection,
	
	numClientInfoSection
} ClientInfoSection;

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

typedef enum {
	LineItemSelectionFieldName = 0,
	LineItemSelectionFieldDetails,
	LineItemSelectionFieldQuantity,
	LineItemSelectionFieldUnitCost,

	numLineItemSelectionField
} LineItemSelectionField;

typedef enum {
	LineItemFieldName = 0,
	LineItemFieldDetails,

	numLineItemField
} LineItemField;

@end
