//
//  FcrAppUIRoomIdTextField.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/7/24.
//  Copyright © 2023 Agora. All rights reserved.
//

import UIKit

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

class FcrAppUIRoomIdTextField: FcrAppUITextField {
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

class FcrAppUIRoomNameTextField: FcrAppUITextField {
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
