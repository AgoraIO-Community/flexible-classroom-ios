//
//  FcrAppUISettingsViewController.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/6/30.
//  Copyright © 2022 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUISettingsViewController: FcrAppUIViewController {
    private enum Item: Int {
        case generalSetting
        case aboutUs
    }
    
    private let tableView = FcrAppUISettingTableView(frame: .zero,
                                                     style: .plain)
    
    private let logoutButton = UIButton(type: .system)
    
    private let dataSource: [Item] = [.generalSetting,
                                      .aboutUs]
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false,
                                                     animated: true)
    }
}

// MARK: - AgoraUIContentContainer
extension FcrAppUISettingsViewController: AgoraUIContentContainer {
    func initViews() {
        view.addSubview(tableView)
        view.addSubview(logoutButton)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.register(cellWithClass: FcrAppUINavigatorCell.self)
        
        logoutButton.addTarget(self,
                               action: #selector(onClickLogout),
                               for: .touchUpInside)
    }
    
    func initViewFrame() {
        tableView.mas_makeConstraints { make in
            make?.left.right().top().bottom().equalTo()(0)
        }
        
        logoutButton.mas_makeConstraints { make in
            make?.centerX.equalTo()(0)
            make?.height.equalTo()(44)
            make?.width.equalTo()(300)
            make?.bottom.equalTo()(-60)
        }
    }
    
    func updateViewProperties() {
        title = "settings_setting".localized()
        
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.borderColor = UIColor(hex: 0xD2D2E2)?.cgColor
        logoutButton.layer.cornerRadius = 6
        logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        logoutButton.setTitleColor(UIColor(hex: 0x357BF6),
                                   for: .normal)
        logoutButton.setTitle("settings_logout".localized(),
                              for: .normal)
    }
}

private extension FcrAppUISettingsViewController {
    func onClickGeneralSettings() {
        let vc = FcrAppUIGeneralSettingsViewController(center: center)
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    func onClickAbout() {
        let vc = FcrAppUIAboutViewController()
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    @objc func onClickLogout() {
        let confirm = AgoraAlertAction(title: "fcr_alert_submit".localized()) { [weak self] _ in
            guard let `self` = self else {
                return
            }
            
            self.center.logout { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }

        let cancel = AgoraAlertAction(title: "fcr_alert_cancel".localized())

        showAlert(title: "fcr_alert_title".localized(),
                  contentList: ["settings_logout_alert".localized()],
                  actions: [confirm,
                            cancel])
    }
}

extension FcrAppUISettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: FcrAppUINavigatorCell.self)
        let type = dataSource[indexPath.row]
        
        switch type {
        case .generalSetting:
            cell.infoLabel.text = "fcr_settings_option_general".localized()
        case .aboutUs:
            cell.infoLabel.text = "fcr_settings_option_about_us".localized()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let type = dataSource[indexPath.row]
        
        switch type {
        case .generalSetting:
            onClickGeneralSettings()
        case .aboutUs:
            onClickAbout()
        }
    }
}
