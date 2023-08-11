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
    
    private let center = FcrAppCenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        initViewFrame()
        updateViewProperties()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.headerView.updateTopConstraints(topSafeArea: view.safeAreaInsets.top)
    }
}

extension FcrAppUIQuickStartViewController: AgoraUIContentContainer {
    func initViews() {
        view.addSubview(contentView)
        
        
        
        contentView.roomInputView.joinRoomView.userNameTextField.text = center.localUser?.nickname
        
        contentView.roomInputView.joinRoomView.joinButton.addTarget(self,
                                                                    action: #selector(onJoinButtonPressed(_ :)),
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
    
    @objc func onJoinButtonPressed(_ sender: UIButton) {
        
        
        
    }
}

extension FcrAppUIQuickStartViewController {
    
}
