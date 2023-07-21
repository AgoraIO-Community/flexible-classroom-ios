//
//  FcrAppUICloseAccountViewController.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/7/11.
//  Copyright © 2022 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUICloseAccountViewController: FcrAppViewController, AgoraUIContentContainer {
    private let closeAccountButton = UIButton(type: .custom)
    private let checkBox = UIButton(type: .custom)
    private let textLabel = UILabel()
    
    private var center: FcrAppCenter
    
    init(center: FcrAppCenter) {
        self.center = center
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
    }
    
    func initViews() {
        view.addSubview(textLabel)
        view.addSubview(checkBox)
        view.addSubview(closeAccountButton)
        
        textLabel.numberOfLines = 0
        
        checkBox.addTarget(self,
                           action: #selector(onClickCheckBox(_:)),
                           for: .touchUpInside)
        checkBox.titleLabel?.adjustsFontSizeToFitWidth = true
        checkBox.titleEdgeInsets = UIEdgeInsets(top: 0,
                                                left: 10,
                                                bottom: 0,
                                                right: 0)
        
        closeAccountButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
       
        closeAccountButton.isEnabled = false
     
        closeAccountButton.addTarget(self,
                               action: #selector(onPressedCloseAccountButton),
                               for: .touchUpInside)
    }
    
    func initViewFrame() {
        textLabel.mas_makeConstraints { make in
            make?.left.equalTo()(20)
            make?.right.equalTo()(-20)
            make?.top.equalTo()(10)
        }
        
        checkBox.mas_makeConstraints { make in
            make?.left.equalTo()(textLabel)
            make?.top.equalTo()(textLabel.mas_bottom)?.offset()(30)
            make?.height.equalTo()(30)
        }
        
        closeAccountButton.mas_makeConstraints { make in
            make?.centerX.equalTo()(0)
            make?.height.equalTo()(44)
            make?.width.equalTo()(300)
            make?.bottom.equalTo()(-60)
        }
    }
    
    func updateViewProperties() {
        view.backgroundColor = UIColor(hex: 0xF9F9FC)
        title = "settings_close_account".localized()
        
        let attrString = NSMutableAttributedString(string: "settings_logoff_detail".localized())
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.paragraphSpacing = 21
        let attr: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 18),
                                                    .foregroundColor: UIColor(hex: 0x191919) as Any,
                                                    .paragraphStyle: paraStyle]
        let range = NSRange(location: 0,
                            length: attrString.length)
        attrString.addAttributes(attr,
                                 range: range)
        textLabel.attributedText = attrString
        
        checkBox.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        checkBox.setTitleColor(UIColor(hex: 0x191919),
                               for: .normal)
        checkBox.setTitle("settings_logoff_agreenment".localized(),
                          for: .normal)
        checkBox.setImage(UIImage(named: "checkBox_unchecked"),
                          for: .normal)
        checkBox.setImage(UIImage(named: "checkBox_checked"),
                          for: .selected)
        
        closeAccountButton.layer.borderWidth = 1
        closeAccountButton.layer.borderColor = UIColor(hex: 0xD2D2E2)?.cgColor
        closeAccountButton.layer.cornerRadius = 6
        
        closeAccountButton.setTitleColor(UIColor(hex: 0x677386),
                                   for: .disabled)
        closeAccountButton.setTitleColor(UIColor(hex: 0x357BF6),
                                   for: .normal)
        
        closeAccountButton.setTitle("settings_logoff_submit".localized(),
                              for: .normal)
    }
}

private extension FcrAppUICloseAccountViewController {
    @objc func onPressedCloseAccountButton() {
        let title = "fcr_alert_title".localized()
        let message = "settings_logoff_alert".localized()
        
        let confirm = AgoraAlertAction(title: "fcr_alert_submit".localized()) { [weak self] _ in
            self?.closeAccount()
        }
        
        let cancel = AgoraAlertAction(title: "fcr_alert_cancel".localized())
        
        showAlert(title: title,
                  contentList: [message],
                  actions: [confirm,
                            cancel])
    }
    
    @objc func onClickCheckBox(_ sender: UIButton) {
        sender.isSelected.toggle()
        closeAccountButton.isEnabled = sender.isSelected
    }
    
    func closeAccount() {
        AgoraLoading.loading()
        
        center.closeAccount { [weak self] in
            AgoraLoading.hide()
            self?.navigationController?.popToRootViewController(animated: true)
        } failure: { [weak self] error in
            AgoraLoading.hide()
            self?.showErrorToast(error)
        }
    }
}
