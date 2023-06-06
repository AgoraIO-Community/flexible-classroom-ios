//
//  DebugModels.swift
//  AgoraEducation
//
//  Created by LYY on 2022/8/5.
//  Copyright © 2022 Agora. All rights reserved.
//

#if canImport(AgoraClassroomSDK_iOS)
import AgoraClassroomSDK_iOS
#endif

#if canImport(AgoraEduUI)
import AgoraEduUI
#endif

#if canImport(AgoraProctorSDK)
import AgoraProctorSDK
#endif

// text
enum DataSourceRoomName: Equatable {
    case none
    case value(String)
    
    var viewText: String {
        switch self {
        case .none:             return ""
        case .value(let value): return value
        }
    }
}

enum DataSourceUserName: Equatable {
    case none
    case value(String)
    
    var viewText: String {
        switch self {
        case .none:             return ""
        case .value(let value): return value
        }
    }
}

enum DataSourceStartTime {
    case none
    case value(Int64)
    
    var timeInterval: TimeInterval {
        switch self {
        case .none:             return Date().timeIntervalSince1970
        case .value(let value): return TimeInterval(value)
        }
    }
}

enum DataSourceDuration {
    case none
    case value(Int64)
    
    var viewText: String {
        switch self {
        case .none:             return ""
        case .value(let value): return "\(value)"
        }
    }
}

enum DataSourceEncryptKey {
    case none
    case value(String)
    
    var viewText: String {
        switch self {
        case .none:             return ""
        case .value(let value): return "\(value)"
        }
    }
}

// option
enum DataSourceRoomType: CaseIterable {
    case unselected
    case oneToOne
    case small
    case lecture
    case proctor
    
    static var allCases: [DataSourceRoomType] {
        return [.oneToOne,
                .small,
                .lecture,
                .proctor]
    }
    
    var viewText: String {
        switch self {
        case .oneToOne:     return "debug_onetoone".ag_localized()
        case .small:        return "debug_small".ag_localized()
        case .lecture:      return "debug_lecture".ag_localized()
        case .proctor:      return "debug_proctor".ag_localized()
        case .unselected:   return ""
        }
    }
    
    #if canImport(AgoraClassroomSDK_iOS)
    var edu: AgoraEduRoomType? {
        switch self {
        case .oneToOne:     return .oneToOne
        case .small:        return .small
        case .lecture:      return .lecture
        case .proctor:      return nil
        case .unselected:   return nil
        }
    }
    #endif
    
    var tag: Int {
        switch self {
        case .oneToOne:     return 0
        case .small:        return 4
        case .lecture:      return 2
        case .proctor:      return 6
        case .unselected:   return 4
        }
    }
}

enum DataSourceMediaLatency: CaseIterable {
    case low
    case ultraLow
    
    var viewText: String {
        switch self {
        case .low:       return "low"
        case .ultraLow:  return "ultraLow"
        }
    }
    
    var edu: AgoraEduLatencyLevel {
        switch self {
        case .low:      return .low
        case .ultraLow: return .ultraLow
        }
    }
}

enum DataSourceRoleType: Int, CaseIterable {
    case unselected
    case teacher = 1
    case student = 2
    case observer = 4
    
    static var allCases: [DataSourceRoleType] {
        return [.teacher, .student, .observer]
    }
    
    var viewText: String {
        switch self {
        case .teacher:      return "debug_role_teacher".ag_localized()
        case .student:      return "debug_role_student".ag_localized()
        case .observer:     return "debug_role_observer".ag_localized()
        case .unselected:   return ""
        }
    }
    
    #if canImport(AgoraClassroomSDK_iOS)
    var edu: AgoraEduUserRole? {
        switch self {
        case .teacher:      return .teacher
        case .student:      return .student
        case .observer:     return .observer
        case .unselected:   return nil
        }
    }
    #endif
}

enum DataSourceDeviceType: String, CaseIterable {
    case main
    case sub
    
    var viewText: String {
        switch self {
        case .main:     return "debug_device_main".ag_localized()
        case .sub:      return "debug_device_sub".ag_localized()
        }
    }
}

