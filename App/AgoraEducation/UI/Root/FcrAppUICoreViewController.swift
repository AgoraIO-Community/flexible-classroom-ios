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
            let options = AgoraEduLaunchConfig(userName: config.userName,
                                               userUuid: config.userId,
                                               userRole: config.userRole.toClassroomType(),
                                               roomName: object.roomDetail.roomName,
                                               roomUuid: object.roomDetail.roomId,
                                               roomType: object.roomDetail.roomType.toClassroomType(),
                                               appId: object.appId,
                                               token: object.token)
            
            self?.joinClassroom(config: options)
        } failure: { [weak self] error in
            AgoraLoading.hide()
            self?.showErrorToast(error)
        }
    }

    func joinClassroom(config: AgoraEduLaunchConfig) {
        agora_ui_language = center.language.proj()
        agora_ui_mode = center.uiMode.toAgoraType()
        
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
}

// MARK: - AgoraEduClassroomSDKDelegate
extension FcrAppUICoreViewController: AgoraEduClassroomSDKDelegate {
    func classroomSDK(_ classroom: AgoraClassroomSDK,
                      didExit reason: AgoraEduExitReason) {
        switch reason {
        case .kickOut:
            showToast("kick out")
        default:
            break
        }
    }
}

// MARK: - AgoraProctorDelegate
extension FcrAppUICoreViewController: AgoraProctorDelegate {
    func onExit(reason: AgoraProctorExitReason) {
        switch reason {
        case .kickOut:
            showToast("kick out")
        default:
            break
        }
        
        self.proctor = nil
    }
}
