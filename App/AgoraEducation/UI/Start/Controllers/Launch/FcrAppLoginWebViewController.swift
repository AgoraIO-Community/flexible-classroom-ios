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

class FcrAppUILoginWebViewController: FcrAppUIWebViewController {
    private var onLoginCompleted: FcrAppBoolCompletion?
    
    private var center: FcrAppCenter
    
    init(url: String,
         center: FcrAppCenter,
         onLoginCompleted: FcrAppBoolCompletion? = nil) {
        self.center = center
        self.onLoginCompleted = onLoginCompleted
        super.init(url: url)
        self.webView.navigationDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false,
                                                     animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true,
                                                     animated: true)
    }
    
    private func login(accessToken: String,
                       refreshToken: String) {
        center.urlGroup.accessToken = accessToken
        center.urlGroup.refreshToken = refreshToken
        
        AgoraLoading.loading()
        
        center.login { [weak self] in
            AgoraLoading.hide()
            
            self?.navigationController?.popViewController(animated: true)
            
            self?.onLoginCompleted?(true)
        } failure: { [weak self] error in
            AgoraLoading.hide()
            
            self?.showErrorToast(error)
            
            self?.navigationController?.popViewController(animated: true)
            
            self?.onLoginCompleted?(false)
        }
    }
}

// MARK: - WKNavigationDelegate
extension FcrAppUILoginWebViewController: WKNavigationDelegate {
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
            
            var accessTokenValue: String?
            var refreshTokenValue: String?
            
            // Get access token and refresh token after logging in
            queryItems.forEach { item in
                if item.name == "accessToken",
                   let accessToken = item.value {
                    accessTokenValue = accessToken
                } else if item.name == "refreshToken",
                          let refreshToken = item.value {
                    refreshTokenValue = refreshToken
                }
            }
            
            decisionHandler(.cancel)
            
            guard let `accessToken` = accessTokenValue,
                  let `refreshToken` = refreshTokenValue else {
                let error = FcrAppError(code: -1,
                                        message: "Access token or refresh token retrieval failed")
                showErrorToast(error)
                onLoginCompleted?(false)
                return
            }
            
            login(accessToken: accessToken,
                  refreshToken: refreshToken)
        } else {
            decisionHandler(.allow)
        }
    }
}
