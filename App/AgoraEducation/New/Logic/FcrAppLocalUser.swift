//
//  FcrAppLocalUser.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/7/6.
//  Copyright © 2023 Agora. All rights reserved.
//

import Foundation
import WebKit

protocol FcrAppLocalUserDelegate: NSObjectProtocol {
    func onLogOut()
}

class FcrAppLocalUser {
    weak var delegate: FcrAppLocalUserDelegate?
    
    var nickName: String
    
    init(nickName: String) {
        self.nickName = nickName
    }
    
//    func logOut(completion: @escaping FcrAppCompletion?) {
//        let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
//        let fromDate = Date(timeIntervalSince1970: 0)
//        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes,
//                                                modifiedSince: fromDate) { [weak self] in
//            self?.delegate?.onLogOut()
//
//            completion?()
//        }
//    }
}
