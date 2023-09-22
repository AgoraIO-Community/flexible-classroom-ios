//
//  FcrAppCenter.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/6.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews
import Foundation
import WebKit
import Armin

protocol FcrAppCenterDelegate: NSObjectProtocol {
    func onLanguageUpdated(_ language: FcrAppLanguage)
    func onLoginExpired()
}

extension FcrAppCenterDelegate {
    func onLoginExpired() {}
}

class FcrAppCenter: NSObject {
    private(set) lazy var urlGroup = FcrAppURLGroup(localStorage: localStorage)
    
    private(set) lazy var tester = FcrAppTester(localStorage: localStorage)
    
    private(set) lazy var room = FcrAppRoom(urlGroup: urlGroup,
                                            armin: armin,
                                            localStorage: localStorage)
    
    private lazy var armin = FcrAppArmin(logTube: self)
    
    let localStorage = FcrAppLocalStorage()
    
    private(set) var localUser: FcrAppLocalUser?
    
    weak var delegate: FcrAppCenterDelegate?
    
    var isFirstAgreedPrivacy = false {
        didSet {
            guard isFirstAgreedPrivacy != oldValue else {
                return
            }
            
            localStorage.writeData(isFirstAgreedPrivacy,
                                   key: .firstPrivacyAgreement)
        }
    }
    
    var isAgreedPrivacy = false {
        didSet {
            guard isAgreedPrivacy != oldValue else {
                return
            }
            
            localStorage.writeData(isAgreedPrivacy,
                                   key: .privacyAgreement)
        }
    }
    
    var isLogined = false {
        didSet {
            guard isLogined != oldValue else {
                return
            }
            
            localStorage.writeData(isLogined,
                                   key: .login)
        }
    }
    
    var uiMode = FcrAppUIMode.light {
        didSet {
            guard uiMode != oldValue else {
                return
            }
            
            localStorage.writeData(uiMode.rawValue,
                                   key: .uiMode)
        }
    }
    
    var language = FcrAppLanguage.en {
        didSet {
            guard language != oldValue else {
                return
            }
            
            localStorage.writeData(language.rawValue,
                                   key: .language)
            
            delegate?.onLanguageUpdated(language)
        }
    }
    
    override init() {
        super.init()
        
        armin.failureDelegate = self
        
        do {
            if let mode = try? localStorage.readStringEnumData(key: .uiMode,
                                                               type: FcrAppUIMode.self) {
                self.uiMode = mode
            }
            
            if let language = try? localStorage.readStringEnumData(key: .language,
                                                                   type: FcrAppLanguage.self) {
                self.language = language
            } else {
                self.language = (UIDevice.current.agora_is_chinese_language ? .zh_cn : .en)
            }
            
            if let firstAgreedPrivacy = try? localStorage.readData(key: .firstPrivacyAgreement,
                                                                   type: Bool.self) {
                self.isFirstAgreedPrivacy = firstAgreedPrivacy
            }
            
            if let privacy = try? localStorage.readData(key: .privacyAgreement,
                                                        type: Bool.self) {
                self.isAgreedPrivacy = privacy
            }
            
            let nickname = try localStorage.readData(key: .nickname,
                                                     type: String.self)
            
            let userId = try localStorage.readData(key: .userId,
                                                   type: String.self)
            
            self.localUser = FcrAppLocalUser(userId: userId,
                                             nickname: nickname,
                                             localStorage: localStorage)
            
            self.isLogined = try localStorage.readData(key: .login,
                                                       type: Bool.self)
        } catch {
            isLogined = false
        }
    }
    
    func getAgoraConsoleURL(success: @escaping FcrAppStringCompletion,
                            failure: @escaping FcrAppFailure) {
        let url = urlGroup.agoraConsole()
        
        let parameters =  ["redirectUrl": "https://sso2.agora.io/",
                           "toRegion": urlGroup.region.rawValue]
        
        armin.request(url: url,
                      parameters: parameters,
                      method: .post,
                      event: "agora-console-url",
                      success: { response in
            let url = try response.dataConvert(type: String.self)
            success(url)
        }, failure: failure)
    }
    
