//
//  FcrAppURLGroup.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/5.
//  Copyright © 2023 Agora. All rights reserved.
//

import Foundation

class FcrAppURLGroup {
    enum Environment: String {
        case dev, pre, pro
    }
    
    enum Region: String {
        case CN, NA, EU, AP
    }
    
    var environment = Environment.pro
    var region = Region.CN
    
    private var host: String {
        switch environment {
        case .dev:
           return "https://api-solutions-dev.bj2.agoralab.co"
        case .pre:
            return "https://api-solutions-pre.bj2.agoralab.co"
        case .pro:
            switch region {
            case .CN:
                return "https://api-solutions.bj2.agoralab.co"
            case .NA:
                return "https://api-solutions.sv3sbm.agoralab.co"
            case .EU:
                return "https://api-solutions.fr3sbm.agoralab.co"
            case .AP:
                return "https://api-solutions.sg3sbm.agoralab.co"
            }
        }
    }
    
    
    
}
