//
//  FcrAppUICoreViewController.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/8/24.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraClassroomSDK_iOS
import AgoraUIBaseViews
import AgoraProctorSDK

class FcrAppUICoreViewController: FcrAppUIViewController {
    let center: FcrAppCenter
    
    var proctor: AgoraProctor?
    
    init(center: FcrAppCenter) {
        self.center = center
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func joinRoomPreCheck(config: FcrAppJoinRoomPreCheckConfig) {
        AgoraLoading.loading()
        
        center.room.joinRoomPreCheck(config: config) { [weak self] object in
            guard let `self` = self else {
                return
            }
            
            let userId = config.userId
            let userName = config.userName
            let userRole = config.userRole
            
            let roomType = object.roomDetail.sceneType
            let roomName = object.roomDetail.roomName
            let roomId = object.roomDetail.roomId
            
            let appId = object.appId
            let token = object.token
            
            let region = self.center.urlGroup.region
            let streamLatency = self.center.room.mediaStreamLatency
            
            switch roomType {
            case .oneToOne, .smallClass, .lectureHall:
                let options = AgoraEduLaunchConfig(userName: config.userName,
                                                   userUuid: config.userId,
                                                   userRole: config.userRole.toClassroomType(),
                                                   roomName: roomName,
                                                   roomUuid: roomId,
                                                   roomType: roomType.toClassroomType(),
                                                   appId: appId,
                                                   token: token)
                
                options.mediaOptions.latencyLevel = streamLatency.toClassroomType()
                options.region = region.toClassroomType()
                
                self.joinClassroom(config: options)
            case .proctor:
                let video = AgoraProctorVideoEncoderConfig()
                let media = AgoraProctorMediaOptions(videoEncoderConfig: video,
                                                     latencyLevel: streamLatency.toClassroomType())
                
                let options = AgoraProctorLaunchConfig(userName: userName,
                                                       userUuid: userId,
                                                       userRole: userRole.toProctorType(),
                                                       roomName: roomName,
                                                       roomUuid: roomId,
                                                       appId: appId,
                                                       token: token,
                                                       region: region.toProctorType(),
                                                       mediaOptions: media)
                
                self.joinProctorRoom(config: options)
            }
        } failure: { [weak self] error in
            AgoraLoading.hide()
            self?.showErrorToast(error)
        }
    }

    func joinClassroom(config: AgoraEduLaunchConfig) {
        agora_ui_language = center.language.proj()
        agora_ui_mode = center.uiMode.toAgoraType()
        
        insertWidgetSampleToClassroom(config)
        
        AgoraClassroomSDK.launch(config) {
            AgoraLoading.hide()
        } failure: { [weak self] error in
            AgoraLoading.hide()
            self?.showErrorToast(error)
        }
    }

    func joinProctorRoom(config: AgoraProctorLaunchConfig) {
        agora_ui_language = center.language.proj()
        agora_ui_mode = center.uiMode.toAgoraType()
        
        let proctor = AgoraProctor(config: config)
        
        proctor.launch {
            AgoraLoading.hide()
        } failure: { [weak self] error in
            AgoraLoading.hide()
            self?.showErrorToast(error)
        }
        
        self.proctor = proctor
    }
    
    func insertWidgetSampleToClassroom(_ config: AgoraEduLaunchConfig) {
        let sample = FcrAppWidgetSample()
        
        let link = center.urlGroup.invitation(roomId: config.roomUuid,
                                              inviterName: config.userName)
        
        config.widgets[sample.sharingLinkWidgetId] = sample.createSharingLink(link)
    }
}

// MARK: - AgoraEduClassroomSDKDelegate
extension FcrAppUICoreViewController: AgoraEduClassroomSDKDelegate {
    func classroomSDK(_ classroom: AgoraClassroomSDK,
                      didExit reason: AgoraEduExitReason) {
    }
}

// MARK: - AgoraProctorDelegate
extension FcrAppUICoreViewController: AgoraProctorDelegate {
    func onExit(reason: AgoraProctorExitReason) {
        self.proctor = nil
    }
}
