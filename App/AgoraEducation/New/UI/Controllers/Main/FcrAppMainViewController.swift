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
   
    private let kTitleMax: CGFloat = 198
    
    private let kTitleMin: CGFloat = 110
    
    private var noticeShow = false
    
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
//                self?.fetchData()
            }
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true,
                                                     animated: true)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        guard FcrUserInfoPresenter.shared.qaMode == false else {
//            let debugVC = DebugViewController()
//            debugVC.modalPresentationStyle = .fullScreen
//            self.present(debugVC,
//                         animated: true,
//                         completion: nil)
//            return
//        }
//        if FcrEnvironment.shared.environment == .dev {
//            titleView.envLabel.text = "测试环境"
//        } else {
//            titleView.envLabel.text = ""
//        }
        
        
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
        
        let vc = FcrAppLoginViewController(center: center)
        
        let navigation = FcrAppNavigationController(rootViewController: vc)
        let frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        let button = UIButton(frame: frame)
        button.setImage(UIImage(named: "ic_navigation_back"), for: .normal)
        
        navigation.backButton = button
        
        navigation.modalPresentationStyle = .fullScreen
        
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
            make?.height.equalTo()(kTitleMax)
        }
    }
    
    func updateViewProperties() {
        titleView.backgroundColor = .clear
        view.backgroundColor = .white
    }
}

// MARK: - RoomListTitleViewDelegate
extension FcrAppMainViewController: FcrAppUIMainTitleViewDelegate {
    func onEnterDebugMode() {
        FcrUserInfoPresenter.shared.qaMode = true
        let debugVC = DebugViewController()
        debugVC.modalPresentationStyle = .fullScreen
        self.present(debugVC,
                     animated: true,
                     completion: nil)
    }
    
    func onClickJoin() {
        let inputModel = RoomInputInfoModel()
        RoomListJoinAlertController.show(in: self,
                                         inputModel: inputModel) { model in
//            self.fillupInputModel(inputModel)
        }
    }
    
    func onClickCreate() {
        RoomCreateViewController.showCreateRoom {
            self.noticeShow = true
//            self.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.noticeShow = false
//                self.tableView.reloadData()
            }
        }
    }
    
    func onClickSetting() {
        let vc = FcrAppUISettingsViewController(center: center)
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
}

// MARK: - SDK delegate
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
