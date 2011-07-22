//
//  PDFManager.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-01-31.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Estimate;

@interface PDFManager : NSObject {

}

+ (NSMutableData *)pdfDataForEstimate:(Estimate *)estimate;
+ (BOOL)savePDFFileForEstimate:(Estimate *)estimate;
+ (NSString *)getPDFNameForEstimate:(Estimate *)estimate;
+ (NSString *)getPDFPathForEstimate:(Estimate *)estimate;

// PDF title as appearing in PDF metadata
+ (NSString *)pdfTitleForEstimate:(Estimate *)estimate;
// dictionary of PDF metadata
+ (NSDictionary *)pdfInfoForEstimate:(Estimate *)estimate;

// paper size fit for user locale
+ (CGRect)paperSizeForUserLocale;

@end
