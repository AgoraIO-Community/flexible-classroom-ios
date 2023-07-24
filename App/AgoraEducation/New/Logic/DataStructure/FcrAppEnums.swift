//
//  FcrAppEnums.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/6.
//  Copyright © 2023 Agora. All rights reserved.
//

import Foundation

enum FcrAppRegion: String, CaseIterable {
    case CN, NA
}

enum FcrAppUIMode: Int, CaseIterable {
    case light, dark
}

enum FcrAppEnvironment: String {
    case dev, pre, pro
}

enum FcrAppLanguage: String, CaseIterable {
    case zh_cn, en
}

enum FcrAppRoomType: Int, FcrAppCodable {
    case oneToOne    = 0
    case lectureHoll = 2
    case smallClass  = 4
    case proctor     = 6
}

enum FcrAppRoomState: Int, FcrAppCodable {
    case unstarted, inProgress, closed
}

enum FcrAppUserRole: Int, FcrAppCodable {
    case teacher = 1
    case student = 2
}
