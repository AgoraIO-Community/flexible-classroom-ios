//
//  FcrAppUIRoomListSubViews.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/13.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUIRoomListPlaceholderCell: UITableViewCell,
                                       AgoraUIContentContainer {
    private let backgroudImageView = UIImageView(frame: .zero)
    private let descriptionLabel = UILabel(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        initViews()
        initViewFrame()
        updateViewProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let yRatio: CGFloat = 0.30
        
        let imageRatio: CGFloat = 256 / 188
        
        let imageWidth: CGFloat = bounds.width * (256 / 375)
        let imageHeight: CGFloat = imageWidth / imageRatio
        
        let imageX: CGFloat = (bounds.width - imageWidth) * 0.5
        let imageY: CGFloat = (bounds.height * yRatio) - (imageHeight * 0.5)
        
        backgroudImageView.frame = CGRect(x: imageX,
                                          y: imageY,
                                          width: imageWidth,
                                          height: imageHeight)
        
        let labelX: CGFloat = 0
        let lableY: CGFloat = backgroudImageView.frame.maxY + 10
        let labelWidth: CGFloat = bounds.width
        let labelHeight: CGFloat = 16
        
        descriptionLabel.frame = CGRect(x: labelX,
                                        y: lableY,
                                        width: labelWidth,
                                        height: labelHeight)
    }
    
    func initViews() {
        contentView.addSubview(backgroudImageView)
        contentView.addSubview(descriptionLabel)
    }
    
    func initViewFrame() {
        
    }
    
    func updateViewProperties() {
        contentView.backgroundColor = FcrAppUIColorGroup.fcr_white
        contentView.backgroundColor = .yellow
        
        backgroudImageView.contentMode = .scaleAspectFit
        backgroudImageView.image = UIImage(named: "fcr_room_list_empty")
        
        descriptionLabel.text = "fcr_home_label_room_list_empty".localized()
        descriptionLabel.font = FcrAppUIFontGroup.font12
        descriptionLabel.textColor = UIColor(hex: 0xACABB0)
        descriptionLabel.textAlignment = .center
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
