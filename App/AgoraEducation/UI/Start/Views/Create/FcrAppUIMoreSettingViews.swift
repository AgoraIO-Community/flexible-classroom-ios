//
//  FcrAppUIMoreSettingViews.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/8/2.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

protocol FcrAppUICreateRoomMoreTableViewDelegate: NSObjectProtocol {
    func tableView(_ tableView: FcrAppUICreateRoomMoreTableView,
                   didSpreadUpdated isSpread: Bool)
    
    func tableView(_ tableView: FcrAppUICreateRoomMoreTableView,
                   didSwitch option: FcrAppUICreateRoomMoreSettingOption)
}

class FcrAppUICreateRoomMoreTableView: UIView,
                                       AgoraUIContentContainer,
                                       UITableViewDataSource,
                                       UITableViewDelegate {
    weak var delegate: FcrAppUICreateRoomMoreTableViewDelegate?
    
    // View
    private let headerView = FcrAppUICreateRoomMoreTitleButton(frame: .zero)
    
    private let tableView = UITableView(frame: .zero,
                                        style: .plain)
    
    // Data
    private(set) var optionList = [FcrAppUICreateRoomMoreSettingOption]()
    
    private var rowHeight: CGFloat {
        get {
            if isSpread {
                return 55
            } else {
                return 60
            }
        }
    }
    
    private var isSpread = false
    
    var suitableHeight: CGFloat {
        get {
            if isSpread {
                return CGFloat(optionList.count + 1) * rowHeight
            } else {
                return rowHeight
            }
        }
    }
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initViews()
        initViewFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(headerView)
        addSubview(tableView)
        
        layer.cornerRadius = 12
        
        headerView.addTarget(self,
                             action: #selector(onHeaderPressed(_:)),
                             for: .touchUpInside)
        
        tableView.rowHeight = 55
        tableView.dataSource = self
        tableView.register(cellWithClass: FcrAppUICreateRoomSwitchCell.self)
        tableView.reloadData()
    }
    
    func initViewFrame() {
        updateTopViewFrame(height: rowHeight)
        
        tableView.mas_makeConstraints { make in
            make?.left.equalTo()(self.mas_left)
            make?.right.equalTo()(self.mas_right)
            make?.top.equalTo()(self.headerView.mas_bottom)
            make?.bottom.equalTo()(self.mas_bottom)
        }
    }
    
    func updateTopViewFrame(height: CGFloat) {
        headerView.mas_makeConstraints { make in
            make?.top.equalTo()(self.mas_top)
            make?.left.equalTo()(self.mas_left)
            make?.right.equalTo()(self.mas_right)
            make?.height.equalTo()(height)
        }
    }
    
    func updateViewProperties() {
        headerView.updateViewProperties()
        
        optionList.removeAll()
        
        let security = FcrAppUICreateRoomMoreSettingOption(iconImage: UIImage(named: "fcr_room_create_security"),
                                                           title: "fcr_create_more_security".localized() + "·",
                                                           subTitle: "fcr_create_more_security_detail".localized(),
                                                           isSwitchOn: false)
       
        optionList.append(security)
        
        tableView.reloadData()
    }
    
    @objc func onHeaderPressed(_ sender: UIButton) {
        guard let header = sender as? FcrAppUICreateRoomMoreTitleButton else {
            return
        }
        
        header.isSpread.toggle()
        isSpread.toggle()
        
        tableView.reloadData()
        
        delegate?.tableView(self,
                            didSpreadUpdated: isSpread)
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return optionList.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: FcrAppUICreateRoomSwitchCell.self,
                                                 for: indexPath)
        
        let option = optionList[indexPath.row]
        
        cell.iconView.image = option.iconImage
        cell.titleLabel.text = option.title
        cell.detailLabel.text = option.subTitle
        cell.switchButton.isSelected = option.isSwitchOn
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        var option = optionList[indexPath.row]
        option.isSwitchOn.toggle()
        optionList[indexPath.row] = option
        
        tableView.reloadData()
        
        delegate?.tableView(self,
                                didSwitch: option)
    }
}

