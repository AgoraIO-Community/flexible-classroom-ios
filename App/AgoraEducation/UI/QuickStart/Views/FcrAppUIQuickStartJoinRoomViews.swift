//
//  FcrAppUIQuickStartJoinRoomViews.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/8/10.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

fileprivate class FcrAppUIQuickStartUserRoleCell: UICollectionViewCell,
                                                  AgoraUIContentContainer {
    private let selectedImageView = UIImageView(frame: .zero)
    let textLabel = UILabel(frame: .zero)
    
    var isRoleSelected: Bool = false {
        didSet {
            update(isRoleSelected)
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
        contentView.addSubview(textLabel)
        contentView.addSubview(selectedImageView)
        
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 15)
        
        textLabel.layer.cornerRadius = 10
        textLabel.layer.masksToBounds = true
    }
    
    func initViewFrame() {
        let selectedImageViewWidth: CGFloat = 24
        let selectedImageViewHeight: CGFloat = selectedImageViewWidth
        let offset: CGFloat = selectedImageViewWidth * 0.5 - 6
        
        selectedImageView.mas_makeConstraints { make in
            make?.right.equalTo()(offset)
            make?.top.equalTo()(-offset)
            make?.width.equalTo()(selectedImageViewWidth)
            make?.width.equalTo()(selectedImageViewHeight)
        }
        
        textLabel.mas_makeConstraints { make in
            make?.left.right().top().bottom().equalTo()(0)
        }
    }
    
    func updateViewProperties() {
        selectedImageView.image = UIImage(named: "fcr_mobile_check2")
        
        update(isRoleSelected)
    }
    
    func update(_ isSelected: Bool) {
        selectedImageView.isHidden = !isSelected
        
        textLabel.textColor = (isSelected ? FcrAppUIColorGroup.fcr_white : FcrAppUIColorGroup.fcr_black)
        textLabel.backgroundColor = (isSelected ? FcrAppUIColorGroup.fcr_v2_brand5 : FcrAppUIColorGroup.fcr_v2_light_input_background)
        textLabel.layer.borderColor = (isSelected ? FcrAppUIColorGroup.fcr_v2_brand6.cgColor : FcrAppUIColorGroup.fcr_v2_light_input_background.cgColor)
        textLabel.layer.borderWidth = 2
    }
}

