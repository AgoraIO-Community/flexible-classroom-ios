//
//  FcrAppUIObjects.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/13.
//  Copyright © 2023 Agora. All rights reserved.
//

import UIKit

struct FcrAppUIRoomListItem {
    var roomState: FcrAppUIRoomState
    var roomType: FcrAppUIRoomType
    var roomId: String
    var roomName: String
    var userRole: FcrAppUIUserRole
    var userName: String
    var time: String
    
    static func create(from: FcrAppServerRoomObject) -> FcrAppUIRoomListItem {
        // Id
        let originalString = from.roomId
        let characters = Array(originalString)
        var newString = [String]()

        for index in stride(from: 0,
                            to: characters.count,
                            by: 3) {
            let subCharacters = characters[index..<min(index + 3,
                                                       characters.count)]
            let subString = String(subCharacters)
            newString.append(subString)
        }

        let roomId = newString.joined(separator: " ")
        
        // Time
        let startDate = Date(timeIntervalSince1970: Double(from.startTime) * 0.001)
        let endDate = Date(timeIntervalSince1970: Double(from.endTime) * 0.001)
        let day = startDate.string(withFormat: "yyyy-MM-dd")
        let startTime = startDate.string(withFormat: "HH:mm")
        let endTime = endDate.string(withFormat: "HH:mm")
        let time = "\(day), \(startTime)-\(endTime)"
        
        let item = FcrAppUIRoomListItem(roomState: from.roomState,
                                        roomType: from.roomType,
                                        roomId: roomId,
                                        roomName: from.roomName,
                                        userRole: from.role,
                                        userName: from.userName,
                                        time: time)
        
        return item
    }
    
    func getRoomId() -> String {
        let text = roomId.replacingOccurrences(of: " ",
                                               with: "")
        return text
    }
}

struct FcrAppUICreatedRoomResult {
    var userId: String
    var userName: String
    var userRole: FcrAppUIUserRole
    
    var roomId: String
    var roomName: String
    var andJoin: Bool
}

struct FcrAppUIJoinRoomConfig {
    var userId: String
    var userName: String
    var userRole: FcrAppUIUserRole
    
    var roomId: String
    var roomName: String
    var roomType: FcrAppUIRoomType
    
    var appId: String
    var token: String
}

struct FcrAppUICreateRoomMoreSettingOption {
    var iconImage: UIImage?
    var title: String
    var subTitle: String?
    var isSwitchOn: Bool
}
