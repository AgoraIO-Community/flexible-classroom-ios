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
        
        let data = try JSONSerialization.data(withJSONObject: json,
                                              options: [])
        
        let model = try JSONDecoder().decode(Self.self,
                                             from: data)
        
        return model
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
struct FcrAppServerRoomObject: FcrAppCodable {
    var roomName: String
    var roomId: String
    var roomType: FcrAppRoomType
    var roomState: FcrAppRoomState
    
    var startTime: Int64
    var endTime: Int64
    
    // User Id who created this room
    var creatorId: String
    
    var industry: String
}

struct FcrAppServerRoomListObject: FcrAppCodable {
    var total: Int
    var nextId: String
    var count: Int
    var list: [FcrAppServerRoomObject]
}


struct FcrAppServerDetailRoomObject: FcrAppCodable {
    var roomName: String
    var roomId: String
    var roomType: FcrAppRoomType
}

struct FcrAppServerJoinRoomObject: FcrAppCodable {
    var token: String
    var appId: String
    var role: FcrAppUserRole
    var roomDetail: FcrAppServerDetailRoomObject
}
