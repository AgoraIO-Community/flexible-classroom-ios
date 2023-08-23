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
    private let contentView: FcrAppUICreateRoomContentView
    
    private var completion: FcrAppCompletion?
    
    private var center: FcrAppCenter
    
    init(center: FcrAppCenter,
         roomTypeList: [FcrAppUIRoomType],
         completion: FcrAppCompletion? = nil) {
        self.center = center
        self.contentView = FcrAppUICreateRoomContentView(roomTypeList: roomTypeList)
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
        view.addSubview(contentView)
        
        contentView.headerView.roomNameTextField.text = center.room.lastRoomName
        contentView.headerView.userNameTextField.text = center.localUser?.nickname
        
        contentView.closeButton.addTarget(self,
                                          action: #selector(onCancelButtonPressed(_:)),
                                          for: .touchUpInside)
        
        contentView.timeView.addTarget(self,
                                       action: #selector(onTimeButtonPressed),
                                       for: .touchUpInside)
        
        contentView.footerView.createButton.addTarget(self,
                                                      action: #selector(onCreateButtonPressed(_:)),
                                                      for: .touchUpInside)
        
        contentView.footerView.cancelButton.addTarget(self,
                                                      action: #selector(onCancelButtonPressed(_:)),
                                                      for: .touchUpInside)
    }
    
    func initViewFrame() {
        contentView.mas_makeConstraints { make in
            make?.left.right().top().bottom().equalTo()(0)
        }
    }
    
    func updateViewProperties() {
        contentView.updateViewProperties()
        
        view.backgroundColor = UIColor(hex: 0xF8FAFF)
    }
}

// MARK: - Actions
private extension FcrAppUICreateRoomViewController {
    @objc func onTimeButtonPressed(_ sender: UIButton) {
        let vc = FcrAppUICreateRoomTimePickerController(date: Date()) { [weak self] date in
            self?.contentView.timeView.startDate = date
        }
        
        presentViewController(vc,
                              animated: true)
    }
    
    @objc func onCancelButtonPressed(_ sender: UIButton) {
        completion = nil
        dismiss(animated: true)
    }
    
    @objc func onCreateButtonPressed(_ sender: UIButton) {
        // Room name
        guard let roomName = contentView.headerView.roomNameTextField.getText() else {
            showToast("fcr_home_toast_room_name_null".localized(),
                      type: .error)
            return
        }
        
        // User name
        guard let userName = contentView.headerView.userNameTextField.getText() else {
            showToast("fcr_home_toast_nick_name_null".localized(),
                      type: .error)
            return
        }
        
        guard let userId = center.localUser?.userId else {
            return
        }
        
        // Time
        var schedule: Date
        
        if let date = contentView.timeView.startDate {
            schedule = date
        } else {
            schedule = Date()
        }
        
        let startTime = Int64(schedule.timeIntervalSince1970) * 1000
        let endTime = (startTime + 30 * 60) * 1000
        
        // Room type
        let roomType = contentView.headerView.selectedRoomType
        
        let config = FcrAppCreateRoomConfig(roomName: roomName,
                                            roomType: roomType,
                                            userId: userId,
                                            userName: userName,
                                            startTime: startTime,
                                            endTime: endTime)
        
        createRoom(config)
    }
}
