//
//  FcrAppUIQuickStartViewController.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/8/9.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraClassroomSDK_iOS
import AgoraUIBaseViews

class FcrAppUIQuickStartViewController: FcrAppUIViewController {
    private lazy var contentView = FcrAppUIQuickStartContentView(userRoleList: userRoleList,
                                                                 roomTypeList: roomTypeList)
    
    private let userRoleList: [FcrAppUIUserRole] = [.student,
                                                    .teacher,
                                                    .audience]
    
    private let roomTypeList: [FcrAppUIRoomType] = [.lectureHall,
                                                    .smallClass,
                                                    .oneToOne,
                                                    .proctor]
    
    private let settingItems: [FcrAppUISettingItem] = [.generalSetting(FcrAppUISettingItem.GeneralItem.quickStartList()),
                                                       .aboutUs(FcrAppUISettingItem.AboutUsItem.allCases)]
    
    private let center = FcrAppCenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        initViewFrame()
        updateViewProperties()
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func joinRoomPreCheck(config: FcrAppJoinRoomPreCheckConfig) {
        AgoraLoading.loading()
        
        center.room.joinRoomPreCheck(config: config) { [weak self] object in
            let options = FcrAppUIJoinRoomConfig(userId: config.userId,
                                                 userName: config.userName,
                                                 userRole: config.userRole,
                                                 roomId: object.roomDetail.roomId,
                                                 roomName: object.roomDetail.roomName,
                                                 roomType: object.roomDetail.roomType,
                                                 appId: object.appId,
                                                 token: object.token)
            
            
            self?.joinRoom(options: options)
        } failure: { [weak self] error in
            AgoraLoading.hide()
            self?.showErrorToast(error)
        }
    }
    
    func joinRoom(options: FcrAppUIJoinRoomConfig) {
        let config = AgoraEduLaunchConfig(userName: options.userName,
                                          userUuid: options.userId,
                                          userRole: options.userRole.toClassroomType(),
                                          roomName: options.roomName,
                                          roomUuid: options.roomId,
                                          roomType: options.roomType.toClassroomType(),
                                          appId: options.appId,
                                          token: options.token)
        
        AgoraClassroomSDK.launch(config) {
            AgoraLoading.hide()
        } failure: { [weak self] error in
            AgoraLoading.hide()
            self?.showErrorToast(error)
        }
    }
}

extension FcrAppUIQuickStartViewController: AgoraUIContentContainer {
    func initViews() {
        view.addSubview(contentView)
        
        contentView.headerView.settingButton.addTarget(self,
                                                       action: #selector(onSettingsButtonPressed(_ :)),
                                                       for: .touchUpInside)
        
        // Join room view
        let joinRoomView = contentView.roomInputView.joinRoomView
        
        joinRoomView.roomIdTextField.text = center.room.lastRoomId
        joinRoomView.userNameTextField.text = center.localUser?.nickname
        
        joinRoomView.joinButton.addTarget(self,
                                          action: #selector(onJoinButtonPressed(_ :)),
                                          for: .touchUpInside)
       
        // Create room view
        let createRoomView = contentView.roomInputView.createRoomView
        
        createRoomView.roomRoomTextField.text = center.room.lastRoomName
        createRoomView.userNameTextField.text = center.localUser?.nickname
        
        createRoomView.roomTypeView.rightButton.addTarget(self,
                                                          action: #selector(onRoomTypeButtonPressed),
                                                          for: .touchUpInside)
    }
    
    func initViewFrame() {
        contentView.mas_makeConstraints { make in
            make?.left.right().top().bottom().equalTo()(0)
        }
    }
    
    func updateViewProperties() {
        contentView.backgroundColor = .white
        
        let attributedText = FcrAppUIPolicyString().getAttributedString(true)
        
        contentView.roomInputView.policyView.textView.attributedText = attributedText
    }
}

private extension FcrAppUIQuickStartViewController {
    @objc func onSettingsButtonPressed(_ sender: UIButton) {
        let vc = FcrAppUISettingsViewController(center: center,
                                                dataSource: settingItems,
                                                needLougout: false)
        
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    @objc func onRoomTypeButtonPressed(_ sender: UIButton) {
        let roomTypeView = contentView.roomInputView.createRoomView.roomTypeView
        
        let vc = FcrAppUIQuickStartClassModeViewController(roomTypeList: roomTypeList,
                                                           selected: roomTypeView.selectedRoomType)
        
        vc.onDismissed = { [weak roomTypeView, weak vc] in
            guard let `roomTypeView` = roomTypeView,
                  let `vc` = vc
            else {
                return
            }
            
            roomTypeView.selectedRoomType = vc.selected
        }
        
        presentViewController(vc,
                              animated: true)
    }
    
    @objc func onJoinButtonPressed(_ sender: UIButton) {
        let joinRoomView = contentView.roomInputView.joinRoomView
        
        // TODO: UI 需要文案提示吗？
        guard let roomId = joinRoomView.roomIdTextField.getText() else {
            return
        }
        
        guard let userName = joinRoomView.userNameTextField.getText() else {
            return
        }
        
        let userRole = joinRoomView.selectedUserRole
        
        let userId = "\(userName)_\(userRole.rawValue)".md5()
        
        let config = FcrAppJoinRoomPreCheckConfig(roomId: roomId,
                                                  userId: userId,
                                                  userName: userName,
                                                  userRole: userRole,
                                                  isQuickStart: true)
        
        localStorage(with: config)
        
        joinRoomPreCheck(config: config)
    }
    
    func localStorage(with config: FcrAppJoinRoomPreCheckConfig) {
        if let localUser = center.localUser {
            localUser.userId = config.userId
            localUser.nickname = config.userName
        } else {
            center.createLocalUser(userId: config.userId,
                                   nickname: config.userName)
        }
    }
}
