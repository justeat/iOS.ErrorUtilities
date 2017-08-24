//
//  NSError+Readability.swift
//  ErrorUtilities
//
//  Created by Alberto De Bortoli on 28/08/2017.
//  Copyright © 2018 Just Eat Holding Ltd.
//

import Foundation

extension NSError {
    
    /**
     Parses Data values in the user info key as String and recursively does the same to all associated underying errors.
     
        - Returns: A copy of the error including all the info contained in the underlined errors
     */
    @objc public func humanReadableError() -> NSError {
        
        var flattenedUserInfo = userInfo
        
        for (key, value) in userInfo {
            
            switch (value) {
            case let string as String:
                flattenedUserInfo[key] = string
            case let data as Data:
                flattenedUserInfo[key] = String(data: data, encoding: String.Encoding.utf8)
            case let error as NSError:
                flattenedUserInfo[key] = error.humanReadableError()
            default:
                continue
            }
        }
        return NSError(domain: domain, code: code, userInfo: flattenedUserInfo)
    }
}
