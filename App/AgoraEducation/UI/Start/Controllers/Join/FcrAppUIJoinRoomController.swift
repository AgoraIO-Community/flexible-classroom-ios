//
//  FcrAppUIJoinRoomController.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/13.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUIJoinRoomController: FcrAppUIPresentedViewController {
    var completion: ((FcrAppUIJoinRoomConfig) -> Void)?
    
    private var center: FcrAppCenter
    
    init(center: FcrAppCenter,
         completion: ((FcrAppUIJoinRoomConfig) -> Void)? = nil) {
        self.center = center
        self.completion = completion
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        contentView = FcrAppUIJoinRoomContentView()
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        super.touchesBegan(touches,
                           with: event)
        
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    override func initViews() {
        super.initViews()
        
        let content = getContentView()
        
        content.roomInputView.roomIdTextField.text = center.room.lastRoomId
        content.roomInputView.userNameTextField.text = center.localUser?.nickname
        
        content.studentView.button.addTarget(self,
                                             action: #selector(onPressedStudentButton(_:)),
                                             for: .touchUpInside)
        
        content.teacherView.button.addTarget(self,
                                             action: #selector(onPressedTeacherButton(_:)),
                                             for: .touchUpInside)
        
        content.closeButton.addTarget(self,
                                      action: #selector(onPressedCloseButton(_:)),
                                      for: .touchUpInside)
        
        content.joinButton.addTarget(self,
                                     action: #selector(onPressedJoinButton(_:)),
                                     for: .touchUpInside)
        
        NotificationCenter.default.observerKeyboard(listening: { [weak self] (info: (endFrame: CGRect, duration: Double)) in
            guard let strongSelf = self else {
                return
            }

            strongSelf.updateInputViewFrame(keyBoardEndFrame: info.endFrame,
                                            duration: info.duration)
        })
    }
    
    override func updateViewProperties() {
        super.updateViewProperties()
        (contentView as! AgoraUIContentContainer).updateViewProperties()
    }
    
    func getContentView() -> FcrAppUIJoinRoomContentView {
        guard let content = contentView as? FcrAppUIJoinRoomContentView else {
            fatalError()
        }
        
        return content
    }
}

// MARK: - Actions
private extension FcrAppUIJoinRoomController {
    @objc func onPressedCloseButton(_ sender: UIButton) {
        UIApplication.shared.keyWindow?.endEditing(true)
        dismiss(animated: true)
    }
    
    @objc func onPressedJoinButton(_ sender: UIButton) {
        let content = getContentView()
        
        guard let roomId = content.roomInputView.roomIdTextField.getText() else {
            showToast("fcr_joinroom_tips_roomid_empty".localized(),
                      type: .error)
            return
        }
        
        guard let userName = content.roomInputView.userNameTextField.getText() else {
            showToast("fcr_joinroom_tips_username_empty".localized(),
                      type: .error)
            return
        }
        
        if userName.count < 2 || userName.count > 20 {
            showToast("fcr_home_toast_content_length".localized(),
                      type: .error)
            return
        }
        
        let userRole: FcrAppUIUserRole = (content.teacherView.button.isSelected ? .teacher : .student)
        
        guard let userId = center.localUser?.userId else {
            fatalError()
        }
        
        AgoraLoading.loading()
        
        let config = FcrAppJoinRoomPreCheckConfig(roomId: roomId,
                                                  userId: userId,
                                                  userName: userName,
                                                  userRole: userRole)
        
        center.room.joinRoomPreCheck(config: config) { [weak self] object in
            let options = FcrAppUIJoinRoomConfig(userId: userId,
                                                 userName: userName,
                                                 userRole: userRole,
                                                 roomId: roomId,
                                                 roomName: object.roomDetail.roomName,
                                                 roomType: object.roomDetail.roomType,
                                                 appId: object.appId,
                                                 token: object.token)
            
            AgoraLoading.hide()
            
            self?.dismiss(animated: true)
            
            self?.completion?(options)
            
            self?.completion = nil
        } failure: { [weak self] error in
            AgoraLoading.hide()
            self?.showErrorToast(error)
        }
    }
    
    @objc func onPressedTeacherButton(_ sender: UIButton) {
        let content = getContentView()
        
        let selected = !content.teacherView.button.isSelected
        
        content.teacherView.selected(selected)
        
        content.studentView.selected(!selected)
    }
    
    @objc func onPressedStudentButton(_ sender: UIButton) {
        let content = getContentView()
        
        let selected = !content.studentView.button.isSelected
        
        content.studentView.selected(selected)
        
        content.teacherView.selected(!selected)
    }
    
    func updateInputViewFrame(keyBoardEndFrame: CGRect,
                              duration: Double) {
        let content = getContentView()
        
        let viewFrame = view.convert(content.roomInputView.frame,
                                     from: content)
        
        let diff = viewFrame.maxY - keyBoardEndFrame.minY
   
        var y: CGFloat = content.frame.origin.y - diff

        if y > contentViewY {
            y = contentViewY
        }
        
        let newFrame = CGRect(x: content.frame.origin.x,
                              y: y,
                              width: content.frame.width,
                              height: content.frame.height)
        
        UIView.animate(withDuration: TimeInterval.agora_animation) {
            content.frame = newFrame
        }
    }
}
