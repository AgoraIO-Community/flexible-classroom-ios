//
//  FcrAppLocalUser.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/6.
//  Copyright © 2023 Agora. All rights reserved.
//

import Foundation
import WebKit

class FcrAppLocalUser {
    private let localStorage: FcrAppLocalStorage
    
    var userId: String
    
    var nickname: String {
        didSet {
            localStorage.writeData(nickname,
                                   key: .nickname)
        }
    }
    
    init(userId: String,
         nickname: String,
         localStorage: FcrAppLocalStorage) {
        self.userId = userId
        self.nickname = nickname
        self.localStorage = localStorage
    }
}
