//
//  FcrAppEnums.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/6.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

enum FcrAppRegion: String, FcrAppStringRawRepresentable, CaseIterable {
    case CN, NA, AP, EU
}

enum FcrAppUIMode: String, FcrAppStringRawRepresentable, CaseIterable {
    case light, dark
    
    func toAgoraType() -> AgoraUIMode {
        switch self {
        case .dark:  return .agoraDark
        case .light: return .agoraLight
        }
    }
}

enum FcrAppEnvironment: String, FcrAppStringRawRepresentable, CaseIterable {
    case dev, pt, pre, pro
    
    var intValue: Int {
        switch self {
        case .dev: return 1
        case .pt:  return 2
        case .pre: return 3
        case .pro: return 4
        }
    }
}

enum FcrAppLanguage: String, FcrAppStringRawRepresentable, CaseIterable {
    case zh_cn, en
    
    var isEN: Bool {
        switch self {
        case .en:    return true
        case .zh_cn: return false
        }
    }
    
    func proj() -> String {
        switch self {
        case .zh_cn: return "zh-Hans"
        case .en:    return "en"
        }
    }
}

enum FcrAppMediaStreamLatency: Int, FcrAppIntRawRepresentable, CaseIterable, FcrAppCodable {
    case low = 1, ultraLow = 2
}

enum FcrAppRoomType: Int, FcrAppCodable {
    case oneToOne    = 0
    case lectureHall = 2
    case smallClass  = 4
    case proctor     = 6
    case cloudClass  = 10
    
    var isValid: Bool {
        switch self {
        case .cloudClass: return false
        default:          return true
        }
    }
}

enum FcrAppRoomState: Int, FcrAppCodable {
    case unstarted, inProgress, closed
}

enum FcrAppUserRole: Int, FcrAppCodable {
    case teacher  = 1
    case student  = 2
    case audience = 4
}

protocol FcrAppStringRawRepresentable: RawRepresentable where Self.RawValue == String {}

protocol FcrAppIntRawRepresentable: RawRepresentable where Self.RawValue == Int {}
