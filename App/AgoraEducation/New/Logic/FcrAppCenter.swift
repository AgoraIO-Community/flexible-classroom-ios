//
//  FcrAppCenter.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/7/6.
//  Copyright © 2023 Agora. All rights reserved.
//

import Foundation
import WebKit
import Armin

class FcrAppCenter: NSObject {
    private lazy var armin = FcrAppArmin(logTube: self)
    private let urlGroup = FcrAppURLGroup()
    
    private(set) lazy var room = FcrAppRoom(urlGroup: urlGroup,
                                            armin: armin)
    
    let localStorage = FcrAppLocalStorage()
    
    var localUser: FcrAppLocalUser?
    
    var isLogined = false
    
    var isAgreedPrivacy = false
    
    override init() {
        super.init()
        initWithLocalStorage()
    }
    
    func updateAccessToken(_ accessToken: String) {
        urlGroup.accessToken = accessToken
        
        localStorage.writeData(accessToken,
                               key: .accessTokenKey)
    }
    
    func updateRefreshToken(_ refreshToken: String) {
        urlGroup.refreshToken = refreshToken
        
        localStorage.writeData(refreshToken,
                               key: .refreshToken)
    }
    
    func switchRegion(_ region: FcrAppRegion) {
        urlGroup.region = region
        
        localStorage.writeData(region.rawValue,
                               key: .region)
    }
    
    func switchEnvironment(_ environment: FcrAppEnvironment) {
        urlGroup.environment = environment
        
        localStorage.writeData(environment.rawValue,
                               key: .environment)
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
            
            let localUser = FcrAppLocalUser(nickName: object.displayName)
            
            localUser.delegate = self
            
            self.localUser = localUser
            
            success()
        }, failure: failure)
    }
    
    private func initWithLocalStorage() {
        do {
            let nickname = try localStorage.readData(key: .nickname,
                                                     type: String.self)
            
            let privacy = try localStorage.readData(key: .privacyAgreement,
                                                    type: Bool.self)
            
            let companyId = try localStorage.readData(key: .companyId,
                                                      type: String.self)
            
            let accessToken = try localStorage.readData(key: .accessTokenKey,
                                                        type: String.self)
            
            let refreshToken = try localStorage.readData(key: .refreshToken,
                                                         type: String.self)
            
            self.isAgreedPrivacy = privacy
            
            self.localUser = FcrAppLocalUser(nickName: nickname)
            
            self.isLogined = true
            
            self.urlGroup.companyId = companyId
            self.urlGroup.accessToken = accessToken
            self.urlGroup.refreshToken = refreshToken
            
        } catch {
            isLogined = false
            isAgreedPrivacy = false
        }
    }
}

extension FcrAppCenter: FcrAppLocalUserDelegate {
    func onLogOut() {
        let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let fromDate = Date(timeIntervalSince1970: 0)
        
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes,
                                                modifiedSince: fromDate) { [weak self] in
            self?.localStorage.allClean()
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
