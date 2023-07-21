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

class FcrAppUIPrivacyTermsViewController: FcrAppViewController {
    private lazy var termTitle = UILabel()
    private lazy var contentView = WKWebView(frame: .zero)
    private lazy var agreementView = FcrAppUIAgreementView(frame: .zero)
    
    var onAgreedCompleted: FcrAppCompletion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        initViewFrame()
        updateViewProperties()
        
        loadPrivacy()
    }
}

extension FcrAppUIPrivacyTermsViewController: AgoraUIContentContainer {
    func initViews() {
        view.addSubview(termTitle)
        
        contentView.uiDelegate = self
        
        view.addSubview(contentView)
        
        agreementView.checkButton.addTarget(self,
                                            action: #selector(onClickRead(_:)),
                                            for: .touchUpInside)
        
        agreementView.agreeButton.addTarget(self,
                                            action: #selector(onClickAgree(_:)),
                                            for: .touchUpInside)
        
        agreementView.disagreeButton.addTarget(self,
                                               action: #selector(onClickDisagree(_:)),
                                               for: .touchUpInside)
        view.addSubview(agreementView)
    }
    
    func initViewFrame() {
        termTitle.mas_makeConstraints { make in
            make?.top.equalTo()(48)
            make?.centerX.equalTo()(0)
        }
        
        agreementView.mas_makeConstraints { make in
            make?.left.right().bottom().equalTo()(0)
            make?.height.equalTo()(180)
        }
        
        contentView.mas_makeConstraints { make in
            make?.top.equalTo()(termTitle.mas_bottom)?.offset()(20)
            make?.left.equalTo()(20)
            make?.right.equalTo()(-20)
            make?.bottom.equalTo()(agreementView.mas_top)?.offset()(10)
        }
    }
    
    func updateViewProperties() {
        view.backgroundColor = .white
        
        termTitle.text = "Service_title".localized()
        termTitle.textColor = .black
        termTitle.font = .boldSystemFont(ofSize: 14)
    }
    
    func loadPrivacy() {
        var url: String
        
        if UIDevice.current.agora_is_chinese_language {
            url = "https://agora-adc-artifacts.s3.cn-north-1.amazonaws.com.cn/demo/education/privacy.html"
        } else {
            url = "https://agora-adc-artifacts.s3.cn-north-1.amazonaws.com.cn/demo/education/privacy_en.html"
        }
        
        if let urlRequest = URLRequest(urlString: url) {
            contentView.load(urlRequest)
        }
    }
    
    @objc func onClickRead(_ sender: Any) {
        agreementView.isAgreed.toggle()
    }
    
    @objc func onClickAgree(_ sender: Any) {
        dismiss(animated: true,
                completion: onAgreedCompleted)
    }
    
    @objc func onClickDisagree(_ sender: UIButton) {
        exit(0)
    }
}

extension FcrAppUIPrivacyTermsViewController: WKUIDelegate {
    public func webView(_ webView: WKWebView,
                        createWebViewWith configuration: WKWebViewConfiguration,
                        for navigationAction: WKNavigationAction,
                        windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let targetFrame = navigationAction.targetFrame,
           !targetFrame.isMainFrame {
            webView.load(navigationAction.request)
        }
        return nil
    }
}

