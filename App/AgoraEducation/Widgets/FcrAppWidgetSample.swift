//
//  FcrAppWidgets.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/8/23.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraWidget

///  TODO:

struct FcrAppWidgetSample {
    let sharingLinkWidgetId = "sharingLink"
    let watermarkWidgetId = "watermark"
    let cloudDriveId = "cloudDrive"
    
    func createWatermark(text: String) -> AgoraWidgetConfig {
        let config = AgoraWidgetConfig(with: AgoraWatermarkWidget.self,
                                       widgetId: watermarkWidgetId)
        
        config.extraInfo = ["watermark": text]
        
        return config
    }
    
    func createSharingLink(_ link: String) -> AgoraWidgetConfig {
        let config = AgoraWidgetConfig(with: AgoraSharingLinkWidget.self,
                                       widgetId: sharingLinkWidgetId)
        
        config.extraInfo = ["sharingLink": link]
        
        return config
    }
    
    func cloudDriveExCourseware() -> [String: Any] {
        let courseware = ["publicCoursewares": FcrAppCloudDriveExItems().publicCoursewares()]
        return courseware
    }
}
