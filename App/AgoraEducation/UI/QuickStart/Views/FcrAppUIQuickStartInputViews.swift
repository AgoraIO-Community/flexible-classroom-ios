//
//  FcrAppUIQuickStartInputViews.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/8/16.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

// MARK: - Input view
class FcrAppUIQuickStartSegmentedControl: UIButton,
                                          AgoraUIContentContainer {
    private(set) var segmented: FcrAppUIQuickStartSegmentOption = .join
    
    private let joinButton = UIButton(frame: .zero)
    private let createButton = UIButton(frame: .zero)
    
    private let lineView = UIView(frame: .zero)
    
    var onSegmented: ((FcrAppUIQuickStartSegmentOption) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        initViewFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(joinButton)
        addSubview(createButton)
        addSubview(lineView)
        
        joinButton.isSelected = true
        joinButton.titleLabel?.font = FcrAppUIFontGroup.font16
        joinButton.addTarget(self,
                             action: #selector(onSelected(_:)),
                             for: .touchUpInside)
        
        createButton.isSelected = false
        createButton.titleLabel?.font = FcrAppUIFontGroup.font16
        createButton.addTarget(self,
                               action: #selector(onSelected(_:)),
                               for: .touchUpInside)
        
        lineView.layer.cornerRadius = 1.5
    }
    
    func initViewFrame() {
        joinButton.mas_makeConstraints { make in
            make?.left.top().bottom().equalTo()(0)
            make?.width.equalTo()(self.mas_width)?.multipliedBy()(0.5)
        }
        
        createButton.mas_makeConstraints { make in
            make?.right.top().bottom().equalTo()(0)
            make?.width.equalTo()(self.mas_width)?.multipliedBy()(0.5)
        }
        
        lineView.mas_makeConstraints { make in
            make?.bottom.equalTo()(0)
            make?.width.equalTo()(self.mas_width)?.multipliedBy()(0.5)?.offset()(-40)
            make?.height.equalTo()(3)
            make?.centerX.equalTo()(self.joinButton.mas_centerX)
        }
    }
    
    func updateViewProperties() {
        joinButton.setTitleColor(FcrAppUIColorGroup.fcr_black,
                                 for: .normal)
        
        joinButton.setTitleColor(FcrAppUIColorGroup.fcr_v2_brand6,
                                 for: .selected)
        
        joinButton.setTitle("fcr_login_free_option_join".localized(),
                            for: .normal)
        
        createButton.setTitleColor(FcrAppUIColorGroup.fcr_black,
                                   for: .normal)
        
        createButton.setTitleColor(FcrAppUIColorGroup.fcr_v2_brand6,
                                   for: .selected)
        
        createButton.setTitle("fcr_login_free_option_create".localized(),
                              for: .normal)
        
        lineView.backgroundColor = FcrAppUIColorGroup.fcr_v2_brand6
    }
    
    @objc private func onSelected(_ sender: UIButton) {
        UIApplication.shared.keyWindow?.endEditing(true)
        
        // deduplication
        guard !sender.isSelected else {
            return
        }
        
        joinButton.isSelected.toggle()
        createButton.isSelected.toggle()
        
        if joinButton.isSelected {
            lineView.mas_remakeConstraints { make in
                make?.bottom.equalTo()(0)
                make?.width.equalTo()(self.mas_width)?.multipliedBy()(0.5)?.offset()(-40)
                make?.height.equalTo()(2)
                make?.centerX.equalTo()(self.joinButton.mas_centerX)
            }
            
            segmented = .join
        } else {
            lineView.mas_remakeConstraints { make in
                make?.bottom.equalTo()(0)
                make?.width.equalTo()(self.mas_width)?.multipliedBy()(0.5)?.offset()(-40)
                make?.height.equalTo()(2)
                make?.centerX.equalTo()(self.createButton.mas_centerX)
            }
            
            segmented = .create
        }
        
        UIView.animate(withDuration: TimeInterval.agora_animation) {
            self.layoutIfNeeded()
        }
        
        onSegmented?(segmented)
    }
}

