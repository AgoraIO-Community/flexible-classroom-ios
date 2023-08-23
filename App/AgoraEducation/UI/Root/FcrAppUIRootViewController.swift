//
//  FcrAppUIRootViewController.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/8/16.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUIRootViewController: UIViewController {
    private let center = FcrAppCenter()
    
    private let forcedQuickStart: Bool
    
    @objc init(forcedQuickStart: Bool) {
        self.forcedQuickStart = forcedQuickStart
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true,
                                                     animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AgoraLoading.initProperties()
        AgoraToast.initProperties()
        
        agora_ui_language = center.language.proj()
        
        if forcedQuickStart {
            let vc = FcrAppUIQuickStartViewController(center: self.center)
            
            navigationController?.pushViewController(vc,
                                                     animated: true)
        } else {
            center.needLogin { [weak self] need in
                guard let `self` = self else {
                    return
                }
                
                var vc: UIViewController
                
                if need {
                    vc = FcrAppUIMainViewController(center: self.center)
                } else {
                    vc = FcrAppUIQuickStartViewController(center: self.center)
                }
                
                self.navigationController?.pushViewController(vc,
                                                              animated: true)
            }
        }
    }
}
