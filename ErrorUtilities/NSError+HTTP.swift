//
//  NSError+HTTP.swift
//  ErrorUtilities
//
//  Created by Alberto De Bortoli on 08/09/2017.
//  Copyright © 2018 Just Eat Holding Ltd.
//

import Foundation

/**
 NSError extension that implements some utility methods for detect standard HTTP errors in the errors chain
 */
extension NSError {
    
    /**
     - returns: true if the error chain contains an error with a code between 400 and 499, false otherwise
     */
    @objc public func isClientError() -> Bool {
        return isUnderlyingError(within: NSMakeRange(400, 100))
    }
    
    /**
        - returns: true if the error chain contains an error with a code between 500 and 599, false otherwise
     */
    @objc public func isServerError() -> Bool {
        return isUnderlyingError(within: NSMakeRange(500, 100))
    }
    
    /**
        - returns: true if the error chain contains an error with a code equal matching one of the following codes:
            - 408 : request timeout
            - 504 : gateway timeout
            - 598 : network read timeout
            - 599 : network connect timeout
     */
    @objc public func isTimeoutError() -> Bool {
        return isPresentUnderlyingError(code: NSURLErrorTimedOut) ||
            isPresentUnderlyingError(code: 408) || // request timeout
            isPresentUnderlyingError(code: 504) || // gateway timeout
            isPresentUnderlyingError(code: 598) || // network read timeout
            isPresentUnderlyingError(code: 599)    // network connect timeout
    }
    
    /**
     - returns: true if the error chain contains an error with a code equal to NSURLErrorNotConnectedToInternet, false otherwise
     */
    @objc public func isConnectivityError() -> Bool {
        return isPresentUnderlyingError(code: NSURLErrorNotConnectedToInternet)
    }
    
    /**
     - returns: true if the error chain contains an error equal to 429, false otherwise
     */
    @objc public func isTooManyRequestsError() -> Bool {
        return isPresentUnderlyingError(code: 429)
    }
    
    /**
     - returns: true if the error chain contains an error equal to 401, false otherwise
     */
    @objc public func isAuthorizationError() -> Bool {
        return isPresentUnderlyingError(code: 401)
    }
}
