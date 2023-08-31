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
    let titleLabel: UIButton = FcrAppUIQuickStartTitleButton(frame: .zero)
    
    let testTag = UILabel()
    let settingButton = UIButton(frame: .zero)
    let signButton = UIButton(frame: .zero)
    
    private var isTopConstraintsUpdated = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        initViewFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(backgroundImageView)
        addSubview(signButton)
        addSubview(settingButton)
        addSubview(titleLabel)
        addSubview(testTag)
        
        titleLabel.titleLabel?.font = FcrAppUIFontGroup.font20
        titleLabel.titleLabel?.textAlignment = .left
        
        signButton.titleLabel?.font = FcrAppUIFontGroup.font14
        signButton.layer.cornerRadius = 15
        signButton.layer.borderWidth = 1
        
        settingButton.layer.cornerRadius = 16
        
        testTag.font = FcrAppUIFontGroup.font20
        testTag.textAlignment = .right
        testTag.isHidden = true
    }
    
    func initViewFrame() {
        backgroundImageView.mas_makeConstraints { make in
            make?.left.right().top().bottom().equalTo()(0)
        }
        
        titleLabel.mas_makeConstraints { make in
            make?.top.equalTo()(0)
            make?.left.equalTo()(22)
            make?.right.equalTo()(-100)
            make?.height.equalTo()(26)
        }
        
        settingButton.mas_makeConstraints { make in
            make?.centerY.equalTo()(self.titleLabel.mas_centerY)
            make?.right.equalTo()(-17)
            make?.width.height().equalTo()(32)
        }
        
        testTag.mas_makeConstraints { make in
            make?.centerY.equalTo()(self.titleLabel.mas_centerY)
            make?.right.equalTo()(self.settingButton.mas_left)?.offset()(-10)
            make?.width.equalTo()(100)
        }
    }
    
    func updateViewProperties() {
        backgroundImageView.image = UIImage(named: "fcr-quick-bg")
        
        // Title label
        titleLabel.setTitleColor(FcrAppUIColorGroup.fcr_white,
                                 for: .normal)
        
        titleLabel.setTitleColor(FcrAppUIColorGroup.fcr_white,
                                 for: .selected)
        
        titleLabel.setTitle("fcr_feedback_label_fcr".localized(),
                            for: .selected)
        
        titleLabel.setTitle("fcr_feedback_label_fcr".localized(),
                            for: .normal)
        
        // Setting button
        settingButton.setImage(UIImage(named: "fcr-quick-setting"),
                               for: .normal)
        
        settingButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        // Test tag
        testTag.textColor = .white
        testTag.text = "Tester"
        
        // Sign button
        signButton.setTitle("fcr_login_free_button_login_sign".localized(),
                            for: .normal)
        
        signButton.setTitleColor(FcrAppUIColorGroup.fcr_white,
                                 for: .normal)
        
        signButton.layer.borderColor = FcrAppUIColorGroup.fcr_white.cgColor
        
        signButton.mas_makeConstraints { make in
            make?.top.equalTo()(self.titleLabel.mas_bottom)?.offset()(22)
            make?.left.equalTo()(18)
            make?.width.equalTo()(signButton.intrinsicContentSize.width + 40)
            make?.height.equalTo()(30)
        }
    }
    
    func updateTopConstraints(topSafeArea: CGFloat) {
        guard !isTopConstraintsUpdated else {
            return
        }
        
        isTopConstraintsUpdated = true
        
        titleLabel.mas_updateConstraints { make in
            let space: CGFloat = (UIDevice.current.isSmallPhone ? 35 : 11)
            let top: CGFloat = (topSafeArea + space)
            make?.top.equalTo()(top)
        }
    }
}

// MARK: - Footer
class FcrAppUIQuickStartFooterView: UIView,
                                    AgoraUIContentContainer {
    private let titleLabel = UILabel(frame: .zero)
    private let contentLabel = FcrAppUITextView(frame: .zero)
    let signButton = UIButton(frame: .zero)
    
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
        addSubview(contentLabel)
        addSubview(signButton)
        
        titleLabel.font = FcrAppUIFontGroup.font14
        contentLabel.font = FcrAppUIFontGroup.font13
        
        contentLabel.isSelectable = false
        contentLabel.textContainerInset = UIEdgeInsets(top: 2,
                                                       left: -4,
                                                       bottom: 0,
                                                       right: 4)
        
        signButton.layer.borderColor = FcrAppUIColorGroup.fcr_white.cgColor
        signButton.layer.borderWidth = 1
        signButton.layer.cornerRadius = 15
        
        signButton.titleLabel?.font = FcrAppUIFontGroup.font15
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
    }
    
    func updateViewProperties() {
        titleLabel.textColor = FcrAppUIColorGroup.fcr_v2_green
        titleLabel.text = "fcr_login_free_tips_login_guide_title".localized()
        
        contentLabel.text = "fcr_login_free_tips_login_guide".localized()
        contentLabel.textColor = FcrAppUIColorGroup.fcr_v2_light_text2
        contentLabel.backgroundColor = .clear
        
        signButton.setTitle("fcr_login_free_button_login_sign".localized(),
                            for: .normal)
        
        signButton.setTitleColor(FcrAppUIColorGroup.fcr_black,
                                 for: .normal)
        
        signButton.backgroundColor = FcrAppUIColorGroup.fcr_white
        
        signButton.mas_makeConstraints { make in
            make?.top.equalTo()(self.contentLabel.mas_bottom)?.offset()(20)
            make?.left.equalTo()(25)
            make?.width.equalTo()(signButton.intrinsicContentSize.width + 40)
            make?.height.equalTo()(30)
        }
    }
}

class FcrAppUIQuickStartContentView: UIScrollView,
                                     AgoraUIContentContainer {
    private let content = UIView()
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        bounces = false
        contentInsetAdjustmentBehavior = .never
        showsVerticalScrollIndicator = false
        addSubview(content)
        
        content.addSubview(headerView)
        content.addSubview(footerView)
        content.addSubview(roomInputView)

        footerView.layer.cornerRadius = FcrAppUIFrameGroup.cornerRadius16
    }
    
    func initViewFrame() {
        content.mas_makeConstraints { make in
            make?.edges.equalTo()(self)
            make?.width.equalTo()(self)
            make?.height.equalTo()(870)
        }
        
        contentSize = CGSize(width: 0,
                             height: 870)
        
        headerView.mas_makeConstraints { make in
            make?.left.right().top().equalTo()(content)
            make?.height.equalTo()(263)
        }

        roomInputView.mas_makeConstraints { make in
            make?.top.equalTo()(self.headerView.mas_bottom)?.offset()(-107)
            make?.left.equalTo()(15)
            make?.right.equalTo()(-15)
            make?.height.equalTo()(479)
        }

        footerView.mas_makeConstraints { make in
            make?.top.equalTo()(self.roomInputView.mas_bottom)?.offset()(-35)
            make?.left.equalTo()(15)
            make?.right.equalTo()(-15)
            make?.height.equalTo()(234)
        }
    }
    
    func updateViewProperties() {
        headerView.updateViewProperties()
        roomInputView.updateViewProperties()
        footerView.updateViewProperties()
        
        content.backgroundColor = UIColor.fcr_hex_string("#F8FAFF")
        footerView.backgroundColor = UIColor.fcr_hex_string("#EBF6FA")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        super.touchesBegan(touches,
                           with: event)
        endEditing(true)
    }
}
