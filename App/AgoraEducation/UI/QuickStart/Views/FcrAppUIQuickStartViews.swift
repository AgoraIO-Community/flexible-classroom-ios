//
//  FcrAppUIQuickStartViews.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/8/10.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

// MARK: - Header view
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
        
        signButton.setTitle("fcr_login_free_button_login_sign".localized(),
                            for: .normal)
        
        signButton.layer.borderColor = FcrAppUIColorGroup.fcr_v2_white.cgColor
        
        settingButton.setImage(UIImage(named: "fcr-quick-setting"),
                               for: .normal)
        // TODO: UI
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
        updateViewProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(joinButton)
        addSubview(createButton)
        addSubview(lineView)
        
        joinButton.isSelected = true
        createButton.isSelected = false
        
        joinButton.addTarget(self,
                             action: #selector(onSelected(_:)),
                             for: .touchUpInside)
        
        createButton.addTarget(self,
                               action: #selector(onSelected(_:)),
                               for: .touchUpInside)
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
            make?.height.equalTo()(2)
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
        
        joinButton.titleLabel?.font = UIFont.systemFont(ofSize: 16,
                                                        weight: .medium)
        
        createButton.setTitleColor(FcrAppUIColorGroup.fcr_black,
                                   for: .normal)
        
        createButton.setTitleColor(FcrAppUIColorGroup.fcr_v2_brand6,
                                   for: .selected)
        
        createButton.setTitle("fcr_login_free_option_create".localized(),
                              for: .normal)
        
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16,
                                                          weight: .medium)
        
        lineView.backgroundColor = FcrAppUIColorGroup.fcr_v2_brand6
    }
    
    @objc private func onSelected(_ sender: UIButton) {
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

class FcrAppUIQuickStartPolicyView: UIView,
                                    AgoraUIContentContainer {
    let checkBox = UIButton(frame: .zero)
    let textView = UITextView(frame: .zero,
                              textContainer: nil)
    
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
        addSubview(checkBox)
        addSubview(textView)
        
        checkBox.addTarget(self,
                           action: #selector(onCheckBoxPressed(_ :)),
                           for: .touchUpInside)
        
        textView.isEditable = false
        textView.isSelectable = true
        textView.dataDetectorTypes = .all
        textView.textContainerInset = UIEdgeInsets(top: 2,
                                                   left: 0,
                                                   bottom: 0,
                                                   right: 0)
    }
    
    func initViewFrame() {
        checkBox.mas_makeConstraints { make in
            make?.left.top().equalTo()(0)
            make?.width.height().equalTo()(16)
        }
        
        textView.mas_makeConstraints { make in
            make?.left.equalTo()(self.checkBox.mas_right)?.offset()(5)
            make?.right.top().bottom().equalTo()(0)
        }
    }
    
    func updateViewProperties() {
        updateCheckBox(checkBox.isSelected)
    }
    
    @objc private func onCheckBoxPressed(_ sender: UIButton) {
        sender.isSelected.toggle()
        updateCheckBox(sender.isSelected)
    }
    
    private func updateCheckBox(_ isSelected: Bool) {
        if isSelected {
            checkBox.setImage(UIImage(named: "fcr_mobile_check1"),
                              for: .normal)
        } else {
            checkBox.setImage(UIImage(named: "fcr_mobile_check0"),
                              for: .normal)
        }
    }
}

