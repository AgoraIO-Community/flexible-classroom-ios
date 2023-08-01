//
//  FcrAppUICreateRoomViews.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/7/28.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUICreateRoomTopView: UIView, AgoraUIContentContainer {
    private let roomNameTextField = FcrAppUIRoomNameTextField(frame: .zero)
    private let userNameTextField = FcrAppUIRoomNameTextField(frame: .zero)
    
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewLayout())
    
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
        addSubview(roomNameTextField)
        addSubview(userNameTextField)
        addSubview(collectionView)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 122,
                                 height: 78)
        layout.minimumInteritemSpacing = 9
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 20,
                                           left: 16,
                                           bottom: 0,
                                           right: 16)
        
        collectionView.setCollectionViewLayout(layout,
                                               animated: false)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(cellWithClass: RoomTypeInfoCell.self)
    }
    
    func initViewFrame() {
        roomNameTextField.mas_makeConstraints { make in
            make?.top.equalTo()(self.mas_top)
            make?.left.equalTo()(self.mas_left)?.offset()(15)
            make?.right.equalTo()(self.mas_right)?.offset()(-15)
            make?.height.equalTo()(60)
        }
        
        userNameTextField.mas_makeConstraints { make in
            make?.top.equalTo()(self.roomNameTextField.mas_bottom)
            make?.left.equalTo()(self.mas_left)?.offset()(15)
            make?.right.equalTo()(self.mas_right)?.offset()(-15)
            make?.height.equalTo()(60)
        }
        
        collectionView.mas_makeConstraints { make in
            make?.top.equalTo()(self.userNameTextField.mas_bottom)
            make?.left.equalTo()(self.mas_left)
            make?.right.equalTo()(self.mas_right)
            make?.bottom.equalTo()(self.mas_bottom)
        }
    }
    
    func updateViewProperties() {
        backgroundColor = .white
        
        roomNameTextField.backgroundColor = .white
        userNameTextField.backgroundColor = .white
        
        if let imageView = roomNameTextField.leftView as? UIImageView {
            imageView.image = UIImage(named: "fcr_room_create_room_name")
        }
        
        if let imageView = userNameTextField.leftView as? UIImageView {
            imageView.image = UIImage(named: "fcr_room_create_user_name")
        }
        
        collectionView.backgroundColor = .clear
    }
}

class FcrAppUICreateRoomTimeView: UIButton, AgoraUIContentContainer {
    private let startTitleLabel = UILabel()
    private let endTitleLabel = UILabel()
    private let startTimeLabel = UILabel()
    private let arrowIcon = UIImageView()
    private let endTimeLabel = UILabel()
    private let endInfoLabel = UILabel()
    
    public var startDate: Date? {
        didSet {
            if let date = startDate {
                startTimeLabel.text = date.string(withFormat: "fcr_create_table_time_format".localized())
                let endDate = date.addingTimeInterval(30*60)
                endTimeLabel.text = endDate.string(withFormat: "HH:mm")
            } else {
                startTimeLabel.text = "fcr_create_current_time".localized()
                endTimeLabel.text = ""
            }
        }
    }
    
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
        addSubview(startTitleLabel)
        addSubview(endTitleLabel)
        addSubview(startTimeLabel)
        addSubview(arrowIcon)
        addSubview(endTimeLabel)
        addSubview(endInfoLabel)
        
        startTitleLabel.font = UIFont.systemFont(ofSize: 13)
        startTimeLabel.font = UIFont.boldSystemFont(ofSize: 14)
        endTitleLabel.font = UIFont.systemFont(ofSize: 13)
        endTimeLabel.font = UIFont.boldSystemFont(ofSize: 14)
        endInfoLabel.font = UIFont.systemFont(ofSize: 10)
    }
    
    func initViewFrame() {
        startTitleLabel.mas_makeConstraints { make in
            make?.top.equalTo()(self.mas_top)?.offset()(16)
            make?.left.equalTo()(21)
        }
        
        endTitleLabel.mas_makeConstraints { make in
            make?.centerY.equalTo()(startTitleLabel)
            make?.left.equalTo()(self.mas_centerX)
        }
        
        startTimeLabel.mas_makeConstraints { make in
            make?.left.equalTo()(startTitleLabel)
            make?.top.equalTo()(startTitleLabel.mas_bottom)?.offset()(12)
        }
        
        arrowIcon.mas_makeConstraints { make in
            make?.left.equalTo()(startTimeLabel.mas_right)?.offset()(5)
            make?.centerY.equalTo()(startTimeLabel)
        }
        
        endTimeLabel.mas_makeConstraints { make in
            make?.left.equalTo()(endTitleLabel)
            make?.centerY.equalTo()(startTimeLabel)
            make?.height.greaterThanOrEqualTo()(10)
        }
        
        endInfoLabel.mas_makeConstraints { make in
            make?.left.equalTo()(endTimeLabel.mas_right)?.offset()(8)
            make?.bottom.equalTo()(endTimeLabel)
        }
    }
    
    func updateViewProperties() {
        arrowIcon.image = UIImage(named: "fcr_room_create_time_arrow")
        
        startTimeLabel.text = "fcr_create_current_time".localized()
        startTitleLabel.text = "fcr_create_start_time".localized()
        startTitleLabel.textColor = UIColor(hex: 0x757575)
        
        endTitleLabel.text = "fcr_create_end_time".localized()
        endTitleLabel.textColor = UIColor(hex: 0x757575)
        
        startTimeLabel.textColor = UIColor.black
        
        endTimeLabel.text = "fcr_create_end_time".localized()
        endTimeLabel.textColor = UIColor(hex: 0x757575)
        
        endInfoLabel.text = "fcr_create_end_time_info".localized()
        endInfoLabel.textColor = UIColor(hex: 0x757575)
    }
}
