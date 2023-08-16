//
//  FcrAppUIRootViewController.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/8/16.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUIRootViewController: FcrAppUINavigationController {
    @objc init(isQuickStart: Bool) {
        if isQuickStart {
            let vc = FcrAppUIQuickStartViewController()
            super.init(rootViewController: vc)
        } else {
            let vc = FcrAppUIMainViewController()
            super.init(rootViewController: vc)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AgoraLoading.initProperties()
        AgoraToast.initProperties()
    }
}
