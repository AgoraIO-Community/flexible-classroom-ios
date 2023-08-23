//
//  FcrAppWidgets.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/8/23.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraWidget

struct FcrAppWidgets {
    let sharingLinkWidgetId = "sharingLink"
    let watermarkWidgetId = "watermark"
    
    func createWatermark() -> AgoraWidgetConfig {
        let config = AgoraWidgetConfig(with: AgoraWatermarkWidget.self,
                                       widgetId: watermarkWidgetId)
        
        return config
    }
    
    func createSharingLink() -> AgoraWidgetConfig {
        let config = AgoraWidgetConfig(with: AgoraSharingLinkWidget.self,
                                       widgetId: sharingLinkWidgetId)
        
        return config
    }
}
