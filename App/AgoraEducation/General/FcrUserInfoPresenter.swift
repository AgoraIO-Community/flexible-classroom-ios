//
//  FcrUserInfoPresenter.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/6/30.
//  Copyright © 2022 Agora. All rights reserved.
//

import WebKit
import UIKit

class FcrUserInfoPresenter {
    private let kAccessToken = "com.agora.accessToken"
    private let kRefreshToken = "com.agora.refreshToken"
    private let kCompanyId = "com.agora.companyId"
    private let kNickName = "com.agora.nickname"
    private let kTheme = "com.agora.theme"
    private let kQAMode = "com.agora.qaMode"
    
    static let shared = FcrUserInfoPresenter()
    
    public func logout(complete: (() -> Void)?) {
        let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let fromDate = Date(timeIntervalSince1970: 0)
        
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes,
                                                modifiedSince: fromDate) {
            UserDefaults.standard.set(nil,
                                      forKey: self.kAccessToken)
            UserDefaults.standard.set(nil,
                                      forKey: self.kRefreshToken)
            UserDefaults.standard.set(nil,
                                      forKey: self.kNickName)
            UserDefaults.standard.set(nil,
                                      forKey: self.kCompanyId)
            complete?()
        }
    }
    
    public var isLogin: Bool {
        get {
            if let saved = UserDefaults.standard.object(forKey: kAccessToken) as? String {
                return !saved.isEmpty
            } else {
                return false
            }
        }
    }
    
    public var accessToken: String {
        set {
            UserDefaults.standard.set("Bearer " + newValue,
                                      forKey: kAccessToken)
        }
        get {
            let saved = UserDefaults.standard.object(forKey: kAccessToken) as? String
            return saved ?? ""
        }
    }
    
    // Using a refreshToken to request an updated accessToken
    public var refreshToken: String {
        set {
            UserDefaults.standard.set(newValue,
                                      forKey: kRefreshToken)
        }
        get {
            let saved = UserDefaults.standard.object(forKey: kRefreshToken) as? String
            return saved ?? ""
        }
    }
    
    public var nickName: String {
        set {
            UserDefaults.standard.set(newValue,
                                      forKey: kNickName)
        }
        get {
            let saved = UserDefaults.standard.object(forKey: kNickName) as? String
            return saved ?? ""
        }
    }
    
    public var companyId: String {
        set {
            UserDefaults.standard.set(newValue,
                                      forKey: kCompanyId)
        }
        get {
            let saved = UserDefaults.standard.object(forKey: kCompanyId) as? String
            return saved ?? ""
        }
    }
    
    public var theme: Int {
        set {
            UserDefaults.standard.set(newValue,
                                      forKey: kTheme)
        }
        get {
            let saved = UserDefaults.standard.object(forKey: kTheme) as? Int
            return saved ?? 0
        }
    }
    
    public var qaMode: Bool {
        set {
            UserDefaults.standard.set(newValue,
                                      forKey: kQAMode)
        }
        get {
            let saved = UserDefaults.standard.object(forKey: kQAMode) as? Bool
            return saved ?? false
        }
    }
}
