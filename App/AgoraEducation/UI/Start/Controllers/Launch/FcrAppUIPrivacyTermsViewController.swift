//
//  FcrAppUIPrivacyTermsViewController.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/7/14.
//  Copyright © 2022 Agora. All rights reserved.
//

import AgoraUIBaseViews
import WebKit
import UIKit

class FcrAppUIPrivacyTermsViewController: FcrAppUIPresentedViewController {
    private let titleLabel = UILabel()
    
    private let textView = FcrAppUITextView(frame: .zero,
                                            textContainer: nil)
    
    private let agreedButton = UIButton(frame: .zero)

    private let disagreedButton = UIButton(frame: .zero)
    
    var onAgreedCompletion: FcrAppCompletion?
    
    override func initViews() {
        super.initViews()
        contentView.addSubview(titleLabel)
        contentView.addSubview(textView)
        contentView.addSubview(agreedButton)
        contentView.addSubview(disagreedButton)
        
        titleLabel.textAlignment = .center
        titleLabel.font = FcrAppUIFontGroup.font16
        
        textView.font = FcrAppUIFontGroup.font12
        
        // Agreed button
        agreedButton.titleLabel?.font = FcrAppUIFontGroup.font14
        agreedButton.layer.cornerRadius = 22
        
        agreedButton.addTarget(self,
                               action: #selector(onAgreedButtonPressed),
                               for: .touchUpInside)
        
        // Disagreed button
        disagreedButton.titleLabel?.font = FcrAppUIFontGroup.font14
        
        disagreedButton.addTarget(self,
                                  action: #selector(onDisagreedButtonPressed),
                                  for: .touchUpInside)
    }
    
    override func initViewFrame() {
        super.initViewFrame()
        
        titleLabel.mas_makeConstraints { make in
            make?.top.equalTo()(36)
            make?.centerX.equalTo()(0)
            make?.left.right().equalTo()(0)
            make?.height.equalTo()(16)
        }
        
        textView.mas_makeConstraints { make in
            make?.top.equalTo()(self.titleLabel.mas_bottom)?.offset()(21)
            make?.left.equalTo()(30)
            make?.bottom.equalTo()(self.disagreedButton.mas_top)?.offset()(10)
            make?.right.equalTo()(-30)
        }
        
        disagreedButton.mas_makeConstraints { make in
            make?.bottom.equalTo()(-12)
            make?.left.equalTo()(33)
            make?.centerX.equalTo()(0)
            make?.height.equalTo()(44)
        }
        
        agreedButton.mas_makeConstraints { make in
            make?.bottom.equalTo()(self.disagreedButton.mas_top)?.offset()(-10)
            make?.left.equalTo()(33)
            make?.height.equalTo()(44)
            make?.centerX.equalTo()(0)
        }
    }
    
    override func updateViewProperties() {
        super.updateViewProperties()
        titleLabel.text = "fcr_login_label_welcome".localized()
        
        textView.attributedText = FcrAppUIPolicyString().loginString()
        
        agreedButton.setTitle("fcr_login_popup_window_button_agree".localized(),
                              for: .normal)
        
        agreedButton.setTitleColor(FcrAppUIColorGroup.fcr_white,
                                   for: .normal)
        
        agreedButton.backgroundColor = FcrAppUIColorGroup.fcr_v2_brand6
        
        disagreedButton.setTitle("fcr_login_popup_window_button_disagree".localized(),
                                 for: .normal)
        
        disagreedButton.setTitleColor(FcrAppUIColorGroup.fcr_v2_light_text1,
                                      for: .normal)
    }
    
    @objc private func onAgreedButtonPressed() {
        onAgreedCompletion?()
    }
    
    @objc private func onDisagreedButtonPressed() {
        exit(0)
    }
}
