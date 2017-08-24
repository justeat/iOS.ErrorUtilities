//
//  ViewController.swift
//  ErrorUtilities
//
//  Created by federicocappelli-je on 08/24/2017.
//  Copyright © 2018 Just Eat Holding Ltd.
//

import UIKit
import ErrorUtilities

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSErrorExtensionConsumption.consumptionExample()
        
        let error = DemoErrorBuilder.error(forCode: DemoErrorCode.generic.rawValue)
        print(error.humanReadableError());
    }

}