enum DataSourceIMType: CaseIterable {
    case rtm
    case easemob
    
    var viewText: String {
        switch self {
        case .rtm:      return "rtm"
        case .easemob:  return "easemob"
        }
    }
}

enum DataSourceEncryptMode: CaseIterable {
    case none
    case SM4128ECB
    case AES128GCM2
    case AES256GCM2
    
    var viewText: String {
        switch self {
        case .none:         return "None"
        case .SM4128ECB:    return "sm4-128-ecb"
        case .AES128GCM2:   return "aes-128-gcm2"
        case .AES256GCM2:   return "aes-256-gcm2"
        }
    }
    
    #if canImport(AgoraClassroomSDK_iOS)
    var edu: AgoraEduMediaEncryptionMode {
        switch self {
        case .none:         return .none
        case .SM4128ECB:    return .SM4128ECB
        case .AES128GCM2:   return .AES128GCM2
        case .AES256GCM2:   return .AES256GCM2
        }
    }
    #endif
    
    #if canImport(AgoraProctorSDK)
    var proctor: AgoraProctorMediaEncryptionMode {
        switch self {
        case .none:         return .none
        case .SM4128ECB:    return .SM4128ECB
        case .AES128GCM2:   return .AES128GCM2
        case .AES256GCM2:   return .AES256GCM2
        }
    }
    #endif
}

enum DataSourceMediaAuth: CaseIterable {
    case none
    case audio
    case video
    case both
    
    var viewText: String {
        switch self {
        case .none:     return "debug_auth_none".ag_localized()
        case .audio:    return "debug_auth_audio".ag_localized()
        case .video:    return "debug_auth_video".ag_localized()
        case .both:     return "debug_auth_both".ag_localized()
        }
    }
}

enum DataSourceUIMode: Int, CaseIterable {
    case light = 0
    case dark = 1
    
    var viewText: String {
        switch self {
        case .light: return "settings_theme_light".ag_localized()
        case .dark:  return "settings_theme_dark".ag_localized()
        }
    }
    
    var edu: AgoraUIMode {
        switch self {
        case .light: return .agoraLight
        case .dark:  return .agoraDark
        }
    }
}

enum DataSourceUILanguage: CaseIterable {
    case zh_cn
    case en
    
    var viewText: String {
        switch self {
        case .zh_cn:    return "debug_uiLanguage_zh_cn".ag_localized()
        case .en:       return "debug_uiLanguage_en".ag_localized()
        }
    }
    
    var edu: FcrSurpportLanguage {
        switch self {
        case .zh_cn:    return .zh_cn
        case .en:       return .en
        }
    }
}

enum DataSourceRegion:String, CaseIterable {
    case CN
    case NA
    case EU
    case AP
    
    var viewText: String {
        return rawValue
    }
    
    #if canImport(AgoraClassroomSDK_iOS)
    var edu: AgoraEduRegion {
        switch self {
        case .CN:   return .CN
        case .NA:   return .NA
        case .EU:   return .EU
        case .AP:   return .AP
        }
    }
    #endif
    
    #if canImport(AgoraProctorSDK)
    var proctor: AgoraProctorRegion {
        switch self {
        case .CN:   return .CN
        case .NA:   return .NA
        case .EU:   return .EU
        case .AP:   return .AP
        }
    }
    #endif
    
    var env: FcrEnvironment.Region {
        switch self {
        case .CN:   return .CN
        case .NA:   return .NA
        case .EU:   return .EU
        case .AP:   return .AP
        }
    }
}

enum DataSourceEnvironment: CaseIterable {
    case dev
    case pre
    case pro
    
    var viewText: String {
        switch self {
        case .dev:      return "debug_env_test".ag_localized()
        case .pre:      return "debug_pre_test".ag_localized()
        case .pro:      return "debug_pro_test".ag_localized()
        }
    }
    
    var edu: FcrEnvironment.Environment {
        switch self {
        case .dev:   return .dev
        case .pre:   return .pre
        case .pro:   return .pro
        }
    }
}

