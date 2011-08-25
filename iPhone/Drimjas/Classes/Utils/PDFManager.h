//
//  PDFManager.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-01-31.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Estimate;
@class Contract;

@interface PDFManager : NSObject {

}

+ (BOOL)savePDFFileForEstimate:(Estimate *)estimate;
+ (NSString *)getPDFPathForEstimate:(Estimate *)estimate;


+ (NSMutableData *)pdfDataForEstimate:(Estimate *)estimate;	// PDF content
+ (NSString *)pdfNameForEstimate:(Estimate *)estimate;		// PDF filename
+ (NSString *)pdfTitleForEstimate:(Estimate *)estimate;		// PDF title as appearing in PDF metadata
+ (NSDictionary *)pdfInfoForEstimate:(Estimate *)estimate;	// dictionary of PDF metadata


+ (NSMutableData *)pdfDataForContract:(Contract *)contract;
+ (NSString *)pdfNameForContract:(Contract *)contract;

@end