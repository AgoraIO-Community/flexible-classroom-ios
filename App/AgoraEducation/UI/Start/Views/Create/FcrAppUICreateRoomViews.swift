//
//  FcrAppUICreateRoomViews.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/7/28.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

// MARK: - Header
class FcrAppUICreateRoomHeaderView: UIView, AgoraUIContentContainer {
    // View
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewLayout())
    
    private let imageSize = CGSize(width: 36,
                                   height: 36)
    
    private(set) lazy var roomNameTextField = FcrAppUIRoomNameTextField(leftViewType: .image,
                                                                        leftImageSize: imageSize)
    
    private(set) lazy var userNameTextField = FcrAppUIRoomNameTextField(leftViewType: .image,
                                                                        leftImageSize: imageSize)
    
    // Data
    private(set) var selectedRoomType: FcrAppUIRoomType
    
    private let roomTypeList: [FcrAppUIRoomType]
    
    init(roomTypeList: [FcrAppUIRoomType]) {
        self.roomTypeList = roomTypeList
        self.selectedRoomType = roomTypeList[0]
        super.init(frame: .zero)
        initViews()
        initViewFrame()
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
        collectionView.register(cellWithClass: FcrAppUICreateRoomTypeCell.self)
        
        collectionView.delegate = self
        collectionView.dataSource = self
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
        roomNameTextField.updateViewProperties()
        userNameTextField.updateViewProperties()
        
        roomNameTextField.backgroundColor = FcrAppUIColorGroup.fcr_white
        userNameTextField.backgroundColor = FcrAppUIColorGroup.fcr_white
        
        if let imageView = roomNameTextField.leftView as? UIImageView {
            imageView.image = UIImage(named: "fcr_room_create_room_name")
        }
        
        if let imageView = userNameTextField.leftView as? UIImageView {
            imageView.image = UIImage(named: "fcr_room_create_user_name")
        }
        
        roomNameTextField.placeholder = "fcr_home_tips_room_name".localized()
        
        userNameTextField.placeholder = "fcr_home_tips_nick_name".localized()
        
        collectionView.backgroundColor = .clear
    }
}

extension FcrAppUICreateRoomHeaderView: UICollectionViewDelegate,
                                        UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return roomTypeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: FcrAppUICreateRoomTypeCell.self,
                                                      for: indexPath)
        let roomType = roomTypeList[indexPath.row]
        
        cell.imageView.image = roomType.image()
        cell.titleLabel.text = roomType.text()
        cell.subTitleLabel.text = roomType.subTitle()
        cell.aSelected = (roomType == selectedRoomType)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath,
                                    animated: false)
        
        selectedRoomType = roomTypeList[indexPath.row]
        
        collectionView.reloadData()
        
        collectionView.scrollToItem(at: indexPath,
                                    at: .centeredHorizontally,
                                    animated: true)
    }
}

class FcrAppUICreateRoomTypeCell: UICollectionViewCell,
                                  AgoraUIContentContainer {
    private let selectIcon = UIImageView()
    
    let imageView = UIImageView()
    
    let titleLabel = UILabel()
    
    let subTitleLabel = UILabel()
    
    let selectedView = UIImageView(frame: .zero)
    
    var aSelected = false {
        didSet {
            guard aSelected != oldValue else {
                return
            }
            selectedView.isHidden = !aSelected
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
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(selectedView)
        
        titleLabel.font = FcrAppUIFontGroup.font14
        titleLabel.textAlignment = .center
        
        subTitleLabel.font = FcrAppUIFontGroup.font12
        subTitleLabel.textAlignment = .center
        
        selectedView.isHidden = true
    }
    
    func initViewFrame() {
        imageView.mas_makeConstraints { make in
            make?.left.right().top().bottom().equalTo()(0)
        }
        
        titleLabel.mas_makeConstraints { make in
            make?.top.equalTo()(15)
            make?.left.right().equalTo()(0)
        }
        
        subTitleLabel.mas_makeConstraints { make in
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(8)
            make?.left.right().equalTo()(0)
        }
        
        selectedView.mas_makeConstraints { make in
            make?.width.height().equalTo()(30)
            make?.top.equalTo()(imageView)?.offset()(-8)
            make?.right.equalTo()(imageView)?.offset()(8)
        }
    }
    
    func updateViewProperties() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        selectedView.image = UIImage(named: "fcr_mobile_check2")
        
        imageView.backgroundColor = FcrAppUIColorGroup.fcr_white
        titleLabel.textColor = FcrAppUIColorGroup.fcr_white
        subTitleLabel.textColor = FcrAppUIColorGroup.fcr_white
    }
}

