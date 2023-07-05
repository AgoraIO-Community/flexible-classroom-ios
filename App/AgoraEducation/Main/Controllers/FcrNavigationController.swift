//
//  MainViewController.swift
//  FlexibleClassroom
//
//  Created by LYY on 2021/4/16.
//  Copyright © 2021 Agora. All rights reserved.
//

import UIKit

@objc public class FcrNavigationController: UINavigationController {
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    public override init(nibName nibNameOrNil: String?,
                         bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil,
                   bundle: nibBundleOrNil)
    }
    
    public override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        navigationBar.isTranslucent = false
        navigationBar.backIndicatorImage = UIImage(named: "ic_navigation_back")
        navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "ic_navigation_back")
        navigationBar.tintColor = UIColor(hex: 0x7B88A0)
        navigationBar.titleTextAttributes = [
            .foregroundColor : UIColor(hex: 0x191919) ?? .black,
            .font : UIFont.systemFont(ofSize: 16)
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetViewControllers(viewControllers: [UIViewController]) {
        for viewController in viewControllers {
            let barItem = UIBarButtonItem(title: "",
                                          style: .plain,
                                          target: nil,
                                          action: nil)
            viewController.navigationItem.backBarButtonItem = barItem
        }
        self.viewControllers = viewControllers
    }
    
    public override func pushViewController(_ viewController: UIViewController,
                                            animated: Bool) {
        super.pushViewController(viewController,
                                 animated: animated)
        
        let barItem = UIBarButtonItem(title: "",
                                      style: .plain,
                                      target: nil,
                                      action: nil)
        viewController.navigationItem.backBarButtonItem = barItem
    }
    
    public override var shouldAutorotate: Bool {
        return self.topViewController?.shouldAutorotate ?? true
    }
    
    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.topViewController?.preferredInterfaceOrientationForPresentation ?? .landscapeRight
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.topViewController?.supportedInterfaceOrientations ?? .landscapeRight
    }
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
}
