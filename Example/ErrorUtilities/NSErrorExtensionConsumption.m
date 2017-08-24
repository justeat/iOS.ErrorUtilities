//
//  NSErrorExtensionConsumption.m
//  ErrorUtilities
//
//  Created by Alberto De Bortoli on 28/08/2017.
//  Copyright © 2018 Just Eat Holding Ltd.
//

#import "NSErrorExtensionConsumption.h"
#import "ErrorUtilities_Example-Swift.h"
#import "ObjCDemoErrorBuilder.h"

@import ErrorUtilities;

@implementation NSErrorExtensionConsumption

/**
 * To make sure the ObjC version of the API still looks nice
 */
+ (void)consumptionExample
{
    NSError *temp = [NSError errorWithUnderlyingErrors:@[]];
    temp = [NSError errorWithUnderlyingError:nil domain:@"com.justeat.errorUtilities" code:0 userInfo:nil];
    temp = [temp errorByAddingUnderlyingError:temp];
    temp = [NSError errorByConcatenatingErrors:@[]];
    
    NSArray *chain = [temp errorChain];
    chain = [temp disassociatedErrorChain];
    chain = [temp subsequentErrorChain];
    
    BOOL isPresent = [temp isPresentUnderlyingErrorWithCode:0];
    isPresent = [temp isUnderlyingErrorWithin:NSMakeRange(0, 0) domain:nil];
    isPresent = [temp isUnderlyingErrorWithPartOf:@[] domain:nil];
    
    NSError *underlyingError = [NSError errorWithDomain:@"innerDomain" code:200 userInfo:@{@"inner data": [@"inner data value" dataUsingEncoding:NSUTF8StringEncoding]}];
    temp = [NSError errorWithUnderlyingError:underlyingError domain:@"mainDomain" code:100 userInfo:@{@"data": [@"data value" dataUsingEncoding:NSUTF8StringEncoding]}];
    NSError *humanReadableError = [temp humanReadableError];
    
    NSLog(@"%@", humanReadableError);
    
    NSError *error = [DemoErrorBuilder errorForCode:DemoErrorCodeGeneric];
    NSLog(@"%@", error);
    
    error = [ObjCDemoErrorBuilder errorForCode:ObjCDemoErrorCodeGeneric];
    NSLog(@"%@", error);
}

@end
