//
//  FcrAppUIQuickStartViewController.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/8/9.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUIQuickStartViewController: FcrAppUICoreViewController {
    lazy var contentView = FcrAppUIQuickStartContentView(userRoleList: userRoleList,
                                                         roomTypeList: roomTypeList)
    
    let userRoleList: [FcrAppUIUserRole] = [.student,
                                            .teacher,
                                            .audience]
    
    let roomTypeList: [FcrAppUIRoomType] = [.smallClass,
                                            .lectureHall,
                                            .oneToOne,
                                            .proctor]
    
    var settingItems: [FcrAppUISettingItem] = [.generalSetting(FcrAppUISettingItem.GeneralItem.quickStartList()),
                                               .aboutUs(FcrAppUISettingItem.AboutUsItem.allCases)]
    
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
    
    override init(center: FcrAppCenter) {
        super.init(center: center)
        center.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}
