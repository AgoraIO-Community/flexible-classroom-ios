//
//  FcrAppUIJoinRoomController.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/9/14.
//  Copyright © 2022 Agora. All rights reserved.
//

import AgoraUIBaseViews

fileprivate class JoinRoomIdTextField: FcrAppUIRoomIdTextField {
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 20,
                      y: 0,
                      width: 75,
                      height: bounds.height)
    }
}

fileprivate class JoinRoomNameTextField: FcrAppUIRoomNameTextField {
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 20,
                      y: 0,
                      width: 75,
                      height: bounds.height)
    }
}

class FcrAppUIJoinRoomController: FcrAppViewController {
    private let contentView = UIView()
    
    private let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    private let alertBg = UIImageView(image: UIImage(named: "fcr_alert_bg"))
    
    private let titleLabel = UILabel()
    
    private let cardView = UIView()
    
    private let idTextField = JoinRoomIdTextField()
    
    private let lineView = UIView()
        
    private let nameTextField = JoinRoomNameTextField()
    
    private let roleTitleLabel = UILabel()
    
    private let studentButton = UIButton(type: .custom)
    
    private let teacherButton = UIButton(type: .custom)
    
    private let closeButton = UIButton(type: .custom)
    
    private let joinButton = UIButton(type: .custom)
    
    var completion: ((FcrAppUIJoinRoomConfig) -> Void)?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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

extension FcrAppUIJoinRoomController: AgoraUIContentContainer {
    func initViews() {
        view.addSubview(contentView)
        contentView.addSubview(effectView)
        contentView.addSubview(alertBg)
        contentView.addSubview(titleLabel)
        contentView.addSubview(cardView)
        cardView.addSubview(lineView)
        contentView.addSubview(idTextField)
        contentView.addSubview(nameTextField)
        contentView.addSubview(roleTitleLabel)
        contentView.addSubview(studentButton)
        contentView.addSubview(teacherButton)
        contentView.addSubview(closeButton)
        contentView.addSubview(joinButton)
        
        idTextField.leftViewMode = .always
        idTextField.leftView = UILabel()
        idTextField.returnKeyType = .done
        idTextField.keyboardType = .numberPad
        
        nameTextField.leftViewMode = .always
        nameTextField.leftView = UILabel()
        nameTextField.returnKeyType = .done
        
        studentButton.addTarget(self,
                                action: #selector(onPressedStudentButton(_:)),
                                for: .touchUpInside)
        studentButton.isSelected = true
        
        teacherButton.addTarget(self,
                                action: #selector(onPressedTeacherButton(_:)),
                                for: .touchUpInside)
        
        closeButton.addTarget(self,
                              action: #selector(onPressedCloseButton(_:)),
                              for: .touchUpInside)
        
        joinButton.addTarget(self,
                               action: #selector(onPressedJoinButton(_:)),
                               for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onKeyBoardShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onKeyBoardHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func initViewFrame() {
        contentView.mas_makeConstraints { make in
            make?.left.equalTo()(16)
            make?.right.bottom().equalTo()(-16)
            make?.height.equalTo()(446)
        }
        
        effectView.mas_makeConstraints { make in
            make?.left.right().top().bottom().equalTo()(0)
        }
        
        alertBg.mas_makeConstraints { make in
            make?.top.left().equalTo()(0)
        }
        
        titleLabel.mas_makeConstraints { make in
            make?.left.top().equalTo()(24)
        }
        
        cardView.mas_makeConstraints { make in
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(28)
            make?.left.equalTo()(15)
            make?.right.equalTo()(-15)
            make?.height.equalTo()(120)
        }
        
        lineView.mas_makeConstraints { make in
            make?.center.width().equalTo()(cardView)
            make?.height.equalTo()(1)
        }
        
        idTextField.mas_makeConstraints { make in
            make?.left.top().right().equalTo()(cardView)
            make?.bottom.equalTo()(lineView)
        }
        
        nameTextField.mas_makeConstraints { make in
            make?.left.bottom().right().equalTo()(cardView)
            make?.top.equalTo()(lineView)
        }
        
        roleTitleLabel.mas_makeConstraints { make in
            make?.top.equalTo()(cardView.mas_bottom)?.offset()(20)
            make?.left.equalTo()(37)
        }
        
        teacherButton.mas_makeConstraints { make in
            make?.top.equalTo()(roleTitleLabel.mas_bottom)?.offset()(12)
            make?.left.equalTo()(17)
            make?.right.equalTo()(contentView.mas_centerX)?.offset()(-6)
            make?.height.equalTo()(45)
        }
        
        studentButton.mas_makeConstraints { make in
            make?.top.equalTo()(roleTitleLabel.mas_bottom)?.offset()(12)
            make?.right.equalTo()(-17)
            make?.left.equalTo()(contentView.mas_centerX)?.offset()(6)
            make?.height.equalTo()(45)
        }
        
        closeButton.mas_makeConstraints { make in
            make?.top.equalTo()(15)
            make?.right.equalTo()(-15)
        }
        
        joinButton.mas_makeConstraints { make in
            make?.bottom.equalTo()(-30)
            make?.left.equalTo()(12)
            make?.right.equalTo()(-12)
            make?.height.equalTo()(46)
        }
    }
    
    func updateViewProperties() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        contentView.layer.cornerRadius = 24
        contentView.clipsToBounds = true
        
        titleLabel.textColor = .black
        titleLabel.text = "fcr_room_join_title".localized()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        cardView.backgroundColor = UIColor.white
        cardView.layer.cornerRadius = 24
        cardView.clipsToBounds = true
        
        lineView.backgroundColor = UIColor(hex: 0xEFEFEF)
        
        if let label = idTextField.leftView as? UILabel {
            label.text = "fcr_room_join_room_id".localized()
            label.font = UIFont.boldSystemFont(ofSize: 15)
            label.textColor = UIColor.black
        }
        
        idTextField.placeholder = "fcr_room_join_room_id_ph".localized()
        idTextField.font = UIFont.boldSystemFont(ofSize: 15)
        idTextField.textColor = UIColor.black
        
        if let label = nameTextField.leftView as? UILabel {
            label.text = "fcr_room_join_room_name".localized()
            label.font = UIFont.boldSystemFont(ofSize: 15)
            label.textColor = UIColor.black
        }
        
        nameTextField.placeholder = "fcr_room_join_room_name_ph".localized()
        nameTextField.font = UIFont.boldSystemFont(ofSize: 15)
        nameTextField.textColor = UIColor.black
        
        roleTitleLabel.text = "fcr_room_join_room_role".localized()
        roleTitleLabel.font = UIFont.systemFont(ofSize: 15)
        roleTitleLabel.textColor = UIColor(hex: 0xBDBEC6)
        
        studentButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        studentButton.setTitleForAllStates("fcr_room_join_room_role_student".localized())
        studentButton.setTitleColor(.white,
                                    for: .selected)
        studentButton.setTitleColor(.black,
                                    for: .normal)
        let normalImg = UIImage(color: .white,
                                size: CGSize(width: 1, height: 1))
        studentButton.setBackgroundImage(normalImg,
                                         for: .normal)
        let selectImg = UIImage(color: UIColor(hex: 0x357BF6) ?? .black,
                                size: CGSize(width: 1, height: 1))
        studentButton.setBackgroundImage(selectImg,
                                         for: .selected)
        
        studentButton.layer.cornerRadius = 10
        studentButton.clipsToBounds = true
        
        teacherButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        teacherButton.setTitleForAllStates("fcr_room_join_room_role_teacher".localized())
        teacherButton.setTitleColor(.white,
                                    for: .selected)
        teacherButton.setTitleColor(.black,
                                    for: .normal)
        teacherButton.setBackgroundImage(normalImg,
                                         for: .normal)
        teacherButton.setBackgroundImage(selectImg,
                                         for: .selected)
        teacherButton.layer.cornerRadius = 10
        teacherButton.clipsToBounds = true
        
        closeButton.setImage(UIImage(named: "fcr_room_create_alert_cancel"),
                             for: .normal)
        
        joinButton.setTitle("fcr_alert_sure".localized(),
                              for: .normal)
        joinButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        joinButton.setTitleColor(.white,
                                   for: .normal)
        joinButton.layer.cornerRadius = 23
        joinButton.clipsToBounds = true
        joinButton.backgroundColor = UIColor(hex: 0x357BF6)
    }
}

// MARK: - Actions
private extension FcrAppUIJoinRoomController {
    @objc func onPressedCloseButton(_ sender: UIButton) {
        UIApplication.shared.keyWindow?.endEditing(true)
        dismiss(animated: true)
    }
    
