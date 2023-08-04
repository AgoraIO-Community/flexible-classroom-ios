//
//  FcrAppObjects.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/13.
//  Copyright © 2023 Agora. All rights reserved.
//

import Foundation

struct FcrAppRoomCreateConfig {
    var roomName: String
    var roomType: FcrAppRoomType
    var userName: String
    var startTime: Int64  // ms
    var endTime: Int64    // ms
    var roomProperties: [String: Any]?
    
    func parameters() -> [String: Any] {
        var parameters = [String: Any]()
        
        parameters["roomName"] = roomName
        parameters["roomType"] = roomType.rawValue
        parameters["userName"] = userName
        parameters["startTime"] = startTime
        parameters["endTime"] = endTime
        
        if let `properties` = roomProperties {
            parameters["properties"] = properties
        }
        
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