// MARK: - main
enum DataSourceType: Equatable {
    case roomName(DataSourceRoomName)
    case userName(DataSourceUserName)
    case roomType(DataSourceRoomType)
    case mediaLatency(DataSourceMediaLatency)
    case roleType(DataSourceRoleType)
    case im(DataSourceIMType)
    case deviceType(DataSourceDeviceType)
    case startTime(DataSourceStartTime)
    case duration(DataSourceDuration)
    case encryptKey(DataSourceEncryptKey)
    case encryptMode(DataSourceEncryptMode)
    case mediaAuth(DataSourceMediaAuth)
    case uiMode(DataSourceUIMode)
    case uiLanguage(DataSourceUILanguage)
    case region(DataSourceRegion)
    case environment(DataSourceEnvironment)
    
    enum Key {
        case roomName, roomType, mediaLatency, startTime, duration
        case userName, roleType, deviceType
        case encryptKey, encryptMode, mediaAuth, serviceType
        case im, uiMode, uiLanguage
        case region, environment
    }
    
    var inKey: Key {
        switch self {
        case .roomName:     return .roomName
        case .userName:     return .userName
        case .roomType:     return .roomType
        case .mediaLatency: return .mediaLatency
        case .roleType:     return .roleType
        case .im:           return .im
        case .deviceType:   return .deviceType
        case .startTime:    return .startTime
        case .duration:     return .duration
        case .encryptKey:   return .encryptKey
        case .encryptMode:  return .encryptMode
        case .mediaAuth:    return .mediaAuth
        case .uiMode:       return .uiMode
        case .uiLanguage:   return .uiLanguage
        case .region:       return .region
        case .environment:  return .environment
        }
    }
    
    static func == (lhs: DataSourceType,
                    rhs: DataSourceType) -> Bool {
        return (lhs.inKey == rhs.inKey)
    }
    
    var title: String {
        switch self {
        case .roomName:      return "debug_room_title".ag_localized()
        case .userName:      return "debug_user_title".ag_localized()
        case .roomType:      return "debug_class_type_title".ag_localized()
        case .mediaLatency:  return "Latency"
        case .roleType:      return "debug_title_role".ag_localized()
        case .im:            return "IM"
        case .deviceType:    return "debug_device_type".ag_localized()
        case .startTime:     return "debug_startTime_title".ag_localized()
        case .duration:      return "debug_duration_title".ag_localized()
        case .encryptKey:    return "debug_encryptKey_title".ag_localized()
        case .encryptMode:   return "debug_encryption_mode_title".ag_localized()
        case .mediaAuth:     return "debug_authMedia_title".ag_localized()
        case .uiMode:        return "debug_uiMode_title".ag_localized()
        case .uiLanguage:    return "debug_uiLanguage_title".ag_localized()
        case .region:        return "debug_region_title".ag_localized()
        case .environment:   return "debug_env_title".ag_localized()
        }
    }
    
    var placeholder: String {
        switch self {
        case .roomName:      return "debug_room_holder".ag_localized()
        case .userName:      return "debug_user_holder".ag_localized()
        case .roomType:      return "debug_type_holder".ag_localized()
        case .mediaLatency:  return "debug_media_latency_holder".ag_localized()
        case .roleType:      return "debug_role_holder".ag_localized()
        case .im:            return "debug_service_type_holder".ag_localized()
        case .deviceType:    return "debug_device_holder".ag_localized()
        case .startTime:     return ""
        case .duration:      return "debug_duration_holder".ag_localized()
        case .encryptKey:    return "debug_encryptKey_holder".ag_localized()
        case .encryptMode:   return "debug_encryption_mode_holder".ag_localized()
        case .mediaAuth:     return "debug_authMedia_holder".ag_localized()
        case .uiMode:        return "debug_uiMode_holder".ag_localized()
        case .uiLanguage:    return "debug_region_holder".ag_localized()
        case .region:        return "debug_region_title".ag_localized()
        case .environment:   return "debug_env_holder".ag_localized()
        }
    }
}

