//
//  FcrAppViewController.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/5.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppViewController: UIViewController {
    override init(nibName nibNameOrNil: String?,
                  bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil,
                   bundle: nibBundleOrNil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var shouldAutorotate: Bool {
        return true
    }
    
    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIDevice.current.agora_is_pad ? .landscapeRight : .portrait
    }

    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIDevice.current.agora_is_pad ? .landscapeRight : .portrait
    }
    
    func showAlert(title: String = "",
                   contentList: [String],
                   actions: [AgoraAlertAction]) {
        let alertController = AgoraAlert()
        
        alertController.show(title: title,
                             contentList: contentList,
                             actions: actions,
                             in: self)
    }
}
