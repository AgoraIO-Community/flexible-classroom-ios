//
//  FcrAppUIEnums.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/7/13.
//  Copyright © 2023 Agora. All rights reserved.
//

import Foundation

typealias FcrAppUIRoomType  = FcrAppRoomType
typealias FcrAppUIRoomState = FcrAppRoomState

extension FcrAppUIRoomType {
    func text() -> String {
        switch self {
        case .oneToOne:     return "fcr_create_onetoone_title".localized()
        case .smallClass:   return "fcr_create_small_title".localized()
        case .lectureHoll:  return "fcr_create_lecture_title".localized()
        case .proctor:      return "pt_home_page_scene_option_online_proctoring".localized()
        }
    }
}

extension FcrAppUIRoomState {
    func text() -> String {
        switch self {
        case .unstarted:   return "fcr_room_list_upcoming".localized()
        case .inProgress:  return "fcr_room_list_live_now".localized()
        case .closed:      return "fcr_room_list_closed".localized()
        }
    }
}
