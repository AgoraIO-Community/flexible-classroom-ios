//
//  FcrAppCenter.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/7/6.
//  Copyright © 2023 Agora. All rights reserved.
//

import Foundation
import Armin

class FcrAppCenter: NSObject {
    private lazy var armin = FcrAppRequest(logTube: self)
    
    var localUser: FcrAppLocalUser?
    
    let localStorage = FcrAppLocalStorage()
    private let urlGroup = FcrAppURLGroup()
    
    override init() {
        super.init()
        createLocalUser()
    }
    
    var isLogined: Bool {
        if let _ = localUser {
            return true
        } else {
            return false
        }
    }
    
    var isAgreedPrivacy: Bool {
        do {
            return try localStorage.readData(key: .privacyAgreement,
                                             type: Bool.self)
        } catch {
            return false
        }
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
        let headers = urlGroup.headers()
        
        print("::::: \(headers)")
        
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
            
            let localUser = FcrAppLocalUser(nickName: object.displayName)
            
            localUser.delegate = self
            
            self.localUser = localUser
            
            success()
        }, failure: failure)
    }
    
    private func createLocalUser() {
        
    }
}

extension FcrAppCenter: FcrAppLocalUserDelegate {
    func onLogOut() {
        localStorage.allClean()
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
