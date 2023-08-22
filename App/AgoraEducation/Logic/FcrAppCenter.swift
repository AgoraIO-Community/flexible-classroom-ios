//
//  FcrAppCenter.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/6.
//  Copyright © 2023 Agora. All rights reserved.
//

import Foundation
import WebKit
import Armin

protocol FcrAppCenterDelegate: NSObjectProtocol {
    func onLanguageUpdated(_ language: FcrAppLanguage)
}

class FcrAppCenter: NSObject {
    private(set) lazy var urlGroup = FcrAppURLGroup(localStorage: localStorage)
    
    private(set) lazy var room = FcrAppRoom(urlGroup: urlGroup,
                                            armin: armin,
                                            localStorage: localStorage)
    
    private lazy var armin = FcrAppArmin(logTube: self)
    
    private let localStorage = FcrAppLocalStorage()
    
    private(set) var localUser: FcrAppLocalUser?
    
    let tester = FcrAppTester()
    
    weak var delegate: FcrAppCenterDelegate?
    
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
        do {
            if let mode = try? localStorage.readData(key: .uiMode,
                                                     type: FcrAppUIMode.self) {
                self.uiMode = mode
            }
            
            if let language = try? localStorage.readData(key: .language,
                                                         type: FcrAppLanguage.self) {
                self.language = language
            }
            
            let privacy = try localStorage.readData(key: .privacyAgreement,
                                                    type: Bool.self)
            
            self.isAgreedPrivacy = privacy
            
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

            self.localStorage.writeData(object.companyId,
                                        key: .companyId)
            
            self.localStorage.writeData(object.companyName,
                                        key: .companyName)
            
            self.localStorage.writeData(object.displayName,
                                        key: .nickname)
            
            self.localStorage.writeData(object.userId,
                                        key: .userId)
            
            self.urlGroup.companyId = object.companyId
            
            let localUser = FcrAppLocalUser(userId: object.userId,
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
        localStorage.writeData(userId,
                               key: .nickname)
        
        localStorage.writeData(nickname,
                               key: .userId)
        
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
