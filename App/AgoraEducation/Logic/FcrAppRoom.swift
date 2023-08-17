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
    private let localStorage: FcrAppLocalStorage
    
    private var nextRoomIdOfList: String?
    
    private(set) var lastRoomId: String? {
        didSet {
            guard let roomId = lastRoomId else {
                return
            }
            
            localStorage.writeData(roomId,
                                   key: .roomId)
        }
    }
    private(set) var lastRoomName: String? {
        didSet {
            guard let roomName = lastRoomName else {
                return
            }
            
            localStorage.writeData(roomName,
                                   key: .roomName)
        }
    }
    
    init(urlGroup: FcrAppURLGroup,
         armin: FcrAppArmin,
         localStorage: FcrAppLocalStorage) {
        self.urlGroup = urlGroup
        self.armin = armin
        self.localStorage = localStorage
        
        if let roomId = try? localStorage.readData(key: .roomId,
                                                   type: String.self) {
            self.lastRoomId = roomId
        }
        
        if let roomName = try? localStorage.readData(key: .roomName,
                                                     type: String.self) {
            self.lastRoomName = roomName
        }
    }
    
    func createRoom(config: FcrAppCreateRoomConfig,
                    success: @escaping FcrAppStringCompletion,
                    failure: @escaping FcrAppFailure) {
        lastRoomName = config.roomName
        
        var url: String
        
        if config.isQuickStart {
            url = urlGroup.quickCreateRoom()
        } else {
            url = urlGroup.createRoom()
        }
        
        let parameters = config.parameters()
        
        let headers = urlGroup.headers()
        
        armin.request(url: url,
                      headers: headers,
                      parameters: parameters,
                      method: .post,
                      event: "create-room",
                      success: { object in
            let data = try object.dataConvert(type: [String: Any].self)
            let roomId = try data.getValue(of: "roomId",
                                           type: String.self)
            success(roomId)
        }, failure: failure)
    }
    
    func joinRoomPreCheck(config: FcrAppJoinRoomPreCheckConfig,
                          success: @escaping (FcrAppServerJoinRoomObject) -> Void,
                          failure: @escaping FcrAppFailure) {
        lastRoomId = config.roomId
        
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
                                 event: "join-room-pre-check",
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
        requestRoomList(nextRoomId: nextRoomIdOfList,
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
            
            self.nextRoomIdOfList = nextRoomId
            
            success(object.list)
        }, failure: failure)
    }
}
