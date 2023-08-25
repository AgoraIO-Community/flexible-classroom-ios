//
//  FcrAppUIRoomListSubViews.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/13.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUIRoomListPlaceholderView: UIView,
                                       AgoraUIContentContainer {
    private let imageView = UIImageView(frame: .zero)
    private let label = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        initViewFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(imageView)
        addSubview(label)
    }
    
    func initViewFrame() {
        imageView.mas_makeConstraints { make in
            make?.top.equalTo()(80)
            make?.left.right().equalTo()(0)
            make?.bottom.equalTo()(-186)
        }
        
        label.mas_makeConstraints { make in
            make?.top.equalTo()(imageView.mas_bottom)
            make?.left.right().equalTo()(0)
            make?.height.equalTo()(16)
        }
    }
    
    func updateViewProperties() {
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "fcr_room_list_empty")
        
        label.text = "fcr_home_label_room_list_empty".localized()
        label.font = FcrAppUIFontGroup.font12
        label.textColor = UIColor(hex: 0xACABB0)
        label.textAlignment = .center
    }
}

class FcrAppUIRoomListCornerRadiusView: UIView {
    let radius: CGFloat = 24
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = radius
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FcrAppUIRoomListTitleView: UIView,
                                 AgoraUIContentContainer {
    private let label = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        initViewFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(label)
    }
    
    func initViewFrame() {
        label.mas_makeConstraints { make in
            make?.left.equalTo()(0)
            make?.right.equalTo()(0)
            make?.height.equalTo()(24)
            make?.bottom.equalTo()(0)
        }
    }
    
    func updateViewProperties() {
        label.font = FcrAppUIFontGroup.font16
        label.text = "fcr_home_label_roomlist".localized()
    }
}

class FcrAppUIRoomListAddedNoticeView: UIView,
                                       AgoraUIContentContainer {
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        initViewFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(label)
        
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        
        label.textAlignment = .center
        label.font = FcrAppUIFontGroup.font12
    }
    
    func initViewFrame() {
        
    }
    
    func updateViewProperties() {
        label.backgroundColor = FcrAppUIColorGroup.fcr_v2_brand6
        
        label.text = "fcr_home_tips_room_created".localized()
        label.textColor = FcrAppUIColorGroup.fcr_white
        
        label.mas_remakeConstraints { make in
            make?.center.equalTo()(0)
            make?.width.equalTo()(label.intrinsicContentSize.width + 20)
            make?.top.equalTo()(0)
            make?.bottom.equalTo()(0)
        }
    }
}
