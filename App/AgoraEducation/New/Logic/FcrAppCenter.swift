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

class FcrAppCenter: NSObject {
    private lazy var armin = FcrAppArmin(logTube: self)
    private(set) lazy var urlGroup = FcrAppURLGroup(localStorage: localStorage)
    
    private(set) lazy var room = FcrAppRoom(urlGroup: urlGroup,
                                            armin: armin)
    
    private let localStorage = FcrAppLocalStorage()
    
    var localUser: FcrAppLocalUser?
    
    var isAgreedPrivacy = false {
        didSet {
            localStorage.writeData(isAgreedPrivacy,
                                   key: .privacyAgreement)
        }
    }
    
    var uiMode = FcrAppUIMode.light {
        didSet {
            localStorage.writeData(uiMode,
                                   key: .uiMode)
        }
    }
    
    var language = FcrAppLanguage.en {
        didSet {
            localStorage.writeData(language,
                                   key: .language)
            
        }
    }
    
    var isLogined = false
    
    override init() {
        super.init()
        do {
            let privacy = try localStorage.readData(key: .privacyAgreement,
                                                    type: Bool.self)
            
            self.isAgreedPrivacy = privacy
            
            let nickname = try localStorage.readData(key: .nickname,
                                                     type: String.self)
            
            self.localUser = FcrAppLocalUser(nickname: nickname,
                                             localStorage: localStorage)
            
            self.isLogined = true
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
    
    func createLocalUser(success: @escaping FcrAppSuccess,
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
            
            self.urlGroup.companyId = object.companyId
            
            let localUser = FcrAppLocalUser(nickname: object.displayName,
                                            localStorage: self.localStorage)
            
            self.localUser = localUser
            
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
            
            completion?()
        }
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
