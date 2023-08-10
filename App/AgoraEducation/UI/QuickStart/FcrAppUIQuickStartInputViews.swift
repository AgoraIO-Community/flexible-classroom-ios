//
//  FcrAppUIQuickStartInputViews.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/8/10.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

fileprivate class FcrAppUIQuickStartSegment: UIButton,
                                             AgoraUIContentContainer {
    private let joinButton = UIButton(frame: .zero)
    private let createButton = UIButton(frame: .zero)
    
    private let lineView = UIView(frame: .zero)
    
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
        
        joinButton.backgroundColor = .green
        createButton.backgroundColor = .red
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
            make?.height.equalTo()(1)
            make?.centerX.equalTo()(self.joinButton.mas_centerX)
        }
    }
    
    func updateViewProperties() {
        joinButton.setTitleColor(FcrAppUIColorGroup.fcr_v2_brand6,
                                 for: .selected)
        
        createButton.setTitleColor(FcrAppUIColorGroup.fcr_v2_brand6,
                                   for: .selected)
        
        joinButton.setTitleColor(FcrAppUIColorGroup.fcr_black,
                                 for: .normal)
        
        createButton.setTitleColor(FcrAppUIColorGroup.fcr_black,
                                   for: .normal)
        
        lineView.backgroundColor = FcrAppUIColorGroup.fcr_v2_brand6
    }
    
    @objc private func onSelected(_ sender: UIButton) {
        joinButton.isSelected.toggle()
        createButton.isSelected.toggle()
        
        if joinButton.isSelected {
            lineView.mas_remakeConstraints { make in
                make?.bottom.equalTo()(0)
                make?.width.equalTo()(self.mas_width)?.multipliedBy()(0.5)?.offset()(-40)
                make?.height.equalTo()(1)
                make?.centerX.equalTo()(self.joinButton.mas_centerX)
            }
        } else {
            lineView.mas_remakeConstraints { make in
                make?.bottom.equalTo()(0)
                make?.width.equalTo()(self.mas_width)?.multipliedBy()(0.5)?.offset()(-40)
                make?.height.equalTo()(1)
                make?.centerX.equalTo()(self.createButton.mas_centerX)
            }
        }
        
        UIView.animate(withDuration: TimeInterval.agora_animation) {
            self.layoutIfNeeded()
        }
    }
}

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
        textLabel.layer.cornerRadius = 16
        textLabel.layer.masksToBounds = true
    }
    
    func initViewFrame() {
        let selectedImageViewWidth: CGFloat = 24
        let selectedImageViewHeight: CGFloat = selectedImageViewWidth
        let offset: CGFloat = selectedImageViewWidth * 0.5 - 4
        
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

class FcrAppUIQuickStartJoinRoomInputView: UIView,
                                           AgoraUIContentContainer,
                                           UICollectionViewDataSource {
    let roomIdTextField = FcrAppUIRoomIdTextField(leftViewType: .text)
    let roomNameTextField = FcrAppUIRoomNameTextField(leftViewType: .text)
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
    
    private let roleList: [FcrAppUIUserRole]
    
    private let joinButton = UIButton(frame: .zero)
    
    private var selectedUserRole = FcrAppUIUserRole.student
    
    init(roleList: [FcrAppUIUserRole]) {
        self.roleList = roleList
        
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
        addSubview(roomNameTextField)
        addSubview(roleLabel)
        addSubview(roleCollection)
        addSubview(joinButton)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = minimumLineSpacing
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.itemSize = itemSize
        layout.sectionInset = sectionInset
        
        roleCollection.setCollectionViewLayout(layout,
                                               animated: false)
        roleCollection.backgroundColor = .red
        roleCollection.dataSource = self
        roleCollection.register(cellWithClass: FcrAppUIQuickStartUserRoleCell.self)
        
        joinButton.layer.cornerRadius = 23
        
        roleLabel.backgroundColor = .blue
        joinButton.backgroundColor = .blue
    }
    
    func initViewFrame() {
        roomIdTextField.mas_makeConstraints { make in
            make?.top.equalTo()(0)
            make?.left.right().equalTo()(0)
            make?.height.equalTo()(54)
        }
        
        roomNameTextField.mas_makeConstraints { make in
            make?.top.equalTo()(self.roomIdTextField.mas_bottom)
            make?.left.right().equalTo()(0)
            make?.height.equalTo()(54)
        }
        
        let collectionWidth = itemSize.width * 2 + minimumInteritemSpacing + sectionInset.right + sectionInset.left
        let collectionHeight = itemSize.height * 2 + minimumLineSpacing + sectionInset.top + sectionInset.bottom
        
        roleCollection.mas_makeConstraints { make in
            make?.top.equalTo()(self.roomNameTextField.mas_bottom)?.offset()(22)
            make?.right.equalTo()(12)
            make?.width.equalTo()(collectionWidth)
            make?.height.equalTo()(collectionHeight)
        }
        
        roleLabel.mas_makeConstraints { make in
            make?.top.equalTo()(self.roleCollection.mas_top)
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
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return roleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: FcrAppUIQuickStartUserRoleCell.self,
                                                      for: indexPath)
        let userRole = roleList[indexPath.item]
        cell.textLabel.text = "\(userRole.rawValue)"
        cell.isRoleSelected = (userRole == selectedUserRole)
        
        return cell
    }
}

class FcrAppUIQuickStartInputView: UIView,
                                   AgoraUIContentContainer {
    private let backgroundImageView = UIImageView(frame: .zero)
    private let operationView = FcrAppUIQuickStartSegment(frame: .zero)
    
    let joinRoomView: FcrAppUIQuickStartJoinRoomInputView
    
    init(roleList: [FcrAppUIUserRole]) {
        self.joinRoomView = FcrAppUIQuickStartJoinRoomInputView(roleList: roleList)
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
        addSubview(operationView)
        addSubview(joinRoomView)
    }
    
    func initViewFrame() {
        backgroundImageView.mas_makeConstraints { make in
            make?.top.left().right().bottom().equalTo()(0)
        }
        
        operationView.mas_makeConstraints { make in
            make?.top.equalTo()(self.backgroundImageView)?.offset()(12)
            make?.left.right().equalTo()(0)
            make?.height.equalTo()(46)
        }
        
        joinRoomView.mas_makeConstraints { make in
            make?.top.equalTo()(self.operationView.mas_bottom)?.offset()(23)
            make?.right.left().equalTo()(0)
            make?.height.equalTo()(207 + 46 + 54)
        }
    }
    
    func updateViewProperties() {
        backgroundImageView.image = UIImage(named: "fcr-quick-input")
        
        backgroundImageView.transform = CGAffineTransform(scaleX: -1,
                                                          y: 1)
    }
}
