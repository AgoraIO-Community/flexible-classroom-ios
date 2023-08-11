//
//  FcrAppUIQuickStartCreateRoomViews.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/8/11.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUIQuickStartRoomNameTextField: FcrAppUIRoomNameTextField {
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 20,
                      y: 0,
                      width: 78,
                      height: bounds.height)
    }
}

class FcrAppUIQuickStartRoomTypeSelectView: UIView,
                                            AgoraUIContentContainer {
    private let leftLabel = UILabel(frame: .zero)
    let lineView = UIView(frame: .zero)
    
    let rightButton = UIButton(frame: .zero)
    
    var selectedRoomType: FcrAppUIRoomType {
        didSet {
            updateButtonName(with: selectedRoomType)
        }
    }
    
    init(selectedRoomType: FcrAppUIRoomType) {
        self.selectedRoomType = selectedRoomType
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
    }
    
    func initViewFrame() {
        leftLabel.mas_makeConstraints { make in
            make?.left.equalTo()(20)
            make?.top.equalTo()(0)
            make?.bottom.equalTo()(0)
            make?.width.equalTo()(78)
        }
        
        rightButton.mas_makeConstraints { make in
            make?.left.equalTo()(leftLabel.mas_right)?.offset()(10)
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
        
        updateButtonName(with: selectedRoomType)
    }
    
    func updateButtonName(with roomType: FcrAppUIRoomType) {
        rightButton.setTitle(roomType.quickText(),
                             for: .normal)
    }
}

class FcrAppUIQuickStartCreateRoomInputView: UIView,
                                             AgoraUIContentContainer {
    let roomRoomTextField = FcrAppUIQuickStartRoomNameTextField(leftViewType: .text)
    let userNameTextField = FcrAppUIQuickStartUserNameTextField(leftViewType: .text)
    let roomTypeView: FcrAppUIQuickStartRoomTypeSelectView
    
    let createButton = UIButton(frame: .zero)
    
    let roomTypeList: [FcrAppUIRoomType]
    
    private var selectedUserRole = FcrAppUIUserRole.student
    
    init(roomTypeList: [FcrAppUIRoomType]) {
        self.roomTypeList = roomTypeList
        self.roomTypeView = FcrAppUIQuickStartRoomTypeSelectView(selectedRoomType: roomTypeList[0])
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
        
        
        
//        createButton.mas_makeConstraints { make in
//            make?.top.equalTo()(self.roleCollection.mas_bottom)?.offset()(29)
//            make?.left.equalTo()(25)
//            make?.right.equalTo()(-25)
//            make?.height.equalTo()(46)
//        }
    }
    
    func updateViewProperties() {
        roomRoomTextField.leftLabel.text = "fcr_login_free_label_room_id".localized()
        roomRoomTextField.placeholder = "fcr_login_free_tips_room_id".localized()
        
        userNameTextField.leftLabel.text = "fcr_login_free_label_nick_name".localized()
        userNameTextField.placeholder = "fcr_login_free_tips_nick_name".localized()
        
        createButton.backgroundColor = FcrAppUIColorGroup.fcr_v2_brand6
        
        createButton.setTitle("fcr_login_free_button_create".localized(),
                            for: .normal)
    }
}

fileprivate extension FcrAppUIRoomType {
    func quickText() -> String {
        switch self {
        case .smallClass:   return "fcr_login_free_class_mode_option_small_classroom".localized()
        case .oneToOne:     return "fcr_login_free_class_mode_option_1on1".localized()
        case .lectureHall:  return "fcr_login_free_class_mode_option_lecture_hall".localized()
        case .proctor:      return "fcr_login_free_class_mode_option_proctoring".localized()
        }
    }
}
