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
    
    func getText() -> String? {
        if let string = text, !string.isEmpty {
            return string
        } else {
            return nil
        }
    }
}

class FcrAppUIIconTextField: FcrAppUITextField, AgoraUIContentContainer {
    enum LeftViewType {
        case image, text
    }
    
    let leftImageView = UIImageView(frame: .zero)
    let leftLabel = UILabel(frame: .zero)
    
    let lineView = UIView(frame: .zero)
    
    let leftViewType: LeftViewType
    
    init(leftViewType: LeftViewType) {
        self.leftViewType = leftViewType
        super.init(frame: .zero)
        initViews()
        initViewFrame()
        updateViewProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(lineView)
        
        switch leftViewType {
        case .image:
            leftImageView.contentMode = .scaleAspectFit
            leftView = leftImageView
        case .text:
            leftLabel.textAlignment = .left
            leftView = leftLabel
        }
        
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
        switch leftViewType {
        case .text:
            leftLabel.font = UIFont.systemFont(ofSize: 15)
            leftLabel.textColor = FcrAppUIColorGroup.fcr_v2_light_text1
        default:
            break
        }
        
        if let color = UIColor(hexString: "#BDBEC6") {
            setPlaceHolderTextColor(color)
        }
        
        textColor = .black
        
        lineView.backgroundColor = UIColor(hexString: "#EFEFEF")
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let horizontalSpace: CGFloat = 12
        
        let x: CGFloat = 10
        let y: CGFloat = horizontalSpace
        let height: CGFloat = bounds.height - (horizontalSpace * 2)
        let width: CGFloat = height
        
        return CGRect(x: x,
                      y: y,
                      width: width,
                      height: height)
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let width: CGFloat = 16
        let height: CGFloat = width
        let x: CGFloat = bounds.width - width - 22
        let y: CGFloat = (bounds.height - height) * 0.5
        
        return CGRect(x: x,
                      y: y,
                      width: width,
                      height: height)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        var x: CGFloat = 0
        
        if let view = leftView {
            x = view.frame.maxX + 10
        }
        
        var width: CGFloat = bounds.width - x
        
        if let view = rightView {
            width -= (bounds.width - view.frame.minX)
        }
        
        return CGRect(x: x,
                      y: 0,
                      width: width,
                      height: height)
    }
        
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var x: CGFloat = 0
        
        if let view = leftView {
            x = view.frame.maxX + 10
        }
        
        var width: CGFloat = bounds.width - x
        
        if let view = rightView {
            width -= (bounds.width - view.frame.minX)
        }
        
        return CGRect(x: x,
                      y: 0,
                      width: width,
                      height: height)
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

class FcrAppUIUserNameTextField: FcrAppUIIconTextField {
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
        
        if text.count > 20 && string.count != 0 {
            return false
        }
        
        return true
    }
}
