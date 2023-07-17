//
//  FcrAppRoomListController.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/7/13.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppRoomListController: UIViewController {
    private let placeholderView = FcrAppUIRoomListPlaceholderView(frame: .zero)
    private let titleView = FcrAppUIRoomListTitleView(frame: .zero)
    
    private let tableView = UITableView(frame: .zero,
                                        style: .plain)
    
    var dataSource = [FcrAppUIRoomListItem]() {
        didSet {
            placeholderView.isHidden = !isShowPlaceholder
            tableView.isHidden = isShowPlaceholder
        }
    }
    
    private var isShowPlaceholder: Bool {
        return (dataSource.count == 0)
    }
    
    override init(nibName nibNameOrNil: String?,
                  bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil,
                   bundle: nibBundleOrNil)
        initViews()
        updateViewProperties()
        initViewFrame()
        
        fakeData()
        tableView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FcrAppRoomListController: AgoraUIContentContainer {
    func initViews() {
        view.addSubview(titleView)
        view.addSubview(placeholderView)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 152
        tableView.register(cellWithClass: FcrAppUIRoomListItemCell.self)
        
        placeholderView.isHidden = !isShowPlaceholder

        tableView.isHidden = isShowPlaceholder
    }
    
    func initViewFrame() {
        placeholderView.mas_makeConstraints { make in
            make?.top.equalTo()(66)
            make?.left.right().bottom().equalTo()(0)
        }
        
        tableView.mas_makeConstraints { make in
            make?.top.equalTo()(66)
            make?.left.right().bottom().equalTo()(0)
        }
        
        let titleCornerRadius = titleView.titleCornerRadius
        
        titleView.mas_makeConstraints { make in
            make?.top.left().equalTo()(0)
            make?.right.equalTo()(titleCornerRadius)
            make?.bottom.equalTo()(placeholderView.mas_top)?.offset()(titleCornerRadius)
        }
    }
    
    func updateViewProperties() {
        tableView.backgroundColor = .red
        
        titleView.backgroundColor = .yellow
        
        placeholderView.backgroundColor = .blue
    }
    
    func fakeData() {
        let item1 = FcrAppServerRoomObject(roomName: "test1",
                                           roomId: "123456789",
                                           roomType: .oneToOne,
                                           roomState: .unstarted,
                                           startTime: 1689566769183,
                                           endTime: 1689586769183,
                                           creatorId: "test",
                                           industry: "agora")
        
        let object1 = FcrAppUIRoomListItem.create(from: item1)
        
        dataSource.append(object1)
    }
}

extension FcrAppRoomListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: FcrAppUIRoomListItemCell.self)
        
        let item = dataSource[indexPath.item]
        
        cell.type = item.roomState
        cell.stateLabel.text = item.roomState.text()
        
        return cell
    }
}

extension FcrAppRoomListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == kSectionTitle {
//            return 66
//        } else if indexPath.section == kSectionNotice {
//            return 74
//        } else if indexPath.section == kSectionRooms {
//            return 152
//        } else if indexPath.section == kSectionEmpty {
//            return 500
//        } else {
//            return 0
//        }
        
        return 152
    }
}

