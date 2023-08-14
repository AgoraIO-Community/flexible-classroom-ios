//
//  FcrAppUIRegionViewController.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/6/30.
//  Copyright © 2022 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUIRegionViewController: FcrAppUIViewController, AgoraUIContentContainer {
    private let tableView = FcrAppUISettingTableView(frame: .zero,
                                                     style: .plain)
        
    private let dataSource = FcrAppUIRegion.allCases
    
    private var selectedRegion: FcrAppUIRegion
    
    private var center: FcrAppCenter
    
    init(center: FcrAppCenter) {
        self.center = center
        self.selectedRegion = center.urlGroup.region
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
        title = "fcr_settings_label_region".localized()
    }
}

extension FcrAppUIRegionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: FcrAppUICheckBoxCell.self)
        let type = dataSource[indexPath.row]
        
        cell.infoLabel.text = type.rawValue
        cell.aSelected = (selectedRegion == type)

        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: false)
        let type = dataSource[indexPath.row]
        
        selectedRegion = type
        tableView.reloadData()
        
        center.urlGroup.region = type
    }
}
