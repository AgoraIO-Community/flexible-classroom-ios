//
//  RoomCreateMoreInfoCells.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/9/17.
//  Copyright © 2022 Agora. All rights reserved.
//

import UIKit


// 伪直播开关
class RoomPlayBackInfoCell: UITableViewCell {
    
    public let switchButton = UIButton(type: .custom)
    
    private let cardView = UIView()
    
    private let lineView = UIView()
    
    private let iconView = UIImageView(image: UIImage(named: "fcr_room_create_playback"))
    
    private let titleLabel = UILabel()
        
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        createViews()
        createConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        cardView.backgroundColor = UIColor.white
        contentView.addSubview(cardView)
        
        lineView.backgroundColor = UIColor(hex: 0xEFEFEF)
        contentView.addSubview(lineView)
        
        contentView.addSubview(iconView)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        titleLabel.text = "fcr_create_more_playback".localized()
        titleLabel.textColor = UIColor.black
        contentView.addSubview(titleLabel)
        
        switchButton.setImage(UIImage(named: "fcr_room_create_off"),
                              for: .normal)
        switchButton.setImage(UIImage(named: "fcr_room_create_on"),
                              for: .selected)
        contentView.addSubview(switchButton)
    }
    
    private func createConstrains() {
        cardView.mas_makeConstraints { make in
            make?.top.bottom().equalTo()(0)
            make?.left.equalTo()(15)
            make?.right.equalTo()(-15)
        }
        lineView.mas_makeConstraints { make in
            make?.left.equalTo()(cardView)?.offset()(15)
            make?.right.bottom().equalTo()(0)
            make?.height.equalTo()(1)
        }
        iconView.mas_makeConstraints { make in
            make?.left.equalTo()(cardView)?.offset()(16)
            make?.centerY.equalTo()(0)
            make?.width.height().equalTo()(18)
        }
        titleLabel.mas_makeConstraints { make in
            make?.left.equalTo()(iconView.mas_right)?.offset()(8)
            make?.centerY.equalTo()(iconView)
        }
        switchButton.mas_makeConstraints { make in
            make?.right.equalTo()(cardView)?.offset()(-16)
            make?.centerY.equalTo()(0)
        }
    }
}
// 伪直播输入框
class RoomPlayBackInputCell: UITableViewCell {
            
    public let label = UILabel()
    
    private let cardView = UIView()
    
    private let lineView = UIView()
    
    private let arrow = UIImageView(image: UIImage(named: "fcr_room_create_right_arrow"))
        
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        createViews()
        createConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        cardView.backgroundColor = UIColor.white
        contentView.addSubview(cardView)
        
        lineView.backgroundColor = UIColor(hex: 0xEFEFEF)
        contentView.addSubview(lineView)
        
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.black
        contentView.addSubview(label)
        
        contentView.addSubview(arrow)
    }
    
    private func createConstrains() {
        cardView.mas_makeConstraints { make in
            make?.top.bottom().equalTo()(0)
            make?.left.equalTo()(15)
            make?.right.equalTo()(-15)
        }
        lineView.mas_makeConstraints { make in
            make?.left.equalTo()(cardView)?.offset()(15)
            make?.right.bottom().equalTo()(0)
            make?.height.equalTo()(1)
        }
        arrow.mas_makeConstraints { make in
            make?.centerY.equalTo()(0)
            make?.right.equalTo()(cardView)?.offset()(-12)
            make?.width.height().equalTo()(30)
        }
        label.mas_makeConstraints { make in
            make?.left.equalTo()(cardView)?.offset()(46)
            make?.top.bottom().equalTo()(0)
            make?.right.equalTo()(arrow.mas_left)
        }
    }
}
