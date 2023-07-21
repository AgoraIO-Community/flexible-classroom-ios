//
//  FcrAppUIDetailInfoCell.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/6/30.
//  Copyright © 2022 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUIDetailInfoCell: UITableViewCell, AgoraUIContentContainer {
    let detailLabel = UILabel()
    let infoLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        initViews()
        initViewFrame()
        updateViewProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(infoLabel)
        addSubview(detailLabel)
        
        separatorInset = .zero
    }
    
    func initViewFrame() {
        infoLabel.mas_makeConstraints { make in
            make?.left.equalTo()(16)
            make?.centerY.equalTo()(0)
        }
        
        detailLabel.mas_makeConstraints { make in
            make?.right.equalTo()(-16)
            make?.centerY.equalTo()(0)
        }
    }
    
    func updateViewProperties() {
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        infoLabel.textColor = UIColor(hex: 0x191919)
        infoLabel.textAlignment = .left
        
        detailLabel.font = UIFont.systemFont(ofSize: 14)
        detailLabel.textColor = UIColor(hex: 0x191919)
        detailLabel.textAlignment = .right
    }
}
