//
//  FcrAppUIAboutViewController.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/6/30.
//  Copyright © 2022 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUIAboutViewController: FcrAppUIViewController {
    private enum Item: Int {
        case privacy
        case terms
        case disclaimer
        case publish
    }
    
    private let tableView = FcrAppUISettingTableView(frame: .zero,
                                                     style: .plain)
    
    private let dataSource: [Item] = [.privacy,
                                      .terms,
                                      .disclaimer,
                                      .publish]
    
    private let versionTime = ""
    
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

extension FcrAppUIAboutViewController: AgoraUIContentContainer {
    func initViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        
        tableView.register(cellWithClass: FcrAppUINavigatorCell.self)
        tableView.register(cellWithClass: FcrAppUIDetailInfoCell.self)
        view.addSubview(tableView)
    }
    
    func initViewFrame() {
        tableView.mas_makeConstraints { make in
            make?.left.right().top().bottom().equalTo()(0)
        }
    }
    
    func updateViewProperties() {
        title = "fcr_settings_label_about_us_about_us".localized()
    }
}

extension FcrAppUIAboutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = dataSource[indexPath.row]
        
        switch type {
        case .privacy:
            let cell = tableView.dequeueReusableCell(withClass: FcrAppUINavigatorCell.self)
            cell.infoLabel.text = "fcr_settings_link_about_us_privacy_policy".localized()
            return cell
        case .terms:
            let cell = tableView.dequeueReusableCell(withClass: FcrAppUINavigatorCell.self)
            cell.infoLabel.text = "fcr_settings_link_about_us_user_agreement".localized()
            return cell
        case .disclaimer:
            let cell = tableView.dequeueReusableCell(withClass: FcrAppUINavigatorCell.self)
            cell.infoLabel.text = "settings_disclaimer".localized()
            return cell
        case .publish:
            let cell = tableView.dequeueReusableCell(withClass: FcrAppUIDetailInfoCell.self)
            cell.infoLabel.text = "settings_publish_time".localized()
            cell.detailLabel.text = versionTime
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: true)
        
        let type = dataSource[indexPath.row]
        
        switch type {
        case .privacy:
            openURL("settings_srivacy_url".localized())
        case .terms:
            openURL("settings_terms_url".localized())
        case .disclaimer:
            let vc = FcrAppUIDisclaimerViewController()
            navigationController?.pushViewController(vc,
                                                     animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView,
                   shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let type = dataSource[indexPath.row]
        
        if type == .publish {
            return false
        } else {
            return true
        }
    }
}
