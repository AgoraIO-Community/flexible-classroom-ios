//
//  FcrAppURLGroup.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/5.
//  Copyright © 2023 Agora. All rights reserved.
//

import Foundation

class FcrAppURLGroup {
    private var host: String {
        switch environment {
        case .dev:
           return "https://api-solutions-dev.bj2.agoralab.co"
        case .pre:
            return "https://api-solutions-pre.bj2.agoralab.co"
        case .pro:
            switch region {
            case .CN:
                return "https://api-solutions.bj2.agoralab.co"
            case .NA:
                return "https://api-solutions.sv3sbm.agoralab.co"
//            case .EU:
//                return "https://api-solutions.fr3sbm.agoralab.co"
//            case .AP:
//                return "https://api-solutions.sg3sbm.agoralab.co"
            }
        }
    }
    
    private let edu = "edu"
    private let companys = "companys"
    private let rooms = "rooms"
    private let sso = "sso"
    private let users = "users"
    private let auth = "auth"
    private let oauth = "oauth"
    private let info = "info"
    private let redirectUrl = "redirectUrl"
    private let refresh = "refresh"
    private let refreshTokenKey = "refreshToken"
    
    private let version1 = "v1"
    private let version2 = "v2"
    private let version3 = "v3"
    
    var companyId = ""
    
    /// Access token is used outside the room
    var accessToken = ""
    
    /// Using a refreshToken to request an updated accessToken
    var refreshToken = ""
    
    var environment = FcrAppEnvironment.pro
    var region = FcrAppRegion.CN
    
    func headers() -> [String: String] {
        return ["Authorization": accessToken]
    }
    
    // Room
    func createRoom() -> String {
        let array = [host, edu, companys,
                     companyId, version1, rooms]
        let url = array.joined(separator: "/")
        return url
    }
    
    func joinRoom() -> String {
        let array = [host, edu, companys,
                     companyId, version1, rooms]
        let url = array.joined(separator: "/")
        return url
    }
    
    func roomInfo(roomId: String) -> String {
        let array = [host, edu, companys,
                     companyId, version1, rooms,
                     roomId]
        let url = array.joined(separator: "/")
        return url
    }
    
    func roomList() -> String {
        let array = [host, edu, companys,
                     companyId, version1, rooms]
        let url = array.joined(separator: "/")
        return url
    }
    
    // User
    /// For login & register
    func agoraConsole() -> String {
        let array = [host, sso, version2,
                     users, oauth, redirectUrl]
        let url = array.joined(separator: "/")
        return url
    }
    
    func userInfo() -> String {
        let array = [host, sso, version2,
                     users, info]
        let url = array.joined(separator: "/")
        return url
    }
    
    func closeAccount() -> String {
        let array = [host, sso, version2,
                     users, auth]
        let url = array.joined(separator: "/")
        return url
    }
    
    // Token
    func refreshAccessToken() -> String {
        let array = [host, sso, version2,
                     users, refresh, refreshTokenKey,
                     refreshToken]
        let url = array.joined(separator: "/")
        return url
    }
}
