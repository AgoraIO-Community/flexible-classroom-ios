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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selected(_ selected: Bool) {
        button.isSelected = selected
        selectedImageView.isHidden = !selected
        
        button.layer.cornerRadius = FcrAppUIFrameGroup.cornerRadius12
        button.clipsToBounds = true
    }
    
    func initViews() {
        addSubview(button)
        addSubview(selectedImageView)
        
        button.titleLabel?.font = FcrAppUIFontGroup.font15
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
    private let imageSize = CGSize(width: 36,
                                   height: 36)
    
    private(set) lazy var roomIdTextField = FcrAppUIRoomIdTextField(leftViewType: .image,
                                                                    leftImageSize: imageSize,
                                                                    leftAreaOffsetX: 8)
    
    private(set) lazy var userNameTextField = FcrAppUIRoomNameTextField(leftViewType: .image,
                                                                        leftImageSize: imageSize,
                                                                        leftAreaOffsetX: 8)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        initViewFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(roomIdTextField)
        addSubview(userNameTextField)
        
        roomIdTextField.leftViewMode = .always
        
        roomIdTextField.returnKeyType = .done
        roomIdTextField.keyboardType = .numberPad
        
        userNameTextField.leftViewMode = .always
        userNameTextField.returnKeyType = .done
        userNameTextField.lineView.isHidden = true
    }
    
    func initViewFrame() {
        roomIdTextField.mas_makeConstraints { make in
            make?.left.top().right().equalTo()(0)
            make?.height.equalTo()(self.mas_height)?.multipliedBy()(0.5)
        }
        
        userNameTextField.mas_makeConstraints { make in
            make?.left.bottom().right().equalTo()(0)
            make?.height.equalTo()(self.mas_height)?.multipliedBy()(0.5)
        }
    }
    
    func updateViewProperties() {
        roomIdTextField.updateViewProperties()
        userNameTextField.updateViewProperties()
        
        roomIdTextField.leftImageView.image = UIImage(named: "fcr_v2_id")
        roomIdTextField.placeholder = "fcr_home_tips_room_id".localized()
        roomIdTextField.font = UIFont.boldSystemFont(ofSize: 15)
        roomIdTextField.textColor = UIColor.black
        roomIdTextField.backgroundColor = FcrAppUIColorGroup.fcr_v2_light_input_background
        
        userNameTextField.leftImageView.image = UIImage(named: "fcr_name")
        userNameTextField.placeholder = "fcr_home_tips_nick_name".localized()
        userNameTextField.font = UIFont.boldSystemFont(ofSize: 15)
        userNameTextField.textColor = UIColor.black
        userNameTextField.backgroundColor = FcrAppUIColorGroup.fcr_v2_light_input_background
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
        
        titleLabel.font = FcrAppUIFontGroup.font16
        
        joinButton.titleLabel?.font = FcrAppUIFontGroup.font16
        
        roomInputView.layer.cornerRadius = 12
        roomInputView.clipsToBounds = true
        
        roleTitleLabel.font = FcrAppUIFontGroup.font15
        
        joinButton.layer.cornerRadius = 23
        joinButton.clipsToBounds = true
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
            make?.width.height().equalTo()(24)
        }
        
        joinButton.mas_makeConstraints { make in
            make?.top.equalTo()(studentView.mas_bottom)?.offset()(49)
            make?.left.equalTo()(12)
            make?.right.equalTo()(-12)
            make?.height.equalTo()(46)
        }
    }
    
    func updateViewProperties() {
        roomInputView.updateViewProperties()
        studentView.updateViewProperties()
        teacherView.updateViewProperties()
        
        titleLabel.textColor = FcrAppUIColorGroup.fcr_black
        titleLabel.text = "fcr_home_label_join_classroom".localized()
        
        roomInputView.backgroundColor = FcrAppUIColorGroup.fcr_white
        
        roleTitleLabel.text = "fcr_home_label_role".localized()
        roleTitleLabel.textColor = FcrAppUIColorGroup.fcr_v2_light_text1
        
        studentView.button.setTitle("fcr_home_role_option_student".localized(),
                                    for: .normal)
        
        teacherView.button.setTitle("fcr_home_role_option_teacher".localized(),
                                    for: .normal)
        
        closeButton.setImage(UIImage(named: "fcr_mobile_closeicon"),
                             for: .normal)
        
        joinButton.setTitle("fcr_home_button_join".localized(),
                            for: .normal)
        
        joinButton.setTitleColor(FcrAppUIColorGroup.fcr_white,
                                 for: .normal)
        
        joinButton.backgroundColor = FcrAppUIColorGroup.fcr_v2_brand6
    }
}
