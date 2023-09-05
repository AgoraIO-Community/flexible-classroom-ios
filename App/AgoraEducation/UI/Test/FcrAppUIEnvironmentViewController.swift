//
//  FcrAppUIEnvironmentViewController.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/8/14.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUIEnvironmentViewController: FcrAppUIViewController,
                                         AgoraUIContentContainer {
    private let tableView = FcrAppUISettingTableView(frame: .zero,
                                                     style: .plain)
        
    private let dataSource = FcrAppUIEnvironment.allCases
    
    private var selected: FcrAppUIEnvironment
    
    private var center: FcrAppCenter
    
    init(center: FcrAppCenter) {
        self.center = center
        self.selected = center.urlGroup.environment
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

extension FcrAppUIEnvironmentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: FcrAppUICheckBoxCell.self)
        let type = dataSource[indexPath.row]
        
        cell.infoLabel.text = type.text
        cell.aSelected = (selected == type)

        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: false)
        let type = dataSource[indexPath.row]
        
        selected = type
        tableView.reloadData()
        
        center.urlGroup.environment = type
    }
}

extension FcrAppUIEnvironment {
    var text: String {
        switch self {
        case .dev: return "Development"
        case .pt:  return "Performance test"
        case .pre: return "Pre-production"
        case .pro: return "Production"
        }
    }
}
