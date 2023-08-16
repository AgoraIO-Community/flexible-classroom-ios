//
//  FcrAppUIQuickStartCreateRoomViews.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/8/11.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUIQuickStartRoomTypeSelectView: UIView,
                                            AgoraUIContentContainer {
    private let leftLabel = UILabel(frame: .zero)
    private let lineView = UIView(frame: .zero)
    private let leftTextWidth: CGFloat
    private let rightViewOffsetX: CGFloat
    
    let rightButton = UIButton(frame: .zero)
    
    var selectedRoomType: FcrAppUIRoomType {
        didSet {
            updateButtonName(with: selectedRoomType)
        }
    }
    
    init(selectedRoomType: FcrAppUIRoomType,
         leftTextWidth: CGFloat,
         rightViewOffsetX: CGFloat) {
        self.selectedRoomType = selectedRoomType
        self.leftTextWidth = leftTextWidth
        self.rightViewOffsetX = rightViewOffsetX
        
        super.init(frame: .zero)
        initViews()
        initViewFrame()
        updateViewProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(leftLabel)
        addSubview(rightButton)
        addSubview(lineView)
        
        leftLabel.font = UIFont.systemFont(ofSize: 15)
        
        // TODO: UI 变量名
        rightButton.backgroundColor = FcrAppUIColorGroup.fcr_v2_light_input_background
        // TODO: UI
        rightButton.layer.cornerRadius = FcrAppUIFrameGroup.quickCornerRadius16
    }
    
    func initViewFrame() {
        leftLabel.mas_makeConstraints { make in
            make?.left.equalTo()(20)
            make?.top.equalTo()(0)
            make?.bottom.equalTo()(0)
            make?.width.equalTo()(self.leftTextWidth)
        }
        
        rightButton.mas_makeConstraints { make in
            make?.left.equalTo()(leftLabel.mas_right)?.offset()(self.rightViewOffsetX)
            make?.right.equalTo()(-18)
            make?.top.equalTo()(7)
            make?.bottom.equalTo()(-7)
        }
        
        lineView.mas_makeConstraints { make in  
            make?.left.equalTo()(0)
            make?.right.equalTo()(0)
            make?.height.equalTo()(1)
            make?.bottom.equalTo()(self.mas_bottom)
        }
    }
    
    func updateViewProperties() {
        leftLabel.textColor = FcrAppUIColorGroup.fcr_black
        
        leftLabel.text = "fcr_login_free_label_class_mode".localized()
        
        lineView.backgroundColor = UIColor(hexString: "#EFEFEF")
        
        // TODO: UI 变量名
        rightButton.setTitleColor(FcrAppUIColorGroup.fcr_black,
                                  for: .normal)
        
        updateButtonName(with: selectedRoomType)
    }
    
    func updateButtonName(with roomType: FcrAppUIRoomType) {
        rightButton.setTitle(roomType.quickText() + "  >",
                             for: .normal)
    }
}

class FcrAppUIQuickStartTimeView: UIView,
                                  AgoraUIContentContainer {
    private let titleLable = UILabel()
    private let lineView = UIView(frame: .zero)
    let timeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        initViewFrame()
        updateViewProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(titleLable)
        addSubview(timeLabel)
        addSubview(lineView)
        
        titleLable.font = FcrAppUIFrameGroup.font10
        timeLabel.font = FcrAppUIFrameGroup.font15
    }
    
    func initViewFrame() {
        titleLable.mas_makeConstraints { make in
            make?.left.equalTo()(20)
            make?.top.equalTo()(20)
            make?.right.equalTo()(-20)
            make?.height.equalTo()(13)
        }
        
        timeLabel.mas_makeConstraints { make in
            make?.left.equalTo()(20)
            make?.top.equalTo()(self.titleLable.mas_bottom)?.offset()(8)
            make?.right.equalTo()(-20)
            make?.height.equalTo()(15)
        }
        
        lineView.mas_makeConstraints { make in
            make?.left.equalTo()(0)
            make?.right.equalTo()(0)
            make?.height.equalTo()(1)
            make?.bottom.equalTo()(self.mas_bottom)
        }
    }
    
    func updateViewProperties() {
        titleLable.text = "fcr_login_free_label_duration_time".localized()
        // TODO: UI 变量名
        titleLable.textColor = FcrAppUIColorGroup.fcr_v2_light_x
        
        timeLabel.textColor = FcrAppUIColorGroup.fcr_v2_light_x
        
        // TODO: UI 变量名
        lineView.backgroundColor = FcrAppUIColorGroup.fcr_light_textline
    }
}

