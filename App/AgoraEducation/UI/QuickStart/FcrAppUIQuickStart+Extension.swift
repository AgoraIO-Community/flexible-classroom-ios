//
//  FcrAppUIQuickStart+Extension.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/8/22.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

extension FcrAppUIQuickStartViewController: AgoraUIContentContainer {
    func initViews() {
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
        
        let attributedText = FcrAppUIPolicyString().quickStartString()
        
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
        if !center.tester.isTest {
           presentMainViweController()
        } else {
            if !popToMainViweController() {
                presentMainViweController()
            }
        }
    }
    
    @objc func onJoinButtonPressed(_ sender: UIButton) {
        let joinRoomView = contentView.roomInputView.joinRoomView
        
        guard let roomId = joinRoomView.roomIdTextField.getText() else {
            showToast("fcr_login_free_toast_room_id_null".localized(),
                      type: .error)
            return
        }
        
        if roomId.count != 9 {
            showToast("fcr_login_free_tips_num_length".localized(),
                      type: .error)
            return
        }
        
        guard let userName = joinRoomView.userNameTextField.getText() else {
            showToast("fcr_login_free_toast_nick_name_null".localized(),
                      type: .error)
            return
        }
        
        if userName.count < 2 || userName.count > 20 {
            showToast("fcr_home_toast_content_length".localized(),
                      type: .error)
            return
        }
        
        guard contentView.roomInputView.policyView.checkBox.isSelected else {
            showToast(FcrAppUIPolicyString().toastString(),
                      type: .error)
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
            showToast("fcr_login_free_toast_room_name_null".localized(),
                      type: .error)
            return
        }
        
        guard let userName = createRoomView.userNameTextField.getText() else {
            showToast("fcr_login_free_toast_nick_name_null".localized(),
                      type: .error)
            return
        }
        
        if userName.count < 2 || userName.count > 20 {
            showToast("fcr_home_toast_content_length".localized(),
                      type: .error)
            return
        }
        
        guard contentView.roomInputView.policyView.checkBox.isSelected else {
            showToast(FcrAppUIPolicyString().toastString(),
                      type: .error)
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
    
    func presentMainViweController() {
        let vc = FcrAppUIMainViewController(center: center)
        
        let navigation = FcrAppUINavigationController(rootViewController: vc)
        
        present(navigation,
                animated: true)
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

// MARK: - Tester
extension FcrAppUIQuickStartViewController: FcrAppTesterDelegate {
    func tester() {
        contentView.headerView.titleLabel.addTarget(self,
                                                    action: #selector(onTestButtonPressed(_ :)),
                                                    for: .touchUpInside)
    }
    
    @objc func onTestButtonPressed(_ sender: UIButton) {
        center.tester.switchMode()
    }
    
    func isTest() {
        center.tester.delegate = self
        onIsTestMode(center.tester.isTest)
    }
    
    func onIsTestMode(_ isTest: Bool) {
        contentView.headerView.testTag.isHidden = !isTest
        
        if isTest {
            settingItems = [.generalSetting(FcrAppUISettingItem.GeneralItem.quickStartTestList()),
                            .aboutUs(FcrAppUISettingItem.AboutUsItem.allCases)]
        } else {
            settingItems = [.generalSetting(FcrAppUISettingItem.GeneralItem.quickStartList()),
                            .aboutUs(FcrAppUISettingItem.AboutUsItem.allCases)]
        }
    }
    
    func popToMainViweController() -> Bool {
        guard let navigation = navigationController else {
            return false
        }
            
        for vc in navigation.viewControllers where vc is FcrAppUIMainViewController {
            navigation.popViewController(animated: true)
            return true
        }
            
        return false
    }
}
