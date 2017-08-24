//
//  DemoErrorBuilder.swift
//  ErrorUtilities
//
//  Created by Alberto De Bortoli on 28/08/2017.
//  Copyright © 2018 Just Eat Holding Ltd.
//

import Foundation
import ErrorUtilities

public let demoErrorDomain = "com.justeat.demoErrorBuilder"

@objc public enum DemoErrorCode: ErrorCode {
    case generic = 1000
    case notGeneric
}

@objc public class DemoErrorBuilder: NSObject, ErrorBuilder {
    
    public static func error(forCode code: ErrorCode) -> NSError {
        
        var userInfo = [String: Any]()
        userInfo[NSLocalizedDescriptionKey] = localizedDescriptionForCode(code: code)
        userInfo[NSLocalizedFailureReasonErrorKey] = failureReasonForCode(code: code)
        
        return NSError(domain: demoErrorDomain, code: code, userInfo: userInfo)
    }
    
    private static func localizedDescriptionForCode(code: ErrorCode) -> String {
        switch code {
        case DemoErrorCode.generic.rawValue:
            return "generic localized description"
        case DemoErrorCode.notGeneric.rawValue:
            return "not generic localized description"
        default:
            return ""
        }
    }
    
    private static func failureReasonForCode(code: ErrorCode) -> String {
        switch code {
        case DemoErrorCode.generic.rawValue:
            return "generic failure reason"
        case DemoErrorCode.notGeneric.rawValue:
            return "not generic failure reason"
        default:
            return ""
        }
    }
}
