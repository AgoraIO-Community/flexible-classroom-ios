//
//  FcrAppUILoginViewController.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/9/21.
//  Copyright © 2022 Agora. All rights reserved.
//

import AgoraUIBaseViews
import UIKit

fileprivate class StartButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let `imageView` = imageView else {
            return
        }
        
        let offset: CGFloat = 4
        var height: CGFloat = bounds.height - (offset * 2)
        var width: CGFloat = height
        var x: CGFloat = offset
        var y: CGFloat = offset
        
        imageView.frame = CGRect(x: x,
                                 y: y,
                                 width: width,
                                 height: height)
        
        guard let label = titleLabel else {
            return
        }
        
        x = imageView.frame.maxX
        y = 0
        width = bounds.width - x
        height = bounds.height
        
        label.frame = CGRect(x: x,
                             y: y,
                             width: width,
                             height: height)
    }
}

class FcrAppUILoginViewController: FcrAppUIViewController {
    private let logoView = UIButton(frame: .zero)
    
    private let backgroundView = UIImageView(frame: .zero)
    
    private let textBgView = UIImageView(frame: .zero)
    
    private let textView = UIImageView(frame: .zero)
    
    private let haloView = UIImageView(frame: .zero)
    
    private let afcView = UIImageView(frame: .zero)
    
    private let startButton = StartButton(frame: .zero)
    
    private let policyView = FcrAppUIPolicyView(checkBoxNormalImage: "fcr_notchoosed",
                                                checkBoxSelectedImage: "fcr_choosed")
    
    private let testTag = UIButton()
    
    private var center: FcrAppCenter
    
    var onCompleted: FcrAppCompletion?
    
    init(center: FcrAppCenter,
         onCompleted: FcrAppCompletion? = nil) {
        self.center = center
        self.onCompleted = onCompleted
        super.init(nibName: nil,
                   bundle: nil)
        center.tester.delegate = self
    }
    
