//
//  FcrAppUIRoomListController.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/13.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

protocol FcrAppUIRoomListControllerDelegate: NSObjectProtocol {
    func onSelectedRoomToJoin(roomInfo: FcrAppUIRoomListItem)
}

class FcrAppUIRoomListController: FcrAppUIViewController {
    private lazy var refreshAction = UIRefreshControl()
    
    private let cornerRadiusView = FcrAppUIRoomListCornerRadiusView()
    
    private let placeholderView = FcrAppUIRoomListPlaceholderView(frame: .zero)
    private let titleView = FcrAppUIRoomListTitleView(frame: .zero)
    private let noticeView = FcrAppUIRoomListAddedNoticeView(frame: .zero)
    private let tableView = UITableView(frame: .zero,
                                        style: .plain)
    
    private var pullUpLoading = false
    
    weak var delegate: FcrAppUIRoomListControllerDelegate?
    
    private var dataSource = [FcrAppUIRoomListItem]() {
        didSet {
            placeholderView.isHidden = !isShowPlaceholder
            tableView.isHidden = isShowPlaceholder
        }
    }
    
    private var isShowPlaceholder: Bool {
        return (dataSource.count == 0)
    }
    
    private var center: FcrAppCenter
    
    init(center: FcrAppCenter) {
        self.center = center
        super.init(nibName: nil,
                   bundle: nil)
        initViews()
        initViewFrame()
        updateViewProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        let offset = tableView.contentSize.height - tableView.frame.size.height + 150
        
        guard offset > 0,
              let changeNew = change?[.newKey] as? CGPoint,
              let changeOld = change?[.oldKey] as? CGPoint,
              changeOld != changeNew,
              keyPath == "contentOffset",
              tableView.contentOffset.y > offset else {
            return
        }

        onPullLoadUp()
    }
    
    func refresh() {
        refreshRoomList { [weak self] in
            self?.tableView.reloadData()
        } failure: { [weak self] error in
            self?.showErrorToast(error)
        }
    }
    
    func addedNotice() {
        noticeView(isShow: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.noticeView(isShow: false)
        }
    }
}

extension FcrAppUIRoomListController: AgoraUIContentContainer {
    func initViews() {
        view.addSubview(cornerRadiusView)
        view.addSubview(noticeView)
        view.addSubview(titleView)
        view.addSubview(placeholderView)
        view.addSubview(tableView)
        
        cornerRadiusView.backgroundColor = .white
        
        noticeView.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 152
        tableView.register(cellWithClass: FcrAppUIRoomListItemCell.self)
        
        tableView.addSubview(refreshAction)
        
        tableView.addObserver(self,
                              forKeyPath: "contentOffset",
                              options: [.new,
                                        .old],
                              context: nil)
        
        refreshAction.addTarget(self,
                                action: #selector(onPullRefreshDown),
                                for: .valueChanged)
        
        placeholderView.isHidden = !isShowPlaceholder

        tableView.isHidden = isShowPlaceholder
        
        placeholderView.isHidden = false
    }
    
    func initViewFrame() {
        let radius = cornerRadiusView.radius
        
        cornerRadiusView.mas_makeConstraints { make in
            make?.top.equalTo()(0)
            make?.left.equalTo()(0)
            make?.right.equalTo()(0)?.offset()(radius)
            make?.bottom.equalTo()(0)?.offset()(radius)
        }
        
        placeholderView.mas_makeConstraints { make in
            make?.top.equalTo()(66)
            make?.left.right().bottom().equalTo()(0)
        }
        
        titleView.mas_makeConstraints { make in
            make?.top.equalTo()(0)
            make?.left.equalTo()(radius)
            make?.right.equalTo()(-radius)
            make?.height.equalTo()(51)
        }
        
        noticeView.mas_makeConstraints { make in
            make?.top.equalTo()(self.titleView.mas_bottom)?.offset()(-40)
            make?.left.right().equalTo()(0)
            make?.height.equalTo()(40)
        }
        
        tableView.mas_makeConstraints { make in
            make?.top.equalTo()(noticeView.mas_bottom)?.offset()(23)
            make?.left.right().bottom().equalTo()(0)
        }
    }
    
    func updateViewProperties() {
        placeholderView.updateViewProperties()
        titleView.updateViewProperties()
        noticeView.updateViewProperties()
        
        tableView.backgroundColor = FcrAppUIColorGroup.fcr_white
        
        titleView.backgroundColor = FcrAppUIColorGroup.fcr_white
        
        placeholderView.backgroundColor = FcrAppUIColorGroup.fcr_white
        
        tableView.reloadData()
    }
    
