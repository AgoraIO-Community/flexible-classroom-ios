//
//  FcrAppUIModeViewController.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/6/30.
//  Copyright © 2022 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUIModeViewController: FcrAppViewController, AgoraUIContentContainer {
    private let tableView = FcrAppUISettingTableView(frame: .zero,
                                                     style: .plain)
    
    private let dataSource = FcrAppUIMode.allCases
    
    private var selectedMode: FcrAppUIMode
    
    private var center: FcrAppCenter
    
    init(center: FcrAppCenter) {
        self.center = center
        self.selectedMode = center.uiMode
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.register(cellWithClass: FcrAppUICheckBoxCell.self)
        view.addSubview(tableView)
    }
    
    func initViewFrame() {
        tableView.mas_makeConstraints { make in
            make?.left.right().top().bottom().equalTo()(0)
        }
    }
    
    func updateViewProperties() {
        title = "settings_theme".localized()
        
        tableView.reloadData()
    }
}

extension FcrAppUIModeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = dataSource[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withClass: FcrAppUICheckBoxCell.self)
        
        cell.infoLabel.text = type.text()
        cell.aSelected = (selectedMode == type)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: true)
        
        let type = dataSource[indexPath.row]
        selectedMode = type
        tableView.reloadData()
        
        center.uiMode = type
    }
}
