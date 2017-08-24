//
//  ObjCDemoErrorBuilder.h
//  ErrorUtilities
//
//  Created by Alberto De Bortoli on 28/08/2017.
//  Copyright © 2018 Just Eat Holding Ltd.
//

@import Foundation;
@import ErrorUtilities;

extern NSString *const ObjCDemoErrorDomain;

typedef NS_ENUM(NSInteger, ObjCDemoErrorCode) {
    ObjCDemoErrorCodeGeneric = 1000,
    ObjCDemoErrorCodeNotGeneric
};

@interface ObjCDemoErrorBuilder : NSObject <ErrorBuilderProtocol>

@end
