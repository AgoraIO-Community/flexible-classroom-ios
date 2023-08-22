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
    private(set) var isTest: Bool = false {
        didSet {
            guard isTest != oldValue else {
                return
            }
            
            delegate?.onIsTestMode(isTest)
            
            localStorage.writeData(isTest,
                                   key: .testMode)
        }
    }
    
    private var count: Int = 0
    
    private let localStorage: FcrAppLocalStorage
    
    weak var delegate: FcrAppTesterDelegate?
    
    init(localStorage: FcrAppLocalStorage) {
        self.localStorage = localStorage
        
        if let isTest = try? localStorage.readData(key: .testMode,
                                                   type: Bool.self) {
            self.isTest = isTest
            
            if isTest {
                count = 10
            }
        }
    }
    
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
