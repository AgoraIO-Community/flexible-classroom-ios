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
    
    let contentViewOffY: CGFloat
    
    let contentViewHorizontalSpace: CGFloat
    
    var contentViewX: CGFloat {
        return contentViewHorizontalSpace
    }
    
    var contentViewY: CGFloat {
        return UIScreen.agora_height - contentHeight + contentViewOffY
    }
    
    var contentWith: CGFloat {
        return UIScreen.agora_width - (contentViewHorizontalSpace * 2)
    }
    
    let contentHeight: CGFloat
    
    let contentView = UIView()
    
    var onDismissed: FcrAppCompletion?
    
    init(contentHeight: CGFloat = 446,
         contentViewOffY: CGFloat = 24,
         contentViewHorizontalSpace: CGFloat = 0) {
        self.contentHeight = contentHeight
        self.contentViewOffY = contentViewOffY
        self.contentViewHorizontalSpace = contentViewHorizontalSpace
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
        
        contentView.layer.cornerRadius = 24
        
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
                                    width: UIScreen.agora_width,
                                    height: contentViewY)
    }
    
    func updateViewProperties() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        contentView.backgroundColor = .white
    }
    
    @objc func onDismissPressed() {
        UIApplication.shared.keyWindow?.endEditing(true)
        onDismissed?()
        dismiss(animated: true)
    }
}

class FcrAppStartUIPresentedViewController: FcrAppUIPresentedViewController {
    // View
    let titleLabel = UILabel()
    
    let closeButton = UIButton(type: .custom)
    
    let lineView = UIView(frame: .zero)
    
    let bottomButton = UIButton(type: .custom)
    
    override func initViews() {
        super.initViews()
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(closeButton)
        contentView.addSubview(lineView)
        contentView.addSubview(bottomButton)
        
        titleLabel.font = FcrAppUIFontGroup.font16
        
        closeButton.addTarget(self,
                              action: #selector(onDismissPressed),
                              for: .touchUpInside)
        
        bottomButton.titleLabel?.font = FcrAppUIFontGroup.font16
        
        bottomButton.layer.cornerRadius = 23
        bottomButton.clipsToBounds = true
    }
    
    override func initViewFrame() {
        super.initViewFrame()
        
        titleLabel.mas_makeConstraints { make in
            make?.left.top().equalTo()(24)
        }
        
        closeButton.mas_makeConstraints { make in
            make?.centerY.equalTo()(self.titleLabel.mas_centerY)
            make?.right.equalTo()(-15)
            make?.width.height().equalTo()(24)
        }
        
        lineView.mas_makeConstraints { make in
            make?.bottom.equalTo()(self.bottomButton.mas_top)?.offset()(-12)
            make?.right.left().equalTo()(0)
            make?.height.equalTo()(1)
        }
        
        bottomButton.mas_makeConstraints { make in
            make?.bottom.equalTo()(-(40 + self.contentViewOffY))
            make?.right.equalTo()(-20)
            make?.left.equalTo()(20)
            make?.height.equalTo()(46)
        }
    }
    
    override func updateViewProperties() {
        super.updateViewProperties()
        titleLabel.textColor = FcrAppUIColorGroup.fcr_black
        
        lineView.backgroundColor = FcrAppUIColorGroup.fcr_v2_line
        
        closeButton.setImage(UIImage(named: "fcr_mobile_closeicon"),
                             for: .normal)
        
        bottomButton.setTitleColor(.white,
                                   for: .normal)
        
        bottomButton.backgroundColor = FcrAppUIColorGroup.fcr_v2_brand6
    }
}