    deinit {
        removeAppActiveObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true,
                                                     animated: true)
        isTest()
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
        privacyCheck()
        addAppActiveObserver()
        tester()
    }
    
    private func addAppActiveObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidBecomeActive),
                                               name: NSNotification.Name("app_did_become_active"),
                                               object: nil)
    }
    
    private func removeAppActiveObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func appDidBecomeActive() {
        createAnimation()
    }
    
    private func privacyCheck() {
        guard center.isFirstAgreedPrivacy == false else {
            return
        }
        
        let vc = FcrAppUIPrivacyTermsViewController(contentHeight: 456,
                                                    contentViewOffY: -15,
                                                    contentViewHorizontalSpace: 15)
        
        presentViewController(vc,
                              animated: true)
        
        vc.onAgreedCompletion = { [weak self] in
            self?.center.isFirstAgreedPrivacy = true
        }
    }
    
    @objc private func onStartButtonPressed() {
        guard policyView.checkBox.isSelected else {
            showToast(FcrAppUIPolicyString().toastString(),
                      type: .error)
            return
        }
        
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
        view.addSubview(backgroundView)
        view.addSubview(logoView)
        view.addSubview(haloView)
        view.addSubview(textBgView)
        view.addSubview(textView)
        view.addSubview(afcView)
        view.addSubview(startButton)
        view.addSubview(policyView)
        view.addSubview(testTag)
        
        textView.contentMode = .scaleAspectFit
        
        startButton.addTarget(self,
                              action: #selector(onStartButtonPressed),
                              for: .touchUpInside)
        
        startButton.layer.cornerRadius = 26
        startButton.layer.masksToBounds = true
        startButton.titleLabel?.font = FcrAppUIFontGroup.font16
        startButton.titleLabel?.textAlignment = .center
        
        policyView.checkBox.isSelected = center.isAgreedPrivacy
        
        policyView.checkBox.addTarget(self,
                                      action: #selector(doPolicyPressed(_ :)),
                                      for: .touchUpInside)
        
        testTag.titleLabel?.font = FcrAppUIFontGroup.font20
        testTag.setTitleColor(.white,
                              for: .normal)
        testTag.setTitle("Test",
                         for: .normal)
        testTag.isHidden = true
    }
    
    func initViewFrame() {
        var compactLayout = UIDevice.current.isSmallPhone
        
        if UIDevice.current.agora_is_pad {
            compactLayout = true
        }
        
        textBgView.isHidden = !compactLayout
        
        let isEn = center.language.isEN
        
        let leftSideSpace: CGFloat = 38
        
        logoView.mas_makeConstraints { make in
            let top: CGFloat = (compactLayout ? 24 : 55)
            let `left`: CGFloat = (leftSideSpace - 2)
            
            make?.top.equalTo()(top)
            make?.left.equalTo()(`left`)
            make?.width.equalTo()(178)
            make?.height.equalTo()(32)
        }
        
        testTag.mas_makeConstraints { make in
            make?.right.equalTo()(-20)
            make?.centerY.equalTo()(logoView.mas_centerY)
            make?.height.equalTo()(20)
        }
        
        backgroundView.mas_makeConstraints { make in
            let offset: CGFloat = (compactLayout ? 18 : 32)
            
            make?.left.equalTo()(leftSideSpace)
            make?.right.equalTo()(-leftSideSpace)
            make?.top.equalTo()(logoView.mas_bottom)?.offset()(offset)
            make?.height.equalTo()(backgroundView.mas_width)
        }
        
        textView.mas_makeConstraints { make in
            make?.left.equalTo()(leftSideSpace)
            
            if isEn {
                let offset: CGFloat = (compactLayout ? -50 : 19)
                
                make?.top.equalTo()(backgroundView.mas_bottom)?.offset()(offset)
                
                make?.width.equalTo()(263)
                make?.height.equalTo()(135)
            } else {
                let offset: CGFloat = (compactLayout ? -50 : 36)
                
                make?.top.equalTo()(backgroundView.mas_bottom)?.offset()(offset)
                
                make?.width.equalTo()(232)
                make?.height.equalTo()(113)
            }
        }
        
        textBgView.mas_makeConstraints { make in
            make?.top.equalTo()(textView.mas_top)?.offset()(-14)
            make?.left.right().equalTo()(0)
            make?.height.equalTo()(textView.mas_height)?.offset()(77)
        }
        
        startButton.mas_makeConstraints { make in
            var offset: CGFloat
            
            if compactLayout {
                offset = (isEn ? 28 : 55)
            } else {
                offset = (isEn ? 28 : 33)
            }
            
            let width: CGFloat = 190
            let height: CGFloat = 52
            
            make?.top.equalTo()(textView.mas_bottom)?.offset()(offset)
            make?.left.equalTo()(leftSideSpace)
            make?.width.equalTo()(width)
            make?.height.equalTo()(height)
        }
        
        policyView.mas_makeConstraints { make in
            make?.left.equalTo()(self.startButton.mas_left)
            make?.top.equalTo()(self.startButton.mas_bottom)?.offset()(29)
            make?.height.equalTo()(40)
            make?.right.equalTo()(-leftSideSpace)
        }
        
        afcView.mas_makeConstraints { make in
            let offset: CGFloat = (compactLayout ? -20 : -30)
            
            make?.left.equalTo()(leftSideSpace)
            make?.bottom.equalTo()(self.mas_bottomLayoutGuideBottom)?.offset()(offset)
            make?.width.equalTo()(109)
            make?.height.equalTo()(36)
        }
    }
    
    func updateViewProperties() {
        view.backgroundColor = FcrAppUIColorGroup.fcr_black
        
        policyView.updateViewProperties()
        
        backgroundView.image = UIImage(named: "fcr_login_center_afc")
        textView.image = UIImage(named: "fcr_login_text_en")
        haloView.image = UIImage(named: "fcr_login_halo")
        afcView.image = UIImage(named: "fcr_login_corner_afc")
       
        startButton.setImage(UIImage(named: "fcr_login_get_start"),
                             for: .normal)
        
        startButton.setTitle("fcr_login_button_welcome".localized(),
                             for: .normal)
        
        startButton.layoutSubviews()
        startButton.backgroundColor = FcrAppUIColorGroup.fcr_v2_brand6
        
        textBgView.image = UIImage(named: "fcr_login_logo_text_bg")
        
        let logoViewImage = (center.language.isEN ? "fcr_login_logo_text_en" : "fcr_login_logo_text_zh")
        let textViewImage = (center.language.isEN ? "fcr_login_text_en" : "fcr_login_text_zh")
        
        logoView.setImage(UIImage(named: logoViewImage),
                          for: .normal)
        
        logoView.setImage(UIImage(named: logoViewImage),
                          for: .selected)
        
        logoView.setImage(UIImage(named: logoViewImage),
                          for: .highlighted)
        
        textView.image = UIImage(named: textViewImage)
        
        policyView.textView.backgroundColor = .clear
        
        policyView.textView.attributedText = FcrAppUIPolicyString().loginString()
    }
    
    @objc private func doPolicyPressed(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        center.isAgreedPrivacy = sender.isSelected
    }
    
    private func createAnimation() {
        guard let bounds = UIApplication.shared.keyWindow?.bounds else {
            return
        }
        
        haloView.frame = CGRect(x: 0,
                                y: 0,
                                width: 100,
                                height: 100)
        
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

// MARK: - Tester
extension FcrAppUILoginViewController: FcrAppTesterDelegate {
    func tester() {
        logoView.addTarget(self,
                           action: #selector(onTestButtonPressed(_ :)),
                           for: .touchUpInside)
        
        testTag.addTarget(self,
                          action: #selector(onTestTagPressed(_ :)),
                          for: .touchUpInside)
    }
    
    @objc func onTestButtonPressed(_ sender: UIButton) {
        center.tester.switchMode()
    }
    
    @objc func onTestTagPressed(_ sender: UIButton) {
        presentQuickStartViewController()
    }
    
    func isTest() {
        center.tester.delegate = self
        onIsTestMode(center.tester.isTest)
    }
    
    func onIsTestMode(_ isTest: Bool) {
        testTag.isHidden = !isTest
    }
    
    func presentQuickStartViewController() {
        let vc = FcrAppUIQuickStartViewController(center: center)
        let navigation = FcrAppUINavigationController(rootViewController: vc)

        navigation.modalPresentationStyle = .fullScreen
        navigation.modalTransitionStyle = .crossDissolve

        present(navigation,
                animated: true)
    }
}
