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
    
    private let titleView = FcrAppUIRoomListTitleView(frame: .zero)
    private let noticeView = FcrAppUIRoomListAddedNoticeView(frame: .zero)
    private let tableView = UITableView(frame: .zero,
                                        style: .plain)
    
    private let defaultPullRoomInfoCount = 5
    
    private var pullUpLoading = false
    
    weak var delegate: FcrAppUIRoomListControllerDelegate?
    
    private var dataSource = [FcrAppUIRoomListItem]()
    
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard isShowPlaceholder else {
            return
        }
        
        tableView.reloadData()
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
        view.addSubview(tableView)
        view.addSubview(noticeView)
        view.addSubview(titleView)
        
        cornerRadiusView.backgroundColor = .white
        
        noticeView.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 152
        tableView.showsVerticalScrollIndicator = false
        tableView.register(cellWithClass: FcrAppUIRoomListItemCell.self)
        tableView.register(cellWithClass: FcrAppUIRoomListPlaceholderCell.self)
        
        tableView.addSubview(refreshAction)
        
        tableView.addObserver(self,
                              forKeyPath: "contentOffset",
                              options: [.new,
                                        .old],
                              context: nil)
        
        refreshAction.addTarget(self,
                                action: #selector(onPullRefreshDown),
                                for: .valueChanged)
    }
    
    func initViewFrame() {
        let radius = cornerRadiusView.radius
        
        cornerRadiusView.mas_makeConstraints { make in
            make?.top.equalTo()(0)
            make?.left.equalTo()(0)
            make?.right.equalTo()(0)?.offset()(radius)
            make?.bottom.equalTo()(0)?.offset()(radius)
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
            make?.top.equalTo()(noticeView.mas_bottom)?.offset()(12)
            make?.left.right().bottom().equalTo()(0)
        }
    }
    
    func updateViewProperties() {
        titleView.updateViewProperties()
        noticeView.updateViewProperties()
        
        tableView.backgroundColor = FcrAppUIColorGroup.fcr_white
        
        titleView.backgroundColor = FcrAppUIColorGroup.fcr_white
        
        tableView.reloadData()
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
        let count = (dataSource.count < defaultPullRoomInfoCount) ? defaultPullRoomInfoCount : dataSource.count
                
        center.room.refreshRoomList(count: count,
                                    success: { [weak self] list in
            let new = list.filtered { object in
                return object.sceneType.isValid
            } map: { object in
                return FcrAppUIRoomListItem.create(from: object)
            }
            
            self?.dataSource = new
            
            success()
        }, failure: failure)
    }
    
    func increaseRoomList(success: @escaping FcrAppSuccess,
                          failure: @escaping FcrAppFailure) {
        center.room.incrementalRoomList(count: defaultPullRoomInfoCount,
                                        success: { [weak self] list in
            let new = list.filtered { object in
                return object.sceneType.isValid
            } map: { object in
                return FcrAppUIRoomListItem.create(from: object)
            }
            
            self?.dataSource.append(contentsOf: new)
            
            success()
        }, failure: failure)
    }
}

extension FcrAppUIRoomListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if isShowPlaceholder {
            return 1
        } else {
            return dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isShowPlaceholder {
            let cell = tableView.dequeueReusableCell(withClass: FcrAppUIRoomListPlaceholderCell.self)
            return cell
        } else {
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
}

extension FcrAppUIRoomListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isShowPlaceholder {
            return tableView.bounds.height
        } else {
            let item = dataSource[indexPath.item]
            
            return item.height
        }
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
        
        UIPasteboard.general.string = link
        
        let message = "fcr_home_tips_invite_copy".localized()
        
        showToast(message)
    }
    
    func onEnteredButtonPressed(at indexPath: IndexPath) {
        let info = dataSource[indexPath.row]
        
        delegate?.onSelectedRoomToJoin(roomInfo: info)
    }
    
    func onCopiedButtonPressed(at indexPath: IndexPath) {
        let info = dataSource[indexPath.row]
        
        UIPasteboard.general.string = info.roomId
        
        let message = "fcr_home_tips_invite_copy_room_id".localized()
        
        showToast(message)
    }
}
