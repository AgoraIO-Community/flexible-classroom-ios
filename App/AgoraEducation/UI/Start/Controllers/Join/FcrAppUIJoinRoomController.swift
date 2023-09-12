//
//  FcrAppUIJoinRoomController.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/13.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUIJoinRoomController: FcrAppStartUIPresentedViewController {
    private let joinView = FcrAppUIJoinRoomView(frame: .zero)
    
    private var center: FcrAppCenter
    
    var completion: ((FcrAppJoinRoomPreCheckConfig) -> Void)?
    
    init(center: FcrAppCenter,
         completion: ((FcrAppJoinRoomPreCheckConfig) -> Void)? = nil) {
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

    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        super.touchesBegan(touches,
                           with: event)
        
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    override func initViews() {
        super.initViews()
        
        contentView.addSubview(joinView)
        
        joinView.roomInputView.roomIdTextField.setShowText(center.room.lastId)
        joinView.roomInputView.userNameTextField.text = center.localUser?.nickname
        
        joinView.studentView.button.addTarget(self,
                                              action: #selector(onPressedStudentButton(_:)),
                                              for: .touchUpInside)
        
        joinView.teacherView.button.addTarget(self,
                                              action: #selector(onPressedTeacherButton(_:)),
                                              for: .touchUpInside)
        
        bottomButton.addTarget(self,
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
    
    override func initViewFrame() {
        super.initViewFrame()
        
        joinView.mas_makeConstraints { make in
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(30)
            make?.left.equalTo()(20)
            make?.right.equalTo()(-20)
            make?.bottom.equalTo()(bottomButton.mas_top)?.offset()
        }
    }
    
    override func updateViewProperties() {
        super.updateViewProperties()
        
        joinView.updateViewProperties()
        
        titleLabel.text = "fcr_home_label_join_classroom".localized()
        
        
        bottomButton.setTitle("fcr_home_button_join".localized(),
                              for: .normal)
    }
}

// MARK: - Actions
private extension FcrAppUIJoinRoomController {
    @objc func onPressedJoinButton(_ sender: UIButton) {
        guard let roomId = joinView.roomInputView.roomIdTextField.getText() else {
            showToast("fcr_joinroom_tips_roomid_empty".localized(),
                      type: .error)
            return
        }
        
        if roomId.count != 9 {
            showToast("fcr_login_free_tips_num_length".localized(),
                      type: .error)
            return
        }
        
        guard let userName = joinView.roomInputView.userNameTextField.getText() else {
            showToast("fcr_joinroom_tips_username_empty".localized(),
                      type: .error)
            return
        }
        
        if userName.count < 2 || userName.count > 20 {
            showToast("fcr_home_toast_content_length".localized(),
                      type: .error)
            return
        }
        
        let userRole: FcrAppUIUserRole = (joinView.teacherView.button.isSelected ? .teacher : .student)
        
        guard let userId = center.localUser?.userId else {
            fatalError()
        }
        
        let config = FcrAppJoinRoomPreCheckConfig(roomId: roomId,
                                                  userId: userId,
                                                  userName: userName,
                                                  userRole: userRole)
        
        dismiss(animated: true)
        
        completion?(config)
        
        completion = nil
    }
    
    @objc func onPressedTeacherButton(_ sender: UIButton) {
        let selected = !joinView.teacherView.button.isSelected
        
        joinView.teacherView.selected(selected)
        
        joinView.studentView.selected(!selected)
    }
    
    @objc func onPressedStudentButton(_ sender: UIButton) {
        let selected = !joinView.studentView.button.isSelected
        
        joinView.studentView.selected(selected)
        
        joinView.teacherView.selected(!selected)
    }
    
    func updateInputViewFrame(keyBoardEndFrame: CGRect,
                              duration: Double) {
        let viewFrame = view.convert(joinView.roomInputView.frame,
                                     from: contentView)
        
        let diff = viewFrame.maxY - keyBoardEndFrame.minY
   
        var y: CGFloat = contentView.frame.origin.y - diff
        
        if y > contentViewY {
            y = contentViewY
        }
        
        let newFrame = CGRect(x: contentView.frame.origin.x,
                              y: y,
                              width: contentView.frame.width,
                              height: contentView.frame.height)
        
        UIView.animate(withDuration: TimeInterval.agora_animation) {
            self.contentView.frame = newFrame
        }
    }
}