    func needLogin(completion: @escaping FcrAppBoolCompletion) {
        if let region = try? localStorage.readStringEnumData(key: .region,
                                                             type: FcrAppRegion.self) {
            if region == .CN {
                completion(true)
            } else {
                completion(false)
            }
        } else {
            let url = urlGroup.needLogin()
            let headers = urlGroup.headers()
            
            armin.request(url: url,
                          headers: headers,
                          method: .get,
                          event: "ip-check") { object in
                let data = try object.dataConvert(type: [String: Any].self)
                let need = try data.getValue(of: "loginType",
                                             type: Bool.self)
                completion(need)
            } failure: { _ in
                completion(true)
            }
        }
    }
    
    func login(success: @escaping FcrAppSuccess,
               failure: @escaping FcrAppFailure) {
        let url = urlGroup.userInfo()
        let headers = ["Authorization": "Bearer \(urlGroup.accessToken)"]
        
        armin.convertableRequest(url: url,
                                 headers: headers,
                                 method: .get,
                                 event: "get-local-user-info",
                                 success: { [weak self] (object: FcrAppServerUserInfoObject) in
            guard let `self` = self else {
                return
            }
            
            self.localStorage.writeData(object.companyName,
                                        key: .companyName)
            
            self.urlGroup.companyId = object.companyId
            
            let localUser = FcrAppLocalUser(userId: object.companyId,
                                            nickname: object.displayName,
                                            localStorage: self.localStorage)
            
            self.localUser = localUser
            
            self.isLogined = true
            
            success()
        }, failure: failure)
    }
    
    func logout(completion: FcrAppCompletion? = nil) {
        let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let fromDate = Date(timeIntervalSince1970: 0)
        
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes,
                                                modifiedSince: fromDate) { [weak self] in
            self?.localStorage.cleanUserInfo()
            self?.localUser = nil
            self?.isLogined = false
            
            completion?()
        }
    }
    
    @discardableResult func createLocalUser(userId: String,
                                            nickname: String) -> FcrAppLocalUser {
        let localUser = FcrAppLocalUser(userId: userId,
                                        nickname: nickname,
                                        localStorage: localStorage)
        
        self.localUser = localUser
        
        return localUser
    }
    
    func closeAccount(success: FcrAppCompletion? = nil,
                      failure: FcrAppFailure? = nil) {
        logout { [weak self] in
            guard let `self` = self else {
                return
            }
            
            let url = self.urlGroup.closeAccount()
            let headers = self.urlGroup.headers()
            
            self.armin.request(url: url,
                               headers: headers,
                               method: .delete,
                               event: "close-account",
                               success: { _ in
                success?()
            }, failure: failure)
        }
    }
    
    private func refreshAccessToken() {
        let url = urlGroup.refreshAccessToken()
        
        armin.request(url: url,
                      method: .post,
                      event: "refresh-access-token") { [weak self] object in
            guard let `self` = self else {
                return
            }
            
            let data = try object.dataConvert(type: [String: Any].self)
            
            let accessToken = try data.getValue(of: "access_token",
                                                type: String.self)
            
            let refreshToken = try data.getValue(of: "refresh_token",
                                                 type: String.self)
            
            self.urlGroup.accessToken = accessToken
            self.urlGroup.refreshToken = refreshToken
        } failure: { [weak self] error in
            self?.isLogined = false
            self?.delegate?.onLoginExpired()
        }
    }
}

extension FcrAppCenter: FcrAppArminFailureDelegate {
    func onRequestFailure(error: FcrAppError) {
        guard error.code == 401 else {
            return
        }
        
        refreshAccessToken()
    }
}

extension FcrAppCenter: ArLogTube {
    func log(info: String,
             extra: String?) {
        logOnConsole("INFO: \(info)",
                     extra: "EXTRA: \(extra ?? "nil")")
    }
    
    func log(warning: String,
             extra: String?) {
        logOnConsole("WARNING: \(warning)",
                     extra: "EXTRA: \(extra ?? "nil")")
    }
    
    func log(error: ArError,
             extra: String?) {
        logOnConsole("ERROR: \(error.localizedDescription)",
                     extra: "EXTRA: \(extra ?? "nil")")
    }
    
    func logOnConsole(_ log: String,
                      extra: String) {
        NSLog("--------------------------")
        NSLog(log)
        NSLog(extra)
        NSLog("--------------------------")
    }
}
