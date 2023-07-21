//
//  FcrAppUINavigatorCell.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/6/30.
//  Copyright © 2022 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUINavigatorCell: UITableViewCell, AgoraUIContentContainer {
    private var arrow = UIImageView(image: UIImage(named: "ic_right_arrow"))
    
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
        separatorInset = .zero
        
        addSubview(infoLabel)
        addSubview(arrow)
    }
    
    func initViewFrame() {
        infoLabel.mas_makeConstraints { make in
            make?.left.equalTo()(16)
            make?.centerY.equalTo()(0)
        }
        
        arrow.mas_makeConstraints { make in
            make?.right.equalTo()(-16)
            make?.centerY.equalTo()(0)
        }
    }
    
    func updateViewProperties() {
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        infoLabel.textColor = UIColor(hex: 0x191919)
        infoLabel.textAlignment = .left
    }
}
