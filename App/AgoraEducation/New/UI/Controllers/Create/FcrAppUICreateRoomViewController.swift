//
//  RoomCreateViewController.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/9/5.
//  Copyright © 2022 Agora. All rights reserved.
//

import AgoraUIBaseViews
import UIKit

class FcrAppUICreateRoomViewController: FcrAppViewController {
        
    enum RoomCreateMoreSetting {
        case title, security, playback, linkInput
    }
    
    private let kSectionRoomType = 0
    private let kSectionRoomSubType = 1
    private let kSectionTime = 2
    private let kSectionMoreSetting = 3
        
    private let backImageView = UIImageView(image: UIImage(named: "fcr_room_create_bg"))
    
    private let closeButton = UIButton(type: .custom)
    
    private let titleLabel = UILabel()
    
    private let tableView = UITableView(frame: .zero,
                                        style: .plain)
    
    private var complete: (() -> Void)?
    
    private let roomTypes: [FcrAppUIRoomType] = [.smallClass,
                                                 .lectureHall,
                                                 .oneToOne]
    
    private var selectedRoomType = FcrAppUIRoomType.smallClass
    
    private var moreSettings: [RoomCreateMoreSetting] = [.title]
    
    private var roomName: String?
        
    private var selectDate: Date?
    
    private var securityOn = false
    
    private var playbackOn = false
    
    
    private var moreSettingSpread = false {
        didSet {
            guard moreSettingSpread != oldValue else {
                return
            }
            updateMoreSettings()
        }
    }
    
    private let topView = FcrAppUICreateRoomTopView(frame: .zero)
    
    private let timeView = FcrAppUICreateRoomTimeView(frame: .zero)
    
    private let actionContentView = UIView()
    
    private let createButton = UIButton(type: .custom)
    
    private let cancelButton = UIButton(type: .custom)
    
    static func showCreateRoom(complete: (() -> Void)?) {
        guard let root = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        let vc = FcrAppUICreateRoomViewController()
        vc.complete = complete
        vc.modalPresentationStyle = .fullScreen
        root.present(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
//        if FcrUserInfoPresenter.shared.nickName.count > 0 {
//            roomName = FcrUserInfoPresenter.shared.nickName + "fcr_create_room_name_owner".localized()
//        }
//
        initViews()
        initViewFrame()
        updateViewProperties()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        super.touchesBegan(touches,
                           with: event)
        
        UIApplication.shared.keyWindow?.endEditing(true)
    }
}

// MARK: - Creations
extension FcrAppUICreateRoomViewController: AgoraUIContentContainer {
    func initViews() {
        view.addSubview(backImageView)
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        view.addSubview(topView)
        view.addSubview(timeView)
        view.addSubview(actionContentView)
        
        actionContentView.addSubview(createButton)
        actionContentView.addSubview(cancelButton)
        
        topView.layer.cornerRadius = 24
        topView.collectionView.delegate = self
        topView.collectionView.dataSource = self
        
        timeView.layer.cornerRadius = 24
        
        timeView.addTarget(self,
                           action: #selector(onTimeButtonPressed),
                           for: .touchUpInside)
        
        closeButton.addTarget(self,
                              action: #selector(onClickCancel(_:)),
                              for: .touchUpInside)
        
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        
        createButton.addTarget(self,
                               action: #selector(onClickCreate(_:)),
                               for: .touchUpInside)
        
        createButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        createButton.layer.cornerRadius = 23
        createButton.clipsToBounds = true
        
        cancelButton.addTarget(self,
                               action: #selector(onClickCancel(_:)),
                               for: .touchUpInside)
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        cancelButton.layer.cornerRadius = 23
        cancelButton.clipsToBounds = true
    }
    
    func initViewFrame() {
        closeButton.mas_makeConstraints { make in
            make?.width.height().equalTo()(44)
            make?.left.equalTo()(16)
            make?.top.equalTo()(44)
        }
        
        backImageView.mas_makeConstraints { make in
            make?.left.top().right().equalTo()(0)
        }
        
        titleLabel.mas_makeConstraints { make in
            make?.centerY.equalTo()(closeButton)
            make?.left.right().equalTo()(0)
        }
        
        topView.mas_makeConstraints { make in
            make?.top.equalTo()(self.titleLabel.mas_bottom)?.offset()(27)
            make?.left.equalTo()(15)
            make?.right.equalTo()(-15)
            make?.height.equalTo()(248)
        }
        
        timeView.mas_makeConstraints { make in
            make?.top.equalTo()(self.topView.mas_bottom)?.offset()(10)
            make?.left.equalTo()(15)
            make?.right.equalTo()(-15)
            make?.height.equalTo()(83)
        }
        
        actionContentView.mas_makeConstraints { make in
            make?.left.right().bottom().equalTo()(0)
            if #available(iOS 11.0, *) {
                make?.top.equalTo()(self.view.mas_safeAreaLayoutGuideBottom)?.offset()(-90)
            } else {
                make?.height.equalTo()(90)
            }
        }
        
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
        view.backgroundColor = UIColor(hex: 0xF8FAFF)
        
