//
//  TableFields.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-04-02.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  GPLv3
//

#import <UIKit/UIKit.h>


@protocol TableFields

typedef enum {
	EstimateDetailSectionOrderNumber = 0,
	EstimateDetailSectionClientInfo,
	EstimateDetailSectionContactInfo,
} EstimateDetailSection;

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
	LineItemSelectionFieldDescription,
	LineItemSelectionFieldQuantity,
	LineItemSelectionFieldUnitCost,

	numLineItemSelectionField
} LineItemSelectionField;

typedef enum {
	LineItemFieldName = 0,
	LineItemFieldDescription,

	numLineItemField
} LineItemField;

typedef enum {
	ContractDetailSectionOrderNumber = 0,
	ContractDetailSectionClientInfo,
	ContractDetailSectionContactInfo,
} ContractDetailSection;

typedef enum {
	InvoiceDetailSectionOrderNumber = 0,
	InvoiceDetailSectionClientInfo,
	InvoiceDetailSectionContactInfo,
} InvoiceDetailSection;


typedef enum {
	TaxesAndCurrencySectionCurrency = 0,
} TaxesAndCurrencySection;

typedef enum {
	TaxesFieldName = 0,
	TaxesFieldPercent,
	TaxesFieldTaxNumber,
	
	numTaxesField
} TaxesField;

typedef enum {
    MyInfoSectionProfession = 0,
    MyInfoSectionOthers,

    numMyInfoSection
} MyInfoSection;

typedef enum {
	MyInfoFieldName = 0,
	MyInfoFieldAddress1,
	MyInfoFieldAddress2,
	MyInfoFieldCity,
	MyInfoFieldState,
	MyInfoFieldPostalCode,
	MyInfoFieldCountry,
	MyInfoFieldPhone,
	MyInfoFieldFax,
	MyInfoFieldEmail,
	MyInfoFieldWebsite,

	numMyInfoField
} MyInfoField;

typedef enum {
	OptionsFieldClients = 0,
	OptionsFieldLineItems,
	OptionsFieldTaxes,
	OptionsFieldMyInfo,
	OptionsFieldAbout,

	numOptionsField
} OptionsField;

@end
