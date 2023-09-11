//
//  FcrAppUIQuickStartCreateRoomViews.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/8/11.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

fileprivate class FcrAppUIQuickStartRoomTypeButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()

        guard let titleLabel = titleLabel,
              let text = titleLabel.text else {
            return
        }

        let size = text.agora_size(font: titleLabel.font,
                                   height: bounds.height)

        var x: CGFloat = (bounds.width - size.width) * 0.5
        var y: CGFloat = 0
        var width: CGFloat = size.width
        var height: CGFloat = bounds.height

        titleLabel.frame = CGRect(x: x,
                                  y: y,
                                  width: width,
                                  height: height)
        
        width = 24
        height = width

        x = titleLabel.frame.maxX
        y = (bounds.height - height) * 0.5

        imageView?.frame = CGRect(x: x,
                                  y: y,
                                  width: width,
                                  height: height)
    }
}

class FcrAppUIQuickStartRoomTypeSelectView: UIView,
                                            AgoraUIContentContainer {
    private let leftLabel = UILabel(frame: .zero)
    private let lineView = UIView(frame: .zero)
    private let leftTextWidth: CGFloat
    private let leftAreaOffsetX: CGFloat
    private let rightViewOffsetX: CGFloat
    
    let rightButton: UIButton = FcrAppUIQuickStartRoomTypeButton(frame: .zero)
    
    var selectedRoomType: FcrAppUIRoomType {
        didSet {
            updateButtonName(with: selectedRoomType)
        }
    }
    
    init(selectedRoomType: FcrAppUIRoomType,
         leftTextWidth: CGFloat,
         leftAreaOffsetX: CGFloat,
         rightViewOffsetX: CGFloat) {
        self.selectedRoomType = selectedRoomType
        self.leftAreaOffsetX = leftAreaOffsetX
        self.leftTextWidth = leftTextWidth
        self.rightViewOffsetX = rightViewOffsetX
        super.init(frame: .zero)
        initViews()
        initViewFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(leftLabel)
        addSubview(rightButton)
        addSubview(lineView)
        
        leftLabel.font = FcrAppUIFontGroup.font15
        
        rightButton.backgroundColor = FcrAppUIColorGroup.fcr_v2_light_input_background
        rightButton.layer.cornerRadius = FcrAppUIFrameGroup.cornerRadius8
        rightButton.titleLabel?.font = FcrAppUIFontGroup.font15
    }
    
    func initViewFrame() {
        leftLabel.mas_makeConstraints { make in
            make?.left.equalTo()(self.leftAreaOffsetX)
            make?.top.equalTo()(0)
            make?.bottom.equalTo()(0)
            make?.width.equalTo()(self.leftTextWidth)
        }
        
        rightButton.mas_makeConstraints { make in
            let left = self.leftAreaOffsetX + self.leftTextWidth + self.rightViewOffsetX
            
            make?.left.equalTo()(left)
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
        
        lineView.backgroundColor = FcrAppUIColorGroup.fcr_v2_line
        
        rightButton.setTitleColor(FcrAppUIColorGroup.fcr_black,
                                  for: .normal)
        
        rightButton.setImage(UIImage(named: "fcr_mobile_right"),
                             for: .normal)
        
        updateButtonName(with: selectedRoomType)
    }
    
    func updateButtonName(with roomType: FcrAppUIRoomType) {
        rightButton.setTitle(roomType.quickText(),
                             for: .normal)
        layoutIfNeeded()
        rightButton.layoutSubviews()
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(titleLable)
        addSubview(timeLabel)
        addSubview(lineView)
        
        titleLable.font = FcrAppUIFontGroup.font10
        timeLabel.font = FcrAppUIFontGroup.font15
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
        
        titleLable.textColor = FcrAppUIColorGroup.fcr_v2_light_text2
        
        timeLabel.textColor = FcrAppUIColorGroup.fcr_v2_light_text2
        
        // TODO: UI 变量名
        lineView.backgroundColor = FcrAppUIColorGroup.fcr_v2_line
    }
}

class FcrAppUIQuickStartCreateRoomInputView: UIView,
                                             AgoraUIContentContainer {
    let roomNameTextField: FcrAppUIRoomNameTextField
    let userNameTextField: FcrAppUIUserNameTextField
    
    let timeView = FcrAppUIQuickStartTimeView(frame: .zero)
    let roomTypeView: FcrAppUIQuickStartRoomTypeSelectView
    let createButton = UIButton(frame: .zero)
    
    let roomTypeList: [FcrAppUIRoomType]
    
    var roomDuration: UInt {
        didSet {
            updateTimeLabel()
        }
    }
    
    init(roomTypeList: [FcrAppUIRoomType],
         roomDuration: UInt,
         leftTextWidth: CGFloat,
         leftTextOffsetX: CGFloat,
         rightViewOffsetX: CGFloat) {
        self.roomTypeList = roomTypeList
        self.roomDuration = roomDuration
        
        self.roomTypeView = FcrAppUIQuickStartRoomTypeSelectView(selectedRoomType: roomTypeList[0],
                                                                 leftTextWidth: leftTextWidth,
                                                                 leftAreaOffsetX: leftTextOffsetX,
                                                                 rightViewOffsetX: rightViewOffsetX)
        
        self.roomNameTextField = FcrAppUIRoomNameTextField(leftViewType: .text,
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(roomNameTextField)
        addSubview(roomTypeView)
        addSubview(userNameTextField)
        addSubview(timeView)
        addSubview(createButton)
        
        roomNameTextField.leftLabel.font = UIFont.systemFont(ofSize: 15)
        roomNameTextField.leftLabel.textAlignment = .left
        
        userNameTextField.leftLabel.font = UIFont.systemFont(ofSize: 15)
        userNameTextField.leftLabel.textAlignment = .left
        
        createButton.layer.cornerRadius = 23
    }
    
    func initViewFrame() {
        roomNameTextField.mas_makeConstraints { make in
            make?.top.equalTo()(0)
            make?.left.right().equalTo()(0)
            make?.height.equalTo()(54)
        }
        
        roomTypeView.mas_makeConstraints { make in
            make?.top.equalTo()(self.roomNameTextField.mas_bottom)
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
        roomNameTextField.updateViewProperties()
        userNameTextField.updateViewProperties()
        timeView.updateViewProperties()
        roomTypeView.updateViewProperties()
        
        roomNameTextField.leftLabel.text = "fcr_login_free_label_room_name".localized()
        roomNameTextField.placeholder = "fcr_login_free_tips_room_name".localized()
        
        userNameTextField.leftLabel.text = "fcr_login_free_label_nick_name".localized()
        userNameTextField.placeholder = "fcr_login_free_tips_nick_name".localized()
        
        createButton.backgroundColor = FcrAppUIColorGroup.fcr_v2_brand6
        
        createButton.setTitle("fcr_login_free_button_create".localized(),
                              for: .normal)
        
        updateTimeLabel()
    }
    
    private func updateTimeLabel() {
        timeView.timeLabel.text = "\(roomDuration)mins"
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
        infoLabel.font = FcrAppUIFontGroup.font15
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
            infoLabel.textColor = FcrAppUIColorGroup.fcr_white
        } else {
            infoLabel.textColor = FcrAppUIColorGroup.fcr_black
        }
    }
}
