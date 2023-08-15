//
//  FcrAppUIQuickStartViewController.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/8/9.
//  Copyright © 2023 Agora. All rights reserved.
//

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
}

extension FcrAppUIQuickStartViewController: AgoraUIContentContainer {
    func initViews() {
        view.addSubview(contentView)
        
        contentView.roomInputView.joinRoomView.userNameTextField.text = center.localUser?.nickname
        
        contentView.headerView.settingButton.addTarget(self,
                                                       action: #selector(onSettingsButtonPressed(_ :)),
                                                       for: .touchUpInside)
        
        contentView.roomInputView.joinRoomView.joinButton.addTarget(self,
                                                                    action: #selector(onJoinButtonPressed(_ :)),
                                                                    for: .touchUpInside)
        
        contentView.roomInputView.createRoomView.roomTypeView.rightButton.addTarget(self,
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
    }
    
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
       
    }
}

extension FcrAppUIQuickStartViewController {
    
}
