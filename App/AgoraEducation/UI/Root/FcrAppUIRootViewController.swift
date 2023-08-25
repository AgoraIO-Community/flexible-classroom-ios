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
    
    private let formalLoginProcess: Bool
    
    @objc init(formalLoginProcess: Bool) {
        self.formalLoginProcess = formalLoginProcess
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AgoraLoading.initProperties()
        AgoraToast.initProperties()
        
        agora_ui_language = center.language.proj()
        
        view.backgroundColor = .black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginProcess()
    }
    
    private func loginProcess() {
        if !formalLoginProcess || center.tester.isTest {
            let vc = FcrAppUIQuickStartViewController(center: center)
            
            presentNavigationController(vc)
        } else {
            if center.isLogined {
                presentMainViewController()
            } else {
                center.needLogin { [weak self] need in
                    guard let `self` = self else {
                        return
                    }
                    
                    if need {
                        self.presentMainViewController()
                    } else {
                        self.presentQuickStartViewController()
                    }
                }
            }
        }
    }
    
    private func presentMainViewController() {
        let vc = FcrAppUIMainViewController(center: center)
        presentNavigationController(vc)
    }
    
    private func presentQuickStartViewController() {
        let vc = FcrAppUIQuickStartViewController(center: center)
        presentNavigationController(vc)
    }
    
    private func presentNavigationController(_ root: UIViewController) {
        let navigation = FcrAppUINavigationController(rootViewController: root)
        
        navigation.modalPresentationStyle = .fullScreen
        navigation.modalTransitionStyle = .crossDissolve
        
        present(navigation,
                animated: true)
    }
}
