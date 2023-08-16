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
    private let dimissButton = UIButton(frame: .zero)
    
    var contentViewY: CGFloat {
        return UIScreen.agora_height - contentHeight + 16
    }
    
    let contentViewX: CGFloat = 0
    
    let contentHeight: CGFloat
    let contentWith: CGFloat = UIScreen.agora_width
    
    var contentView = UIView()
    
    var onDismissed: FcrAppCompletion?
    
    init(contentHeight: CGFloat = 446) {
        self.contentHeight = contentHeight
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        initViewFrame()
        updateViewProperties()
    }
    
    func initViews() {
        view.addSubview(contentView)
        view.addSubview(dimissButton)
        
        contentView.layer.cornerRadius = 12
        
        dimissButton.backgroundColor = .clear
        
        dimissButton.addTarget(self,
                               action: #selector(onDismissPressed),
                               for: .touchUpInside)
    }
    
    func initViewFrame() {
        contentView.frame = CGRect(x: contentViewX,
                                   y: contentViewY,
                                   width: contentWith,
                                   height: contentHeight)
        
        dimissButton.frame = CGRect(x: 0,
                                    y: 0,
                                    width: contentWith,
                                    height: contentViewY)
    }
    
    func updateViewProperties() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        contentView.backgroundColor = .white
    }
    
    @objc private func onDismissPressed() {
        onDismissed?()
        dismiss(animated: true)
    }
}
