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

class FcrAppUIMainViewController: FcrAppUIViewController {
    lazy var roomListComponent = FcrAppUIRoomListController(center: center)
    
    let backgroundView = UIImageView(frame: .zero)
    
    let headerView = FcrAppUIMainHeaderView(frame: .zero)
    
    var settingItems: [FcrAppUISettingItem] = [.generalSetting(FcrAppUISettingItem.GeneralItem.startList()),
                                               .aboutUs(FcrAppUISettingItem.AboutUsItem.allCases)]
    
    let roomTypeList: [FcrAppUIRoomType] = [.smallClass,
                                            .lectureHall,
                                            .oneToOne,
                                            .proctor]
    
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        initViewFrame()
        updateViewProperties()
        launch()
        tester()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true,
                                                     animated: true)
        isTest()
    }
    
    func joinRoom(config: AgoraEduLaunchConfig) {
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
}

// MARK: - AgoraProctorDelegate
extension FcrAppUIMainViewController: AgoraProctorDelegate {
    func onExit(reason: AgoraProctorExitReason) {
        switch reason {
        case .kickOut:
            AgoraToast.toast(message: "kick out")
        default:
            break
        }
        
        self.proctor = nil
    }
}
