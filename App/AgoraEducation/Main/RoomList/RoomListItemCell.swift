//
//  FcrAppUIRoomListItemCell.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/9/2.
//  Copyright © 2022 Agora. All rights reserved.
//

import UIKit
import AgoraEduCore



//
class RoomListNotiCell: UITableViewCell {
    
    let cardView = UIView()
    
    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        
        cardView.backgroundColor = UIColor(hex: 0x357BF6)
        cardView.layer.cornerRadius = 20
        cardView.clipsToBounds = true
        contentView.addSubview(cardView)
        
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "fcr_room_list_room_created".localized()
        contentView.addSubview(label)
        
        label.mas_makeConstraints { make in
            make?.center.equalTo()(0)
            make?.height.greaterThanOrEqualTo()(20)
            make?.width.greaterThanOrEqualTo()(126)
        }
        cardView.mas_makeConstraints { make in
            make?.center.equalTo()(label)
            make?.width.equalTo()(label)?.offset()(44)
            make?.height.equalTo()(label)?.offset()(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//
