//
//  FcrAppUIRoomListItemCell.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/14.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

protocol FcrAppUIRoomListItemCellDelegate: NSObjectProtocol {
    func onPressedSharedButton(at indexPath: IndexPath)
    func onPressedEnteredButton(at indexPath: IndexPath)
    func onPressedCopiedButton(at indexPath: IndexPath)
}

typealias FcrAppUIRoomListItemCellType = FcrAppUIRoomState

class FcrAppUIRoomListItemCell: UITableViewCell {
    weak var delegate: FcrAppUIRoomListItemCellDelegate?
    
    var indexPath: IndexPath?
    
    var type: FcrAppUIRoomListItemCellType = .unstarted {
        didSet {
            guard oldValue != type else {
                return
            }
            
            updateType()
        }
    }
    
    private let cardView = UIView()
    
    private let stateIcon = UIImageView(image: UIImage(named: "fcr_room_list_state_live"))
    
    let stateLabel = UILabel()
    
    private let verticalLine = UIView()
    
    private let idTitleLabel = UILabel()
    
    let idLabel = UILabel()
    
    private let copyButton = UIButton(type: .custom)
    
    let nameLabel = UILabel()
    
    private let timeIcon = UIImageView(image: UIImage(named: "fcr_room_list_state_live"))
    
    let timeLabel = UILabel()
    
    private let typeIcon = UIImageView(image: UIImage(named: "fcr_room_list_state_live"))
        
    let typeLabel = UILabel()
    
    private let enterButton = UIButton(type: .custom)
    
    private let shareButton = UIButton(type: .custom)
    
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
}

// MARK: - Creations
extension FcrAppUIRoomListItemCell: AgoraUIContentContainer {
    func initViews() {
        contentView.addSubview(cardView)
        
        cardView.addSubview(stateIcon)
        cardView.addSubview(stateLabel)
        cardView.addSubview(verticalLine)
        cardView.addSubview(idTitleLabel)
        cardView.addSubview(idLabel)
        cardView.addSubview(copyButton)
        cardView.addSubview(nameLabel)
        cardView.addSubview(timeIcon)
        cardView.addSubview(timeLabel)
        cardView.addSubview(typeIcon)
        cardView.addSubview(typeLabel)
        cardView.addSubview(enterButton)
        cardView.addSubview(shareButton)
        
        copyButton.addTarget(self,
                             action: #selector(onClickCopy(_:)),
                             for: .touchUpInside)
        
        enterButton.addTarget(self,
                              action: #selector(onClickEnter(_:)),
                              for: .touchUpInside)
        
        shareButton.addTarget(self,
                              action: #selector(onClickShare(_:)),
                              for: .touchUpInside)
    }
    
    func initViewFrame() {
        cardView.mas_makeConstraints { make in
            make?.edges.equalTo()(UIEdgeInsets(top: 6,
                                               left: 14,
                                               bottom: 6,
                                               right: 14))
        }
        
        stateIcon.mas_makeConstraints { make in
            make?.left.top().equalTo()(14)
        }
        
        stateLabel.mas_makeConstraints { make in
            make?.left.equalTo()(17)
            make?.centerY.equalTo()(stateIcon)
        }
        
        verticalLine.mas_makeConstraints { make in
            make?.left.equalTo()(stateLabel.mas_right)?.offset()(8)
            make?.centerY.equalTo()(stateLabel)
            make?.width.equalTo()(1)
            make?.height.equalTo()(8)
        }
        
        idTitleLabel.mas_makeConstraints { make in
            make?.left.equalTo()(verticalLine.mas_right)?.offset()(12)
            make?.centerY.equalTo()(stateLabel)
        }
        
        idLabel.mas_makeConstraints { make in
            make?.left.equalTo()(idTitleLabel.mas_right)?.offset()(4)
            make?.centerY.equalTo()(stateLabel)
        }
        
        copyButton.mas_makeConstraints { make in
            make?.left.equalTo()(idLabel.mas_right)
            make?.centerY.equalTo()(stateLabel)
        }
        
        shareButton.mas_makeConstraints { make in
            make?.top.equalTo()(14)
            make?.right.equalTo()(-12)
        }
        
        nameLabel.mas_makeConstraints { make in
            make?.left.equalTo()(17)
            make?.top.equalTo()(stateLabel.mas_bottom)?.offset()(12)
        }
        
        timeIcon.mas_makeConstraints { make in
            make?.top.equalTo()(nameLabel.mas_bottom)?.offset()(17)
            make?.left.equalTo()(nameLabel)
        }
        
        timeLabel.mas_makeConstraints { make in
            make?.centerY.equalTo()(timeIcon)
            make?.left.equalTo()(timeIcon.mas_right)?.offset()(8)
        }
        
        typeIcon.mas_makeConstraints { make in
            make?.top.equalTo()(timeLabel.mas_bottom)?.offset()(7)
            make?.left.equalTo()(nameLabel)
        }
        
        typeLabel.mas_makeConstraints { make in
            make?.centerY.equalTo()(typeIcon)
            make?.left.equalTo()(typeIcon.mas_right)?.offset()(8)
        }
        
        enterButton.mas_makeConstraints { make in
            make?.right.offset()(-14)
            make?.bottom.offset()(-19)
            make?.width.equalTo()(100)
            make?.height.equalTo()(36)
        }
    }
    
