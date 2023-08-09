//
//  FcrAppUIPresentedViewController.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/8/7.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUIPresentedViewController: FcrAppUIViewController,
                                       AgoraUIContentContainer {
    var contentViewY: CGFloat {
        return UIScreen.agora_height - contentHeight + 16
    }
    
    let contentViewX: CGFloat = 0
    
    let contentHeight: CGFloat = 446
    let contentWith: CGFloat = UIScreen.agora_width
    
    var contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        initViewFrame()
        updateViewProperties()
    }
    
    func initViews() {
        view.addSubview(contentView)
        
        contentView.layer.cornerRadius = 12
    }
    
    func initViewFrame() {
        contentView.frame = CGRect(x: contentViewX,
                                   y: contentViewY,
                                   width: contentWith,
                                   height: contentHeight)
    }
    
    func updateViewProperties() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        contentView.backgroundColor = .white
    }
}
