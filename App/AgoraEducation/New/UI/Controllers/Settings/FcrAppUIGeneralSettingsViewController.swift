//
//  FcrAppUIGeneralSettingsViewController.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/6/30.
//  Copyright © 2022 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUIGeneralSettingsViewController: FcrAppUIViewController {
    private enum Item: Int {
        case nickname
        case language
        case region
        case mode
        case logoff
    }
    
    private let tableView = FcrAppUISettingTableView(frame: .zero,
                                                     style: .plain)
    
    private let dataSource: [Item] = [.nickname,
                                      .language,
                                      .region,
                                      .mode,
                                      .logoff]
    
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
}

extension FcrAppUIGeneralSettingsViewController: AgoraUIContentContainer {
    func initViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.register(cellWithClass: FcrAppUINavigatorCell.self)
        view.addSubview(tableView)
    }
    
    func initViewFrame() {
        tableView.mas_makeConstraints { make in
            make?.left.right().top().bottom().equalTo()(0)
        }
    }
    
    func updateViewProperties() {
        title = "fcr_settings_option_general".localized()
    }
}

extension FcrAppUIGeneralSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: FcrAppUINavigatorCell.self)
        let type = dataSource[indexPath.row]
        
        switch type {
        case .nickname:
            cell.infoLabel.text = "settings_nickname".localized()
        case .language:
            cell.infoLabel.text = "fcr_settings_label_language".localized()
        case .region:
            cell.infoLabel.text = "fcr_settings_label_region".localized()
        case .mode:
            cell.infoLabel.text = "settings_theme".localized()
        case .logoff:
            cell.infoLabel.text = "settings_close_account".localized()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: false)
        
        let type = dataSource[indexPath.row]
        
        switch type {
        case .nickname:
            let vc = FcrAppUINicknameViewController(center: center)
            navigationController?.pushViewController(vc,
                                                     animated: true)
        case .language:
            let vc = FcrAppUILanguageViewController(center: center)
            navigationController?.pushViewController(vc,
                                                     animated: true)
        case .region:
            let vc = FcrAppUIRegionViewController(center: center)
            navigationController?.pushViewController(vc,
                                                     animated: true)
        case .mode:
            let vc = FcrAppUIModeViewController(center: center)
            navigationController?.pushViewController(vc,
                                                     animated: true)
        case .logoff:
            let vc = FcrAppUICloseAccountViewController(center: center)
            navigationController?.pushViewController(vc,
                                                     animated: true)
        }
    }
}
