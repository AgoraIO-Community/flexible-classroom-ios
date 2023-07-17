//
//  FcrEnvironment.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/7/7.
//  Copyright © 2022 Agora. All rights reserved.
//

#if canImport(AgoraClassroomSDK_iOS)
import AgoraClassroomSDK_iOS
#endif

#if canImport(AgoraProctorSDK)
import AgoraProctorSDK
#endif

import UIKit

class FcrEnvironment {
    
    private let kRegion = "com.agora.region"
    private let kEnvironment = "com.agora.environment"
    
    static let shared = FcrEnvironment()
    
    public var server = "https://api-solutions-dev.bj2.agoralab.co"
    
    enum Environment: String {
        case dev, pre, pro
    }
    
    enum Region: String {
        case CN, NA, EU, AP
        
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
    }
    // environment
    private lazy var _environment: Environment = {
        let saved = UserDefaults.standard.object(forKey: kEnvironment) as? String
        return Environment(rawValue: saved ?? "pro") ?? Environment.pro
    }()
    var environment: Environment {
        set {
            _environment = newValue
            UserDefaults.standard.set(newValue.rawValue, forKey: kEnvironment)
            updateBaseURL()
            updateSDKEnviroment()
        }
        get {
            return _environment
        }
    }
    // region
    private lazy var _region: Region = {
        let saved = UserDefaults.standard.object(forKey: kRegion) as? String
        return Region(rawValue: saved ?? "CN") ?? Region.CN
    }()
    
    var region: Region {
        set {
            _region = newValue
            UserDefaults.standard.set(newValue.rawValue,
                                      forKey: kRegion)
            updateBaseURL()
        }
        get {
            return _region
        }
    }
    
    init() {
        updateBaseURL()
        updateSDKEnviroment()
    }
    
    func updateBaseURL() {
        switch environment {
        case .dev:
            server = "https://api-solutions-dev.bj2.agoralab.co"
        case .pre:
            server = "https://api-solutions-pre.bj2.agoralab.co"
        case .pro:
            switch region {
            case .CN:
                server = "https://api-solutions.bj2.agoralab.co"
            case .NA:
                server = "https://api-solutions.sv3sbm.agoralab.co"
            case .EU:
                server = "https://api-solutions.fr3sbm.agoralab.co"
            case .AP:
                server = "https://api-solutions.sg3sbm.agoralab.co"
            }
        }
    }
    
    func updateSDKEnviroment() {
        let sel = NSSelectorFromString("setEnvironment:")
        
        #if canImport(AgoraClassroomSDK_iOS)
        switch environment {
        case .pro:
            AgoraClassroomSDK.perform(sel,
                                      with: 2)
        case .pre:
            AgoraClassroomSDK.perform(sel,
                                      with: 1)
        case .dev:
            AgoraClassroomSDK.perform(sel,
                                      with: 0)
        }
        #endif
    }
}

