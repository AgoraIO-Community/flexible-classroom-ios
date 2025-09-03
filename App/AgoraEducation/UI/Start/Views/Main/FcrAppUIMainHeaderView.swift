//
//  FcrAppUIMainTitleView.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/9/2.
//  Copyright © 2022 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUIMainTitleActionView: UIView,
                                   AgoraUIContentContainer {
    private let contentView = UIImageView(frame: .zero)
    private let iconBGView = UIImageView(frame: .zero)
    
    let iconView = UIImageView(frame: .zero )
    let titleLabel = UILabel()
    let button = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        initViewFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(contentView)
        addSubview(iconBGView)
        addSubview(iconView)
        addSubview(button)
        addSubview(titleLabel)
        
        titleLabel.textAlignment = .center
    }
    
    func initViewFrame() {
        contentView.agora_mas_makeConstraints { make in
            make?.left.right().top().bottom().equalTo()(0)
        }
        
        iconBGView.agora_mas_makeConstraints { make in
            make?.width.height().equalTo()(40)
            make?.left.equalTo()(8)
            make?.centerY.equalTo()(0)
        }
        
        iconView.agora_mas_makeConstraints { make in
            make?.center.equalTo()(iconBGView)
            make?.width.height().equalTo()(40)
        }
        
        titleLabel.agora_mas_makeConstraints { make in
            make?.left.equalTo()(iconView.agora_mas_right)
            make?.right.top().bottom().equalTo()(0)
        }
        
        button.agora_mas_makeConstraints { make in
            make?.left.right().top().bottom().equalTo()(0)
        }
    }
    
    func updateViewProperties() {
        titleLabel.font = FcrAppUIFontGroup.font16
        titleLabel.textColor = FcrAppUIColorGroup.fcr_black
        
        contentView.image = UIImage(named: "fcr_room_list_start_button_bg")
        iconBGView.image = UIImage(named: "fcr_room_list_action_bg")
    }
}

fileprivate class FcrAppUIMainTitleButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.frame = bounds
    }
}

class FcrAppUIMainHeaderView: UIView,
                              AgoraUIContentContainer {
    private let backgroundView = UIImageView(frame: .zero)
    
    let titleLabel: UIButton = FcrAppUIMainTitleButton()
    
    let joinActionView = FcrAppUIMainTitleActionView(frame: .zero)
    
    let createActionView = FcrAppUIMainTitleActionView(frame: .zero)
    
    let settingButton = UIButton(type: .custom)
    
    let testTag = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        initViewFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(backgroundView)
        addSubview(titleLabel)
        addSubview(joinActionView)
        addSubview(createActionView)
        addSubview(settingButton)
        addSubview(testTag)
        
        backgroundView.contentMode = .scaleToFill
        
        // Title label
        titleLabel.titleLabel?.font = FcrAppUIFontGroup.font20
        
        testTag.font = FcrAppUIFontGroup.font20
        testTag.text = "Test"
        testTag.isHidden = true
    }
    
    func initViewFrame() {
        backgroundView.agora_mas_makeConstraints { make in
            make?.left.top().right().bottom().equalTo()(0)
        }
        
        titleLabel.agora_mas_makeConstraints { make in
            let top: CGFloat = (UIDevice.current.isSmallPhone ? 40 : 68)
            
            make?.top.equalTo()(top)
            make?.left.equalTo()(16)
        }
        
        joinActionView.agora_mas_makeConstraints { make in
            make?.top.equalTo()(titleLabel.agora_mas_bottom)?.offset()(28)
            make?.left.equalTo()(24)
            make?.right.equalTo()(createActionView.agora_mas_left)?.offset()(-15)
            make?.height.equalTo()(56)
        }
        
        createActionView.agora_mas_makeConstraints { make in
            make?.top.equalTo()(joinActionView.agora_mas_top)
            make?.right.equalTo()(-24)
            make?.width.equalTo()(self.joinActionView.agora_mas_width)
            make?.height.equalTo()(joinActionView.agora_mas_height)
        }
        
        settingButton.agora_mas_makeConstraints { make in
            make?.centerY.equalTo()(titleLabel)
            make?.right.equalTo()(-14)
        }
        
        testTag.agora_mas_makeConstraints { make in
            make?.centerY.equalTo()(settingButton)
            make?.right.equalTo()(settingButton.agora_mas_left)?.offset()(-5)
        }
    }
    
    func updateViewProperties() {
        joinActionView.updateViewProperties()
        createActionView.updateViewProperties()
        
        backgroundView.image = UIImage(named: "fcr_room_list_bg")
        
        titleLabel.setTitleColor(FcrAppUIColorGroup.fcr_black,
                                 for: .normal)
        
        titleLabel.setTitleColor(FcrAppUIColorGroup.fcr_black,
                                 for: .selected)
        
        titleLabel.setTitle("fcr_phone_home_label_welcome".localized(),
                            for: .normal)
        
        joinActionView.iconView.image = UIImage(named: "fcr_room_list_join")
        joinActionView.titleLabel.text = "fcr_login_button_join_room".localized()
        
        createActionView.iconView.image = UIImage(named: "fcr_room_list_create")
        createActionView.titleLabel.text = "fcr_login_button_create_room".localized()
        
        settingButton.setImage(UIImage(named: "fcr_room_list_setting"),
                               for: .normal)
        
        testTag.textColor = FcrAppUIColorGroup.fcr_black
    }
}
