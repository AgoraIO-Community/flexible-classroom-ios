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
    private lazy var roomListComponent = FcrAppUIRoomListController(center: center)
    
    private let backgroundView = UIImageView(image: UIImage(named: "fcr_room_list_bg"))
    
    private let titleView = FcrAppUIMainTitleView(frame: .zero)
    
    private var proctor: AgoraProctor?
    
    private let center = FcrAppCenter()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        initViewFrame()
        updateViewProperties()
        
        // 1. Check if agreed privacy
        privacyCheck { [weak self] in
            // 2. Check if logined
            self?.loginCheck { [weak self] in
                // 3. Refresh data
                self?.roomListComponent.refresh()
            }
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true,
                                                     animated: true)
    }
}

private extension FcrAppUIMainViewController {
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
        // Loading view
        if let bundle = Bundle.agora_bundle("AgoraEduUI"),
           let url = bundle.url(forResource: "img_loading",
                                withExtension: "gif"),
           let data = try? Data(contentsOf: url) {
            AgoraLoading.setImageData(data)
        }
        
        // Toast view
        let noticeImage = UIImage(named: "toast_notice")!
        let warningImage = UIImage(named: "toast_warning")!
        let errorImage = UIImage(named: "toast_warning")!
        
        AgoraToast.setImages(noticeImage: noticeImage,
                             warningImage: warningImage,
                             errorImage: errorImage)
        
        if let navigation = navigationController as? FcrAppUINavigationController {
            navigation.csDelegate = self
        }
        
        view.addSubview(backgroundView)
        view.addSubview(titleView)
        view.addSubview(roomListComponent.view)
        
        titleView.delegate = self
    }
    
    func initViewFrame() {
        backgroundView.mas_makeConstraints { make in
            make?.left.top().right().equalTo()(0)
        }
        
        roomListComponent.view.mas_makeConstraints { make in
            make?.top.equalTo()(198)
            make?.left.right().bottom().equalTo()(0)
        }
        
        titleView.mas_makeConstraints { make in
            make?.left.top().right().equalTo()(0)
            make?.height.equalTo()(198)
        }
    }
    
    func updateViewProperties() {
        titleView.backgroundColor = .clear
        view.backgroundColor = .white
    }
}

extension FcrAppUIMainViewController: FcrAppUIMainTitleViewDelegate {
    func onEnterDebugMode() {
        
    }
    
    func onClickJoin() {
        let vc = FcrAppUIJoinRoomController(center: center) { [weak self] object in
            self?.joinRoom(options: object)
        }
        
        presentViewController(vc,
                              animated: true)
    }
    
    func onClickCreate() {
        let vc = FcrAppUICreateRoomViewController(center: center) { [weak self] in
            self?.roomListComponent.addedNotice()
        }
        
        present(vc,
                animated: true)
    }
    
    func onClickSetting() {
        let vc = FcrAppUISettingsViewController(center: center)
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
}

private extension FcrAppUIMainViewController {
    func joinRoom(options: FcrAppUIJoinRoomConfig) {
        let config = AgoraEduLaunchConfig(userName: options.userName,
                                          userUuid: options.userId,
                                          userRole: options.userRole.toClassroomType(),
                                          roomName: options.roomName,
                                          roomUuid: options.roomId,
                                          roomType: options.roomType.toClassroomType(),
                                          appId: options.appId,
                                          token: options.token)
        
        AgoraLoading.loading()
        
        AgoraClassroomSDK.launch(config) {
            AgoraLoading.hide()
        } failure: { [weak self] error in
            AgoraLoading.hide()
            self?.showErrorToast(error)
        }
    }
}

extension FcrAppUIMainViewController: FcrAppNavigationControllerDelegate {
    func navigationWillPopToRoot(_ navigation: FcrAppUINavigationController) {
        loginCheck { [weak self] in
            self?.roomListComponent.refresh()
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
