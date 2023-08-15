//
//  FcrAppRoom.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/7.
//  Copyright © 2023 Agora. All rights reserved.
//

import Foundation

class FcrAppRoom {
    private var urlGroup: FcrAppURLGroup
    private var armin: FcrAppArmin
    
    private var nextRoomId: String?
    
    init(urlGroup: FcrAppURLGroup,
         armin: FcrAppArmin) {
        self.urlGroup = urlGroup
        self.armin = armin
    }
    
    func createRoom(config: FcrAppCreateRoomConfig,
                    success: @escaping FcrAppStringCompletion,
                    failure: @escaping FcrAppFailure) {
        var url: String
        
        if config.isQuickStart {
            url = urlGroup.quickCreateRoom()
        } else {
            url = urlGroup.createRoom()
        }
        
        let parameters = config.parameters()
        
        armin.request(url: url,
                      parameters: parameters,
                      method: .post,
                      event: "create-room",
                      success: { object in
            let roomId = try object.dataConvert(type: String.self)
            success(roomId)
        }, failure: failure)
    }
    
    func joinRoomPreCheck(config: FcrAppJoinRoomConfig,
                          success: @escaping (FcrAppServerJoinRoomObject) -> Void,
                          failure: @escaping FcrAppFailure) {
        var url: String
        
        if config.isQuickStart {
            url = urlGroup.quickJoinRoom()
        } else {
            url = urlGroup.joinRoom()
        }
        
        let parameters = config.parameters()
        
        let headers = urlGroup.headers()
        
        armin.convertableRequest(url: url,
                                 headers: headers,
                                 parameters: parameters,
                                 method: .put,
                                 event: "join-room",
                                 success: success,
                                 failure: failure)
    }
    
    func refreshRoomList(count: Int,
                         success: @escaping ([FcrAppServerRoomObject]) -> Void,
                         failure: @escaping FcrAppFailure) {
        requestRoomList(count: count,
                        success: success,
                        failure: failure)
    }
    
    func incrementalRoomList(count: Int,
                             success: @escaping ([FcrAppServerRoomObject]) -> Void,
                             failure: @escaping FcrAppFailure) {
        requestRoomList(nextRoomId: nextRoomId,
                        count: count,
                        success: success,
                        failure: failure)
    }
    
    private func requestRoomList(nextRoomId: String? = nil,
                                 count: Int,
                                 success: @escaping ([FcrAppServerRoomObject]) -> Void,
                                 failure: @escaping FcrAppFailure) {
        let url = urlGroup.roomList()
        var parameters: [String: Any] = ["count": count]
        
        if let nextId = nextRoomId {
            parameters["nextId"] = nextId
        }
        
        armin.convertableRequest(url: url,
                                 parameters: parameters,
                                 method: .get,
                                 event: "room-list",
                                 success: { [weak self] (object: FcrAppServerRoomListObject) in
            guard let `self` = self else {
                return
            }
            
            self.nextRoomId = nextRoomId
            
            success(object.list)
        }, failure: failure)
    }
}
