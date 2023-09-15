//
//  FcrAppUIRoomIdTextField.swift
//  FlexibleClassroom
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
        if let string = text,
           !string.isEmpty {
            return string
        } else {
            return nil
        }
    }
}

class FcrAppUIIconTextField: FcrAppUITextField,
                             AgoraUIContentContainer {
    enum LeftViewType {
        case image, text
    }
    
    private var clearButtonFrame = CGRect(x: 0,
                                          y: 0,
                                          width: 16,
                                          height: 16)
    
    private let clearButtonRight: CGFloat = 22
    
    private let clearButton = UIButton(frame: .zero)
    
    let leftImageSize: CGSize
    let leftTextWidth: CGFloat
    let leftAreaOffsetX: CGFloat
    let editAreaOffsetX: CGFloat
    
    let leftImageView = UIImageView(frame: .zero)
    let leftLabel = UILabel(frame: .zero)
    
    let lineView = UIView(frame: .zero)
    
    let leftViewType: LeftViewType
    
    init(leftViewType: LeftViewType,
         leftImageSize: CGSize = CGSize.zero,
         leftTextWidth: CGFloat = 80,
         leftAreaOffsetX: CGFloat = 0,
         editAreaOffsetX: CGFloat = 10) {
        self.leftViewType = leftViewType
        
        self.leftImageSize = leftImageSize
        self.leftTextWidth = leftTextWidth
        self.leftAreaOffsetX = leftAreaOffsetX
        self.editAreaOffsetX = editAreaOffsetX
        
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
        
        clearButton.setImage(UIImage(named: "fcr_clear_button"),
                             for: .normal)
        
        clearButton.addTarget(self,
                              action: #selector(onClearPressed),
                              for: .touchUpInside)
        
        rightView = clearButton
        rightViewMode = .whileEditing
        
        leftViewMode = .always
        
        returnKeyType = .done
    }
    
    @objc private func onClearPressed() {
        text = nil
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
        
        lineView.backgroundColor = FcrAppUIColorGroup.fcr_v2_line
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        switch leftViewType {
        case .image:
            let x: CGFloat = leftAreaOffsetX
            let y: CGFloat = (bounds.height - leftImageSize.height) / 2
            let height: CGFloat = leftImageSize.height
            let width: CGFloat = leftImageSize.width
            
            return CGRect(x: x,
                          y: y,
                          width: width,
                          height: height)
        case .text:
            let x: CGFloat = leftAreaOffsetX
            let y: CGFloat = 0
            let height: CGFloat = bounds.height
            let width: CGFloat = leftTextWidth
            
            return CGRect(x: x,
                          y: y,
                          width: width,
                          height: height)
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.textRect(forBounds: bounds)
        
        rect.origin.x += editAreaOffsetX
        
        var width: CGFloat = bounds.width - rect.origin.x
        
        width -= (clearButtonRight * 2 + clearButton.width)
        
        rect.size.width = width
        
        return rect
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        var x: CGFloat = 0
        
        if let view = leftView {
            x = view.frame.maxX + editAreaOffsetX
        }
        
        var width: CGFloat = bounds.width - x
        
        width -= (clearButtonRight * 2 + clearButton.width)
        
        return CGRect(x: x,
                      y: 0,
                      width: width,
                      height: height)
    }
        
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var x: CGFloat = 0
        
        if let view = leftView {
            x = view.frame.maxX + editAreaOffsetX
        }
        
        var width: CGFloat = bounds.width - x
        
        width -= (clearButtonRight * 2 + clearButton.width)
        
        return CGRect(x: x,
                      y: 0,
                      width: width,
                      height: height)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let width: CGFloat = clearButtonFrame.width
        let height: CGFloat = width
        let x: CGFloat = bounds.width - width - clearButtonRight
        let y: CGFloat = (bounds.height - height) * 0.5
        
        clearButtonFrame = CGRect(x: x,
                                  y: y,
                                  width: width,
                                  height: height)
        
        return clearButtonFrame
    }
}

class FcrAppUIRoomIdTextField: FcrAppUIIconTextField {
    private var maxCount = (9 + 2)
    
    override init(leftViewType: FcrAppUIIconTextField.LeftViewType,
                  leftImageSize: CGSize = CGSize.zero,
                  leftTextWidth: CGFloat = 80,
                  leftAreaOffsetX: CGFloat = 0,
                  editAreaOffsetX: CGFloat = 10) {
        super.init(leftViewType: leftViewType,
                   leftImageSize: leftImageSize,
                   leftTextWidth: leftTextWidth,
                   leftAreaOffsetX: leftAreaOffsetX,
                   editAreaOffsetX: editAreaOffsetX)
        
        keyboardType = .numberPad
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getText() -> String? {
        let text = super.getText()
        
        if let string = text {
            let finalText = string.replacingOccurrences(of: " ",
                                                        with: "")
            
            if !finalText.isEmpty {
                return finalText
            } else {
                return nil
            }
        } else {
            return text
        }
    }
    
    func setShowText(_ text: String?) {
        guard let text = text else {
            return
        }
        
        let string = getShowText(text)
        
        guard string.count <= maxCount else {
            return
        }
        
        self.text = string
    }
    
    func getShowText(_ text: String) -> String {
        // 去除输入中的空格
        var updatedText = text.replacingOccurrences(of: " ",
                                                    with: "")
        
        var finalText = ""
        let maxDigits = 3
        
        // 每三个数字空一格
        while updatedText.count > 0 {
            let subString = String(updatedText.prefix(maxDigits))
            finalText += subString + " "
            
            updatedText = String(updatedText.dropFirst(maxDigits))
        }
        
        // 去除最后的空格
        finalText = finalText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return finalText
    }
    
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
        
        if text.count >= maxCount && string.count != 0 {
            return false
        }
        
        // 只能输入数字
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }
        
        // 每三个数字空一格
        if let currentText = textField.text,
            let rangeOfTextToReplace = Range(range, in: currentText) {
            
            let updatedText = currentText.replacingCharacters(in: rangeOfTextToReplace,
                                                              with: string)
            
            textField.text = getShowText(updatedText)
            return false
        }
        
        return true
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