class FcrAppUIQuickStartInputView: UIView,
                                   AgoraUIContentContainer {
    private let backgroundImageView = UIImageView(frame: .zero)
    private let segmentedControl = FcrAppUIQuickStartSegmentedControl(frame: .zero)
    
    let joinRoomView: FcrAppUIQuickStartJoinRoomInputView
    let createRoomView: FcrAppUIQuickStartCreateRoomInputView
    let policyView = FcrAppUIQuickStartPolicyView()
    
    init(userRoleList: [FcrAppUIUserRole],
         roomTypeList: [FcrAppUIRoomType]) {
        self.joinRoomView = FcrAppUIQuickStartJoinRoomInputView(userRoleList: userRoleList,
                                                                leftTextWidth: 85,
                                                                leftTextOffX: 20,
                                                                rightViewOffsetX: 14)
        
        self.createRoomView = FcrAppUIQuickStartCreateRoomInputView(roomTypeList: roomTypeList,
                                                                    leftTextWidth: 85,
                                                                    leftTextOffX: 20,
                                                                    rightViewOffsetX: 14)
        super.init(frame: .zero)
        initViews()
        initViewFrame()
        updateViewProperties()
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
        backgroundImageView.image = UIImage(named: "fcr-quick-input")
        
        backgroundImageView.transform = CGAffineTransform(scaleX: -1,
                                                          y: 1)
    }
    
    private func updateBackgroundTransform(with segmented: FcrAppUIQuickStartSegmentOption) {
        switch segmented {
        case .join:
            backgroundImageView.transform = CGAffineTransform(scaleX: -1,
                                                              y: 1)
        case .create:
            backgroundImageView.transform = CGAffineTransformIdentity
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

// MARK: - Footer
class FcrAppUIQuickStartFooterView: UIView,
                                    AgoraUIContentContainer {
    private let titleLabel = UILabel(frame: .zero)
    private let contentLabel = UILabel(frame: .zero)
    let signButton = UIButton(frame: .zero)
    
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
        addSubview(contentLabel)
        addSubview(signButton)
        
        // TODO: UI 字体粗细
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.font = UIFont.systemFont(ofSize: 13)
        contentLabel.numberOfLines = 0
        
        signButton.layer.borderColor = FcrAppUIColorGroup.fcr_v2_white.cgColor
        signButton.layer.borderWidth = 1
        signButton.layer.cornerRadius = 15
    }
    
    func initViewFrame() {
        titleLabel.mas_makeConstraints { make in
            make?.top.equalTo()(60)
            make?.left.equalTo()(25)
            make?.right.equalTo()(-25)
            make?.height.equalTo()(14)
        }
        
        contentLabel.mas_makeConstraints { make in
            make?.top.equalTo()(self.titleLabel.mas_bottom)?.offset()(10)
            make?.left.equalTo()(25)
            make?.right.equalTo()(-25)
            make?.height.equalTo()(80)
        }
        
        signButton.mas_makeConstraints { make in
            make?.top.equalTo()(self.contentLabel.mas_bottom)?.offset()(20)
            make?.left.equalTo()(25)
            make?.width.equalTo()(87)
            make?.height.equalTo()(30)
        }
    }
    
    func updateViewProperties() {
        titleLabel.textColor = FcrAppUIColorGroup.fcr_v2_green
        titleLabel.text = "fcr_login_free_tips_login_guide_title".localized()
        
        contentLabel.text = "fcr_login_free_tips_login_guide".localized()
        
        // TODO: UI 变量名是啥？
//        contentLabel.textColor = FcrAppUIColorGroup.
        
        // TODO: UI
        signButton.setTitle("fcr_login_free_button_login_sign".localized(),
                            for: .normal)
        
        signButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
}

class FcrAppUIQuickStartContentView: UIView,
                                     AgoraUIContentContainer {
    let headerView = FcrAppUIQuickStartHeaderView(frame: .zero)
    let roomInputView: FcrAppUIQuickStartInputView
    let footerView = FcrAppUIQuickStartFooterView(frame: .zero)
    
    init(userRoleList: [FcrAppUIUserRole],
         roomTypeList: [FcrAppUIRoomType]) {
        self.roomInputView = FcrAppUIQuickStartInputView(userRoleList: userRoleList,
                                                         roomTypeList: roomTypeList)
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
        addSubview(footerView)
        addSubview(roomInputView)
        
        footerView.layer.cornerRadius = FcrAppUIFrameGroup.quickCornerRadius16
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
        
        footerView.mas_makeConstraints { make in
            make?.top.equalTo()(self.roomInputView.mas_bottom)?.offset()(-50)
            make?.left.equalTo()(15)
            make?.right.equalTo()(-15)
            make?.height.equalTo()(234)
        }
    }
    
    func updateViewProperties() {
        footerView.backgroundColor = UIColor.fcr_hex_string("#EBF6FA")
    }
}
