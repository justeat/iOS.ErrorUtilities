//
//  ObjCDemoErrorBuilder.m
//  ErrorUtilities
//
//  Created by Alberto De Bortoli on 28/08/2017.
//  Copyright © 2018 Just Eat Holding Ltd.
//

#import "ObjCDemoErrorBuilder.h"

NSString * const ObjCDemoErrorDomain = @"com.justeat.demoErrorBuilder";

@implementation ObjCDemoErrorBuilder

+ (NSError * _Nonnull)errorForCode:(NSInteger)code
{
    NSMutableDictionary * userInfo = [[NSMutableDictionary alloc] init];
    userInfo[NSLocalizedDescriptionKey] = [self _localizedDescriptionForCode:code];
    userInfo[NSLocalizedFailureReasonErrorKey] = [self _failureReasonForCode:code];;
    
    return [NSError errorWithDomain:ObjCDemoErrorDomain code:code userInfo:userInfo];
}

#pragma mark - Private

+ (NSString *)_localizedDescriptionForCode:(ObjCDemoErrorCode)code
{
    switch (code) {
        case ObjCDemoErrorCodeGeneric:
            return @"generic localized description";
        case ObjCDemoErrorCodeNotGeneric:
            return @"not generic localized description";
    }
    
    return @"";
}

+ (NSString *)_failureReasonForCode:(ObjCDemoErrorCode)code
{
    switch (code) {
        case ObjCDemoErrorCodeGeneric:
            return @"generic failure reason";
        case ObjCDemoErrorCodeNotGeneric:
            return @"not generic failure reason";
    }
    
    return @"";
}

@end
