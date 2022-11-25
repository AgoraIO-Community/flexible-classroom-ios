//
//  LoginStartViewController.swift
//  AgoraEducation
//
//  Created by Jonathan on 2022/9/21.
//  Copyright © 2022 Agora. All rights reserved.
//

import AgoraUIBaseViews
import UIKit

class LoginStartViewController: UIViewController {
    public static func showLoginIfNot(complete: (() -> Void)?) {
        guard FcrUserInfoPresenter.shared.isLogin == false,
              let root = UIApplication.shared.keyWindow?.rootViewController
        else {
            complete?()
            return
        }
        let vc = LoginStartViewController()
        vc.onComplete = complete
        let navi = FcrNavigationController(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        navi.modalTransitionStyle = .crossDissolve
        root.present(navi, animated: true)
    }
    
    private let logoView = UIImageView(image: UIImage(named: "fcr_login_logo_text_en"))
    
    private let imageView = UIImageView(image: UIImage(named: "fcr_login_center_afc"))
    
    private let textView = UIImageView(image: UIImage(named: "fcr_login_text_en"))
    private let textBgView = UIImageView(image: UIImage(named: "fcr_login_logo_text_bg"))
    
    private let haloView = UIImageView(image: UIImage(named: "fcr_login_halo"))
    
    private let afcView = UIImageView(image: UIImage(named: "fcr_login_corner_afc"))
    
    private let startButton = UIButton(type: .custom)
    
    private var onComplete: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        createViews()
        createConstrains()
        createAnimation()
        localizedImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true,
                                                     animated: true)
    }
    
    public override var shouldAutorotate: Bool {
        return true
    }
    
    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIDevice.current.agora_is_pad ? .landscapeRight : .portrait
    }

    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIDevice.current.agora_is_pad ? .landscapeRight : .portrait
    }
    
    @objc func onClickStart() {
        AgoraLoading.loading()
        FcrOutsideClassAPI.getAuthWebPage { dict in
            AgoraLoading.hide()
            guard let redirectURL = dict["data"] as? String else {
                return
            }
            let vc = LoginWebViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.onComplete = self.onComplete
            vc.urlStr = redirectURL
            self.navigationController?.pushViewController(vc,
                                                          animated: true)
        } onFailure: { code, msg in
            AgoraLoading.hide()
            AgoraToast.toast(message: msg,
                             type: .error)
        }
    }
}
// MARK: - Creation
private extension LoginStartViewController {
    func createViews() {
        view.addSubview(imageView)
        view.addSubview(logoView)
        view.addSubview(textBgView)
        view.addSubview(haloView)
        view.addSubview(textView)
        view.addSubview(afcView)
        
        startButton.setBackgroundImage(UIImage(named: "fcr_login_get_start"),
                                       for: .normal)
        startButton.addTarget(self,
                              action: #selector(onClickStart),
                              for: .touchUpInside)
        view.addSubview(startButton)
        
        let isSmallDevice = (LoginConfig.device == .iPhone_Small)
        if !isSmallDevice {
            textBgView.agora_visible = false
        }
    }
    
    func createConstrains() {
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
    
    func createAnimation() {
        guard let bounds = UIApplication.shared.keyWindow?.bounds else {
            return
        }
        let animation = CAKeyframeAnimation(keyPath: "position")
        let point0 = CGPoint(x: 20, y: 56)
        let point1 = CGPoint(x: bounds.maxX - 20, y: 0.3 * bounds.height)
        let point2 = CGPoint(x: 20, y: 0.6 * bounds.height)
        let point3 = CGPoint(x: bounds.maxX - 20, y: bounds.maxY - 20)
        animation.values = [
            NSValue(cgPoint: point0),
            NSValue(cgPoint: point1),
            NSValue(cgPoint: point2),
            NSValue(cgPoint: point3),
            NSValue(cgPoint: point2),
            NSValue(cgPoint: point1),
            NSValue(cgPoint: point0)
        ]
        animation.duration = 24
        animation.repeatCount = MAXFLOAT
        haloView.layer.add(animation,
                           forKey: "com.agora.halo")
    }
    
    func localizedImage() {
        if FcrLocalization.shared.language == .zh_cn {
            logoView.image = UIImage(named: "fcr_login_logo_text_zh")
            textView.image = UIImage(named: "fcr_login_text_zh")
        } else {
            logoView.image = UIImage(named: "fcr_login_logo_text_en")
            textView.image = UIImage(named: "fcr_login_text_en")
        }
    }
}
