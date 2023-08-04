//
//  FcrAppUICreateRoomViewController.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/8/4.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUICreateRoomViewController: FcrAppViewController {
    // View
    private let backgroundImageView = UIImageView(frame: .zero)
    
    private let closeButton = UIButton(type: .custom)
    
    private let titleLabel = UILabel()
    
    private let headerView = FcrAppUICreateRoomHeaderView(roomTypeList:  [.smallClass,
                                                                          .lectureHall,
                                                                          .oneToOne])
    
    private let timeView = FcrAppUICreateRoomTimeView(frame: .zero)
    
    private let moreTableView = FcrAppUICreateRoomMoreTableView(frame: .zero)
    
    private let footerView = FcrAppUICreateRoomFooterView(frame: .zero)
    
    private var complete: (() -> Void)?
    
    private var center: FcrAppCenter
    
    init(center: FcrAppCenter) {
        self.center = center
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        view.addSubview(backgroundImageView)
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        view.addSubview(headerView)
        view.addSubview(timeView)
        view.addSubview(moreTableView)
        view.addSubview(footerView)
        
        headerView.layer.cornerRadius = 24
        
        closeButton.addTarget(self,
                              action: #selector(onClickCancel(_:)),
                              for: .touchUpInside)
        
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        
        timeView.layer.cornerRadius = 12
        
        timeView.addTarget(self,
                           action: #selector(onTimeButtonPressed),
                           for: .touchUpInside)
        
        moreTableView.layer.cornerRadius = 12
        moreTableView.delegate = self
        
        footerView.createButton.addTarget(self,
                                          action: #selector(onClickCreate(_:)),
                                          for: .touchUpInside)
        
        footerView.cancelButton.addTarget(self,
                                          action: #selector(onClickCancel(_:)),
                                          for: .touchUpInside)
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
            if #available(iOS 11.0, *) {
                make?.top.equalTo()(self.view.mas_safeAreaLayoutGuideBottom)?.offset()(-90)
            } else {
                make?.height.equalTo()(90)
            }
        }
        
        updateMoreTableViewHeight()
    }
    
    func updateViewProperties() {
        view.backgroundColor = UIColor(hex: 0xF8FAFF)
        
        backgroundImageView.image = UIImage(named: "fcr_room_create_bg")
        
        titleLabel.text = "fcr_create_room".localized()
        
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
            self.view.layoutIfNeeded()
        }
    }
}

extension FcrAppUICreateRoomViewController: FcrAppUICreateRoomMoreTableViewDelegate {
    func tableView(_ tableView: FcrAppUICreateRoomMoreTableView,
                   didSpreadUpdated isSpread: Bool) {
        updateMoreTableViewHeight(animated: true)
    }
    
    func tableView(_ tableView: FcrAppUICreateRoomMoreTableView,
                   didSwitch option: FcrAppUICreateRoomMoreSettingOption) {
        
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
        guard let roomName = headerView.userNameTextField.text,
                !roomName.isEmpty else {
            showToast("fcr_create_label_roomname_empty".localized(),
                      type: .error)
            return
        }
        
        guard let userName = headerView.userNameTextField.text,
              !userName.isEmpty else {
            showToast("user name empty",
                      type: .error)
            return
        }
        
        let roomType = headerView.selectedRoomType
        
        var date = Date()
       
        let startTime = Int64(date.timeIntervalSince1970) * 1000
        let endTime = (startTime + 30 * 60) * 1000
        
//        var date = selectDate ?? Date()

//        var roomProperties = [String: Any]()
       
//        roomProperties["watermark"] = securityOn
        
        
//        AgoraLoading.loading()
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
        
        AgoraLoading.loading()
        
        
        let config = FcrAppRoomCreateConfig(roomName: "",
                                            roomType: roomType,
                                            userName: "",
                                            startTime: startTime,
                                            endTime: endTime)
        
        center.room.createRoom(config: config) { [weak self] roomId in
            AgoraLoading.hide()
            
            self?.dismiss(animated: true)
        } failure: { [weak self] error in
            AgoraLoading.hide()
            self?.showErrorToast(error)
        }
    }
}

