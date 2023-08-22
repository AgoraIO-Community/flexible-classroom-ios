//
//  FcrAppUISettingTableView.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/20.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUISettingTableView: UITableView,
                                AgoraUIContentContainer {
    private let footer = UIView(frame: .zero)
    
    override init(frame: CGRect,
                  style: UITableView.Style) {
        super.init(frame: frame,
                   style: style)
        initViews()
        initViewFrame()
        updateViewProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        tableFooterView = footer
    }
    
    func initViewFrame() {
        
    }
    
    func updateViewProperties() {
        footer.backgroundColor = UIColor(hexString: "#EEEEF7")
        
        rowHeight = 52
        separatorInset = .zero
        separatorColor = UIColor(hexString: "#EEEEF7")
    }
}
