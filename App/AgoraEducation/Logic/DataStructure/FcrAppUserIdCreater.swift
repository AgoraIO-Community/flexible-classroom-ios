//
//  FcrAppUserIdCreater.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/9/12.
//  Copyright © 2023 Agora. All rights reserved.
//

import Foundation

struct FcrAppUserIdCreater {
    static func start(userId: String,
                      userName: String,
                      userRole: FcrAppUserRole,
                      roomType: FcrAppRoomType) -> String {
        var localUserId: String
        
        switch roomType {
        case .proctor:
            localUserId = "\(userName.md5())-sub"
        default:
            localUserId = userId + "\(userRole.rawValue)"
        }
        
        printDebug("localUserId: \(localUserId)")
        
        return localUserId
    }
    
    static func quickStart(userName: String,
                           userRole: FcrAppUserRole,
                           roomType: FcrAppRoomType) -> String {
        var localUserId: String
        
        switch roomType {
        case .proctor:
            localUserId = "\(userName.md5())-sub"
        default:
            localUserId = "\(userName)_\(userRole.rawValue)".md5()
        }
        
        printDebug("localUserId: \(localUserId)")
        
        return localUserId
    }
}
