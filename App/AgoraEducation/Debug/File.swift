//
//  File.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/6/29.
//  Copyright © 2023 Agora. All rights reserved.
//

import Foundation

struct FcrAppError: Error {
    var code: Int
    var message: String
}

fileprivate let PrivacyAgreementKey = "com.agora.privacyTermsAgree"
fileprivate let AccessTokenKey = "com.agora.accessToken"
fileprivate let RefreshTokenKey = "com.agora.refreshToken"
fileprivate let CompanyIdKey = "com.agora.companyId"
fileprivate let NickNameKey = "com.agora.nickname"
fileprivate let ThemeKey = "com.agora.theme"
fileprivate let kQAMode = "com.agora.qaMode"

class FcrAppLocalUser {
    static var isLogined: Bool {
        get {
            if let saved = UserDefaults.standard.object(forKey: AccessTokenKey) as? String {
                return !saved.isEmpty
            } else {
                return false
            }
        }
    }
    
    static var isAgreedPrivacy: Bool {
        get {
            if let agree = UserDefaults.standard.object(forKey: PrivacyAgreementKey) as? Bool {
                return agree
            } else {
                return false
            }
        }
        
        set {
            UserDefaults.standard.set(newValue,
                                      forKey: PrivacyAgreementKey)
        }
    }

    var accessToken: String {
        didSet {
            UserDefaults.standard.set("Bearer " + accessToken,
                                      forKey: AccessTokenKey)
        }
    }
    
    // Using a refreshToken to request an updated accessToken
    var refreshToken: String {
        didSet {
            UserDefaults.standard.set(refreshToken,
                                      forKey: RefreshTokenKey)
        }
    }
    
    var nickName: String {
        didSet {
            UserDefaults.standard.set(nickName,
                                      forKey: NickNameKey)
        }
    }
    
    var companyId: String {
        didSet {
            UserDefaults.standard.set(companyId,
                                      forKey: CompanyIdKey)
        }
    }
    
    var theme: Int {
        didSet {
            UserDefaults.standard.set(theme,
                                      forKey: ThemeKey)
        }
    }
    
    init(accessToken: String,
         refreshToken: String,
         nickName: String,
         companyId: String,
         theme: Int) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.nickName = nickName
        self.companyId = companyId
        self.theme = theme
    }
    
    static func create() throws -> FcrAppLocalUser {
        guard let accessToken = UserDefaults.standard.object(forKey: AccessTokenKey) as? String else {
            throw FcrAppError(code: -1,
                              message: "accessTokey nil")
        }
        
        guard let refreshToken = UserDefaults.standard.object(forKey: RefreshTokenKey) as? String else {
            throw FcrAppError(code: -1,
                              message: "refreshToken nil")
        }
        
        guard let nickName = UserDefaults.standard.object(forKey: NickNameKey) as? String else {
            throw FcrAppError(code: -1,
                              message: "nickName nil")
        }
        
        guard let companyId = UserDefaults.standard.object(forKey: CompanyIdKey) as? String else {
            throw FcrAppError(code: -1,
                              message: "companyId nil")
        }
        
        guard let theme = UserDefaults.standard.object(forKey: ThemeKey) as? Int else {
            throw FcrAppError(code: -1,
                              message: "accessTokey nil")
        }
        
        let localUser = FcrAppLocalUser(accessToken: accessToken,
                                        refreshToken: refreshToken,
                                        nickName: nickName,
                                        companyId: companyId,
                                        theme: theme)
        
        return localUser
    }
}
