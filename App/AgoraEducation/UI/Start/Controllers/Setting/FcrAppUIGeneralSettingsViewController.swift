//
//  FcrAppUIGeneralSettingsViewController.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/6/30.
//  Copyright © 2022 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUIGeneralSettingsViewController: FcrAppUIViewController {
    private let tableView = FcrAppUISettingTableView(frame: .zero,
                                                     style: .plain)
    
    private let dataSource: [FcrAppUISettingItem.GeneralItem]
    
    private var center: FcrAppCenter
    
    init(center: FcrAppCenter,
         dataSource: [FcrAppUISettingItem.GeneralItem]) {
        self.center = center
        self.dataSource = dataSource
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
        
        tableView.reloadData()
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
        case .theme:
            cell.infoLabel.text = "settings_theme".localized()
        case .closeAccount:
            cell.infoLabel.text = "settings_close_account".localized()
        case .environment:
            cell.infoLabel.text = "Environment"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: false)
        
        let type = dataSource[indexPath.row]
        
        var vc: UIViewController
        
        switch type {
        case .nickname:
            vc = FcrAppUINicknameViewController(center: center)
        case .language:
            vc = FcrAppUILanguageViewController(center: center)
        case .region:
            vc = FcrAppUIRegionViewController(center: center)
        case .theme:
            vc = FcrAppUIModeViewController(center: center)
        case .environment:
            vc = FcrAppUIEnvironmentViewController(center: center)
        case .closeAccount:
            vc = FcrAppUICloseAccountViewController(center: center)
        }
        
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
}
