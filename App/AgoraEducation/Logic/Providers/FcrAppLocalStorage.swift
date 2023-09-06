//
//  FcrAppLocalStorage.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/5.
//  Copyright © 2023 Agora. All rights reserved.
//

import Foundation

class FcrAppLocalStorage {
    enum Key: String, CaseIterable {
        case privacyAgreement      = "com.agora.privacyTermsAgree"
             
        case login                 = "com.agora.login"
        case accessToken           = "com.agora.accessToken"
        case refreshToken          = "com.agora.refreshToken"
        case companyId             = "com.agora.companyId"
        case companyName           = "com.agora.companyName"
        case nickname              = "com.agora.nickname"
        case userId                = "com.agora.userId"
             
        case roomId                = "com.agora.roomId"
        case roomName              = "com.agora.roomName"
        case roomDuration          = "com.agora.roomDuration"
        case mediaStreamLatency    = "com.agora.mediaStreamLatency"
             
        case environment           = "com.agora.environment"
        case language              = "com.agora.language"
        case region                = "com.agora.region"
        case uiMode                = "com.agora.uiMode"
             
        case testMode              = "com.agora.testMode"
        
        var isUserInfo: Bool {
            switch self {
            case .privacyAgreement,
                 .environment,
                 .testMode:
                return false
            default:
                return true
            }
        }
    }
    
    func writeData(_ value: Any,
                   key: Key) {
        UserDefaults.standard.set(value,
                                  forKey: key.rawValue)
    }
    
    func readData<T: Any>(key: Key,
                          type: T.Type) throws -> T {
        if let value = UserDefaults.standard.object(forKey: key.rawValue) {
            
            if let StringRawRepresentable = type.self as? any FcrAppStringRawRepresentable.Type {
                let value = StringRawRepresentable.init(rawValue: value as! String)
                
                return value as! T
            } else if let IntRawRepresentable = type.self as? any FcrAppIntRawRepresentable.Type {
                let value = IntRawRepresentable.init(rawValue: value as! Int)
                
                return value as! T
            } else {
                return value as! T
            }
        } else {
            printDebug("read key: \(key), nil")
            
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
        printDebug("remove key: \(key)")
        
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    func cleanUserInfo() {
        let list = Key.allCases
        
        for item in list {
            guard item.isUserInfo else {
                continue
            }
            
            removeData(key: item)
        }
    }
    
    func allClean() {
        let list = Key.allCases
        
        for item in list {
            removeData(key: item)
        }
    }
}
