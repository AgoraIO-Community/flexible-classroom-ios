//
//  FcrAppEnums.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/6.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

enum FcrAppRegion: String, FcrAppStringRawRepresentable, CaseIterable {
    case CN, NA
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

enum FcrAppMediaStreamLatency: String, FcrAppStringRawRepresentable, CaseIterable {
    case low, ultraLow
}

enum FcrAppRoomType: Int, FcrAppCodable {
    case oneToOne    = 0
    case lectureHall = 2
    case smallClass  = 4
    case proctor     = 6
}

enum FcrAppRoomState: Int, FcrAppCodable {
    case unstarted, inProgress, closed
}

enum FcrAppUserRole: Int, FcrAppCodable {
    case teacher
    case student
    case audience
}

protocol FcrAppStringRawRepresentable: RawRepresentable where Self.RawValue == String {}

protocol FcrAppIntRawRepresentable: RawRepresentable where Self.RawValue == Int {}
