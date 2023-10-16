//
//  FcrAppUIPolicyString.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/8/15.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

struct FcrAppUIPolicyString {
    let privacyText = "fcr_login_label_privacy_policy".localized()
    let tearmsText = "fcr_login_label_terms_of_service".localized()
    
    func getPrivacyLink(isMainLandChina: Bool) -> String {
        let language = isMainLandChina ? "zh-Hans" : "en"
        
        let privacyLink = "fcr_login_label_privacy_policy_link".localized(with: language)
        
        return privacyLink
    }
    
    func getTearmsLink(isMainLandChina: Bool) -> String {
        let language = isMainLandChina ? "zh-Hans" : "en"
        
        let tearmsLink = "fcr_login_label_terms_of_service_link".localized(with: language)
        
        return tearmsLink
    }
    
    func loginDetailString(isMainLandChina: Bool) -> NSMutableAttributedString {
        var text = "fcr_login_popup_window_label_content".localized()
        
        text = ifNeedTearms(text,
                            isMainLandChina: isMainLandChina)
        
        return string(text,
                      foregroundColor: FcrAppUIColorGroup.fcr_v2_light_text2,
                      isMainLandChina: isMainLandChina)
    }
    
    func loginString(isMainLandChina: Bool) -> NSMutableAttributedString {
        var text = "fcr_login_free_option_read_agree".localized()
        
        text = ifNeedTearms(text,
                            isMainLandChina: isMainLandChina)
        
        return string(text,
                      foregroundColor: FcrAppUIColorGroup.fcr_white,
                      isMainLandChina: isMainLandChina)
    }
    
    func loginTitleString(isMainLandChina: Bool) -> String {
        var text = "fcr_login_popup_window_label_title_again".localized()
        
        text = ifNeedTearms(text,
                            isMainLandChina: isMainLandChina)
        
        return replace(text)
    }
    
    func loginDetailString2(isMainLandChina: Bool) -> NSMutableAttributedString {
        var text = "fcr_login_popup_window_label_content_again".localized()
        
        text = ifNeedTearms(text,
                            isMainLandChina: isMainLandChina)
        
        return string(text,
                      foregroundColor: FcrAppUIColorGroup.fcr_v2_light_text2,
                      isMainLandChina: isMainLandChina)
    }
    
    func quickStartString(isMainLandChina: Bool) -> NSMutableAttributedString {
        var text = "fcr_login_free_option_read_agree".localized()
        
        text = ifNeedTearms(text,
                            isMainLandChina: isMainLandChina)
        
        return string(text,
                      foregroundColor: FcrAppUIColorGroup.fcr_v2_light_text2,
                      isMainLandChina: isMainLandChina)
    }
    
    func toastString() -> String {
        let text = "fcr_login_free_tips_read_agree".localized()
        
        return replace(text)
    }
    
    private func string(_ string: String,
                        foregroundColor: UIColor,
                        isMainLandChina: Bool) -> NSMutableAttributedString {
        let text = replace(string)
        
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttribute(.foregroundColor,
                                      value: foregroundColor,
                                      range: NSRange(location: 0, length: text.count))
        
        if let range = text.range(of: privacyText) {
            attributedString.addAttribute(.link,
                                           value: getPrivacyLink(isMainLandChina: isMainLandChina),
                                           range: NSRange(range, in: text))
        }
        
        if let range = text.range(of: tearmsText) {
            attributedString.addAttribute(.link,
                                           value: getTearmsLink(isMainLandChina: isMainLandChina),
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
    
    private func ifNeedTearms(_ string: String,
                              isMainLandChina: Bool) -> String {
        var text = string
        
        let isChinese = UIDevice.current.agora_is_chinese_language
        
        if isMainLandChina,
           !isChinese {
            text = text.replacingOccurrences(of: "{yyy}",
                                             with: "{xxx} and {yyy}")
            
        }
        
        return text
    }
}
