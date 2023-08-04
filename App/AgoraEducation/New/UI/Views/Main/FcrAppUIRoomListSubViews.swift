//
//  FcrAppUIRoomListSubViews.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/13.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUIRoomListPlaceholderView: UIView, AgoraUIContentContainer {
    private let imageView = UIImageView(frame: .zero)
    private let label = UILabel(frame: .zero)
    
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
        
        label.text = "fcr_room_list_empty".localized()
        label.font = UIFont.systemFont(ofSize: 12)
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
        updateViewProperties()
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
        label.font = UIFont.systemFont(ofSize: 16,
                                       weight: .medium)
        label.text = "fcr_room_list_rooms".localized()
    }
}

class FcrAppUIRoomListAddedNoticeView: UIView,
                                       AgoraUIContentContainer {
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        updateViewProperties()
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
        label.font = UIFont.boldSystemFont(ofSize: 12)
    }
    
    func initViewFrame() {
        guard let size = label.text?.agora_size(font: label.font) else {
            return
        }
        
        let width = size.width + 20
        
        label.mas_remakeConstraints { make in
            make?.center.equalTo()(0)
            make?.width.equalTo()(width)
            make?.top.equalTo()(0)
            make?.bottom.equalTo()(0)
        }
    }
    
    func updateViewProperties() {
        label.backgroundColor = UIColor(hex: 0x357BF6)
        
        label.text = "fcr_room_list_room_created".localized()
        label.textColor = .white
    }
}
