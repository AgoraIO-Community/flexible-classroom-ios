//
//  FcrAppUIQuickStartClassModeViewController.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/8/15.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUIQuickStartClassModeViewController: FcrAppUIPresentedViewController {
    private let lineView = UIView()
    
    private let titleLabel = UILabel()
    
    private let tableView = UITableView(frame: .zero)
    
    private let dataSource: [FcrAppUIRoomType]
    
    private(set) var selected: FcrAppUIRoomType
    
    init(roomTypeList: [FcrAppUIRoomType],
         selected: FcrAppUIRoomType) {
        self.dataSource = roomTypeList
        self.selected = selected
        super.init(contentHeight: (377 + 24))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initViews() {
        super.initViews()
        contentView.addSubview(lineView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(tableView)
        
        lineView.layer.cornerRadius = 2.5
        
        titleLabel.textAlignment = .center
        titleLabel.font = FcrAppUIFontGroup.font16
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.separatorStyle = .none
       
        tableView.register(cellWithClass: FcrAppUIQuickStartCheckBoxCell.self)
        tableView.rowHeight = 60
        tableView.reloadData()
    }
    
    override func initViewFrame() {
        super.initViewFrame()
        
        lineView.mas_makeConstraints { make in
            make?.top.equalTo()(6)
            make?.centerX.equalTo()(0)
            make?.width.equalTo()(50)
            make?.height.equalTo()(5)
        }
        
        titleLabel.mas_makeConstraints { make in
            make?.top.equalTo()(28)
            make?.left.right().equalTo()(0)
            make?.height.equalTo()(15)
        }
        
        tableView.mas_makeConstraints { make in
            make?.left.equalTo()(15)
            make?.right.equalTo()(-15)
            make?.top.equalTo()(self.titleLabel.mas_bottom)?.offset()(20)
            make?.bottom.equalTo()(0)
        }
    }
    
    override func updateViewProperties() {
        super.updateViewProperties()
        
        titleLabel.textColor = FcrAppUIColorGroup.fcr_black
        titleLabel.text = "fcr_login_free_class_mode_label_choose".localized()
        
        lineView.backgroundColor = UIColor(hexString: "#D9D9D9")
    }
}

extension FcrAppUIQuickStartClassModeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: FcrAppUIQuickStartCheckBoxCell.self)
        let type = dataSource[indexPath.section]
        
        cell.infoLabel.text = type.quickText()
        cell.aSelected = (selected == type)

        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: false)
        let type = dataSource[indexPath.section]
        
        selected = type
        tableView.reloadData()
    }
}
