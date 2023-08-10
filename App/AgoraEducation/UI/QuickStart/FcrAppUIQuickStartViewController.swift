//
//  FcrAppUIQuickStartViewController.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/8/9.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUIQuickStartViewController: FcrAppUIViewController {
    private lazy var contentView = FcrAppUIQuickStartContentView(roleList: roleList)
    
    private let roleList: [FcrAppUIUserRole] = [.student,
                                                .teacher,
                                                .audience]
    
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
    }
    
    func initViewFrame() {
        contentView.mas_makeConstraints { make in
            make?.left.right().top().bottom().equalTo()(0)
        }
    }
    
    func updateViewProperties() {
        contentView.backgroundColor = .white
    }
}

extension FcrAppUIQuickStartViewController {
    
}
