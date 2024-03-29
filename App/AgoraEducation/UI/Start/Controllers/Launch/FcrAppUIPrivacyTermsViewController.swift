//
//  FcrAppUIPrivacyTermsViewController.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/7/14.
//  Copyright © 2022 Agora. All rights reserved.
//

import AgoraUIBaseViews
import UIKit

class FcrAppUIPrivacyTermsViewController: FcrAppUIPresentedViewController {
    private let titleLabel = UILabel()
    
    private let textView = FcrAppUITextView(frame: .zero,
                                            textContainer: nil)
    
    private let agreedButton = UIButton(frame: .zero)

    private let disagreedButton = UIButton(frame: .zero)
    
    private let isMainLandChina: Bool
    
    var onAgreedCompletion: FcrAppBoolCompletion?
    
    init(contentHeight: CGFloat = 446,
         contentViewOffY: CGFloat = 24,
         contentViewHorizontalSpace: CGFloat = 0,
         canHide: Bool = true,
         isMainLandChina: Bool,
         onAgreedCompletion: FcrAppBoolCompletion? = nil) {
        self.isMainLandChina = isMainLandChina
        self.onAgreedCompletion = onAgreedCompletion
        
        super.init(contentHeight: contentHeight,
                   contentViewOffY: contentViewOffY,
                   contentViewHorizontalSpace: contentViewHorizontalSpace,
                   canHide: canHide,
                   onDismissed: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        agreedButton.mas_makeConstraints { make in
            make?.bottom.equalTo()(self.disagreedButton.mas_top)?.offset()(-10)
            make?.left.equalTo()(33)
            make?.height.equalTo()(44)
            make?.centerX.equalTo()(0)
        }
        
        disagreedButton.mas_makeConstraints { make in
            make?.bottom.equalTo()(-12)
            make?.left.equalTo()(33)
            make?.centerX.equalTo()(0)
            make?.height.equalTo()(44)
        }
    }
    
    override func updateViewProperties() {
        super.updateViewProperties()
        titleLabel.text = "fcr_login_label_welcome".localized()
        
        textView.attributedText = FcrAppUIPolicyString().loginDetailString(isMainLandChina: isMainLandChina)
        
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
        dismissSelf()
        onAgreedCompletion?(true)
        onAgreedCompletion = nil
    }
    
    @objc private func onDisagreedButtonPressed() {
        dismissSelf()
        onAgreedCompletion?(false)
        onAgreedCompletion = nil
    }
}