    @objc func onPressedJoinButton(_ sender: UIButton) {
        guard let roomId = idTextField.text,
              roomId.count > 0
        else {
            AgoraToast.toast(message: "fcr_joinroom_tips_roomid_empty".localized(),
                             type: .error)
            return
        }
        
        guard let name = nameTextField.text,
              name.count > 0
        else {
            AgoraToast.toast(message: "fcr_joinroom_tips_username_empty".localized(),
                             type: .error)
            return
        }
        
        let role: FcrAppUIUserRole = (teacherButton.isSelected ? .teacher : .student)
        
        let options = FcrAppUIJoinRoomConfig(roomId: roomId,
                                              nickname: name,
                                              userRole: role)
        
        completion?(options)
        
        dismiss(animated: true)
    }
    
    @objc func onPressedTeacherButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        studentButton.isSelected.toggle()
    }
    
    @objc func onPressedStudentButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        teacherButton.isSelected.toggle()
    }
    
    @objc func onKeyBoardShow(_ sender: NSNotification) {
        guard let userInfo = sender.userInfo,
              let value = userInfo["UIKeyboardBoundsUserInfoKey"] as? NSValue
        else {
            return
        }
        let height = value.cgRectValue.size.height
        var contentHeight: CGFloat = 446
        if idTextField.isEditing {
            contentHeight = idTextField.frame.maxY + height + 40
        } else if nameTextField.isEditing {
            contentHeight = nameTextField.frame.maxY + height
        }
        contentView.mas_updateConstraints { make in
            make?.height.equalTo()(contentHeight)
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func onKeyBoardHide(_ sender: NSNotification) {
        contentView.mas_updateConstraints { make in
            make?.height.equalTo()(446)
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}
