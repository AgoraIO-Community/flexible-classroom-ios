//
//  FcrAppTester.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/8/22.
//  Copyright © 2023 Agora. All rights reserved.
//

import Foundation

protocol FcrAppTesterDelegate: NSObjectProtocol {
    func onIsTestMode(_ isTest: Bool)
}

class FcrAppTester {
    private var isTest: Bool = false {
        didSet {
            delegate?.onIsTestMode(isTest)
        }
    }
    
    private var count: Int = 0
    
    weak var delegate: FcrAppTesterDelegate?
    
    func switchMode() {
        if isTest {
            count -= 1
            
            if count == 0 {
                isTest = false
            }
        } else {
            count += 1
            
            if count == 10 {
                isTest = true
            }
        }
    }
}
