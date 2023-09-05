//
//  FcrAppUIEnums.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/13.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraClassroomSDK_iOS
import Foundation

typealias FcrAppUIRoomState   = FcrAppRoomState
typealias FcrAppUILanguage    = FcrAppLanguage
typealias FcrAppUIRoomType    = FcrAppRoomType
typealias FcrAppUIRegion      = FcrAppRegion
typealias FcrAppUIUserRole    = FcrAppUserRole
typealias FcrAppUIDateType    = Calendar.Component
typealias FcrAppUIEnvironment = FcrAppEnvironment

extension FcrAppUIRoomType {
    func text() -> String {
        switch self {
        case .oneToOne:     return "fcr_home_label_class_mode_1on1".localized()
        case .smallClass:   return "fcr_home_label_class_mode_small_classroom".localized()
        case .lectureHall:  return "fcr_home_label_class_mode_lecture_hall".localized()
        case .proctor:      return "fcr_home_label_class_mode_proctoring".localized()
        }
    }
    
    func quickText() -> String {
        switch self {
        case .smallClass:   return "fcr_login_free_class_mode_option_small_classroom".localized()
        case .oneToOne:     return "fcr_login_free_class_mode_option_1on1".localized()
        case .lectureHall:  return "fcr_login_free_class_mode_option_lecture_hall".localized()
        case .proctor:      return "fcr_login_free_class_mode_option_proctoring".localized()
        }
    }
    
    func toClassroomType() -> AgoraEduRoomType {
        switch self {
        case .oneToOne:     return .oneToOne
        case .lectureHall:  return .lecture
        case .smallClass:   return .small
        default:            fatalError()
        }
    }
}

extension FcrAppUIUserRole {
    func toClassroomType() -> AgoraEduUserRole {
        switch self {
        case .student:     return .student
        case .teacher:     return .teacher
        case .audience:    return .observer
        }
    }
}

extension FcrAppUILanguage {
    func text() -> String {
        switch self {
        case .zh_cn: return "fcr_settings_option_general_language_simplified".localized()
        case .en:    return "fcr_settings_option_general_language_english".localized()
        }
    }
}

extension FcrAppUIMode {
    func text() -> String {
        switch self {
        case .light: return "settings_theme_light".localized()
        case .dark:  return "settings_theme_dark".localized()
        }
    }
}

extension FcrAppUIRoomState {
    func text() -> String {
        switch self {
        case .unstarted:   return "fcr_home_label_status_upcoming".localized()
        case .inProgress:  return "fcr_home_label_status_live".localized()
        case .closed:      return "fcr_home_label_status_over".localized()
        }
    }
}

enum FcrAppUIQuickStartSegmentOption {
    case join, create
}

enum FcrAppUISettingItem {
    enum GeneralItem: CaseIterable {
        case nickname
        case language
        case region
        case theme
        case closeAccount
        case environment
        case roomDuration
        case quickStart
        
        static func startList() -> [GeneralItem] {
            return [.nickname,
                    .language,
                    .region,
                    .theme,
                    .closeAccount]
        }
        
        static func quickStartList() -> [GeneralItem] {
            return [.language,
                    .region,
                    .theme]
        }
        
        static func startTestList() -> [GeneralItem] {
            return [.nickname,
                    .language,
                    .region,
                    .theme,
                    .closeAccount,
                    .environment,
                    .quickStart]
        }
        
        static func quickStartTestList() -> [GeneralItem] {
            return [.language,
                    .region,
                    .theme,
                    .roomDuration,
                    .environment]
        }
    }
    
    enum AboutUsItem: CaseIterable {
        case privacy
        case terms
        case disclaimer
        case publish
    }
    
    case generalSetting([GeneralItem])
    case aboutUs([AboutUsItem])
}
