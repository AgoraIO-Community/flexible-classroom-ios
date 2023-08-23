//
//  FcrAppUIQuickStartViewController.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/8/9.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraClassroomSDK_iOS
import AgoraUIBaseViews
import AgoraProctorSDK

class FcrAppUIQuickStartViewController: FcrAppUIViewController {
    lazy var contentView = FcrAppUIQuickStartContentView(userRoleList: userRoleList,
                                                         roomTypeList: roomTypeList)
    
    let userRoleList: [FcrAppUIUserRole] = [.student,
                                            .teacher,
                                            .audience]
    
    let roomTypeList: [FcrAppUIRoomType] = [.lectureHall,
                                            .smallClass,
                                            .oneToOne,
                                            .proctor]
    
    var settingItems: [FcrAppUISettingItem] = [.generalSetting(FcrAppUISettingItem.GeneralItem.quickStartList()),
                                               .aboutUs(FcrAppUISettingItem.AboutUsItem.allCases)]
    
    let center: FcrAppCenter
    
    var proctor: AgoraProctor?
    
    init(center: FcrAppCenter) {
        self.center = center
        super.init(nibName: nil,
                   bundle: nil)
        center.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        initViewFrame()
        updateViewProperties()
        tester()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.headerView.updateTopConstraints(topSafeArea: view.safeAreaInsets.top)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true,
                                                     animated: true)
        isTest()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func createRoom(config: FcrAppCreateRoomConfig) {
        AgoraLoading.loading()
        
        center.room.createRoom(config: config) { [weak self] roomId in
            AgoraLoading.hide()
            
            let config = FcrAppJoinRoomPreCheckConfig(roomId: roomId,
                                                      userId: config.userId,
                                                      userName: config.userName,
                                                      userRole: .teacher,
                                                      isQuickStart: true)
            
            self?.joinRoomPreCheck(config: config)
        } failure: { [weak self] error in
            AgoraLoading.hide()
            self?.showErrorToast(error)
        }
    }
    
    func joinRoomPreCheck(config: FcrAppJoinRoomPreCheckConfig) {
        AgoraLoading.loading()
        
        center.room.joinRoomPreCheck(config: config) { [weak self] object in
            AgoraLoading.hide()
            
            let options = AgoraEduLaunchConfig(userName: config.userName,
                                               userUuid: config.userId,
                                               userRole: config.userRole.toClassroomType(),
                                               roomName: object.roomDetail.roomName,
                                               roomUuid: object.roomDetail.roomId,
                                               roomType: object.roomDetail.roomType.toClassroomType(),
                                               appId: object.appId,
                                               token: object.token)
            
            self?.joinClassRoom(config: options)
        } failure: { [weak self] error in
            AgoraLoading.hide()
            self?.showErrorToast(error)
        }
    }
    
    func joinClassRoom(config: AgoraEduLaunchConfig) {
        agora_ui_language = center.language.proj()
        agora_ui_mode = center.uiMode.toAgoraType()
        
        AgoraLoading.loading()
        
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
        
        proctor = AgoraProctor(config: config)
        
        AgoraLoading.loading()
        
        proctor?.launch {
            AgoraLoading.hide()
        } failure: {[weak self] error in
            AgoraLoading.hide()
            self?.showErrorToast(error)
        }
    }
}

