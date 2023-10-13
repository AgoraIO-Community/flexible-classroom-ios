//
//  FcrAppUIPolicyString.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/8/15.
//  Copyright © 2023 Agora. All rights reserved.
//

import UIKit

struct FcrAppUIPolicyString {
    let privacyLink = "fcr_login_label_privacy_policy_link".localized()
    let tearmsLink = "fcr_login_label_terms_of_service_link".localized()
    
    let privacyText = "fcr_login_label_privacy_policy".localized()
    let tearmsText = "fcr_login_label_terms_of_service".localized()
    
    func loginDetailString() -> NSMutableAttributedString {
        let text = "fcr_login_popup_window_label_content".localized()
        
        return string(text,
                      foregroundColor: FcrAppUIColorGroup.fcr_v2_light_text2)
    }
    
    func loginString() -> NSMutableAttributedString {
        let text = "fcr_login_free_option_read_agree".localized()
        
        return string(text,
                      foregroundColor: FcrAppUIColorGroup.fcr_white)
    }
    
    func loginTitleString() -> String {
        let text = "fcr_login_popup_window_label_title_again".localized()
        
        return replace(text)
    }
    
    func loginDetailString2() -> NSMutableAttributedString {
        let text = "fcr_login_popup_window_label_content_again".localized()
        
        return string(text,
                      foregroundColor: FcrAppUIColorGroup.fcr_v2_light_text2)
    }
    
    func quickStartString() -> NSMutableAttributedString {
        let text = "fcr_login_free_option_read_agree".localized()
        
        return string(text,
                      foregroundColor: FcrAppUIColorGroup.fcr_v2_light_text2)
    }
    
    func toastString() -> String {
        let text = "fcr_login_free_tips_read_agree".localized()
        
        return replace(text)
    }
    
    private func string(_ string: String,
                        foregroundColor: UIColor) -> NSMutableAttributedString {
        let text = replace(string)
        
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttribute(.foregroundColor,
                                      value: foregroundColor,
                                      range: NSRange(location: 0, length: text.count))
        
        if let range = text.range(of: privacyText) {
            attributedString.addAttribute(.link,
                                           value: privacyLink,
                                           range: NSRange(range, in: text))
        }
        
        if let range = text.range(of: tearmsText) {
            attributedString.addAttribute(.link,
                                           value: tearmsLink,
                                           range: NSRange(range, in: text))
        }
        
        return attributedString
    }
    
    private func replace(_ string: String) -> String {
        var text = string
        
        text = text.replacingOccurrences(of: "{xxx}",
                                         with: privacyText)
        
        text = text.replacingOccurrences(of: "{yyy}",
                                         with: tearmsText)
        
        return text
    }
}