class FcrAppUIQuickStartInputView: UIView,
                                   AgoraUIContentContainer {
    private let backgroundImageView = UIImageView(frame: .zero)
    private let segmentedControl = FcrAppUIQuickStartSegmentedControl(frame: .zero)
    
    let joinRoomView: FcrAppUIQuickStartJoinRoomInputView
    let createRoomView: FcrAppUIQuickStartCreateRoomInputView
    let policyView = FcrAppUIPolicyView(checkBoxNormalImage: "fcr_mobile_check0",
                                        checkBoxSelectedImage: "fcr_mobile_check1")
    
    init(userRoleList: [FcrAppUIUserRole],
         roomTypeList: [FcrAppUIRoomType],
         roomDuration: UInt) {
        self.joinRoomView = FcrAppUIQuickStartJoinRoomInputView(userRoleList: userRoleList,
                                                                leftTextWidth: 85,
                                                                leftTextOffsetX: 20,
                                                                rightViewOffsetX: 14)
        
        self.createRoomView = FcrAppUIQuickStartCreateRoomInputView(roomTypeList: roomTypeList,
                                                                    roomDuration: roomDuration,
                                                                    leftTextWidth: 85,
                                                                    leftTextOffsetX: 20,
                                                                    rightViewOffsetX: 14)
        super.init(frame: .zero)
        initViews()
        initViewFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func initViews() {
        addSubview(backgroundImageView)
        addSubview(segmentedControl)
        addSubview(joinRoomView)
        addSubview(createRoomView)
        addSubview(policyView)
        
        segmentedControl.onSegmented = { [weak self] segmented in
            self?.updateBackgroundTransform(with: segmented)
            self?.updateInputViewType(with: segmented)
        }
        
        createRoomView.isHidden = true
    }
    
    func initViewFrame() {
        backgroundImageView.mas_makeConstraints { make in
            make?.top.left().right().bottom().equalTo()(0)
        }
        
        segmentedControl.mas_makeConstraints { make in
            make?.top.equalTo()(self.backgroundImageView)?.offset()(12)
            make?.left.right().equalTo()(0)
            make?.height.equalTo()(46)
        }
        
        joinRoomView.mas_makeConstraints { make in
            make?.top.equalTo()(self.segmentedControl.mas_bottom)?.offset()(23)
            make?.right.left().equalTo()(0)
            make?.bottom.equalTo()(-85)
        }
        
        createRoomView.mas_makeConstraints { make in
            make?.top.equalTo()(self.segmentedControl.mas_bottom)?.offset()(23)
            make?.right.left().equalTo()(0)
            make?.bottom.equalTo()(-85)
        }
        
        policyView.mas_makeConstraints { make in
            make?.left.equalTo()(24)
            make?.right.equalTo()(-24)
            make?.bottom.equalTo()(0)
            make?.height.equalTo()(71)
        }
    }
    
    func updateViewProperties() {
        segmentedControl.updateViewProperties()
        joinRoomView.updateViewProperties()
        createRoomView.updateViewProperties()
        policyView.updateViewProperties()
        
        backgroundImageView.image = UIImage(named: "fcr-quick-input")
        
        updateBackgroundTransform(with: segmentedControl.segmented)
        updateInputViewType(with: segmentedControl.segmented)
    }
    
    private func updateBackgroundTransform(with segmented: FcrAppUIQuickStartSegmentOption) {
        switch segmented {
        case .join:
            backgroundImageView.transform = CGAffineTransform(scaleX: -1,
                                                              y: 1)
        case .create:
            backgroundImageView.transform = CGAffineTransform.identity
        }
    }
    
    private func updateInputViewType(with segmented: FcrAppUIQuickStartSegmentOption) {
        switch segmented {
        case .join:
            joinRoomView.isHidden = false
            createRoomView.isHidden = true
        case .create:
            joinRoomView.isHidden = true
            createRoomView.isHidden = false
        }
    }
}
