//
//  FcrAppUIRoomIdTextField.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/7/24.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUITextField: UITextField, UITextFieldDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        // The first character is not a blank
        if let text = textField.text,
            text.isEmpty,
            string.first == " " {
            return false
        } else {
            return true
        }
    }
}

class FcrAppUIIconTextField: FcrAppUITextField, AgoraUIContentContainer {
    private let lineView = UIView(frame: .zero)
    let iconImageView = UIImageView(frame: .zero)
    
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
        addSubview(lineView)
        
        iconImageView.contentMode = .scaleAspectFit
        
        leftView = iconImageView
        leftViewMode = .always
        
        clearButtonMode = .always
    }
    
    func initViewFrame() {
        lineView.mas_makeConstraints { make in
            make?.left.equalTo()(0)
            make?.right.equalTo()(0)
            make?.height.equalTo()(1)
            make?.bottom.equalTo()(self.mas_bottom)
        }
    }
    
    func updateViewProperties() {
        if let color = UIColor(hexString: "#BDBEC6") {
            setPlaceHolderTextColor(color)
        }
        
        textColor = .black
        
        lineView.backgroundColor = UIColor(hexString: "#EFEFEF")
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0,
                      y: 0,
                      width: 36,
                      height: bounds.height)
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let width: CGFloat = 16
        let height: CGFloat = width
        let x: CGFloat = bounds.width - width - 22
        let y: CGFloat = (bounds.height - height) * 0.5
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
}

class FcrAppUIRoomIdTextField: FcrAppUIIconTextField {
    override func textField(_ textField: UITextField,
                            shouldChangeCharactersIn range: NSRange,
                            replacementString string: String) -> Bool {
        guard super.textField(textField,
                              shouldChangeCharactersIn: range,
                              replacementString: string)
        else {
            return false
        }
        
        guard let text = textField.text else {
            return true
        }
        
        if text.count > 50 && string.count != 0 {
            return false
        }
        
        let regex = "^[0-9]*$"
        let format = NSPredicate(format: "SELF MATCHES %@" , regex).evaluate(with: string)
        
        return format
    }
}

class FcrAppUIRoomNameTextField: FcrAppUIIconTextField {
    override func textField(_ textField: UITextField,
                            shouldChangeCharactersIn range: NSRange,
                            replacementString string: String) -> Bool {
        guard super.textField(textField,
                              shouldChangeCharactersIn: range,
                              replacementString: string)
        else {
            return false
        }
        
        guard let text = textField.text else {
            return true
        }
        
        if text.count > 50 && string.count != 0 {
            return false
        }
        
        return true
    }
}
