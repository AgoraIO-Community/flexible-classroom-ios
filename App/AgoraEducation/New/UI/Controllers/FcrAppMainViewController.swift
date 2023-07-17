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
    /**views**/
    private let kSectionTitle = 0
    private let kSectionNotice = 1
    private let kSectionRooms = 2
    private let kSectionEmpty = 3
    
    let backgroundView = UIImageView(image: UIImage(named: "fcr_room_list_bg"))
    
    
    
    let titleView = RoomListTitleView(frame: .zero)
    /**data**/
    var dataSource = [RoomItemModel]()
    
    private let kTitleMax: CGFloat = 198
    
    private let kTitleMin: CGFloat = 110
    
    private var noticeShow = false

    private lazy var refreshAction = UIRefreshControl() // 下拉刷新
    private var roomNextId: String?
    private var isRefreshing = false // 下拉刷新
    
    private var isLoading = false // 上拉加载
    
    private var proctor: AgoraProctor?
    
    private let center = FcrAppCenter()
    
    private let roomListComponent = FcrAppRoomListController()

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
        
        let vc = FcrAppPrivacyTermsViewController()
        
        present(vc,
                animated: true)
        
        vc.onAgreedCompleted = { [weak self] in
            self?.center.localStorage.writeData(true,
                                                key: .privacyAgreement)
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
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
//        let offset = tableView.contentSize.height - tableView.frame.size.height + 150
//
//        guard offset > 0,
//              let changeNew = change?[.newKey] as? CGPoint,
//              let changeOld = change?[.oldKey] as? CGPoint,
//              changeOld != changeNew,
//              keyPath == "contentOffset",
//              tableView.contentOffset.y > offset else {
//            return
//        }

        onPullLoadUp()
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
        
        backgroundView.backgroundColor = .red
        view.addSubview(backgroundView)
        
        
//
//        titleView.delegate = self
//        titleView.clipsToBounds = true
//        view.addSubview(titleView)
        
        // Room list
        view.addSubview(roomListComponent.view)
        
        
        // 下拉刷新
//        refreshAction.addTarget(self,
//                                action: #selector(onPullRefreshDown),
//                                for: .valueChanged)
//        tableView.addSubview(refreshAction)
//        // 下拉加载
//        tableView.addObserver(self,
//                              forKeyPath: "contentOffset",
//                              options: [.new,
//                                        .old],
//                              context: nil)
    }
    
    func initViewFrame() {
        backgroundView.mas_makeConstraints { make in
            make?.left.top().right().equalTo()(0)
        }
        
        roomListComponent.view.mas_makeConstraints { make in
            make?.top.equalTo()(198)
            make?.left.right().bottom().equalTo()(0)
        }
        
//        tableView.mas_makeConstraints { make in
//            make?.left.right().top().bottom().equalTo()(0)
//        }
//        titleView.mas_makeConstraints { make in
//            make?.left.top().right().equalTo()(0)
//            make?.height.equalTo()(kTitleMax)
//        }
    }
    
    func updateViewProperties() {
        
    }
}

// MARK: - Private
private extension FcrAppMainViewController {
//    func fetchData(nextId: String? = nil,
//                   onComplete: (() -> Void)? = nil) {
//        FcrOutsideClassAPI.fetchRoomList(nextId: nextId,
//                                         count: 10) { [weak self] dict in
//            guard let `self` = self,
//                  let data = dict["data"] as? [String: Any],
//                  let list = data["list"] as? [Dictionary<String, Any>]
//            else {
//                return
//            }
//
//            if let nextIdFromData = data["nextId"] as? String {
//                self.roomNextId = nextIdFromData
//            }
//
//            if let _ = nextId {
//                self.dataSource = self.dataSource + RoomItemModel.arrayWithDataList(list)
//            } else {
//                self.dataSource = RoomItemModel.arrayWithDataList(list)
//            }
//
//            self.tableView.reloadData()
//            onComplete?()
//        } onFailure: { code, msg in
//            onComplete?()
//            AgoraToast.toast(message: msg,
//                             type: .warning)
//        }
//    }
    
    // MARK: actions
    @objc func onPullRefreshDown() {
        guard !isRefreshing else {
            return
        }
        isRefreshing = true
        
//        fetchData { [weak self] in
//            self?.isRefreshing = false
//            self?.refreshAction.endRefreshing()
//        }
    }
    
    @objc func onPullLoadUp() {
        guard !isLoading else {
            return
        }
        isLoading = true
        
//        fetchData(nextId: roomNextId) { [weak self] in
//            self?.isLoading = false
//        }
    }
}
// MARK: - FcrAppUIRoomListItemCell Call Back
extension FcrAppMainViewController: FcrAppUIRoomListItemCellDelegate {
    func onClickShare(at indexPath: IndexPath) {
        let item = dataSource[indexPath.row]
        RoomListShareAlertController.show(in: self,
                                          roomId: item.roomId,
                                          complete: nil)
    }
    
    func onClickEnter(at indexPath: IndexPath) {
        let item = dataSource[indexPath.row]
        let inputModel = RoomInputInfoModel()
        inputModel.roomId = item.roomId
        inputModel.roomName = item.roomName
        inputModel.roleType = item.role ?? 1
        inputModel.userName = FcrUserInfoPresenter.shared.nickName
//        fillupInputModel(inputModel)
    }
    
    func onClickCopy(at indexPath: IndexPath) {
        let item = dataSource[indexPath.row]
        UIPasteboard.general.string = item.roomId
        AgoraToast.toast(message: "fcr_sharingLink_tips_roomid".localized(),
                         type: .notice)
    }
}
// MARK: - Table View Call Back
extension FcrAppMainViewController {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 4
//    }
    
//    func tableView(_ tableView: UITableView,
//                   numberOfRowsInSection section: Int) -> Int {
//        if section == kSectionTitle {
//            return 1
//        } else if section == kSectionNotice {
//            return noticeShow ? 1 : 0
//        } else if section == kSectionRooms {
//            return dataSource.count
//        } else if section == kSectionEmpty {
//            return dataSource.count > 0 ? 0 : 1
//        } else {
//            return 0
//        }
//    }
//
//    func tableView(_ tableView: UITableView,
//                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == kSectionTitle {
//            let cell = tableView.dequeueReusableCell(withClass: RoomListTitleCell.self)
//            return cell
//        } else if indexPath.section == kSectionNotice {
//            let cell = tableView.dequeueReusableCell(withClass: RoomListNotiCell.self)
//            return cell
//        } else if indexPath.section == kSectionRooms {
//            let cell = tableView.dequeueReusableCell(withClass: FcrAppUIRoomListItemCell.self)
//            cell.delegate = self
//            cell.indexPath = indexPath
//            cell.model = dataSource[indexPath.row]
//            return cell
//        } else if indexPath.section == kSectionEmpty {
//            let cell = tableView.dequeueReusableCell(withClass: RoomListEmptyCell.self)
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withClass: RoomListEmptyCell.self)
//            return cell
//        }
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var height = kTitleMax - scrollView.contentOffset.y
        height = height < kTitleMin ? kTitleMin : height
        titleView.setSoildPercent(scrollView.contentOffset.y/(kTitleMax - kTitleMin))
        titleView.mas_updateConstraints { make in
            make?.height.equalTo()(height)
        }
    }
    

}
// MARK: - RoomListTitleViewDelegate
extension FcrAppMainViewController: RoomListTitleViewDelegate {
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
        let vc = FcrSettingsViewController()
        self.navigationController?.pushViewController(vc,
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
