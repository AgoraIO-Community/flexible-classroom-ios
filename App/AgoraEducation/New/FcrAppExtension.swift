//
//  FcrAppExtension.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2021/12/16.
//  Copyright © 2021 Agora. All rights reserved.
//

import AgoraUIBaseViews
import CommonCrypto
import Foundation
import UIKit

typealias FcrAppCompletion = () -> (Void)
typealias FcrAppSuccess = () -> (Void)
typealias FcrAppFailure = (FcrAppError) -> (Void)

extension Bundle {
    var version: String {
        guard let infoDictionary = infoDictionary,
              let version = infoDictionary["CFBundleShortVersionString"] as? String else {
            return ""
        }
        return version
    }
}

extension UIDevice {
    var isSmallPhone: Bool {
        guard UIDevice.current.agora_is_pad else {
            return false
        }
        
        if UIScreen.main.bounds.size.height < 700 {
            return true
        } else {
            return false
        }
    }
}

extension String {
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!,
               strLen,
               result)
        
        let hash = NSMutableString()
        
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deallocate()
        
        return hash as String
    }
}
