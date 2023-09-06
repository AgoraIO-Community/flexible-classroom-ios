//
//  FcrAppUICheckBoxCell.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/6/30.
//  Copyright © 2022 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUICheckBoxCell: UITableViewCell,
                            AgoraUIContentContainer {
    private var checkBox = UIImageView(frame: .zero)
    
    var aSelected = false {
        didSet {
            guard aSelected != oldValue else {
                return
            }
            
            if aSelected {
                checkBox.image = UIImage(named: "ic_round_check_box_sel")
            } else {
                checkBox.image = UIImage(named: "ic_round_check_box_unsel")
            }
        }
    }
    
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
        addSubview(checkBox)
    }
    
    func initViewFrame() {
        infoLabel.mas_makeConstraints { make in
            make?.left.equalTo()(16)
            make?.centerY.equalTo()(0)
        }
        
        checkBox.mas_makeConstraints { make in
            make?.right.equalTo()(-20)
            make?.centerY.equalTo()(0)
        }
    }
    
    func updateViewProperties() {
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        infoLabel.textColor = UIColor(hex: 0x191919)
        infoLabel.textAlignment = .left
    }
}
