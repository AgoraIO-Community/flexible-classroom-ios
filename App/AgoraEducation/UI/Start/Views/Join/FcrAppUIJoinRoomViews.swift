//
//  FcrAppUIJoinRoomViews.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/8/9.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUIJoinRoomRoleView: UIView,
                                AgoraUIContentContainer {
    private let selectedImageView = UIImageView(frame: .zero)
    let button = UIButton(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        initViewFrame()
        updateViewProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selected(_ selected: Bool) {
        button.isSelected = selected
        selectedImageView.isHidden = !selected
        
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
    }
    
    func initViews() {
        addSubview(button)
        addSubview(selectedImageView)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
    
    func initViewFrame() {
        button.mas_makeConstraints { make in
            make?.right.left().bottom().top().equalTo()(0)
        }
        
        let selectedImageViewWidth: CGFloat = 24
        let selectedImageViewHeight: CGFloat = selectedImageViewWidth
        let offset: CGFloat = selectedImageViewWidth * 0.5 - 4
        
        selectedImageView.mas_makeConstraints { make in
            make?.right.equalTo()(offset)
            make?.top.equalTo()(-offset)
            make?.width.equalTo()(selectedImageViewWidth)
            make?.width.equalTo()(selectedImageViewHeight)
        }
    }
    
    func updateViewProperties() {
        selectedImageView.image = UIImage(named: "fcr_mobile_check2")
        
        button.setTitleColor(.white,
                             for: .selected)
        
        button.setTitleColor(.black,
                             for: .normal)
        
        let normalImg = UIImage(color: FcrAppUIColorGroup.fcr_v2_light1,
                                size: CGSize(width: 1, height: 1))
        
        button.setBackgroundImage(normalImg,
                                  for: .normal)
        
        let selectImg = UIImage(color: FcrAppUIColorGroup.fcr_v2_brand6,
                                size: CGSize(width: 1, height: 1))
        
        button.setBackgroundImage(selectImg,
                                  for: .selected)
    }
}
 
class FcrAppUIJoinRoomInputView: UIView,
                                 AgoraUIContentContainer {
    let idTextField = FcrAppUIRoomIdTextField(leftViewType: .image)
    
    let nameTextField = FcrAppUIRoomNameTextField(leftViewType: .image)
    
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
        addSubview(idTextField)
        addSubview(nameTextField)
        
        idTextField.leftViewMode = .always
        
        idTextField.returnKeyType = .done
        idTextField.keyboardType = .numberPad
        
        nameTextField.leftViewMode = .always
        nameTextField.returnKeyType = .done
        nameTextField.lineView.isHidden = true
    }
    
    func initViewFrame() {
        idTextField.mas_makeConstraints { make in
            make?.left.top().right().equalTo()(0)
            make?.height.equalTo()(self.mas_height)?.multipliedBy()(0.5)
        }
        
        nameTextField.mas_makeConstraints { make in
            make?.left.bottom().right().equalTo()(0)
            make?.height.equalTo()(self.mas_height)?.multipliedBy()(0.5)
        }
    }
    
    func updateViewProperties() {
        idTextField.leftImageView.image = UIImage(named: "fcr_v2_id")
        idTextField.placeholder = "fcr_room_join_room_id_ph".localized()
        idTextField.font = UIFont.boldSystemFont(ofSize: 15)
        idTextField.textColor = UIColor.black
        idTextField.backgroundColor = FcrAppUIColorGroup.fcr_v2_light_input_background
        
        nameTextField.leftImageView.image = UIImage(named: "fcr_name")
        nameTextField.placeholder = "fcr_room_join_room_name_ph".localized()
        nameTextField.font = UIFont.boldSystemFont(ofSize: 15)
        nameTextField.textColor = UIColor.black
        nameTextField.backgroundColor = FcrAppUIColorGroup.fcr_v2_light_input_background
    }
}

class FcrAppUIJoinRoomContentView: UIView,
                                   AgoraUIContentContainer {
    private let titleLabel = UILabel()
    
    private let roleTitleLabel = UILabel()
    
    let roomInputView = FcrAppUIJoinRoomInputView()
    
    let studentView = FcrAppUIJoinRoomRoleView()
    
    let teacherView = FcrAppUIJoinRoomRoleView()
    
    let closeButton = UIButton(type: .custom)
    
    let joinButton = UIButton(type: .custom)
    
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
        addSubview(titleLabel)
        addSubview(roomInputView)
       
        addSubview(roleTitleLabel)
        addSubview(studentView)
        addSubview(teacherView)
        addSubview(closeButton)
        addSubview(joinButton)
        
        teacherView.selected(false)
        studentView.selected(true)
    }
    
    func initViewFrame() {
        titleLabel.mas_makeConstraints { make in
            make?.left.top().equalTo()(24)
        }
        
        roomInputView.mas_makeConstraints { make in
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(28)
            make?.left.equalTo()(15)
            make?.right.equalTo()(-15)
            make?.height.equalTo()(120)
        }
        
        roleTitleLabel.mas_makeConstraints { make in
            make?.top.equalTo()(roomInputView.mas_bottom)?.offset()(20)
            make?.left.equalTo()(37)
        }
        
        teacherView.mas_makeConstraints { make in
            make?.top.equalTo()(roleTitleLabel.mas_bottom)?.offset()(12)
            make?.left.equalTo()(17)
            make?.right.equalTo()(self.mas_centerX)?.offset()(-6)
            make?.height.equalTo()(45)
        }
        
        studentView.mas_makeConstraints { make in
            make?.top.equalTo()(roleTitleLabel.mas_bottom)?.offset()(12)
            make?.right.equalTo()(-17)
            make?.left.equalTo()(self.mas_centerX)?.offset()(6)
            make?.height.equalTo()(45)
        }
        
        closeButton.mas_makeConstraints { make in
            make?.top.equalTo()(15)
            make?.right.equalTo()(-15)
        }
        
        joinButton.mas_makeConstraints { make in
            make?.top.equalTo()(studentView.mas_bottom)?.offset()(49)
            make?.left.equalTo()(12)
            make?.right.equalTo()(-12)
            make?.height.equalTo()(46)
        }
    }
    
    func updateViewProperties() {
        titleLabel.textColor = .black
        titleLabel.text = "fcr_room_join_title".localized()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        roomInputView.backgroundColor = UIColor.white
        roomInputView.layer.cornerRadius = 12
        roomInputView.clipsToBounds = true
        
        roleTitleLabel.text = "fcr_room_join_room_role".localized()
        roleTitleLabel.font = UIFont.systemFont(ofSize: 15)
        roleTitleLabel.textColor = FcrAppUIColorGroup.fcr_v2_light_text1
        
        studentView.button.setTitleForAllStates("fcr_room_join_room_role_student".localized())
       
        teacherView.button.setTitleForAllStates("fcr_room_join_room_role_teacher".localized())
        
        closeButton.setImage(UIImage(named: "fcr_mobile_closeicon"),
                             for: .normal)
        
        joinButton.setTitle("fcr_alert_sure".localized(),
                              for: .normal)
        joinButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        joinButton.setTitleColor(.white,
                                   for: .normal)
        joinButton.layer.cornerRadius = 23
        joinButton.clipsToBounds = true
        joinButton.backgroundColor = UIColor(hex: 0x357BF6)
    }
}