fileprivate extension FcrAppUIRoomType {
    func image() -> UIImage? {
        switch self {
        case .smallClass:  return UIImage(named: "fcr_room_create_small_bg")
        case .lectureHall: return UIImage(named: "fcr_room_create_lecture_bg")
        case .oneToOne:    return UIImage(named: "fcr_room_create_1v1_bg")
        case .proctor:     return UIImage(named: "fcr_room_create_proctor_bg")
        }
    }
    
    func subTitle() -> String? {
        switch self {
        case .smallClass:  return "fcr_create_small_detail".localized()
        case .lectureHall: return "fcr_create_lecture_detail".localized()
        case .oneToOne:    return "fcr_create_onetoone_detail".localized()
        case .proctor:     return nil
        }
    }
}

// MARK: - Room time
class FcrAppUICreateRoomTimeView: UIButton,
                                  AgoraUIContentContainer {
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
                let endDate = date.addingTimeInterval(30 * 60)
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
        arrowIcon.image = UIImage(named: "fcr_home_label_create_classroom")
        
        startTimeLabel.text = "fcr_create_current_time".localized()
        startTitleLabel.text = "fcr_home_label_starttime".localized()
        startTitleLabel.textColor = FcrAppUIColorGroup.fcr_v2_light_text2
        
        endTitleLabel.text = "fcr_home_label_endtime".localized()
        endTitleLabel.textColor = FcrAppUIColorGroup.fcr_v2_light_text2
        
        startTimeLabel.textColor = UIColor.black
        
        endTimeLabel.text = "fcr_create_end_time".localized()
        endTimeLabel.textColor = FcrAppUIColorGroup.fcr_v2_light_text2
        
        endInfoLabel.text = "fcr_create_end_time_info".localized()
        endInfoLabel.textColor = FcrAppUIColorGroup.fcr_v2_light_text2
    }
}

// MARK: - Footer
class FcrAppUICreateRoomFooterView: UIView,
                                    AgoraUIContentContainer {
    let createButton = UIButton(type: .custom)
    let cancelButton = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        initViewFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(createButton)
        addSubview(cancelButton)
        
        createButton.titleLabel?.font = FcrAppUIFontGroup.font16
        createButton.layer.cornerRadius = 23
        createButton.clipsToBounds = true
        
        cancelButton.titleLabel?.font = FcrAppUIFontGroup.font16
        cancelButton.layer.cornerRadius = 23
        cancelButton.clipsToBounds = true
    }
    
    func initViewFrame() {
        createButton.mas_makeConstraints { make in
            make?.top.equalTo()(16)
            make?.right.equalTo()(-30)
            make?.height.equalTo()(46)
            make?.width.equalTo()(190)
        }
        
        cancelButton.mas_makeConstraints { make in
            make?.centerY.equalTo()(createButton)
            make?.right.equalTo()(createButton.mas_left)?.offset()(-15)
            make?.height.equalTo()(46)
            make?.width.equalTo()(110)
        }
    }
    
    func updateViewProperties() {
        createButton.setTitle("fcr_home_button_create".localized(),
                              for: .normal)
        
        createButton.setTitleColor(.white,
                                   for: .normal)
        
        createButton.backgroundColor = FcrAppUIColorGroup.fcr_v2_brand6
        
        cancelButton.setTitle("fcr_home_button_cancel".localized(),
                              for: .normal)
        
        cancelButton.setTitleColor(.black,
                                   for: .normal)
        
        cancelButton.backgroundColor = UIColor(hex: 0xF8F8F8)
    }
}

