//
//  FcrAppServerObject.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/6.
//  Copyright © 2023 Agora. All rights reserved.
//

import Foundation

protocol FcrAppCodable: Codable {
    
}

extension FcrAppCodable {
    public static func decode(from json: [String : Any]) throws -> Self  {
        guard JSONSerialization.isValidJSONObject(json) else {
            throw FcrAppError(code: -1,
                              message: "json: \(json) is invalid")
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json,
                                                  options: [])
            
            let model = try JSONDecoder().decode(Self.self,
                                                 from: data)
            
            return model
        } catch {
            throw FcrAppError(code: -1,
                              message: "json convert to model unsuccessfully: \(json)")
        }
    }
}

struct FcrAppServerResponseObject {
    var code: Int
    var msg: String
    var data: Any
    
    init(json: [String: Any]) throws {
        self.code = try json.getValue(of: "code",
                                     type: Int.self)
        
        self.msg = try json.getValue(of: "msg",
                                     type: String.self)
        
        self.data = try json.getValue(of: "data",
                                      type: Any.self)
    }
    
    func dataConvert<T: Any>(type: T.Type) throws -> T {
        if let `data` = data as? T {
            return data
        } else {
            throw FcrAppError(code: -1,
                              message: "Failed data type conversion")
        }
    }
}

// MARK: - User
struct FcrAppServerUserInfoObject: FcrAppCodable {
    var companyId: String
    var companyName: String
    var displayName: String
    var userId: String
}

// MARK: - Room
struct FcrAppServerShortRoomObject: FcrAppCodable {
    var roomName: String
    var roomId: String
    var sceneType: FcrAppRoomType
    var roomState: FcrAppRoomState
    
    var startTime: Int64
    var endTime: Int64
    
    // User Id who created this room
    var creatorId: String
    var industry: String
}

struct FcrAppServerRoomObject: FcrAppCodable {
    var roomName: String
    var roomId: String
    var sceneType: FcrAppRoomType
    var roomState: FcrAppRoomState
    
    var role: FcrAppUserRole
    var userName: String
    var startTime: Int64
    var endTime: Int64
    
    // User Id who created this room
    var creatorId: String
    
    var industry: String
}

struct FcrAppServerRoomListObject: FcrAppCodable {
    var total: Int
    var nextId: String?
    var count: Int
    var list: [FcrAppServerRoomObject]
}

struct FcrAppServerDetailRoomPropertiesObject: FcrAppCodable {
    var latencyLevel: FcrAppMediaStreamLatency
    var watermark: Bool
}

struct FcrAppServerDetailRoomObject: FcrAppCodable {
    var roomName: String
    var roomId: String
    var sceneType: FcrAppRoomType
    var roomProperties: FcrAppServerDetailRoomPropertiesObject
}

struct FcrAppServerJoinRoomObject: FcrAppCodable {
    var token: String
    var appId: String
    var roomDetail: FcrAppServerDetailRoomObject
}
