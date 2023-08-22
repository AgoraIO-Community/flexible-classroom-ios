//
//  FcrAppUIMain+Extension.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/8/22.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraClassroomSDK_iOS
import AgoraUIBaseViews
import AgoraProctorSDK
import AgoraWidgets

extension FcrAppUIMainViewController {
    func navigation() {
        // 1. Check if agreed privacy
        privacyCheck { [weak self] in
            // 2. Check if logined
            self?.loginCheck { [weak self] in
                // 3. Refresh data
                self?.roomListComponent.refresh()
            }
        }
    }
    
    func privacyCheck(completion: @escaping FcrAppCompletion) {
        guard center.isAgreedPrivacy == false else {
            completion()
            return
        }
        
        let vc = FcrAppUIPrivacyTermsViewController()
        
        present(vc,
                animated: true)
        
        vc.onAgreedCompleted = { [weak self] in
            self?.center.isAgreedPrivacy = true
            completion()
        }
    }
    
    func loginCheck(completion: @escaping FcrAppCompletion) {
        guard center.isLogined == false else {
            return
        }
        
        let vc = FcrAppUILoginViewController(center: center)
        
        let navigation = FcrAppUINavigationController(rootViewController: vc)
        
        present(navigation,
                animated: true)
        
        vc.onCompleted = { [weak navigation] in
            navigation?.dismiss(animated: true)
        }
    }
}

extension FcrAppUIMainViewController: AgoraUIContentContainer {
    func initViews() {
        agora_ui_language = center.language.proj()
        
        if let navigation = navigationController as? FcrAppUINavigationController {
            navigation.csDelegate = self
        }
        
        view.addSubview(backgroundView)
        view.addSubview(headerView)
        view.addSubview(roomListComponent.view)
        
        // Join view
        headerView.joinActionView.button.addTarget(self,
                                                  action: #selector(onJoinButtonPressed(_ :)),
                                                  for: .touchUpInside)
        
        // Create view
        headerView.createActionView.button.addTarget(self,
                                                    action: #selector(onCreateButtonPressed(_:)),
                                                    for: .touchUpInside)
        
        // Setting button
        headerView.settingButton.addTarget(self,
                                          action: #selector(onSettingButtonPressed(_:)),
                                          for: .touchUpInside)
    }
    
    func initViewFrame() {
        backgroundView.mas_makeConstraints { make in
            make?.left.top().right().equalTo()(0)
        }
        
        roomListComponent.view.mas_makeConstraints { make in
            make?.top.equalTo()(198)
            make?.left.right().bottom().equalTo()(0)
        }
        
        headerView.mas_makeConstraints { make in
            make?.left.top().right().equalTo()(0)
            make?.height.equalTo()(198)
        }
    }
    
    func updateViewProperties() {
        headerView.updateViewProperties()
        
        roomListComponent.updateViewProperties()
        
        backgroundView.image = UIImage(named: "fcr_room_list_bg")
        
        headerView.backgroundColor = .clear
        view.backgroundColor = .white
    }
}

private extension FcrAppUIMainViewController {
    @objc func onJoinButtonPressed(_ sender: UIButton) {
        let vc = FcrAppUIJoinRoomController(center: center) { [weak self] object in
            let config = AgoraEduLaunchConfig(userName: object.userName,
                                              userUuid: object.userId,
                                              userRole: object.userRole.toClassroomType(),
                                              roomName: object.roomName,
                                              roomUuid: object.roomId,
                                              roomType: object.roomType.toClassroomType(),
                                              appId: object.appId,
                                              token: object.token)
            
            self?.joinRoom(config: config)
        }
        
        presentViewController(vc,
                              animated: true)
    }
     
    @objc func onCreateButtonPressed(_ sender: UIButton) {
        let vc = FcrAppUICreateRoomViewController(center: center) { [weak self] in
            self?.roomListComponent.addedNotice()
        }
        
        present(vc,
                animated: true)
    }
    
    @objc func onSettingButtonPressed(_ sender: UIButton) {
        let vc = FcrAppUISettingsViewController(center: center,
                                                dataSource: settingItems)
        
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
}

extension FcrAppUIMainViewController: FcrAppNavigationControllerDelegate {
    func navigationWillPopToRoot(_ navigation: FcrAppUINavigationController) {
        loginCheck { [weak self] in
            self?.roomListComponent.refresh()
        }
    }
}

extension FcrAppUIMainViewController: FcrAppCenterDelegate {
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
extension FcrAppUIMainViewController: FcrAppTesterDelegate {
    func tester() {
        center.tester.delegate = self
        
        headerView.titleLabel.addTarget(self,
                                       action: #selector(onTestButtonPressed(_ :)),
                                       for: .touchUpInside)
    }
    
    @objc func onTestButtonPressed(_ sender: UIButton) {
        center.tester.switchMode()
    }
    
    func onIsTestMode(_ isTest: Bool) {
        headerView.testTag.isHidden = !isTest
        
        if isTest {
            settingItems = [.generalSetting(FcrAppUISettingItem.GeneralItem.startTestList()),
                            .aboutUs(FcrAppUISettingItem.AboutUsItem.allCases)]
        } else {
            settingItems = [.generalSetting(FcrAppUISettingItem.GeneralItem.startList()),
                            .aboutUs(FcrAppUISettingItem.AboutUsItem.allCases)]
        }
    }
}
