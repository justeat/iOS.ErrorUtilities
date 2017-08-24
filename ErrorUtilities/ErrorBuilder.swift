//
//  ErrorBuilder.swift
//  ErrorUtilities
//
//  Created by Federico Cappelli on 24/08/2017.
//  Copyright © 2018 Just Eat Holding Ltd.
//

import UIKit

public typealias ErrorCode = Int

/*
 Each app and module has its own error builder, where the error domain is specified and the errors are created, using the pre-assigned error code range.
 Documentation: https://tech.just-eat.com/?p=465107
 */
@objc(ErrorBuilderProtocol) public protocol ErrorBuilder {
    
    @objc static func error(forCode code: ErrorCode) -> NSError
}
