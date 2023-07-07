//
//  FcrAppLocalStorage.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/7/5.
//  Copyright © 2023 Agora. All rights reserved.
//

import Foundation

fileprivate let kQAMode = "com.agora.qaMode"

class FcrAppLocalStorage {
    enum Key: String, CaseIterable {
        case privacyAgreement = "com.agora.privacyTermsAgree"
        case accessTokenKey = "com.agora.accessToken"
        case refreshToken = "com.agora.refreshToken"
        case companyId = "com.agora.companyId"
        case companyName = "com.agora.companyName"
        case nickname = "com.agora.nickname"
        case theme = "com.agora.theme"
        
        case region = "com.agora.region"
        case environment = "com.agora.environment"
    }
    
    func writeData(_ value: Any,
                   key: Key) {
        UserDefaults.standard.set(value,
                                  forKey: key.rawValue)
    }
    
    func readData<T: Any>(key: Key,
                          type: T.Type) throws -> T {
        if let value = UserDefaults.standard.object(forKey: key.rawValue) as? T {
            return value
        } else {
            throw FcrAppError(code: -1,
                              message: "\(key.rawValue)'s value is nil")
        }
    }
    
    func hasData(key: Key) -> Bool {
        if let _ = UserDefaults.standard.object(forKey: key.rawValue) {
            return true
        } else {
            return false
        }
    }
    
    func removeData(key: Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    func allClean() {
        let list = Key.allCases
        
        for item in list {
            removeData(key: item)
        }
    }
}
