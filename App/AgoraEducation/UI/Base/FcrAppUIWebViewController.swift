//
//  FcrAppUIWebViewController.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/10/12.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews
import WebKit

class FcrAppUIWebViewController: FcrAppUIViewController,
                                 AgoraUIContentContainer {
    let webView = WKWebView()
    
    let url: String
    
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
    
    func initViews() {
        view.addSubview(webView)
    }
    
    func initViewFrame() {
        webView.mas_makeConstraints { make in
            make?.left.right().top().bottom().equalTo()(0)
        }
    }
    
    func updateViewProperties() {
        
    }
}
