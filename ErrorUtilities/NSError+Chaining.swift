//
//  NSError+Chaining.swift
//  ErrorUtilities
//
//  Created by Federico Cappelli on 24/08/2017.
//  Copyright © 2018 Just Eat Holding Ltd.
//

import Foundation

/**
 Documentation: https://tech.just-eat.com/?p=465107
 Terminology:
 - Underlying errors: a sequence of nested errors (vai the NSUnderlyingErrorKey in the userInfo dictionary)
 - Error chain: Underlying errors in a flattened, array version. Each error still have the NSUnderlyingErrorKey key in the UserInfo.
 - Dissociated Error chain: Underlying errors in a flattened, array version. The NSUnderlyingErrorKey key has been set to nil in each Error's UserInfo.
 
 */
extension NSError {
    
    //MARK: - Creation
    
    /**
     Creates a chain of nested underlying errors from an array of errors.
     
     - parameter underlyingErrors: An array of NSErrors.
     - returns: The first error of the provided array with all the other errors nested ad underyling errors.
     */
    @objc public static func error(underlyingErrors: [NSError]) -> NSError? {
        guard let error = underlyingErrors.first else {
            return nil
        }
        
        if underlyingErrors.count > 1 {
            var userInfo = error.userInfo
            userInfo[NSUnderlyingErrorKey] = self.error(underlyingErrors: Array(underlyingErrors.dropFirst(1)))
            return NSError(domain: error.domain, code: error.code, userInfo: userInfo)
        }
        else {
            return error
        }
    }
    
    /**
     Creates a new error with the underlying NSError provided.
     - parameter underlyingError: The NSError to underline.
     - parameter domain: The new error domain.
     - parameter code: The new error code.
     - parameter userInfo: The new error UserInfo, will be integrated with the NSUnderlyingErrorKey.
     - returns: A new error with underlyingError as NSUnderlyingErrorKey, the provided domain, error code and user info.
     */
    @objc public static func error(underlyingError: NSError?, domain: String, code: Int, userInfo: [String : Any]? = nil) -> NSError {
        var localUserInfo = userInfo ?? [String : Any]()
        
        if underlyingError != nil {
            localUserInfo[NSUnderlyingErrorKey] = underlyingError
        }
        return NSError(domain: domain, code: code, userInfo: localUserInfo)
    }
    
    //MARK: - Composition

    /**
     Add an error to the current error as underlying error.
     - parameter underlyingError: The error to set as underlying error.
     - returns: A new error with the same characteristics of the current one plus the provided error set for NSUnderlyingErrorKey in the userInfo.
     */
    @objc (errorByAddingUnderlyingError:)
    public func errorByAdding(underlyingError: NSError) -> NSError {
        var userInfo =  self.userInfo
        userInfo[NSUnderlyingErrorKey] = underlyingError
        return NSError(domain: self.domain, code: self.code, userInfo: userInfo)
    }
        
    /**
     Concatenates separated errors with underlying errors in a continuous linked list of Errors.
     - parameter errors: N errors eg: 3 errors like (3(2(1))) + (4) + (6(7(8)))
     - returns: A continous chain of underlying errors, eg: (3(2(1(4(6(7(8))))))))
     */
    @objc (errorByConcatenatingErrors:)
    public static func errorByConcatenating(_ errors:[NSError]) -> NSError? {
        
        var completeChain: [NSError] = []
        for error in errors {
            completeChain.append(contentsOf: error.errorChain())
        }
        
        return NSError.error(underlyingErrors: completeChain)
    }
    
    //MARK: - Querying
    
    /**
     Extracts and returns all the errors under the NSUnderlyingErrorKey, recursively.
     - Returns: An Array<NSError> with all the underlying errors including self
     */
    @objc public func errorChain() -> [NSError] {
        guard let underError = self.userInfo[NSUnderlyingErrorKey] as? NSError else {
            return [self]
        }
        return [self] + underError.errorChain()
    }
    
    /**
     Extracts and returns all the errors under the NSUnderlyingErrorKey, recursively. After extracting an error, it creates a copy of it self by removing the NSUnderlyingErrorKey key.
     - Returns: An Array<NSError> with all the underlying errors including self after it disassociates the connected errors.
     */
    @objc public func disassociatedErrorChain() -> [NSError] {
        
        guard let underError = self.userInfo[NSUnderlyingErrorKey] as? NSError else {
            return [self]
        }
        
        var userInfoCopy = self.userInfo
        userInfoCopy.removeValue(forKey: NSUnderlyingErrorKey)
        let copyOfSelf = NSError(domain: self.domain, code: self.code, userInfo: userInfoCopy)
        
        return [copyOfSelf] + underError.disassociatedErrorChain()
    }
    
    /**
     Extracts and returns all the errors under the NSUnderlyingErrorKey, recursively.
     - Returns: An Array<NSError> with all the underlying errors excluding self
     */
    @objc public func subsequentErrorChain() -> [NSError] {
        guard let underError = self.userInfo[NSUnderlyingErrorKey] as? NSError else {
            return []
        }
        
        return [underError] + underError.subsequentErrorChain()
    }
    
    /**
     Check if any error code in the Underlying errors linked list matches the provided code.
     - parameter : Error code to check.
     - returns: True if the error code is found in any of the errors. False otherwise.
     */
    @objc public func isPresentUnderlyingError(code: Int) -> Bool {
        for underError in self.errorChain() {
            if underError.code == code {
                return true
            }
        }
        return false
    }
    
    /**
     Check if any of the underlying errors has the code and domain provided.
     - parameter range: Error codes range to check.
     - parameter domain: Error domain to check. (Optional)
     - returns: True if one of the error codes from the provided range and domain is found in any of the errors. False otherwise.
     */
    @objc public func isUnderlyingError(within range: NSRange, domain: String? = nil) -> Bool {
        guard let codeRange = Range(range) else {
            return false
        }
        
        for underError in self.errorChain() {
            if domain != nil {
                if codeRange.contains(underError.code) && underError.domain == domain {
                    return true
                }
            }
            else {
                if codeRange.contains(underError.code) {
                    return true
                }
            }
        }
        return false
    }
    
    /**
     Check if any of the underlying errors has an error code from the provided array and if the domain matches.
     - parameter codesArray: Error codes to check.
     - parameter domain: Error domain to check. (Optional)
     - returns: True if one of the error codes from the provided array and domain is found in any of the errors. False otherwise.
     */
    @objc public func isUnderlyingError(partOf codesArray: [Int], domain: String? = nil) -> Bool {
        if codesArray.count == 0 {
            return false
        }
        
        for underError in self.errorChain()  {
            if domain != nil {
                if codesArray.contains(underError.code) && underError.domain == domain {
                    return true
                }
            }
            else {
                if codesArray.contains(underError.code) {
                    return true
                }
            }
        }
        return false
    }
}
