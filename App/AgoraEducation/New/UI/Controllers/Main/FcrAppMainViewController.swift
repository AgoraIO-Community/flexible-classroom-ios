//
//  RoomListViewController.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/9/2.
//  Copyright © 2022 Agora. All rights reserved.
//

#if canImport(AgoraClassroomSDK_iOS)
import AgoraClassroomSDK_iOS
#else
import AgoraClassroomSDK
#endif
import AgoraUIBaseViews
import AgoraProctorSDK
import AgoraWidgets

class FcrAppMainViewController: FcrAppViewController {
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

private extension FcrAppMainViewController {
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
        
        let navigation = FcrAppNavigationController(rootViewController: vc)
        
        present(navigation,
                animated: true)
        
        vc.onCompleted = { [weak navigation] in
            navigation?.dismiss(animated: true)
        }
    }
}

extension FcrAppMainViewController: AgoraUIContentContainer {
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
        
        if let navigation = navigationController as? FcrAppNavigationController {
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

extension FcrAppMainViewController: FcrAppUIMainTitleViewDelegate {
    func onEnterDebugMode() {
        
    }
    
    func onClickJoin() {
        let vc = FcrAppUIJoinRoomController()
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc,
                animated: true)
        
        vc.completion = { [weak self] (options) in
            self?.joinRoom(options: options)
        }
    }
    
    func onClickCreate() {
        RoomCreateViewController.showCreateRoom {
//            self.noticeShow = true
//            self.tableView.reloadData()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                self.noticeShow = false
//                self.tableView.reloadData()
//            }
        }
    }
    
    func onClickSetting() {
        let vc = FcrAppUISettingsViewController(center: center)
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
}

private extension FcrAppMainViewController {
    func joinRoom(options: FcrAppUIJoinRoomOptions) {
        guard let userId = center.localUser?.userId else {
            return
        }
        
        AgoraLoading.loading()
        
        center.room.joinRoomPreCheck(roomId: options.roomId,
                                     role: options.userRole,
                                     userId: userId) { [weak self] object in
            guard let self = self else {
                return
            }
            
            let config = self.createClassroomConfig(userId: userId,
                                                    userName: options.nickname,
                                                    joinRoomObject: object)
            AgoraClassroomSDK.launch(config) {
                AgoraLoading.hide()
            } failure: { [weak self] error in
                AgoraLoading.hide()
                self?.showErrorToast(error)
            }
        } failure: { [weak self] error in
            AgoraLoading.hide()
            
            self?.showErrorToast(error)
        }
    }
    
    func createClassroomConfig(userId: String,
                               userName: String,
                               joinRoomObject: FcrAppServerJoinRoomObject) -> AgoraEduLaunchConfig {
        let config = AgoraEduLaunchConfig(userName: userName,
                                          userUuid: userId,
                                          userRole: joinRoomObject.role.toClassroomType(),
                                          roomName: joinRoomObject.roomDetail.roomName,
                                          roomUuid: joinRoomObject.roomDetail.roomId,
                                          roomType: joinRoomObject.roomDetail.roomType.toClassroomType(),
                                          appId: joinRoomObject.appId,
                                          token: joinRoomObject.token)
        
        return config
    }
}

extension FcrAppMainViewController: FcrAppNavigationControllerDelegate {
    func navigationWillPopToRoot(_ navigation: FcrAppNavigationController) {
        loginCheck { [weak self] in
            self?.roomListComponent.refresh()
        }
    }
}

// MARK: - AgoraProctorDelegate
extension FcrAppMainViewController: AgoraProctorDelegate {
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