    func fakeData() {
        let item1 = FcrAppServerRoomObject(roomName: "test1",
                                           roomId: "123456789",
                                           roomType: .oneToOne,
                                           roomState: .unstarted,
                                           role: .teacher,
                                           userName: "user-abe",
                                           startTime: 1689566769183,
                                           endTime: 1689586769183,
                                           creatorId: "test",
                                           industry: "agora")
        
        let item2 = FcrAppServerRoomObject(roomName: "test2",
                                           roomId: "123456789",
                                           roomType: .smallClass,
                                           roomState: .inProgress,
                                           role: .teacher,
                                           userName: "user-abe",
                                           startTime: 1689566769183,
                                           endTime: 1689586769183,
                                           creatorId: "test",
                                           industry: "agora")
        
        let item3 = FcrAppServerRoomObject(roomName: "test3",
                                           roomId: "123456789",
                                           roomType: .lectureHall,
                                           roomState: .closed,
                                           role: .teacher,
                                           userName: "user-abe",
                                           startTime: 1689566769183,
                                           endTime: 1689586769183,
                                           creatorId: "test",
                                           industry: "agora")
        
        let object1 = FcrAppUIRoomListItem.create(from: item1)
        let object2 = FcrAppUIRoomListItem.create(from: item2)
        let object3 = FcrAppUIRoomListItem.create(from: item3)
        
        dataSource.append(object1)
        dataSource.append(object2)
        dataSource.append(object3)
    }
    
    @objc private func onPullRefreshDown() {
        guard refreshAction.isRefreshing else {
            return
        }
        
        tableView.isUserInteractionEnabled = false
        
        refreshRoomList { [weak self] in
            self?.tableView.isUserInteractionEnabled = true
            self?.refreshAction.endRefreshing()
            self?.tableView.reloadData()
        } failure: { [weak self] error in
            self?.tableView.isUserInteractionEnabled = true
            self?.refreshAction.endRefreshing()
            self?.showErrorToast(error)
        }
    }
    
    private func onPullLoadUp() {
        guard !pullUpLoading else {
            return
        }
        
        pullUpLoading = true
        
        increaseRoomList { [weak self] in
            self?.pullUpLoading = false
            self?.tableView.reloadData()
        } failure: { [weak self] error in
            self?.pullUpLoading = false
            self?.showErrorToast(error)
        }
    }
    
    private func noticeView(isShow: Bool) {
        if isShow {
            noticeView.isHidden = false
        }
        
        let offset: CGFloat = (isShow ? 11 : -40)
        
        noticeView.mas_updateConstraints { make in
            make?.top.equalTo()(self.titleView.mas_bottom)?.offset()(offset)
        }
        
        UIView.animate(withDuration: TimeInterval.agora_animation) {
            self.view.layoutIfNeeded()
        } completion: { isFinished in
            guard isFinished, !isShow else {
                return
            }
            
            self.noticeView.isHidden = true
        }
    }
}

private extension FcrAppUIRoomListController {
    func refreshRoomList(success: @escaping FcrAppSuccess,
                         failure: @escaping FcrAppFailure) {
        let count = (dataSource.count < 10) ? 10 : dataSource.count
                
        center.room.refreshRoomList(count: count,
                                    success: { [weak self] list in
            let newDataSource = list.map { objet in
                return FcrAppUIRoomListItem.create(from: objet)
            }
            
            self?.dataSource = newDataSource
            
            success()
        }, failure: failure)
    }
    
    func increaseRoomList(success: @escaping FcrAppSuccess,
                          failure: @escaping FcrAppFailure) {
        center.room.incrementalRoomList(count: 10,
                                        success: { [weak self] list in
            let newDataSource = list.map { objet in
                return FcrAppUIRoomListItem.create(from: objet)
            }
            
            self?.dataSource.append(contentsOf: newDataSource)
            
            success()
        }, failure: failure)
    }
}

extension FcrAppUIRoomListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: FcrAppUIRoomListItemCell.self)
        
        let item = dataSource[indexPath.item]
        
        cell.indexPath = indexPath
        cell.type = item.roomState
        cell.stateLabel.text = item.roomState.text()
        cell.idLabel.text = item.roomId
        cell.nameLabel.text = item.roomName
        cell.timeLabel.text = item.time
        cell.typeLabel.text = item.roomType.text()
        cell.delegate = self
        
        return cell
    }
}

extension FcrAppUIRoomListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152
    }
}

extension FcrAppUIRoomListController: FcrAppUIRoomListItemCellDelegate {
    func onSharedButtonPressed(at indexPath: IndexPath) {
        let info = dataSource[indexPath.row]
        
        var inviterName = ""
        
        if let name = center.localUser?.nickname {
            inviterName = name
        }
        
        let link = center.urlGroup.invitation(roomId: info.roomId,
                                              inviterName: inviterName)
        
        printDebug("sharing link: \(link ?? "nil")")
        
        UIPasteboard.general.string = link
        
        let message = "fcr_sharingLink_tips_roomid".localized() + ": " + info.roomId
        
        showToast(message)
    }
    
    func onEnteredButtonPressed(at indexPath: IndexPath) {
        let info = dataSource[indexPath.row]
        
        delegate?.onSelectedRoomToJoin(roomInfo: info)
    }
    
    func onCopiedButtonPressed(at indexPath: IndexPath) {
        let info = dataSource[indexPath.row]
        
        UIPasteboard.general.string = info.roomId
        
        let message = "fcr_sharingLink_tips_roomid".localized() + ": " + info.roomId
        
        showToast(message)
    }
}
