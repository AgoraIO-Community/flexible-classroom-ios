//
//  FcrAppUIMainTitleView.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/9/2.
//  Copyright © 2022 Agora. All rights reserved.
//

import AgoraUIBaseViews

protocol FcrAppUIMainTitleViewDelegate: NSObjectProtocol {
    func onClickJoin()
    
    func onClickCreate()
    
    func onClickSetting()
    
    func onEnterDebugMode()
}

class FcrAppUIMainTitleView: UIView, AgoraUIContentContainer {
    weak var delegate: FcrAppUIMainTitleViewDelegate?
    
    public let envLabel = UILabel()
    
    private let cardView = UIView()
    
    private let titleLabel = UILabel()
    
    private let joinActionView = RoomListActionView(frame: .zero)
    
    private let createActionView = RoomListActionView(frame: .zero)
    
    private let settingButton = UIButton(type: .custom)
    
    private var debugCount: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        initViewFrame()
        updateViewProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onClickJoin(_ sender: UIButton) {
        delegate?.onClickJoin()
    }
    
    @objc func onClickCreate(_ sender: UIButton) {
        delegate?.onClickCreate()
    }
    
    @objc func onTouchDebug() {
        guard debugCount >= 10 else {
            debugCount += 1
            return
        }
        delegate?.onEnterDebugMode()
    }
    
    @objc func onClickSetting(_ sender: UIButton) {
        delegate?.onClickSetting()
    }
    
    func initViews() {
        cardView.backgroundColor = .clear
        addSubview(cardView)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = UIColor.black
        titleLabel.text = "fcr_room_list_title".localized()
        titleLabel.isUserInteractionEnabled = true
        addSubview(titleLabel)
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(onTouchDebug))
        titleLabel.addGestureRecognizer(tap)
        
        joinActionView.iconView.image = UIImage(named: "fcr_room_list_join")
        joinActionView.titleLabel.text = "fcr_room_list_join".localized()
        joinActionView.button.addTarget(self,
                                        action: #selector(onClickJoin(_:)),
                                        for: .touchUpInside)
        addSubview(joinActionView)
        
        createActionView.iconView.image = UIImage(named: "fcr_room_list_create")
        createActionView.titleLabel.text = "fcr_room_list_create".localized()
        createActionView.button.addTarget(self,
                                          action: #selector(onClickCreate(_:)),
                                          for: .touchUpInside)
        addSubview(createActionView)
        
        settingButton.setImage(UIImage(named: "fcr_room_list_setting"),
                               for: .normal)
        settingButton.addTarget(self,
                                action: #selector(onClickSetting(_:)),
                                for: .touchUpInside)
        addSubview(settingButton)
        
        envLabel.textColor = .black
        envLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(envLabel)
    }
    
    func initViewFrame() {
        cardView.mas_makeConstraints { make in
            make?.left.right().top().bottom().equalTo()(0)
        }
        
        titleLabel.mas_makeConstraints { make in
            make?.top.equalTo()(68)
            make?.left.equalTo()(16)
        }
        
        joinActionView.mas_makeConstraints { make in
            make?.left.equalTo()(24)
            make?.width.equalTo()(self)?.multipliedBy()(0.4)
            make?.height.equalTo()(56)
            make?.bottom.equalTo()(-20)
        }
        
        createActionView.mas_makeConstraints { make in
            make?.left.equalTo()(joinActionView.mas_right)?.offset()(15)
            make?.width.equalTo()(self)?.multipliedBy()(0.4)
            make?.height.equalTo()(56)
            make?.bottom.equalTo()(-20)
        }
        
        settingButton.mas_makeConstraints { make in
            make?.centerY.equalTo()(titleLabel)
            make?.right.equalTo()(-14)
        }
        
        envLabel.mas_makeConstraints { make in
            make?.centerY.equalTo()(settingButton)
            make?.right.equalTo()(settingButton.mas_left)?.offset()(5)
        }
    }
    
    func updateViewProperties() {
        
    }
}

private class RoomListActionView: UIView, AgoraUIContentContainer {
    private let contentView = UIImageView(image: UIImage(named: "fcr_room_list_start_button_bg"))
    private let iconBGView = UIImageView(image: UIImage(named: "fcr_room_list_action_bg"))
    
    let iconView = UIImageView(image: UIImage())
    let titleLabel = UILabel()
    let button = UIButton(type: .custom)
    
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
        addSubview(contentView)
        addSubview(iconBGView)
        addSubview(iconView)
        addSubview(button)
        addSubview(titleLabel)
        
        titleLabel.textAlignment = .center
    }
    
    func initViewFrame() {
        contentView.mas_makeConstraints { make in
            make?.left.right().top().bottom().equalTo()(0)
        }
        iconBGView.mas_makeConstraints { make in
            make?.width.height().equalTo()(44)
            make?.left.equalTo()(8)
            make?.centerY.equalTo()(0)
        }
        iconView.mas_makeConstraints { make in
            make?.center.equalTo()(iconBGView)
        }
        titleLabel.mas_makeConstraints { make in
            make?.left.equalTo()(iconView.mas_right)
            make?.right.top().bottom().equalTo()(0)
        }
        button.mas_makeConstraints { make in
            make?.left.right().top().bottom().equalTo()(0)
        }
    }
    
    func updateViewProperties() {
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .black
    }
}
