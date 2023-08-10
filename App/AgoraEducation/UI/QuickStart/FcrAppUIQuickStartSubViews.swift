//
//  FcrAppUIQuickStartSubViews.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/8/10.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

fileprivate class FcrAppUIQuickStartTitleButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.frame = bounds
    }
}

class FcrAppUIQuickStartHeaderView: UIView,
                                    AgoraUIContentContainer {
    private let backgroundImageView = UIImageView(frame: .zero)
    private let titleLabel = FcrAppUIQuickStartTitleButton(frame: .zero)
    
    let settingButton = UIButton(frame: .zero)
    let signButton = UIButton(frame: .zero)
    
    private var isTopConstraintsUpdated = false
    
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
        addSubview(backgroundImageView)
        addSubview(signButton)
        addSubview(settingButton)
        addSubview(titleLabel)
        
        signButton.layer.cornerRadius = 15
        signButton.layer.borderWidth = 1
        
        settingButton.layer.cornerRadius = 16
    }
    
    func initViewFrame() {
        backgroundImageView.mas_makeConstraints { make in
            make?.left.right().top().bottom().equalTo()(0)
        }
        
        titleLabel.mas_makeConstraints { make in
            make?.top.equalTo()(0)
            make?.left.equalTo()(22)
            make?.right.equalTo()(-100)
            make?.height.equalTo()(48)
        }
        
        signButton.mas_makeConstraints { make in
            make?.top.equalTo()(self.titleLabel.mas_bottom)?.offset()(22)
            make?.left.equalTo()(18)
            make?.width.equalTo()(87)
            make?.height.equalTo()(30)
        }
        
        settingButton.mas_makeConstraints { make in
            make?.centerY.equalTo()(self.titleLabel.mas_centerY)
            make?.right.equalTo()(-17)
            make?.width.height().equalTo()(32)
        }
    }
    
    func updateViewProperties() {
        backgroundImageView.image = UIImage(named: "fcr-quick-bg")
        
        titleLabel.setTitleColor(FcrAppUIColorGroup.fcr_v2_white,
                                 for: .normal)
        
        titleLabel.setTitleColor(FcrAppUIColorGroup.fcr_v2_white,
                                 for: .selected)
        
        titleLabel.setTitle("fcr_feedback_label_fcr".localized(),
                            for: .selected)
        
        titleLabel.setTitle("fcr_feedback_label_fcr".localized(),
                            for: .normal)
        
        titleLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        titleLabel.titleLabel?.textAlignment = .left
        
        signButton.setTitle("fcr_login_free_tips_login_guide_sign_in".localized(),
                            for: .normal)
        
        signButton.layer.borderColor = FcrAppUIColorGroup.fcr_v2_white.cgColor
        
        settingButton.setImage(UIImage(named: "fcr-quick-setting"),
                               for: .normal)
        
        settingButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }
    
    func updateTopConstraints(topSafeArea: CGFloat) {
        guard !isTopConstraintsUpdated else {
            return
        }
        
        isTopConstraintsUpdated = true
        
        titleLabel.mas_updateConstraints { make in
            make?.top.equalTo()(topSafeArea)
        }
    }
}

class FcrAppUIQuickStartContentView: UIView,
                                     AgoraUIContentContainer {
    let headerView = FcrAppUIQuickStartHeaderView(frame: .zero)
    let roomInputView: FcrAppUIQuickStartInputView
    
    init(roleList: [FcrAppUIUserRole]) {
        self.roomInputView = FcrAppUIQuickStartInputView(roleList: roleList)
        super.init(frame: .zero)
        initViews()
        initViewFrame()
        updateViewProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(headerView)
        addSubview(roomInputView)
    }
    
    func initViewFrame() {
        headerView.mas_makeConstraints { make in
            make?.left.right().top().equalTo()(0)
            make?.height.equalTo()(263)
        }
        
        roomInputView.mas_makeConstraints { make in
            make?.top.equalTo()(self.headerView.mas_bottom)?.offset()(-107)
            make?.left.equalTo()(15)
            make?.right.equalTo()(-15)
            make?.height.equalTo()(479)
        }
        
        roomInputView.backgroundColor = .blue
    }
    
    func updateViewProperties() {
        
    }
}
