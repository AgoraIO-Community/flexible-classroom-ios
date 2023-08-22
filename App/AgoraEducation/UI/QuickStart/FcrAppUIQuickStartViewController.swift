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
    
    private var settingItems: [FcrAppUISettingItem] = [.generalSetting(FcrAppUISettingItem.GeneralItem.quickStartList()),
                                                       .aboutUs(FcrAppUISettingItem.AboutUsItem.allCases)]
    
    private let center: FcrAppCenter
    
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
            let options = AgoraEduLaunchConfig(userName: config.userName,
                                               userUuid: config.userId,
                                               userRole: config.userRole.toClassroomType(),
                                               roomName: object.roomDetail.roomName,
                                               roomUuid: object.roomDetail.roomId,
                                               roomType: object.roomDetail.roomType.toClassroomType(),
                                               appId: object.appId,
                                               token: object.token)
            
            self?.joinRoom(config: options)
        } failure: { [weak self] error in
            AgoraLoading.hide()
            self?.showErrorToast(error)
        }
    }
    
    func joinRoom(config: AgoraEduLaunchConfig) {
        agora_ui_language = center.language.proj()
        agora_ui_mode = center.uiMode.toAgoraType()
        
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
        agora_ui_language = center.language.proj()
        
        view.addSubview(contentView)
        
        // Header view
        let headerView = contentView.headerView
        
        headerView.settingButton.addTarget(self,
                                           action: #selector(onSettingsButtonPressed(_ :)),
                                           for: .touchUpInside)
        
        headerView.signButton.addTarget(self,
                                        action: #selector(onSignInButtonPressed(_ :)),
                                        for: .touchUpInside)
        
        // Join room view
        let joinRoomView = contentView.roomInputView.joinRoomView
        
        joinRoomView.roomIdTextField.setShowText(center.room.lastRoomId)
        joinRoomView.userNameTextField.text = center.localUser?.nickname
        
        joinRoomView.joinButton.addTarget(self,
                                          action: #selector(onJoinButtonPressed(_ :)),
                                          for: .touchUpInside)
       
        // Create room view
        let createRoomView = contentView.roomInputView.createRoomView
        
        createRoomView.roomNameTextField.text = center.room.lastRoomName
        createRoomView.userNameTextField.text = center.localUser?.nickname
        
        createRoomView.roomTypeView.rightButton.addTarget(self,
                                                          action: #selector(onRoomTypeButtonPressed),
                                                          for: .touchUpInside)
        
        createRoomView.createButton.addTarget(self,
                                              action: #selector(onCreateButtonPressed(_ :)),
                                              for: .touchUpInside)
        
        // Policy view
        let policyView = contentView.roomInputView.policyView
        
        policyView.checkBox.isSelected = center.isAgreedPrivacy
        policyView.checkBox.addTarget(self,
                                      action: #selector(onPolicyButtonPressed(_ :)),
                                      for: .touchUpInside)
        
        // Footer view
        contentView.footerView.signButton.addTarget(self,
                                                    action: #selector(onSignInButtonPressed(_ :)),
                                                    for: .touchUpInside)
    }
    
    func initViewFrame() {
        contentView.mas_makeConstraints { make in
            make?.edges.equalTo()(self.view)
        }
    }
    
    func updateViewProperties() {
        contentView.backgroundColor = UIColor.fcr_hex_string("#F8FAFF")
        
        let attributedText = FcrAppUIPolicyString().getAttributedString(true)
        
        contentView.roomInputView.policyView.textView.attributedText = attributedText
        
        contentView.updateViewProperties()
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
    
    @objc func onSignInButtonPressed(_ sender: UIButton) {
        let vc = FcrAppUIMainViewController(center: center)
        present(vc,
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
        
        localStorage(with: userId,
                     userName: userName)
        
        joinRoomPreCheck(config: config)
    }
    
    @objc func onCreateButtonPressed(_ sender: UIButton) {
        let createRoomView = contentView.roomInputView.createRoomView
        
        guard let roomName = createRoomView.roomNameTextField.getText() else {
            return
        }
        
        guard let userName = createRoomView.userNameTextField.getText() else {
            return
        }
     
        let userRole = FcrAppUserRole.teacher
        
        let userId = "\(userName)_\(userRole.rawValue)".md5()
        
        let roomType = createRoomView.roomTypeView.selectedRoomType
        
        let config = FcrAppCreateRoomConfig(roomName: roomName,
                                            roomType: roomType,
                                            userId: userId,
                                            userName: userName,
                                            isQuickStart: true)
        
        localStorage(with: userId,
                     userName: userName)
        
        createRoom(config: config)
    }
    
    @objc func onPolicyButtonPressed(_ sender: UIButton) {
        sender.isSelected.toggle()
        center.isAgreedPrivacy = sender.isSelected
    }
    
    func localStorage(with userId: String,
                      userName: String) {
        if let localUser = center.localUser {
            localUser.userId = userId
            localUser.nickname = userName
        } else {
            center.createLocalUser(userId: userId,
                                   nickname: userName)
        }
    }
}

extension FcrAppUIQuickStartViewController: FcrAppCenterDelegate {
    func onLanguageUpdated(_ language: FcrAppLanguage) {
        agora_ui_language = language.proj()
        
        guard let navigation = navigationController else {
            return
        }
        
        for vc in navigation.viewControllers {
            if let `vc` = vc as? AgoraUIContentContainer {
                vc.updateViewProperties()
                
                printDebug("ui" + vc.description)
            } else {
                printDebug(vc.description)
            }
        }
        
        updateViewProperties()
    }
}

extension UIView {
    func updateSubViewProperties() {
        for subView in subviews where subView is AgoraUIContentContainer  {
            if subView.subviews.count > 0 {
                subView.updateSubViewProperties()
            } else {
                let view = subView as! AgoraUIContentContainer
                view.updateViewProperties()
            }
        }
    }
}

// MARK: - Tester
extension FcrAppUIQuickStartViewController: FcrAppTesterDelegate {
    func tester() {
        center.tester.delegate = self
        
        contentView.headerView.titleLabel.addTarget(self,
                                                    action: #selector(onTestButtonPressed(_ :)),
                                                    for: .touchUpInside)
    }
    
    @objc func onTestButtonPressed(_ sender: UIButton) {
        center.tester.switchMode()
    }
    
    func onIsTestMode(_ isTest: Bool) {
        contentView.headerView.testTag.isHidden = !isTest
        
        if isTest {
            settingItems = [.generalSetting(FcrAppUISettingItem.GeneralItem.testList()),
                            .aboutUs(FcrAppUISettingItem.AboutUsItem.allCases)]
        } else {
            settingItems = [.generalSetting(FcrAppUISettingItem.GeneralItem.quickStartList()),
                            .aboutUs(FcrAppUISettingItem.AboutUsItem.allCases)]
        }
    }
}
