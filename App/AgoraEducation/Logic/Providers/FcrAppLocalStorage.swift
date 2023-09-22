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
        case firstPrivacyAgreement = "com.agora.first.privacyTermsAgree"
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
        printDebug("write key: \(key), value: \(value)")
        UserDefaults.standard.set(value,
                                  forKey: key.rawValue)
    }
    
    func readStringEnumData<T: FcrAppStringRawRepresentable>(key: Key,
                                                             type: T.Type) throws -> T {
        let stringValue = try readData(key: key,
                                       type: String.self)

        if let value = T(rawValue: stringValue) {
            return value
        } else {
            throw FcrAppError(code: -1,
                              message: "FcrAppStringRawRepresentable \(key.rawValue)'s value is nil")
        }
    }

    func readIntEnumData<T: FcrAppIntRawRepresentable>(key: Key,
                                                       type: T.Type) throws -> T {
        let intValue = try readData(key: key,
                                    type: Int.self)

        if let value = T(rawValue: intValue) {
            return value
        } else {
            throw FcrAppError(code: -1,
                              message: "FcrAppIntRawRepresentable \(key.rawValue)'s value is nil")
        }
    }

    func readData<T: Any>(key: Key,
                          type: T.Type) throws -> T {
        if let value = UserDefaults.standard.object(forKey: key.rawValue) {
            if let `value` = value as? T {
                printDebug("read key: \(key), value: \(value)")
                return value
            } else {
                printDebug("read key: \(key), nil")

                throw FcrAppError(code: -1,
                                  message: "\(key.rawValue)'s value is translated unsuccessfully")
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
