//
//  FcrAppUICreateRoomViewController.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/8/4.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUICreateRoomViewController: FcrAppUIViewController {
    // View
    private let backgroundImageView = UIImageView(frame: .zero)
    
    private let closeButton = UIButton(type: .custom)
    
    private let titleLabel = UILabel()
    
    private let headerView = FcrAppUICreateRoomHeaderView(roomTypeList: [.smallClass,
                                                                         .lectureHall,
                                                                         .oneToOne])
    
    private let timeView = FcrAppUICreateRoomTimeView(frame: .zero)
    
    private let moreTableView = FcrAppUICreateRoomMoreTableView(frame: .zero)
    
    private let footerView = FcrAppUICreateRoomFooterView(frame: .zero)
    
    private var completion: FcrAppCompletion?
    
    private var center: FcrAppCenter
    
    init(center: FcrAppCenter,
         completion: FcrAppCompletion? = nil) {
        self.center = center
        self.completion = completion
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
    
    func createRoom(_ config: FcrAppCreateRoomConfig) {
        AgoraLoading.loading()
        
        center.room.createRoom(config: config) { [weak self] roomId in
            AgoraLoading.hide()
            self?.dismiss(animated: true)
            self?.completion?()
            self?.completion = nil
        } failure: { [weak self] error in
            AgoraLoading.hide()
            self?.showErrorToast(error)
        }
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
        headerView.updateViewProperties()
        timeView.updateViewProperties()
        moreTableView.updateViewProperties()
        footerView.updateViewProperties()
        
        view.backgroundColor = UIColor(hex: 0xF8FAFF)
        
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
        let vc = FcrAppUICreateRoomTimePickerController(date: Date()) { [weak self] date in
            self?.timeView.startDate = date
        }
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        present(vc,
                animated: true)
    }
    
    @objc func onClickCancel(_ sender: UIButton) {
        completion = nil
        dismiss(animated: true)
    }
    
    @objc func onClickCreate(_ sender: UIButton) {
        // Room name
        guard let roomName = headerView.userNameTextField.getText() else {
            showToast("fcr_create_label_roomname_empty".localized(),
                      type: .error)
            return
        }
        
        // User name
        guard let userName = headerView.userNameTextField.getText() else {
            showToast("user name empty",
                      type: .error)
            return
        }
        
        guard let userId = center.localUser?.userId else {
            return
        }
        
        // Time
        var schedule: Date
        
        if let date = timeView.startDate {
            schedule = date
        } else {
            schedule = Date()
        }
        
        let startTime = Int64(schedule.timeIntervalSince1970) * 1000
        let endTime = (startTime + 30 * 60) * 1000
        
        // Room type
        let roomType = headerView.selectedRoomType
        
        let config = FcrAppCreateRoomConfig(roomName: roomName,
                                            roomType: roomType,
                                            userId: userId,
                                            userName: userName,
                                            startTime: startTime,
                                            endTime: endTime)
        
        createRoom(config)
    }
}