// MARK: - Sub views
class FcrAppUICreateRoomMoreTitleButton: UIButton,
                                         AgoraUIContentContainer {
    var isSpread = false {
        didSet {
            guard isSpread != oldValue else {
                return
            }
            
            UIView.animate(withDuration: TimeInterval.agora_animation) {
                self.updateTitleViewFrame(isSpread: self.isSpread)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateTitleViewFrame(isSpread: isSpread)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        initViewFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
    }
    
    func initViewFrame() {
        updateTitleViewFrame(isSpread: false)
    }
    
    func updateTitleViewFrame(isSpread: Bool) {
        imageView?.isHidden = isSpread
        
        if isSpread {
            let titleWidth: CGFloat = 110
            let titleHeight: CGFloat = 30
            let titleX: CGFloat = 18
            let y: CGFloat = 16
            
            titleLabel?.frame = CGRect(x: titleX,
                                      y: y,
                                      width: titleWidth,
                                      height: titleHeight)
        } else {
            let width: CGFloat = 110
            let height: CGFloat = 30
            let x = (bounds.width - width) * 0.5
            let y: CGFloat = 16
            
            titleLabel?.frame = CGRect(x: x,
                                      y: y,
                                      width: width,
                                      height: height)
            
            let imageWidth: CGFloat = 30
            let imageHeight: CGFloat = imageWidth
            
            let imageX: CGFloat = bounds.width * 0.5 + 25
            
            imageView?.frame = CGRect(x: imageX,
                                      y: y,
                                      width: imageWidth,
                                      height: imageHeight)
        }
    }
    
    func updateViewProperties() {
        setImage(UIImage(named: "fcr_room_create_arrow_down"),
                 for: .normal)
        
        setTitle("fcr_create_more_setting".localized(),
                 for: .normal)
        
        setTitleColor(UIColor.black,
                      for: .normal)
    }
}

class FcrAppUICreateRoomSwitchCell: UITableViewCell,
                                    AgoraUIContentContainer {
    private let lineView = UIView()
    
    let iconView = UIImageView(frame: .zero)
    
    let switchButton = UIButton(type: .custom)
    
    let titleLabel = UILabel()
    
    let detailLabel = UILabel()
        
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        initViews()
        initViewFrame()
        updateViewProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        selectionStyle = .none
        
        contentView.addSubview(lineView)
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(switchButton)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        detailLabel.font = UIFont.boldSystemFont(ofSize: 13)
    }
    
    func initViewFrame() {
        iconView.mas_makeConstraints { make in
            make?.left.equalTo()(contentView.mas_left)?.offset()(16)
            make?.centerY.equalTo()(0)
            make?.width.height().equalTo()(18)
        }
        
        lineView.mas_makeConstraints { make in
            make?.left.equalTo()(iconView.mas_left)
            make?.right.bottom().equalTo()(0)
            make?.height.equalTo()(1)
        }
        
        titleLabel.mas_makeConstraints { make in
            make?.left.equalTo()(iconView.mas_right)?.offset()(8)
            make?.centerY.equalTo()(iconView)
        }
        
        detailLabel.mas_makeConstraints { make in
            make?.left.equalTo()(titleLabel.mas_right)?.offset()(12)
            make?.centerY.equalTo()(iconView)
        }
        
        switchButton.mas_makeConstraints { make in
            make?.right.equalTo()(contentView.mas_right)?.offset()(-16)
            make?.centerY.equalTo()(0)
        }
    }
    
    func updateViewProperties() {
        lineView.backgroundColor = UIColor(hex: 0xEFEFEF)
        
        titleLabel.textColor = UIColor.black
        
        detailLabel.textColor = UIColor(hex: 0x757575)
        
        switchButton.setImage(UIImage(named: "fcr_room_create_off"),
                              for: .normal)
        
        switchButton.setImage(UIImage(named: "fcr_room_create_on"),
                              for: .selected)
    }
}
