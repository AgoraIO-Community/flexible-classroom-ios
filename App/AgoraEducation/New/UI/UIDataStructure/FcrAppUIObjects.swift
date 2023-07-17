//
//  FcrAppUIObjects.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/7/13.
//  Copyright © 2023 Agora. All rights reserved.
//

import Foundation

struct FcrAppUIRoomListItem {
    var roomState: FcrAppUIRoomState
    var roomType: FcrAppRoomType
    var roomId: String
    var roomName: String
    var time: String
    
    static func create(from: FcrAppServerRoomObject) -> FcrAppUIRoomListItem {
        // Time
        let startDate = Date(timeIntervalSince1970: Double(from.startTime) * 0.001)
        let endDate = Date(timeIntervalSince1970: Double(from.endTime) * 0.001)
        let day = startDate.string(withFormat: "yyyy-MM-dd")
        let startTime = startDate.string(withFormat: "HH:mm")
        let endTime = endDate.string(withFormat: "HH:mm")
        let time = "\(day), \(startTime)-\(endTime)"
        
        let item = FcrAppUIRoomListItem(roomState: from.roomState,
                                        roomType: from.roomType,
                                        roomId: from.roomId,
                                        roomName: from.roomName,
                                        time: time)
        
        return item
    }
}