// MARK: - Content view
class FcrAppUICreateRoomContentView: UIView,
                                     AgoraUIContentContainer,
                                     FcrAppUICreateRoomMoreTableViewDelegate {
    let headerView: FcrAppUICreateRoomHeaderView
    
    private let backgroundImageView = UIImageView(frame: .zero)
    
    let closeButton = UIButton(frame: .zero)
    
    private let titleLabel = UILabel()
    
    let timeView = FcrAppUICreateRoomTimeView(frame: .zero)
    
    private let moreTableView = FcrAppUICreateRoomMoreTableView(frame: .zero)
    
    let footerView = FcrAppUICreateRoomFooterView(frame: .zero)
    
    init(roomTypeList: [FcrAppUIRoomType]) {
        self.headerView = FcrAppUICreateRoomHeaderView(roomTypeList: roomTypeList)
        super.init(frame: .zero)
        initViews()
        initViewFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(backgroundImageView)
        addSubview(closeButton)
        addSubview(titleLabel)
        addSubview(headerView)
        addSubview(timeView)
        addSubview(moreTableView)
        addSubview(footerView)
        
        headerView.layer.cornerRadius = 24
        
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        
        timeView.layer.cornerRadius = 12
        
        moreTableView.layer.cornerRadius = 12
        moreTableView.delegate = self
    }
    
    func initViewFrame() {
        closeButton.mas_makeConstraints { make in
            make?.width.height().equalTo()(44)
            make?.left.equalTo()(16)
            make?.top.equalTo()(44)
        }
        
        backgroundImageView.mas_makeConstraints { make in
            make?.left.top().right().equalTo()(0)
        }
        
        titleLabel.mas_makeConstraints { make in
            make?.centerY.equalTo()(closeButton)
            make?.left.right().equalTo()(0)
        }
        
        headerView.mas_makeConstraints { make in
            make?.top.equalTo()(self.titleLabel.mas_bottom)?.offset()(27)
            make?.left.equalTo()(15)
            make?.right.equalTo()(-15)
            make?.height.equalTo()(248)
        }
        
        timeView.mas_makeConstraints { make in
            make?.top.equalTo()(self.headerView.mas_bottom)?.offset()(10)
            make?.left.equalTo()(15)
            make?.right.equalTo()(-15)
            make?.height.equalTo()(83)
        }
        
        footerView.mas_makeConstraints { make in
            make?.left.right().bottom().equalTo()(0)
            make?.height.equalTo()(96)
        }
        
        updateMoreTableViewHeight()
    }
    
    func updateViewProperties() {
        headerView.updateViewProperties()
        timeView.updateViewProperties()
        moreTableView.updateViewProperties()
        footerView.updateViewProperties()
        
        backgroundImageView.image = UIImage(named: "fcr_room_create_bg")
        
        titleLabel.text = "fcr_home_label_create_classroom".localized()
        
        headerView.backgroundColor = .white
        
        timeView.backgroundColor = .white
        
        moreTableView.backgroundColor = .white
        
        footerView.backgroundColor = .white
        
        closeButton.setImage(UIImage(named: "fcr_room_create_cancel"),
                             for: .normal)
    }
    
    func updateMoreTableViewHeight(animated: Bool = false) {
        let height = moreTableView.suitableHeight
        
        moreTableView.mas_remakeConstraints { make in
            make?.left.equalTo()(15)
            make?.right.equalTo()(-15)
            make?.top.equalTo()(self.timeView.mas_bottom)?.offset()(10)
            make?.height.equalTo()(height)
        }
        
        guard animated else {
            return
        }
        
        UIView.animate(withDuration: TimeInterval.agora_animation) {
            self.layoutIfNeeded()
        }
    }
    
    func tableView(_ tableView: FcrAppUICreateRoomMoreTableView,
                   didSpreadUpdated isSpread: Bool) {
        updateMoreTableViewHeight(animated: true)
    }
    
    func tableView(_ tableView: FcrAppUICreateRoomMoreTableView,
                   didSwitch option: FcrAppUICreateRoomMoreSettingOption) {
        
    }
}