class FcrAppUIQuickStartCreateRoomInputView: UIView,
                                             AgoraUIContentContainer {
    let roomRoomTextField: FcrAppUIRoomNameTextField
    let userNameTextField: FcrAppUIUserNameTextField
    
    let timeView = FcrAppUIQuickStartTimeView(frame: .zero)
    let roomTypeView: FcrAppUIQuickStartRoomTypeSelectView
    let createButton = UIButton(frame: .zero)
    
    let roomTypeList: [FcrAppUIRoomType]
    
    init(roomTypeList: [FcrAppUIRoomType],
         leftTextWidth: CGFloat,
         leftTextOffsetX: CGFloat,
         rightViewOffsetX: CGFloat) {
        self.roomTypeList = roomTypeList
        self.roomTypeView = FcrAppUIQuickStartRoomTypeSelectView(selectedRoomType: roomTypeList[0],
                                                                 leftTextWidth: leftTextWidth,
                                                                 rightViewOffsetX: rightViewOffsetX)
        
        self.roomRoomTextField = FcrAppUIRoomNameTextField(leftViewType: .text,
                                                           leftTextWidth: leftTextWidth,
                                                           leftAreaOffsetX: leftTextOffsetX,
                                                           editAreaOffsetX: rightViewOffsetX)
        
        self.userNameTextField = FcrAppUIUserNameTextField(leftViewType: .text,
                                                           leftTextWidth: leftTextWidth,
                                                           leftAreaOffsetX: leftTextOffsetX,
                                                           editAreaOffsetX: rightViewOffsetX)
        
        super.init(frame: .zero)
        initViews()
        initViewFrame()
        updateViewProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(roomRoomTextField)
        addSubview(roomTypeView)
        addSubview(userNameTextField)
        addSubview(timeView)
        addSubview(createButton)
        
        roomRoomTextField.leftLabel.font = UIFont.systemFont(ofSize: 15)
        roomRoomTextField.leftLabel.textAlignment = .left
        
        userNameTextField.leftLabel.font = UIFont.systemFont(ofSize: 15)
        userNameTextField.leftLabel.textAlignment = .left
        
        createButton.layer.cornerRadius = 23
    }
    
    func initViewFrame() {
        roomRoomTextField.mas_makeConstraints { make in
            make?.top.equalTo()(0)
            make?.left.right().equalTo()(0)
            make?.height.equalTo()(54)
        }
        
        roomTypeView.mas_makeConstraints { make in
            make?.top.equalTo()(self.roomRoomTextField.mas_bottom)
            make?.left.right().equalTo()(0)
            make?.height.equalTo()(54)
        }
        
        userNameTextField.mas_makeConstraints { make in
            make?.top.equalTo()(self.roomTypeView.mas_bottom)
            make?.left.right().equalTo()(0)
            make?.height.equalTo()(54)
        }
        
        timeView.mas_makeConstraints { make in
            make?.top.equalTo()(self.userNameTextField.mas_bottom)
            make?.left.right().equalTo()(0)
            make?.height.equalTo()(80)
        }
        
        createButton.mas_makeConstraints { make in
            make?.left.equalTo()(25)
            make?.right.equalTo()(-25)
            make?.height.equalTo()(46)
            make?.bottom.equalTo()(0)
        }
    }
    
    func updateViewProperties() {
        roomRoomTextField.leftLabel.text = "fcr_login_free_label_room_name".localized()
        roomRoomTextField.placeholder = "fcr_login_free_tips_room_name".localized()
        
        userNameTextField.leftLabel.text = "fcr_login_free_label_nick_name".localized()
        userNameTextField.placeholder = "fcr_login_free_tips_nick_name".localized()
        
        timeView.timeLabel.text = "30mins"
        
        createButton.backgroundColor = FcrAppUIColorGroup.fcr_v2_brand6
        
        createButton.setTitle("fcr_login_free_button_create".localized(),
                              for: .normal)
    }
}

class FcrAppUIQuickStartCheckBoxCell: UITableViewCell,
                                      AgoraUIContentContainer {
    private var checkBox = UIImageView(frame: .zero)
    
    var aSelected = false {
        didSet {
            guard aSelected != oldValue else {
                return
            }
            
            updateCheckBoxImage(aSelected)
            updateBackgroudColor(aSelected)
            updateTextColor(aSelected)
        }
    }
    
    let infoLabel = UILabel()
    
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
        separatorInset = .zero
        
        contentView.addSubview(infoLabel)
        contentView.addSubview(checkBox)
        
        contentView.layer.cornerRadius = 16
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        infoLabel.textAlignment = .center
    }
    
    func initViewFrame() {
        infoLabel.mas_makeConstraints { make in
            make?.centerX.centerY().equalTo()(0)
            make?.top.bottom().equalTo()(0)
            make?.right.equalTo()(self.checkBox.mas_left)
        }
        
        checkBox.mas_makeConstraints { make in
            make?.width.height().equalTo()(24)
            make?.right.equalTo()(-16)
            make?.centerY.equalTo()(0)
        }
    }
    
    func updateViewProperties() {
        updateCheckBoxImage(aSelected)
        updateBackgroudColor(aSelected)
        updateTextColor(aSelected)
    }
    
    private func updateBackgroudColor(_ isSelected: Bool) {
        if isSelected {
            contentView.backgroundColor = FcrAppUIColorGroup.fcr_v2_brand6
        } else {
            contentView.backgroundColor = UIColor.fcr_hex_string("#4262FF",
                                                                 transparency: 0.2)
        }
    }
    
    private func updateCheckBoxImage(_ isSelected: Bool) {
        if isSelected {
            checkBox.image = UIImage(named: "fcr_mobile_check1")
        } else {
            checkBox.image = UIImage(named: "fcr_mobile_check0")
        }
    }
    
    private func updateTextColor(_ isSelected: Bool) {
        if isSelected {
            infoLabel.textColor = FcrAppUIColorGroup.fcr_v2_white
        } else {
            infoLabel.textColor = FcrAppUIColorGroup.fcr_black
        }
    }
}
