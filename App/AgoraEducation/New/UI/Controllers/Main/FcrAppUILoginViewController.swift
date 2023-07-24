//
//  FcrAppUILoginViewController.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/9/21.
//  Copyright © 2022 Agora. All rights reserved.
//

import AgoraUIBaseViews
import UIKit

class FcrAppUILoginViewController: FcrAppViewController {
    private let logoView = UIImageView(image: UIImage(named: "fcr_login_logo_text_en"))
    
    private let imageView = UIImageView(image: UIImage(named: "fcr_login_center_afc"))
    
    private let textView = UIImageView(image: UIImage(named: "fcr_login_text_en"))
    
    private let textBgView = UIImageView(image: UIImage(named: "fcr_login_logo_text_bg"))
    
    private let haloView = UIImageView(image: UIImage(named: "fcr_login_halo"))
    
    private let afcView = UIImageView(image: UIImage(named: "fcr_login_corner_afc"))
    
    private let startButton = UIButton(type: .custom)
    
    private var center: FcrAppCenter
    
    var onCompleted: FcrAppCompletion?
    
    init(center: FcrAppCenter,
         onCompleted: FcrAppCompletion? = nil) {
        self.center = center
        self.onCompleted = onCompleted
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true,
                                                     animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        initViewFrame()
        updateViewProperties()
        createAnimation()
    }
    
    @objc func onClickStart() {
        AgoraLoading.loading()
        
        center.getAgoraConsoleURL { [weak self] url in
            guard let `self` = self else {
                return
            }
            
            AgoraLoading.hide()
            
            let vc = FcrAppUILoginWebViewController(url: url,
                                                  center: self.center) { [weak self] isLogined in
                if isLogined {
                    self?.navigationController?.dismiss(animated: true)
                } else {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            
            self.navigationController?.pushViewController(vc,
                                                          animated: true)
        } failure: { [weak self] error in
            AgoraLoading.hide()
            
            self?.showErrorToast(error)
        }
    }
}

// MARK: - AgoraUIContentContainer
extension FcrAppUILoginViewController: AgoraUIContentContainer {
    func initViews() {
        view.addSubview(imageView)
        view.addSubview(logoView)
        view.addSubview(textBgView)
        view.addSubview(haloView)
        view.addSubview(textView)
        view.addSubview(afcView)
        view.addSubview(startButton)
        
        if UIDevice.current.isSmallPhone {
            textBgView.agora_visible = false
        }
        
        startButton.setBackgroundImage(UIImage(named: "fcr_login_get_start"),
                                       for: .normal)
        startButton.addTarget(self,
                              action: #selector(onClickStart),
                              for: .touchUpInside)
    }
    
    func initViewFrame() {
        let isSmallDevice = (LoginConfig.device == .iPhone_Small)
        
        let leftSideSpace: CGFloat = 29
        
        logoView.mas_makeConstraints { make in
            make?.top.equalTo()(isSmallDevice ? 24 : 55)
            make?.left.equalTo()(leftSideSpace)
        }
        
        imageView.mas_makeConstraints { make in
            make?.top.equalTo()(logoView.mas_bottom)?.offset()(isSmallDevice ? 15 : 32)
            make?.left.equalTo()(leftSideSpace)
            make?.right.equalTo()(-leftSideSpace)
            make?.height.equalTo()(imageView.mas_width)
        }
        
        afcView.mas_makeConstraints { make in
            make?.left.equalTo()(leftSideSpace)
            make?.bottom.equalTo()(-30)
        }
        
        startButton.mas_makeConstraints { make in
            make?.bottom.equalTo()(afcView.mas_top)?.offset()(isSmallDevice ? -47 : -81)
            make?.left.equalTo()(leftSideSpace)
            make?.width.equalTo()(isSmallDevice ? 160 : 190)
            make?.height.equalTo()(isSmallDevice ? 44 : 52)
        }
        
        textBgView.mas_makeConstraints { make in
            make?.left.right().equalTo()(0)
            make?.bottom.equalTo()(startButton.mas_top)?.offset()(-22)
            make?.height.equalTo()(isSmallDevice ? 120 : 135)
        }
        
        let textViewSize = textView.size
        let textViewRatio = textViewSize.width / textViewSize.height

        textView.mas_makeConstraints { make in
            make?.top.equalTo()(textBgView.mas_top)?.offset()(4)
            make?.bottom.equalTo()(textBgView.mas_bottom)?.offset()(-20)
            make?.left.equalTo()(32)
            make?.width.equalTo()(textView.mas_height)?.multipliedBy()(textViewRatio)
        }
    }
    
    func updateViewProperties() {
        view.backgroundColor = .black
        
        if FcrLocalization.shared.language == .zh_cn {
            logoView.image = UIImage(named: "fcr_login_logo_text_zh")
            textView.image = UIImage(named: "fcr_login_text_zh")
        } else {
            logoView.image = UIImage(named: "fcr_login_logo_text_en")
            textView.image = UIImage(named: "fcr_login_text_en")
        }
    }
    
    func createAnimation() {
        guard let bounds = UIApplication.shared.keyWindow?.bounds else {
            return
        }
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        
        let point0 = CGPoint(x: 20,
                             y: 56)
        
        let point1 = CGPoint(x: bounds.maxX - 20,
                             y: 0.3 * bounds.height)
        
        let point2 = CGPoint(x: 20,
                             y: 0.6 * bounds.height)
        
        let point3 = CGPoint(x: bounds.maxX - 20,
                             y: bounds.maxY - 20)
        
        animation.values = [NSValue(cgPoint: point0),
                            NSValue(cgPoint: point1),
                            NSValue(cgPoint: point2),
                            NSValue(cgPoint: point3),
                            NSValue(cgPoint: point2),
                            NSValue(cgPoint: point1),
                            NSValue(cgPoint: point0)]
        
        animation.duration = 24
        animation.repeatCount = MAXFLOAT
        
        haloView.layer.add(animation,
                           forKey: "com.agora.halo")
    }
}
