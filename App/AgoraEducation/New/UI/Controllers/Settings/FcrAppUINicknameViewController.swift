//
//  FcrAppUINicknameViewController.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/6/30.
//  Copyright © 2022 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUINicknameViewController: FcrAppUIViewController {
    private let textField = UITextField(frame: .zero)
    private let line = UIView()
    private var center = FcrAppCenter()

    init(center: FcrAppCenter) {
        super.init(nibName: nil,
                   bundle: nil)
        
        self.center = center
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let text = textField.text,
                !text.isEmpty else {
            return
        }
    
        center.localUser?.nickname = text
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        super.touchesBegan(touches,
                           with: event)
        textField.resignFirstResponder()
    }
}

extension FcrAppUINicknameViewController: AgoraUIContentContainer {
    func initViews() {
        textField.text = center.localUser?.nickname
        
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        
        view.addSubview(textField)
        view.addSubview(line)
    }
    
    func initViewFrame() {
        textField.mas_makeConstraints { make in
            make?.top.equalTo()(0)
            make?.left.equalTo()(16)
            make?.right.equalTo()(-16)
            make?.height.equalTo()(52)
        }
        
        line.mas_makeConstraints { make in
            make?.left.right().equalTo()(0)
            make?.height.equalTo()(1)
            make?.top.equalTo()(textField.mas_bottom)
        }
    }
    
    func updateViewProperties() {
        title = "settings_nickname".localized()
        
        view.backgroundColor = .white
        
        textField.textColor = UIColor(hex: 0x191919)
        textField.font = UIFont.systemFont(ofSize: 14)
        line.backgroundColor = UIColor(hex: 0xEEEEF7)
    }
}

extension FcrAppUINicknameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        
        if text.count > 50 && string.count != 0 {
            return false
        }
        
        return true
    }
}
