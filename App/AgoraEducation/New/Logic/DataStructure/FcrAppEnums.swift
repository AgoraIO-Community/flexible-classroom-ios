//
//  FcrAppEnums.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/7/6.
//  Copyright © 2023 Agora. All rights reserved.
//

import Foundation

enum FcrAppRegion: String {
    case CN, NA
}

enum FcrAppEnvironment: String {
    case dev, pre, pro
}

enum FcrAppRoomType: Int, FcrAppCodable {
    case oneToOne    = 0
    case lectureHoll = 2
    case smallClass  = 4
    case proctor     = 6
}

enum FcrAppRoomState: Int, FcrAppCodable {
    case unstarted  = 0
    case inProgress = 1
    case closed     = 2
}
