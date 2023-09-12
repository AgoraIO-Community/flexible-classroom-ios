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
        switch roomType {
        case .proctor:
            return "\(userName.md5())_sub"
        default:
            let new = userId + "\(userRole.rawValue)"
            return new
        }
    }
    
    static func quickStart(userName: String,
                           userRole: FcrAppUserRole,
                           roomType: FcrAppRoomType) -> String {
        switch roomType {
        case .proctor:
            return "\(userName.md5())_sub"
        default:
            let userId = "\(userName)_\(userRole.rawValue)".md5()
            return userId
        }
    }
}
