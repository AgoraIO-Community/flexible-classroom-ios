//
//  FcrAppEnums.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/6.
//  Copyright © 2023 Agora. All rights reserved.
//

import Foundation

enum FcrAppRegion: String, FcrAppStringRawRepresentable, CaseIterable {
    case CN, NA
}

enum FcrAppUIMode: Int, FcrAppIntRawRepresentable, CaseIterable {
    case light, dark
}

enum FcrAppEnvironment: String, FcrAppStringRawRepresentable, CaseIterable {
    case dev, pre, pro
}

enum FcrAppLanguage: String, FcrAppStringRawRepresentable, CaseIterable {
    case zh_cn, en
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
