//
//  LoginWebViewController.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/7/11.
//  Copyright © 2022 Agora. All rights reserved.
//

import AgoraUIBaseViews
import WebKit
import UIKit

class FcrAppLoginWebViewController: FcrAppViewController {
    private var webView = WKWebView()
    
    public var url: String
    
    public var onComplete: (() -> Void)?
    
    private var debugButton = UIButton(type: .custom)
    
    private var debugCount: Int = 0
    
    init(url: String) {
        self.url = url
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
        loadURL()
    }
    
    private func loadURL() {
        guard let consoleURL = URL(string: url) else {
            return
        }
        
        let request = URLRequest(url: consoleURL)
        webView.load(request)
    }
    
    private func fetchUserInfo() {
        AgoraLoading.loading()
        
        FcrOutsideClassAPI.fetchUserInfo { rsp in
            AgoraLoading.hide()
            
            guard let data = rsp["data"] as? [String: Any] else {
                return
            }
            
            if let companyId = data["companyId"] as? String {
                FcrUserInfoPresenter.shared.companyId = companyId
            }
            
            if let companyName = data["companyName"] as? String {
                FcrUserInfoPresenter.shared.nickName = companyName
            }
            
            self.dismiss(animated: true,
                         completion: self.onComplete)
        } onFailure: { code, msg in
            AgoraLoading.hide()
            
            self.dismiss(animated: true,
                         completion: self.onComplete)
        }
    }
    
    @objc private func onTouchDebug() {
        guard debugCount >= 10 else {
            debugCount += 1
            return
        }
        
        FcrUserInfoPresenter.shared.qaMode = true
        dismiss(animated: true)
    }
}

extension FcrAppLoginWebViewController: AgoraUIContentContainer {
    func initViews() {
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        debugButton.addTarget(self,
                              action: #selector(onTouchDebug),
                              for: .touchUpInside)
        view.addSubview(debugButton)
    }
    
    func initViewFrame() {
        webView.mas_makeConstraints { make in
            make?.left.right().top().bottom().equalTo()(0)
        }
        
        debugButton.mas_makeConstraints { make in
            make?.height.equalTo()(60)
            make?.width.equalTo()(40)
            make?.left.bottom().equalTo()(0)
        }
    }
    
    func updateViewProperties() {
        debugButton.backgroundColor = .clear
    }
}

// MARK: - WKNavigationDelegate
extension FcrAppLoginWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView,
                 didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url?.absoluteURL,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else {
            decisionHandler(.allow)
            return
        }
        
        if queryItems.contains(where: {$0.name == "accessToken"}),
           queryItems.contains(where: {$0.name == "refreshToken"}) {
            // 获取登录结果
            queryItems.forEach { item in
                if item.name == "accessToken",
                   let accessToken = item.value {
                    FcrUserInfoPresenter.shared.accessToken = accessToken
                } else if item.name == "refreshToken",
                          let refreshToken = item.value {
                    FcrUserInfoPresenter.shared.refreshToken = refreshToken
                }
            }
            fetchUserInfo()
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
