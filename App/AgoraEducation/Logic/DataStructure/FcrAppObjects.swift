//
//  FcrAppObjects.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/13.
//  Copyright © 2023 Agora. All rights reserved.
//

import Foundation

struct FcrAppCreateRoomConfig {
    var roomName: String
    var roomType: FcrAppRoomType
    
    var userId: String
    var userName: String
    
    var startTime: Int64  // ms
    var duration: Int64   // ms
    
    var mediaStreamLatency: FcrAppMediaStreamLatency
    var watermark: Bool = false
    
    var isQuickStart: Bool = false
    
    func parameters() -> [String: Any] {
        var parameters = [String: Any]()
        
        parameters["roomName"] = roomName
        parameters["sceneType"] = roomType.rawValue
        parameters["userName"] = userName
        parameters["userUuid"] = userId
        
        parameters["startTime"] = startTime
        parameters["endTime"] = (startTime + duration)
        
        let properties: [String: Any] = ["watermark": watermark,
                                         "latencyLevel": mediaStreamLatency.rawValue]
        
        parameters["roomProperties"] = properties
        
        return parameters
    }
}

struct FcrAppJoinRoomPreCheckConfig {
    var roomId: String
    var userId: String
    var userName: String
    var userRole: FcrAppUserRole
    var isQuickStart: Bool = false

    func parameters() -> [String: Any] {
        var parameters = [String: Any]()

        parameters["roomId"] = roomId
        parameters["userUuid"] = userId
        parameters["userName"] = userName
        parameters["role"] = userRole.rawValue

        return parameters
    }
}

struct FcrAppError: Error {
    var code: Int
    var message: String
    
    func description() -> String {
        return "code: \(code), message: \(message)"
    }
}
