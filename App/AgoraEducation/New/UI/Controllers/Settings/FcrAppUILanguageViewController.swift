//
//  FcrLanguageViewController.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/6/30.
//  Copyright © 2022 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUILanguageViewController: FcrAppViewController, AgoraUIContentContainer {
    private let tableView = FcrAppUISettingTableView(frame: .zero,
                                                     style: .plain)
    
    private let dataSource = FcrAppUILanguage.allCases
    
    private var selectedLanguage: FcrAppUILanguage
    
    private var center: FcrAppCenter
    
    init(center: FcrAppCenter) {
        self.center = center
        self.selectedLanguage = center.language
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
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        
        tableView.register(cellWithClass: FcrAppUICheckBoxCell.self)
    }
    
    func initViewFrame() {
        tableView.mas_makeConstraints { make in
            make?.left.right().top().bottom().equalTo()(0)
        }
    }
    
    func updateViewProperties() {
        title = "fcr_settings_label_language".localized()
        
        tableView.reloadData()
    }
}

extension FcrAppUILanguageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: FcrAppUICheckBoxCell.self)
        let type = dataSource[indexPath.row]
        cell.infoLabel.text = type.text()
        cell.aSelected = (selectedLanguage == type)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: true)
        
        let selected = dataSource[indexPath.row]
        
        selectedLanguage = selected
        center.language = selected
    }
}
