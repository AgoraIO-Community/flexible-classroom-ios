//
//  FcrAppUILoginViewController.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/9/21.
//  Copyright © 2022 Agora. All rights reserved.
//

import AgoraUIBaseViews

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

fileprivate class AgreementView: UIView,
                                 AgoraUIContentContainer {
    let closeButton = UIButton(frame: .zero)
    let titleLabel = UILabel(frame: .zero)
    let contentView = FcrAppUITextView(frame: .zero,
                                       textContainer: nil)
    
    let exitButton = UIButton(frame: .zero)
    let agreeButton = UIButton(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        initViewFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(titleLabel)
        addSubview(closeButton)
        addSubview(contentView)
        addSubview(exitButton)
        addSubview(agreeButton)
        
        closeButton.layer.cornerRadius = 10
        exitButton.layer.cornerRadius = 18
        agreeButton.layer.cornerRadius = 18
        
        // Title label
        titleLabel.font = FcrAppUIFontGroup.font16
        titleLabel.numberOfLines = 0
        
        // Content view
        contentView.font = FcrAppUIFontGroup.font12
    }
    
    func initViewFrame() {
        titleLabel.mas_makeConstraints { make in
            make?.top.equalTo()(20)
            make?.left.equalTo()(20)
            make?.right.equalTo()(-32)
            make?.bottom.equalTo()(contentView.mas_top)?.offset()(-15)
        }
        
        closeButton.mas_makeConstraints { make in
            make?.top.equalTo()(10)
            make?.right.equalTo()(-10)
            make?.height.equalTo()(20)
            make?.width.equalTo()(20)
        }
        
        contentView.mas_makeConstraints { make in
            make?.left.equalTo()(20)
            make?.right.equalTo()(-20)
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(15)
            make?.bottom.equalTo()(-15)
        }
        
        exitButton.mas_makeConstraints { make in
            make?.left.equalTo()(20)
            make?.bottom.equalTo()(-20)
            make?.width.equalTo()(110)
            make?.height.equalTo()(36)
        }
        
        agreeButton.mas_makeConstraints { make in
            make?.right.equalTo()(-20)
            make?.bottom.equalTo()(-20)
            make?.width.equalTo()(110)
            make?.height.equalTo()(36)
        }
    }
    
    func updateViewProperties() {
        // Close button
        closeButton.setImage(UIImage(named: "fcr_close"),
                             for: .normal)

        closeButton.backgroundColor = FcrAppUIColorGroup.fcr_v2_light4
        
        // Title label
        titleLabel.textColor = FcrAppUIColorGroup.fcr_v2_light_text1
        
        // Exit button
        exitButton.setTitleColor(FcrAppUIColorGroup.fcr_v2_light_text1,
                                 for: .normal)
        exitButton.setTitle("fcr_login_popup_window_again_button_disagree".localized(),
                            for: .normal)
        exitButton.backgroundColor = FcrAppUIColorGroup.fcr_v2_light1
        
        exitButton.titleLabel?.font = FcrAppUIFontGroup.font14
        
        // Agree button
        agreeButton.setTitleColor(FcrAppUIColorGroup.fcr_white,
                                 for: .normal)
        agreeButton.setTitle("fcr_login_popup_window_again_button_agree".localized(),
                             for: .normal)
        agreeButton.backgroundColor = FcrAppUIColorGroup.fcr_v2_brand6
        
        agreeButton.titleLabel?.font = FcrAppUIFontGroup.font14
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
    
    private let agreementView = AgreementView(frame: .zero)
    
    private let closeButton = UIButton(frame: .zero)
    
    private let testTag = UIButton()
    
    private var center: FcrAppCenter
    
    var onCompleted: FcrAppCompletion?
    
    init(center: FcrAppCenter,
         closeIsHidden: Bool = true,
         onCompleted: FcrAppCompletion? = nil) {
        self.center = center
        self.onCompleted = onCompleted
        super.init(nibName: nil,
                   bundle: nil)
        center.tester.delegate = self
        closeButton.isHidden = closeIsHidden
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
        
        if center.isLogined {
            showMainVC(animated: true)
        }
    }
    
    private func showMainVC(animated: Bool = false) {
        let mainVC = FcrAppUIMainViewController(center: center)
        navigationController?.pushViewController(mainVC,
                                                 animated: animated)
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
        
        let contentTextTopSpace: CGFloat = 73
        let contentTextBottomSpace: CGFloat = 144
        let contentViewOffY: CGFloat = 15
        
        let contentViewHorizontalSpace: CGFloat = 15
        let text = FcrAppUIPolicyString().loginDetailString(isMainLandChina: center.isMainLandChinaIP).mutableString as String
        let contentTextHorizontalSpace: CGFloat = 30
        let contentTextWidth = (UIScreen.agora_width - (contentViewHorizontalSpace + contentTextHorizontalSpace) * 2)
        let contentTextHeight = text.agora_size(font: FcrAppUIFontGroup.font12,
                                                width: contentTextWidth).height
        
        let contentHeight = contentTextHeight + contentTextTopSpace + contentTextBottomSpace + contentViewOffY
        
        let vc = FcrAppUIPrivacyTermsViewController(contentHeight: contentHeight,
                                                    contentViewOffY: -contentViewOffY,
                                                    contentViewHorizontalSpace: contentViewHorizontalSpace,
                                                    canHide: false, isMainLandChina: center.isMainLandChinaIP)
        
        presentViewController(vc,
                              animated: true)
        
        vc.onAgreedCompletion = { [weak self] (isAgreed) in
            if isAgreed {
                self?.center.isFirstAgreedPrivacy = true
            } else {
                self?.showAgreementView()
            }
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
        view.addSubview(closeButton)
        view.addSubview(agreementView)
        view.addSubview(testTag)
        
        textView.contentMode = .scaleAspectFit
        
        startButton.addTarget(self,
                              action: #selector(onStartButtonPressed),
                              for: .touchUpInside)
        
        startButton.layer.cornerRadius = 26
        startButton.layer.masksToBounds = true
        startButton.titleLabel?.font = FcrAppUIFontGroup.font16
        startButton.titleLabel?.textAlignment = .center
        
        policyView.checkBox.addTarget(self,
                                      action: #selector(onPolicyPressed(_ :)),
                                      for: .touchUpInside)
        
        closeButton.setImage(UIImage(named: "fcr_close"),
                             for: .normal)
        
        closeButton.backgroundColor = FcrAppUIColorGroup.fcr_app_white
        closeButton.layer.cornerRadius = 18
        closeButton.layer.masksToBounds = true
        
        closeButton.addTarget(self,
                              action: #selector(onCloseButtonPressed),
                              for: .touchUpInside)
        
        testTag.titleLabel?.font = FcrAppUIFontGroup.font20
        testTag.setTitleColor(.white,
                              for: .normal)
        testTag.setTitle("Test",
                         for: .normal)
        testTag.isHidden = true
        
        agreementView.titleLabel.text = FcrAppUIPolicyString().loginTitleString(isMainLandChina: center.isMainLandChinaIP)
        agreementView.contentView.attributedText = FcrAppUIPolicyString().loginDetailString2(isMainLandChina: center.isMainLandChinaIP)
        
        agreementView.closeButton.addTarget(self,
                                            action: #selector(onCloseButtonOfAgreementViewPressed),
                                            for: .touchUpInside)
        
        agreementView.exitButton.addTarget(self,
                                           action: #selector(onExitButtonOfAgreementViewPressed),
                                           for: .touchUpInside)
        
        agreementView.agreeButton.addTarget(self,
                                            action: #selector(onAgreeButtonOfAgreementViewPressed),
                                            for: .touchUpInside)
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
        
        closeButton.mas_makeConstraints { make in
            make?.right.equalTo()(-20)
            make?.centerY.equalTo()(logoView.mas_centerY)
            make?.width.height().equalTo()(36)
        }
        
        testTag.mas_makeConstraints { make in
            make?.right.equalTo()(closeButton.mas_left)?.offset()(-20)
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
        
        let contentWidth: CGFloat = 275
        
        let titleText = FcrAppUIPolicyString().loginTitleString(isMainLandChina: center.isMainLandChinaIP)
        let titleTextWidth: CGFloat = (contentWidth - 20 - 32)
        let titleTextHeight = titleText.agora_size(font: agreementView.titleLabel.font,
                                                   width: titleTextWidth).height
        
        let titleTextTopSpace: CGFloat = 20
        
        let contentText = FcrAppUIPolicyString().loginDetailString2(isMainLandChina: center.isMainLandChinaIP).mutableString as String
        
        let contentTextWidth: CGFloat = (contentWidth - 20 - 20)
        let contentTextHeight = contentText.agora_size(font: FcrAppUIFontGroup.font12,
                                                       width: contentTextWidth).height
        
        let contentTextTopSpace: CGFloat = 15
        let contentTextBottomSpace: CGFloat = 71
        
        let contentHeight: CGFloat = (titleTextTopSpace + titleTextHeight + contentTextHeight + contentTextTopSpace + contentTextBottomSpace)
        
        let x: CGFloat = (UIScreen.agora_width - contentWidth) * 0.5
        let y: CGFloat = UIScreen.agora_height
        
        let frame = CGRect(x: x,
                           y: y,
                           width: contentWidth,
                           height: contentHeight)
        
        agreementView.frame = frame
        
        agreementView.layer.cornerRadius = 16
    }
    
    func updateViewProperties() {
        view.backgroundColor = FcrAppUIColorGroup.fcr_black
        
        policyView.updateViewProperties()
        agreementView.updateViewProperties()
        
        agreementView.backgroundColor = .white
        
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
        
        policyView.textView.attributedText = FcrAppUIPolicyString().loginString(isMainLandChina: center.isMainLandChinaIP)
    }
}

// MARK: - Action
private extension FcrAppUILoginViewController {
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
                guard isLogined else {
                    return
                }
                
                self?.showMainVC(animated: true)
            }
            
            self.navigationController?.pushViewController(vc,
                                                          animated: true)
        } failure: { [weak self] error in
            AgoraLoading.hide()
            
            self?.showErrorToast(error)
        }
    }
    
    @objc func onCloseButtonPressed() {
        navigationController?.dismiss(animated: true)
    }
    
    @objc func onPolicyPressed(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @objc func onCloseButtonOfAgreementViewPressed() {
        hideAgreementView()
    }
    
    @objc func onAgreeButtonOfAgreementViewPressed() {
        hideAgreementView()
        center.isFirstAgreedPrivacy = true
        policyView.checkBox.isSelected = true
    }
    
    @objc func onExitButtonOfAgreementViewPressed() {
        exit(0)
    }
}

private extension FcrAppUILoginViewController {
    func createAnimation() {
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
    
    func showAgreementView() {
        var new = agreementView.frame
       
        let y: CGFloat = (UIScreen.agora_height - new.size.height) * 0.5
        
        new.origin.y = y

        UIView.animate(withDuration: TimeInterval.agora_animation) {
            self.agreementView.frame = new
        }
    }
    
    func hideAgreementView() {
        let y: CGFloat = UIScreen.agora_height
        
        var new = agreementView.frame
        new.origin.y = y

        UIView.animate(withDuration: TimeInterval.agora_animation) {
            self.agreementView.frame = new
        }
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
        navigationController?.dismiss(animated: true)
    }
    
    func isTest() {
        center.tester.delegate = self
        onIsTestMode(center.tester.isTest)
    }
    
    func onIsTestMode(_ isTest: Bool) {
        testTag.isHidden = !isTest
    }
}
