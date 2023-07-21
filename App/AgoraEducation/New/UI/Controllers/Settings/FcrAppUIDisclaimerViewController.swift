//
//  FcrTermsViewController.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/7/4.
//  Copyright © 2022 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUIDisclaimerViewController: FcrAppViewController, AgoraUIContentContainer {
    private let textLabel = UILabel()
    private let infoLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        initViewFrame()
        updateViewProperties()
    }
    
    func initViews() {
        view.addSubview(textLabel)
        view.addSubview(infoLabel)
        
        textLabel.numberOfLines = 0
        
        infoLabel.font = UIFont.systemFont(ofSize: 12)
        infoLabel.textAlignment = .center
    }
    
    func initViewFrame() {
        textLabel.mas_makeConstraints { make in
            make?.left.equalTo()(10)
            make?.right.equalTo()(-10)
            make?.top.equalTo()(10)
        }
        
        infoLabel.mas_makeConstraints { make in
            make?.left.right().equalTo()(0)
            make?.bottom.equalTo()(-20)
        }
    }
    
    func updateViewProperties() {
        view.backgroundColor = UIColor(hex: 0xF9F9FC)
        title = "settings_disclaimer_title".localized()
        
        let attrString = NSMutableAttributedString(string: "settings_disclaimer_detail".localized())
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.paragraphSpacing = 21
        
        let attr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14),
                                                   .foregroundColor: UIColor(hex: 0x586376) ?? UIColor.black,
                                                   .paragraphStyle: paraStyle]
        attrString.addAttributes(attr,
                                 range: NSRange(location: 0,
                                                length: attrString.length))
        textLabel.attributedText = attrString
        
        infoLabel.text = "settings_powerd_by".localized()
        infoLabel.textColor = UIColor(hex: 0x7D8798)
    }
}