    func updateViewProperties() {
        cardView.backgroundColor = UIColor(hex: 0x5765FF)
        cardView.layer.cornerRadius = 16
        cardView.clipsToBounds = true
        
        stateLabel.font = UIFont.boldSystemFont(ofSize: 12)
        stateLabel.text = "   "
        
        idTitleLabel.text = "ID"
        idTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        idLabel.font = UIFont.systemFont(ofSize: 10)
        
        copyButton.setImage(UIImage(named: "fcr_room_list_copy_black"),
                            for: .normal)
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        timeLabel.font = UIFont.systemFont(ofSize: 10)
        
        typeLabel.font = UIFont.systemFont(ofSize: 10)
        
        enterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        enterButton.layer.cornerRadius = 18
        enterButton.clipsToBounds = true
        enterButton.setTitle("fcr_room_list_enter".localized(),
                             for: .normal)
        
        shareButton.setImage(UIImage(named: "fcr_room_list_share_black"),
                             for: .normal)
        
        updateType()
    }
    
    func updateType() {
        switch type {
        case .unstarted:
            cardView.alpha = 1
            stateIcon.isHidden = true
            cardView.backgroundColor = UIColor(hex: 0xE4E6FF)
            shareButton.isHidden = false
            enterButton.isHidden = false
            enterButton.backgroundColor = UIColor(hex: 0x357BF6)
            enterButton.setTitleColor(.white,
                                      for: .normal)
            copyButton.isHidden = false
            shareButton.setImage(UIImage(named: "fcr_room_list_share_black"),
                                 for: .normal)
            copyButton.setImage(UIImage(named: "fcr_room_list_copy_black"),
                                for: .normal)
            timeIcon.image = UIImage(named: "fcr_room_list_clock_black")
            typeIcon.image = UIImage(named: "fcr_room_list_label_black")
            verticalLine.backgroundColor = .black
            
            // text color
            stateLabel.textColor = .black
            idTitleLabel.textColor = .black
            idLabel.textColor = .black
            nameLabel.textColor = .black
            timeLabel.textColor = .black
            typeLabel.textColor = .black
            
            stateLabel.mas_updateConstraints { make in
                make?.left.equalTo()(17)
            }
        case .inProgress:
            cardView.alpha = 1
            stateIcon.isHidden = false
            cardView.backgroundColor = UIColor(hex: 0x5765FF)
            shareButton.isHidden = false
            enterButton.isHidden = false
            enterButton.backgroundColor = .black
            shareButton.setImage(UIImage(named: "fcr_room_list_share_white"),
                                 for: .normal)
            copyButton.isHidden = false
            copyButton.setImage(UIImage(named: "fcr_room_list_copy_white"),
                                for: .normal)
            timeIcon.image = UIImage(named: "fcr_room_list_clock_white")
            typeIcon.image = UIImage(named: "fcr_room_list_label_white")
            verticalLine.backgroundColor = .white
            
            // text color
            stateLabel.textColor = .white
            idTitleLabel.textColor = .white
            idLabel.textColor = .white
            nameLabel.textColor = .white
            timeLabel.textColor = .white
            typeLabel.textColor = .white
            
            stateLabel.mas_updateConstraints { make in
                make?.left.equalTo()(35)
            }
        case .closed:
            cardView.alpha = 0.5
            cardView.backgroundColor = UIColor(hex: 0xF0F0F7)
            verticalLine.backgroundColor = .black
            
            stateIcon.isHidden = true
            shareButton.isHidden = true
            enterButton.isHidden = true
            copyButton.isHidden = true
            
            timeIcon.image = UIImage(named: "fcr_room_list_clock_black")
            typeIcon.image = UIImage(named: "fcr_room_list_label_black")
            
            // text color
            stateLabel.textColor = .black
            idTitleLabel.textColor = .black
            idLabel.textColor = .black
            nameLabel.textColor = .black
            timeLabel.textColor = .black
            typeLabel.textColor = .black
            
            stateLabel.mas_updateConstraints { make in
                make?.left.equalTo()(17)
            }
        }
    }
}

private extension FcrAppUIRoomListItemCell {
    @objc func onClickShare(_ sender: UIButton) {
        guard let i = indexPath else {
            return
        }
        
        delegate?.onPressedSharedButton(at: i)
    }
    
    @objc func onClickEnter(_ sender: UIButton) {
        guard let i = indexPath else {
            return
        }
        
        delegate?.onPressedEnteredButton(at: i)
    }
    
    @objc func onClickCopy(_ sender: UIButton) {
        guard let i = indexPath else {
            return
        }
        delegate?.onPressedCopiedButton(at: i)
    }
}
