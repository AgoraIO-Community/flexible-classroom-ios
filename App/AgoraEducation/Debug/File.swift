//
//  File.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/6/29.
//  Copyright © 2023 Agora. All rights reserved.
//

import Foundation

struct FcrAppError: Error {
    var code: Int
    var message: String
    
    func description() -> String {
        return "code: \(code), message: \(message)"
    }
}

fileprivate let PrivacyAgreementKey = "com.agora.privacyTermsAgree"
fileprivate let AccessTokenKey = "com.agora.accessToken"
fileprivate let RefreshTokenKey = "com.agora.refreshToken"
fileprivate let CompanyIdKey = "com.agora.companyId"
fileprivate let NickNameKey = "com.agora.nickname"
fileprivate let ThemeKey = "com.agora.theme"
fileprivate let kQAMode = "com.agora.qaMode"