        titleLabel.text = "fcr_create_room".localized()
        
        topView.backgroundColor = .white
        
        timeView.backgroundColor = .white
        
        actionContentView.backgroundColor = UIColor.white
        
        closeButton.setImage(UIImage(named: "fcr_room_create_cancel"),
                             for: .normal)
        
        createButton.setTitle("fcr_create_submit".localized(),
                              for: .normal)
        
        createButton.setTitleColor(.white,
                                   for: .normal)
        
        createButton.backgroundColor = UIColor(hex: 0x357BF6)
        
        cancelButton.setTitle("fcr_create_cancel".localized(),
                              for: .normal)
        
        cancelButton.setTitleColor(.black,
                                   for: .normal)
        
        cancelButton.backgroundColor = UIColor(hex: 0xF8F8F8)
    }
}

// MARK: - Actions
private extension FcrAppUICreateRoomViewController {
    @objc func onTimeButtonPressed(_ sender: UIButton) {
        let vc = FcrAppUICreateRoomTimePickerController(date: Date())
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc,
                animated: true)
    }
    
    @objc func onClickCancel(_ sender: UIButton) {
        complete = nil
        dismiss(animated: true)
    }
    
    @objc func onClickCreate(_ sender: UIButton) {
        guard let name = roomName,
              name.count > 0
        else {
            AgoraToast.toast(message: "fcr_create_label_roomname_empty".localized(),
                             type: .error)
            return
        }
        var date = selectDate ?? Date()
        date.second = 0
        date.millisecond = 0
        let startTime = UInt(date.timeIntervalSince1970)
        let endTime = startTime + 30 * 60
        var roomProperties = [String: Any]()
       
//        roomProperties["watermark"] = securityOn
        
        
        AgoraLoading.loading()
//        FcrOutsideClassAPI.createClassRoom(roomName: name,
//                                           roomType: selectedRoomType.rawValue,
//                                           startTime: startTime * 1000,
//                                           endTine: endTime * 1000,
//                                           roomProperties: roomProperties) { rsp in
//            AgoraLoading.hide()
//            self.complete?()
//            self.complete = nil
//            self.dismiss(animated: true)
//        } onFailure: { code, msg in
//            AgoraLoading.hide()
//            AgoraToast.toast(message: msg,
//                             type: .error)
//        }
    }
    
    @objc func onClickSecurity(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        securityOn = sender.isSelected
    }
    
    @objc func onClickPlayback(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        playbackOn = sender.isSelected
        updateMoreSettings()
    }
    
    func updateSubRoomType() {
//        if selectedRoomType == .lecture {
//            serviceTypes = [.livePremium]
//            if selectedServiceType == nil {
//                selectedServiceType = .livePremium
//            }
//        } else {
//            serviceTypes = []
//            selectedServiceType = nil
//        }
        tableView.reloadData()
    }
    
    func showTimeSelection() {
//        FcrAppUICreateRoomTimePickerController.showTimeSelection(in: self,
//                                                        from: Date()) { date in
//            self.selectDate = date
//            self.tableView.reloadData()
//        }
    }
    
    func updateMoreSettings() {
//        if selectedRoomType == .lecture,
//           selectedServiceType == .fusion {
//            if moreSettingSpread {
//                if playbackOn {
//                    moreSettings = [.title, .security, .playback, .linkInput]
//                } else {
//                    moreSettings = [.title, .security, .playback]
//                }
//            } else {
//                moreSettings = [.title]
//            }
//        } else {
//            if moreSettingSpread {
//                moreSettings = [.title, .security]
//            } else {
//                moreSettings = [.title]
//            }
//        }
//        tableView.reloadData()
    }
}
// MARK: - RoomBaseInfoCell Call Back
extension FcrAppUICreateRoomViewController: RoomBaseInfoCellDelegate {
    func onRoomNameChanged(text: String) {
        roomName = text
    }
}
// MARK: - Table View Call Back
//extension FcrAppUICreateRoomViewController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 4
//    }
//
//    func tableView(_ tableView: UITableView,
//                   numberOfRowsInSection section: Int) -> Int {
//        if section == kSectionRoomType {
//            return 1
//        } else if section == kSectionTime {
//            return 1
//        } else if section == kSectionMoreSetting {
//            return moreSettings.count
//        } else {
//            return 0
//        }
//    }
//
//    func tableView(_ tableView: UITableView,
//                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == kSectionRoomType {
//            let cell = tableView.dequeueReusableCell(withClass: RoomBaseInfoCell.self)
//            cell.inputText = roomName
//            cell.optionsView = collectionView
//            cell.delegate = self
//            return cell
//        } else if indexPath.section == kSectionTime {
//            let cell = tableView.dequeueReusableCell(withClass: RoomTimeInfoCell.self)
//            cell.startDate = selectDate
//            return cell
//        } else {
//            let type = moreSettings[indexPath.row]
//            if type == .title {
//                let cell = tableView.dequeueReusableCell(withClass: RoomMoreTitleCell.self)
//                cell.spred = moreSettingSpread
//                return cell
//            } else if type == .security {
//                let cell = tableView.dequeueReusableCell(withClass: RoomSecurityInfoCell.self)
//                cell.switchButton.isSelected = securityOn
//                cell.switchButton.addTarget(self,
//                                            action: #selector(onClickSecurity(_:)),
//                                            for: .touchUpInside)
//                return cell
//            } else if type == .playback {
//                let cell = tableView.dequeueReusableCell(withClass: RoomPlayBackInfoCell.self)
//                cell.switchButton.isSelected = playbackOn
//                cell.switchButton.addTarget(self,
//                                            action: #selector(onClickPlayback(_:)),
//                                            for: .touchUpInside)
//                return cell
//            } else {
//                let cell = tableView.dequeueReusableCell(withClass: RoomPlayBackInputCell.self)
//                return cell
//            }
//        }
//    }
//
//    func tableView(_ tableView: UITableView,
//                   didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath,
//                              animated: false)
//        if indexPath.section == kSectionTime {
//            showTimeSelection()
//        } else if indexPath.section == kSectionMoreSetting {
//            let type = moreSettings[indexPath.row]
//            switch type {
//            case .title:
//                moreSettingSpread = true
////            case .linkInput:
////                FcrInputAlertController.show(in: self,
////                                             text: playbackLink,
////                                             min: 1) { str in
////                    self.playbackLink = str
////                    self.tableView.reloadData()
////                }
//            default: break
//            }
//        }
//    }
//
//    func tableView(_ tableView: UITableView,
//                   heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == kSectionRoomType {
//            return 200
//        } else if indexPath.section == kSectionRoomSubType {
//            return 60
//        } else if indexPath.section == kSectionTime {
//            return 94
//        } else if indexPath.section == kSectionMoreSetting {
//            return 60
//        } else {
//            return 0
//        }
//    }
//
//    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        var isEnabe = false
//        if indexPath.section == kSectionRoomSubType ||
//            indexPath.section == kSectionTime {
//            isEnabe = true
//        }
//        if indexPath.section == kSectionMoreSetting ||
//            indexPath.row == 0 {
//            isEnabe = true
//        }
//        return isEnabe
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        UIApplication.shared.keyWindow?.endEditing(true)
//    }
//}
// MARK: - Collection View Call Back
extension FcrAppUICreateRoomViewController: UICollectionViewDelegate,
                                    UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return roomTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: RoomTypeInfoCell.self,
                                                      for: indexPath)
        let roomType = roomTypes[indexPath.row]
        
        cell.imageView.image = roomType.image()
        cell.titleLabel.text = roomType.title()
        cell.subTitleLabel.text = roomType.subTitle()
        cell.aSelected = (roomType == selectedRoomType)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath,
                                    animated: false)
        selectedRoomType = roomTypes[indexPath.row]
        
        collectionView.reloadData()
        
        collectionView.scrollToItem(at: indexPath,
                                    at: .centeredHorizontally,
                                    animated: true)
    }
}

fileprivate extension FcrAppUIRoomType {
    func image() -> UIImage? {
        switch self {
        case .smallClass:
            return UIImage(named: "fcr_room_create_small_bg")
        case .lectureHall:
            return UIImage(named: "fcr_room_create_lecture_bg")
        case .oneToOne:
            return UIImage(named: "fcr_room_create_1v1_bg")
        case .proctor:
            return nil
        }
    }
    
    func title() -> String? {
        switch self {
        case .smallClass:
            return "fcr_create_small_title".localized()
        case .lectureHall:
            return "fcr_create_lecture_title".localized()
        case .oneToOne:
            return "fcr_create_onetoone_title".localized()
        case .proctor:
            return nil
        }
    }
    
    func subTitle() -> String? {
        switch self {
        case .smallClass:
            return "fcr_create_small_detail".localized()
        case .lectureHall:
            return "fcr_create_lecture_detail".localized()
        case .oneToOne:
            return "fcr_create_onetoone_detail".localized()
        case .proctor:
            return nil
        }
    }
}