class FcrAppUIQuickStartJoinRoomInputView: UIView,
                                           AgoraUIContentContainer,
                                           UICollectionViewDataSource,
                                           UICollectionViewDelegate {
    // View
    private let roleLabel = UILabel()
    private let roleCollection = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewLayout())
    
    let roomIdTextField: FcrAppUIRoomIdTextField
    
    let userNameTextField: FcrAppUIUserNameTextField
    
    let joinButton = UIButton(frame: .zero)
    
    private var itemSize = CGSize(width: 114,
                                  height: 45)
    
    private let sectionInset: UIEdgeInsets
    
    private let minimumInteritemSpacing: CGFloat = 8
    
    private let minimumLineSpacing: CGFloat = 14
    
    private let leftTextWidth: CGFloat
    private let leftTextOffsetX: CGFloat
    private let rightViewOffsetX: CGFloat
    
    // Data
    private let userRoleList: [FcrAppUIUserRole]
    
    private(set) var selectedUserRole = FcrAppUIUserRole.student
    
    init(userRoleList: [FcrAppUIUserRole],
         leftTextWidth: CGFloat,
         leftTextOffsetX: CGFloat,
         rightViewOffsetX: CGFloat) {
        self.userRoleList = userRoleList
        
        self.roomIdTextField = FcrAppUIRoomIdTextField(leftViewType: .text,
                                                       leftTextWidth: leftTextWidth,
                                                       leftAreaOffsetX: leftTextOffsetX,
                                                       editAreaOffsetX: rightViewOffsetX)
        
        self.userNameTextField = FcrAppUIUserNameTextField(leftViewType: .text,
                                                           leftTextWidth: leftTextWidth,
                                                           leftAreaOffsetX: leftTextOffsetX,
                                                           editAreaOffsetX: rightViewOffsetX)
        
        self.sectionInset = UIEdgeInsets(top: 12,
                                         left: 0,
                                         bottom: 12,
                                         right: 12)
        
        self.leftTextWidth = leftTextWidth
        self.leftTextOffsetX = leftTextOffsetX
        self.rightViewOffsetX = rightViewOffsetX
        
        super.init(frame: .zero)
        initViews()
        initViewFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(roomIdTextField)
        addSubview(userNameTextField)
        addSubview(roleLabel)
        addSubview(roleCollection)
        addSubview(joinButton)
        
        roomIdTextField.leftLabel.font = FcrAppUIFontGroup.font15
        roomIdTextField.leftLabel.textAlignment = .left
        
        userNameTextField.leftLabel.font = FcrAppUIFontGroup.font15
        userNameTextField.leftLabel.textAlignment = .left
        
        roleCollection.dataSource = self
        roleCollection.delegate = self
        roleCollection.register(cellWithClass: FcrAppUIQuickStartUserRoleCell.self)
        
        joinButton.layer.cornerRadius = 23
        joinButton.titleLabel?.font = FcrAppUIFontGroup.font15
    }
    
    func initViewFrame() {
        roomIdTextField.mas_makeConstraints { make in
            make?.top.equalTo()(0)
            make?.left.right().equalTo()(0)
            make?.height.equalTo()(54)
        }
        
        userNameTextField.mas_makeConstraints { make in
            make?.top.equalTo()(self.roomIdTextField.mas_bottom)
            make?.left.right().equalTo()(0)
            make?.height.equalTo()(54)
        }
        
        roleLabel.mas_makeConstraints { make in
            make?.top.equalTo()(self.userNameTextField.mas_bottom)?.offset()(22)
            make?.left.equalTo()(self.leftTextOffsetX)
            make?.width.equalTo()(self.leftTextWidth)
            make?.height.equalTo()(23)
        }
        
        joinButton.mas_makeConstraints { make in
            make?.left.equalTo()(25)
            make?.right.equalTo()(-25)
            make?.height.equalTo()(46)
            make?.bottom.equalTo()(0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionViewFrame()
    }
    
    func updateViewProperties() {
        roomIdTextField.updateViewProperties()
        userNameTextField.updateViewProperties()
        
        roomIdTextField.leftLabel.text = "fcr_login_free_label_room_id".localized()
        roomIdTextField.placeholder = "fcr_login_free_tips_room_id".localized()
        
        userNameTextField.leftLabel.text = "fcr_login_free_label_nick_name".localized()
        userNameTextField.placeholder = "fcr_login_free_tips_nick_name".localized()
        
        roleLabel.text = "fcr_login_free_label_role".localized()
        
        joinButton.backgroundColor = FcrAppUIColorGroup.fcr_v2_brand6
        
        joinButton.setTitle("fcr_login_free_button_join".localized(),
                            for: .normal)
        
        joinButton.setTitleColor(FcrAppUIColorGroup.fcr_white,
                                 for: .normal)
        
        roleCollection.backgroundColor = .white
        
        roleCollection.reloadData()
    }
    
    func updateCollectionViewFrame() {
        let collectionWidth: CGFloat = (bounds.width - roleLabel.frame.maxX - rightViewOffsetX)
        let collectionHeight = itemSize.height * 2 + minimumLineSpacing + sectionInset.top + sectionInset.bottom
        
        let x: CGFloat = roleLabel.frame.maxX + rightViewOffsetX
        let y: CGFloat = userNameTextField.frame.maxY + 10
        
        let itemWidth = (collectionWidth - minimumInteritemSpacing - sectionInset.right - sectionInset.left) * 0.5
        let itemHeight = itemSize.height
         
        itemSize = CGSize(width: itemWidth,
                          height: itemHeight)
        
        roleCollection.frame = CGRect(x: x,
                                      y: y,
                                      width: collectionWidth,
                                      height: collectionHeight)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = minimumLineSpacing
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.itemSize = itemSize
        layout.sectionInset = sectionInset
        
        roleCollection.setCollectionViewLayout(layout,
                                               animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return userRoleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: FcrAppUIQuickStartUserRoleCell.self,
                                                      for: indexPath)
        let userRole = userRoleList[indexPath.item]
        cell.textLabel.text = userRole.text()
        cell.isRoleSelected = (userRole == selectedUserRole)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        UIApplication.shared.keyWindow?.endEditing(true)
        
        let userRole = userRoleList[indexPath.item]
        selectedUserRole = userRole
        
        collectionView.reloadData()
    }
}

fileprivate extension FcrAppUIUserRole {
    func text() -> String {
        switch self {
        case .teacher:  return "fcr_login_free_role_option_teacher".localized()
        case .student:  return "fcr_login_free_role_option_student".localized()
        case .audience: return "fcr_login_free_role_option_audience".localized()
        }
    }
}