// MARK: - view models
enum DebugInfoCellType {
    case text(placeholder: String,
              text: String?,
              textWarning: Bool = false,
              action: CellTextEndEditingAction)
    case option(options: [(String, OptionSelectedAction)],
                placeholder: String,
                text: String?,
                selectedIndex: Int)
    case time(timeInterval: TimeInterval,
              action: CellTimePickedAction)
}

struct DebugInfoCellModel {
    var title: String
    var type: DebugInfoCellType
}

// MARK: - launch
/** 入参模型*/
struct DebugLaunchInfo {
    var roomName: String
    var roomId: String
    var userName: String
    var userId: String
    var mediaLatency: DataSourceMediaLatency
    var roomType: DataSourceRoomType
    var roleType: DataSourceRoleType
    var im: DataSourceIMType
    var deviceType: DataSourceDeviceType
    var duration: NSNumber?
    var encryptKey: String?
    var encryptMode: DataSourceEncryptMode
    
    var startTime: NSNumber?
    
    var mediaAuth: DataSourceMediaAuth
    var region: DataSourceRegion
    var uiMode: DataSourceUIMode
    var uiLanguage: DataSourceUILanguage
    var environment: DataSourceEnvironment
    
    #if canImport(AgoraClassroomSDK_iOS)
    var eduEncryptionConfig: AgoraEduMediaEncryptionConfig? {
        let modeRawValue = encryptMode.edu.rawValue
        guard (modeRawValue > 0 && modeRawValue <= 6),
              let key = encryptKey else {
            return nil
        }
        let encryptionConfig = AgoraEduMediaEncryptionConfig(mode: encryptMode.edu,
                                                             key: key)
        return encryptionConfig
    }
    
    var eduMediaOptions: AgoraEduMediaOptions {
        let latencyLevel = mediaLatency.edu
        let encryptionConfig = eduEncryptionConfig
        
        let videoState: AgoraEduStreamState = (mediaAuth == .video || mediaAuth == .both) ? .on : .off
        let audioState: AgoraEduStreamState = (mediaAuth == .audio || mediaAuth == .both) ? .on : .off
        let mediaOptions = AgoraEduMediaOptions(encryptionConfig: encryptionConfig,
                                                videoEncoderConfig: nil,
                                                latencyLevel: latencyLevel,
                                                videoState: videoState,
                                                audioState: audioState)
        
        return mediaOptions
    }
    #endif
    
    #if canImport(AgoraProctorSDK)
    var proctorEncryptionConfig: AgoraProctorMediaEncryptionConfig? {
        let modeRawValue = encryptMode.proctor.rawValue
        
        guard (modeRawValue > 0 && modeRawValue <= 6),
              let key = encryptKey else {
            return nil
        }
        
        let encryptionConfig = AgoraProctorMediaEncryptionConfig(key: key,
                                                                 mode: encryptMode.proctor)
        return encryptionConfig
    }
    
    var proctorLatencyLevel: AgoraProctorLatencyLevel {
        let latencyLevel = AgoraProctorLatencyLevel.ultraLow
        return latencyLevel
    }
    
    var proctorMediaOptions: AgoraProctorMediaOptions {
        let latencyLevel = proctorLatencyLevel
        let encryptionConfig = proctorEncryptionConfig
        let videoEncoderCofig = AgoraProctorVideoEncoderConfig()
        
        let mediaOptions = AgoraProctorMediaOptions(videoEncoderConfig: videoEncoderCofig,
                                                    encryptionConfig: encryptionConfig,
                                                    latencyLevel: latencyLevel)
        
        return mediaOptions
    }
    #endif
}

extension FcrSurpportLanguage {
    var string: String? {
        switch self {
        case .zh_cn: return "zh-Hans"
        case .en:    return "en"
        default:     return nil
        }
    }
}

extension Array where Element == DataSourceType {
    func indexOfType(_ typeKey: DataSourceType.Key) -> Int? {
        return self.firstIndex(where: {typeKey == $0.inKey})
    }
    
    func valueOfType(_ typeKey: DataSourceType.Key) -> Any? {
        guard let index = indexOfType(typeKey) else {
            return nil
        }
        let value = self[index]
        return value
    }
}
