//
//  FcrAppUIMainViewController.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/13.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraClassroomSDK_iOS
import AgoraUIBaseViews
import AgoraProctorSDK
import AgoraWidgets

class FcrAppUIMainViewController: FcrAppUICoreViewController {
    lazy var roomListComponent = FcrAppUIRoomListController(center: center)
    
    let headerView = FcrAppUIMainHeaderView(frame: .zero)
    
    var settingItems: [FcrAppUISettingItem] = [.generalSetting(FcrAppUISettingItem.GeneralItem.startList()),
                                               .aboutUs(FcrAppUISettingItem.AboutUsItem.allCases)]
    
    let roomTypeList: [FcrAppUIRoomType] = [.smallClass,
                                            .lectureHall,
                                            .oneToOne,
                                            .proctor]
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override init(center: FcrAppCenter) {
        super.init(center: center)
        center.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        launch()
        initViews()
        initViewFrame()
        updateViewProperties()
        tester()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true,
                                                     animated: true)
        isTest()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard center.isLogined else {
            return
        }
        
        refreshRoomList()
    }
}
