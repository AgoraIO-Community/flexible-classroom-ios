//
//  FcrAppUIPolicyString.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/8/15.
//  Copyright © 2023 Agora. All rights reserved.
//

import Foundation

struct FcrAppUIPolicyString {
    let privacyPolicyLink = ""
    let privacyPolicyText = ""
    
    let termsOfUseLink = "https://www.google.com"
    let termsOfUseText = "tearms of use"
    
    func getAttributedString(_ isEnglish: Bool) -> NSMutableAttributedString {
        
        var string = "fcr_login_free_option_read_agree".localized()
        
        if isEnglish {
            string = string.replacingOccurrences(of: "{zzz}",
                                                 with: termsOfUseText)
        } else {
            
        }
        
        let attributedString = NSMutableAttributedString(string: string)
        
        let range = NSRange(location: (string.count - termsOfUseText.count),
                            length: termsOfUseText.count)
        
        attributedString.addAttribute(.link,
                                      value: termsOfUseLink,
                                      range: range)
        
        return attributedString
    }
}