/**
 // 课程业务信息组装
 func fillupInputModel(_ model: RoomInputInfoModel) {
     self.fillupClassInfo(model: model) { model in
         self.fillupTokenInfo(model: model) { model in
             if model.roomType == 6 {
                 self.startLaunchProctorRoom(with: model)
             } else {
                 self.startLaunchClassRoom(with: model)
             }
         }
     }
 }
 
 func fillupClassInfo(model: RoomInputInfoModel,
                      complete: @escaping (RoomInputInfoModel) -> Void) {
     guard let roomId = model.roomId else {
         return
     }
     AgoraLoading.loading()
     FcrOutsideClassAPI.fetchRoomDetail(roomId: roomId) { [weak self] rsp in
         AgoraLoading.hide()
         guard let data = rsp["data"] as? [String: Any],
               let item = RoomItemModel.modelWith(dict: data)
         else {
             return
         }
         let now = Date()
         let endDate = Date(timeIntervalSince1970: Double(item.endTime) * 0.001)
         model.roomType = Int(item.roomType)
         model.roomName = item.roomName
         let cid = FcrUserInfoPresenter.shared.companyId
         if model.roomType == 6 {
             model.userUuid = "\(cid)-sub"
         } else {
             model.userUuid = cid
         }
         if let roomProperties = item.roomProperties {
             if let service = roomProperties["serviceType"] as? Int,
                let serviceType = AgoraEduServiceType(rawValue: service) {
                 model.serviceType = serviceType
             }
             if let watermark = roomProperties["watermark"] as? Bool {
                 model.watermark = watermark
             }
         }
         
         // CDN大班课暂不支持老师端
         if model.roomType == 2,
            model.roleType == 1,
            let serviceTypeInt = model.serviceType?.rawValue,
             serviceTypeInt != 0 {
             AgoraToast.toast(message: "fcr_joinroom_tips_cdn_character".localized(),
                              type: .warning)
             return
         }
         if now.compare(endDate) == .orderedDescending { // 课程过期
             self?.fetchData()
         } else {
             complete(model)
         }
     } onFailure: { code, msg in
         AgoraLoading.hide()
         let str = (code == 500) ? "fcr_joinroom_tips_emptyid".localized() : msg
         AgoraToast.toast(message: str,
                          type: .warning)
     }
 }
 
 func fillupTokenInfo(model: RoomInputInfoModel,
                      complete: @escaping (RoomInputInfoModel) -> Void) {
     AgoraLoading.loading()
     guard let roomUuid = model.roomId,
           let userUuid = model.userUuid
     else {
         return
     }
     FcrOutsideClassAPI.joinRoom(roomId: roomUuid,
                                 userRole: model.roleType,
                                 userUuid: userUuid) { dict in
         AgoraLoading.hide()
         guard let data = dict["data"] as? [String : Any] else {
             fatalError("TokenBuilder buildByServer can not find data, dict: \(dict)")
         }
         guard let token = data["token"] as? String,
               let appId = data["appId"] as? String else {
             fatalError("TokenBuilder buildByServer can not find value, dict: \(dict)")
         }
         model.token = token
         model.appId = appId
         complete(model)
     } onFailure: { code, msg in
         AgoraLoading.hide()
         AgoraToast.toast(message: msg,
                          type: .warning)
     }
 }

 // 组装Launch参数并拉起教室
 func startLaunchClassRoom(with model: RoomInputInfoModel) {
     guard let userName = model.userName,
           let roomName = model.roomName,
           let roomId = model.roomId,
           let appId = model.appId,
           let token = model.token,
           let userUuid = model.userUuid
     else {
         return
     }
     let role = model.roleType
     let region = getLaunchRegion()
     var latencyLevel = AgoraEduLatencyLevel.ultraLow
     if model.serviceType == .livePremium {
         latencyLevel = .ultraLow
         model.serviceType = nil
     } else if model.serviceType == .liveStandard {
         latencyLevel = .low
         model.serviceType = nil
     }
     var roomType: AgoraEduRoomType
     switch model.roomType {
     case 0:   roomType = .oneToOne
     case 2:   roomType = .lecture
     case 4:   roomType = .small
     default:  roomType = .small
     }
     let mediaOptions = AgoraEduMediaOptions(encryptionConfig: nil,
                                             videoEncoderConfig: nil,
                                             latencyLevel: latencyLevel,
                                             videoState: .on,
                                             audioState: .on)
     let launchConfig = AgoraEduLaunchConfig(userName: userName,
                                             userUuid: userUuid,
                                             userRole: AgoraEduUserRole(rawValue: role) ?? .student,
                                             roomName: roomName,
                                             roomUuid: roomId,
                                             roomType: roomType,
                                             appId: appId,
                                             token: token,
                                             startTime: nil,
                                             duration: NSNumber(value: 60 * 30),
                                             region: region,
                                             mediaOptions: mediaOptions,
                                             userProperties: nil)
     // MARK: 若对widgets需要添加或修改时，可获取launchConfig中默认配置的widgets进行操作并重新赋值给launchConfig
     var widgets = Dictionary<String,AgoraWidgetConfig>()
     launchConfig.widgets.forEach { (k,v) in
         if k == "cloudDrive" {
             v.extraInfo = ["publicCoursewares": model.publicCoursewares()]
         }
         if k == "netlessBoard",
            v.extraInfo != nil {
             var newExtra = v.extraInfo as! Dictionary<String, Any>
             newExtra["coursewareList"] = model.publicCoursewares()
             v.extraInfo = newExtra
         }
         widgets[k] = v
     }
     
     // Theme
     switch FcrUserInfoPresenter.shared.theme {
     case 0:
         agora_ui_mode = .agoraLight
     default:
         agora_ui_mode = .agoraDark
     }
     
     // share link
     let sharingLink = AgoraWidgetConfig(with: AgoraSharingLinkWidget.self,
                                         widgetId: "sharingLink")
     widgets[sharingLink.widgetId] = sharingLink
     sharingLink.extraInfo = ["sharingLink": FcrShareLink.shareLinkWith(roomId: roomId)]
     // water mark
     if model.watermark {
         let watermark = AgoraWidgetConfig(with: AgoraWatermarkWidget.self,
                                           widgetId: "watermark")
         widgets[watermark.widgetId] = watermark
         watermark.extraInfo = ["watermark": userName]
     }
     
     launchConfig.widgets = widgets
     if let service = model.serviceType { // 职教入口
         AgoraLoading.loading()
         AgoraClassroomSDK.vocationalLaunch(launchConfig,
                                            service: service) {
             AgoraLoading.hide()
         } failure: { error in
             AgoraLoading.hide()
             
             let `error` = error as NSError
             
             if error.code == 30403100 {
                 AgoraToast.toast(message: "login_kicked".localized(),
                                  type: .error)
             } else {
                 AgoraToast.toast(message: error.localizedDescription,
                                  type: .error)
             }
         }
     } else { // 灵动课堂入口
         AgoraLoading.loading()
         AgoraClassroomSDK.launch(launchConfig) {
             AgoraLoading.hide()
         } failure: { error in
             AgoraLoading.hide()
              
             let `error` = error as NSError
             
             if error.code == 30403100 {
                 AgoraToast.toast(message: "login_kicked".localized(),
                                  type: .error)
             } else {
                 AgoraToast.toast(message: error.localizedDescription,
                                  type: .error)
             }
         }
     }
 }
 
 // 组装Launch参数并拉起监考房间
 func startLaunchProctorRoom(with model: RoomInputInfoModel) {
     guard let userName = model.userName,
           let roomName = model.roomName,
           let roomUuid = model.roomId,
           let appId = model.appId,
           let token = model.token,
           let userUuid = model.userUuid
     else {
         return
     }
     var latencyLevel = AgoraProctorLatencyLevel.ultraLow
     if model.serviceType == .livePremium {
         latencyLevel = .ultraLow
     } else if model.serviceType == .liveStandard {
         latencyLevel = .low
     }
     let mediaOptions = AgoraProctorMediaOptions(videoEncoderConfig: AgoraProctorVideoEncoderConfig(),
                                                 encryptionConfig: nil,
                                                 latencyLevel: latencyLevel)
     let launchConfig = AgoraProctorLaunchConfig(userName: userName,
                                                 userUuid: userUuid,
                                                 userRole: .student,
                                                 roomName: roomName,
                                                 roomUuid: roomUuid,
                                                 appId: appId,
                                                 token: token,
                                                 region: FcrEnvironment.shared.region.proctor,
                                                 mediaOptions: mediaOptions,
                                                 userProperties: nil)
     
     let proctor = AgoraProctor(config: launchConfig,
                               delegate: self)
     self.proctor = proctor
     
     
     switch FcrEnvironment.shared.environment {
     case .pro:
         proctor.setParameters(["environment": 2])
     case .pre:
         proctor.setParameters(["environment": 1])
     case .dev:
         proctor.setParameters(["environment": 0])
     }
     
     proctor.launch {
         AgoraLoading.hide()
     } failure: { [weak self] (error) in
         AgoraLoading.hide()

         self?.proctor = nil

         let `error` = error as NSError

         if error.code == 30403100 {
             AgoraToast.toast(message: "login_kicked".localized(),
                              type: .error)
         } else {
             AgoraToast.toast(message: error.localizedDescription,
                              type: .error)
         }
     }
 }
 
 func getLaunchRegion() -> AgoraEduRegion {
     switch FcrEnvironment.shared.region {
     case .CN: return .CN
     case .NA: return .NA
     case .EU: return .EU
     case .AP: return .AP
     }
 }
 */
