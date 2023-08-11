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
        
        // TODO: UI
        textLabel.layer.cornerRadius = 16
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
        
        textLabel.textColor = (isSelected ? FcrAppUIColorGroup.fcr_v2_white : FcrAppUIColorGroup.fcr_black)
        textLabel.backgroundColor = (isSelected ? FcrAppUIColorGroup.fcr_v2_brand6 : FcrAppUIColorGroup.fcr_v2_light_input_background)
    }
}

class FcrAppUIQuickStartRoomIdTextField: FcrAppUIRoomIdTextField {
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 20,
                      y: 0,
                      width: 78,
                      height: bounds.height)
    }
}

class FcrAppUIQuickStartUserNameTextField: FcrAppUIUserNameTextField {
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 20,
                      y: 0,
                      width: 78,
                      height: bounds.height)
    }
}

class FcrAppUIQuickStartJoinRoomInputView: UIView,
                                           AgoraUIContentContainer,
                                           UICollectionViewDataSource,
                                           UICollectionViewDelegate {
    let roomIdTextField = FcrAppUIQuickStartRoomIdTextField(leftViewType: .text)
    let userNameTextField = FcrAppUIQuickStartUserNameTextField(leftViewType: .text)
    let roleLabel = UILabel()
    let roleCollection = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewLayout())
    
    private let itemSize = CGSize(width: 114,
                                  height: 45)
    
    private let sectionInset = UIEdgeInsets(top: 12,
                                            left: 12,
                                            bottom: 12,
                                            right: 12)
    
    private let minimumInteritemSpacing: CGFloat = 8
    
    private let minimumLineSpacing: CGFloat = 14
    
    private let userRoleList: [FcrAppUIUserRole]
    
    let joinButton = UIButton(frame: .zero)
    
    private var selectedUserRole = FcrAppUIUserRole.student
    
    init(userRoleList: [FcrAppUIUserRole]) {
        self.userRoleList = userRoleList
        
        super.init(frame: .zero)
        initViews()
        initViewFrame()
        updateViewProperties()
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
        
        roomIdTextField.leftLabel.font = UIFont.systemFont(ofSize: 15)
        roomIdTextField.leftLabel.textAlignment = .left
        
        userNameTextField.leftLabel.font = UIFont.systemFont(ofSize: 15)
        userNameTextField.leftLabel.textAlignment = .left
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = minimumLineSpacing
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.itemSize = itemSize
        layout.sectionInset = sectionInset
        
        roleCollection.setCollectionViewLayout(layout,
                                               animated: false)
        roleCollection.dataSource = self
        roleCollection.delegate = self
        roleCollection.register(cellWithClass: FcrAppUIQuickStartUserRoleCell.self)
        
        joinButton.layer.cornerRadius = 23
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
        
        let collectionWidth = itemSize.width * 2 + minimumInteritemSpacing + sectionInset.right + sectionInset.left
        let collectionHeight = itemSize.height * 2 + minimumLineSpacing + sectionInset.top + sectionInset.bottom
        
        roleCollection.mas_makeConstraints { make in
            make?.top.equalTo()(self.userNameTextField.mas_bottom)?.offset()(8)
            make?.right.equalTo()(0)
            make?.width.equalTo()(collectionWidth)
            make?.height.equalTo()(collectionHeight)
        }
        
        roleLabel.mas_makeConstraints { make in
            make?.top.equalTo()(self.roleCollection.mas_top)?.offset()(sectionInset.top)
            make?.left.equalTo()(20)
            make?.right.equalTo()(self.roleCollection.mas_left)?.offset()(-10)
            make?.height.equalTo()(23)
        }
        
        joinButton.mas_makeConstraints { make in
            make?.top.equalTo()(self.roleCollection.mas_bottom)?.offset()(29)
            make?.left.equalTo()(25)
            make?.right.equalTo()(-25)
            make?.height.equalTo()(46)
        }
    }
    
    func updateViewProperties() {
        roomIdTextField.leftLabel.text = "fcr_login_free_label_room_id".localized()
        roomIdTextField.placeholder = "fcr_login_free_tips_room_id".localized()
        
        userNameTextField.leftLabel.text = "fcr_login_free_label_nick_name".localized()
        userNameTextField.placeholder = "fcr_login_free_tips_nick_name".localized()
        
        roleLabel.text = "fcr_login_free_label_role".localized()
        
        joinButton.backgroundColor = FcrAppUIColorGroup.fcr_v2_brand6
        
        joinButton.setTitle("fcr_login_free_button_join".localized(),
                            for: .normal)
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
