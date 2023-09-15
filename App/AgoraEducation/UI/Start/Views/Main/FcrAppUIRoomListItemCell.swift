//
//  FcrAppUIRoomListItemCell.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/14.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

protocol FcrAppUIRoomListItemCellDelegate: NSObjectProtocol {
    func onSharedButtonPressed(at indexPath: IndexPath)
    func onEnteredButtonPressed(at indexPath: IndexPath)
    func onCopiedButtonPressed(at indexPath: IndexPath)
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
    
    private let copiedButton = UIButton(type: .custom)
    
    let nameLabel = UILabel()
    
    private let timeIcon = UIImageView(image: UIImage(named: "fcr_room_list_state_live"))
    
    let timeLabel = UILabel()
    
    private let typeIcon = UIImageView(image: UIImage(named: "fcr_room_list_state_live"))
        
    let typeLabel = UILabel()
    
    private let enteredButton = UIButton(type: .custom)
    
    private let sharedButton = UIButton(type: .custom)
    
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
        cardView.addSubview(copiedButton)
        cardView.addSubview(nameLabel)
        cardView.addSubview(timeIcon)
        cardView.addSubview(timeLabel)
        cardView.addSubview(typeIcon)
        cardView.addSubview(typeLabel)
        cardView.addSubview(enteredButton)
        cardView.addSubview(sharedButton)
        
        nameLabel.numberOfLines = 0
        
        copiedButton.addTarget(self,
                             action: #selector(onCopiedButtonPressed(_:)),
                             for: .touchUpInside)
        
        enteredButton.addTarget(self,
                              action: #selector(onEnteredButtonPressed(_:)),
                              for: .touchUpInside)
        
        sharedButton.addTarget(self,
                              action: #selector(onSharedButtonPressed(_:)),
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
        
        copiedButton.mas_makeConstraints { make in
            make?.left.equalTo()(idLabel.mas_right)
            make?.centerY.equalTo()(stateLabel)
        }
        
        sharedButton.mas_makeConstraints { make in
            make?.top.equalTo()(16)
            make?.right.equalTo()(-16)
        }
        
        nameLabel.mas_makeConstraints { make in
            make?.left.equalTo()(16)
            make?.top.equalTo()(stateLabel.mas_bottom)?.offset()(12)
            make?.right.equalTo()(-16)
        }
        
        timeIcon.mas_makeConstraints { make in
            make?.top.equalTo()(nameLabel.mas_bottom)?.offset()(17)
            make?.left.equalTo()(nameLabel)
        }
        
        timeLabel.mas_makeConstraints { make in
            make?.centerY.equalTo()(timeIcon)
            make?.left.equalTo()(timeIcon.mas_right)?.offset()(5)
        }
        
        typeIcon.mas_makeConstraints { make in
            make?.top.equalTo()(timeLabel.mas_bottom)?.offset()(7)
            make?.left.equalTo()(nameLabel)
        }
        
        typeLabel.mas_makeConstraints { make in
            make?.centerY.equalTo()(typeIcon)
            make?.left.equalTo()(typeIcon.mas_right)?.offset()(5)
        }
        
        enteredButton.mas_makeConstraints { make in
            make?.top.equalTo()(timeLabel.mas_top)?.offset()(2)
            make?.right.offset()(-16)
            make?.width.equalTo()(100)
            make?.height.equalTo()(36)
        }
    }
    
    func updateViewProperties() {
        cardView.backgroundColor = UIColor(hex: 0x5765FF)
        cardView.layer.cornerRadius = 16
        cardView.clipsToBounds = true
        
        stateLabel.font = FcrAppUIFontGroup.font12
        stateLabel.text = "   "
        
        idTitleLabel.text = "ID"
        idTitleLabel.font = UIFont.systemFont(ofSize: 10,
                                              weight: .bold)
        
        idLabel.font = FcrAppUIFontGroup.font10
        
        copiedButton.setImage(UIImage(named: "fcr_room_list_copy_black"),
                            for: .normal)
        
        nameLabel.font = FcrAppUIFontGroup.font16
        
        timeLabel.font = FcrAppUIFontGroup.font10
        
        typeLabel.font = FcrAppUIFontGroup.font10
        
        enteredButton.titleLabel?.font = UIFont.systemFont(ofSize: 12,
                                                           weight: .heavy)
        enteredButton.layer.cornerRadius = 18
        enteredButton.clipsToBounds = true
        enteredButton.setTitle("fcr_home_button_join".localized(),
                               for: .normal)
        
        sharedButton.setImage(UIImage(named: "fcr_room_list_share_black"),
                              for: .normal)
        
        updateType()
    }
    
    func updateType() {
        switch type {
        case .unstarted:
            cardView.alpha = 1
            cardView.backgroundColor = UIColor(hex: 0xE4E6FF)
            
            stateIcon.isHidden = true
            
            sharedButton.isHidden = false
            sharedButton.setImage(UIImage(named: "fcr_room_list_share_black"),
                                 for: .normal)
            
            enteredButton.isHidden = false
            enteredButton.backgroundColor = FcrAppUIColorGroup.fcr_v2_brand6
            enteredButton.setTitleColor(.white,
                                      for: .normal)
            
            copiedButton.isHidden = false
            copiedButton.setImage(UIImage(named: "fcr_room_list_copy_black"),
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
            cardView.backgroundColor = UIColor(hex: 0x5765FF)
            
            stateIcon.isHidden = false
            
            sharedButton.isHidden = false
            sharedButton.setImage(UIImage(named: "fcr_room_list_share_white"),
                                 for: .normal)
            
            enteredButton.isHidden = false
            enteredButton.backgroundColor = .black
            
            copiedButton.isHidden = false
            copiedButton.setImage(UIImage(named: "fcr_room_list_copy_white"),
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
            sharedButton.isHidden = true
            enteredButton.isHidden = true
            copiedButton.isHidden = true
            
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
    @objc func onSharedButtonPressed(_ sender: UIButton) {
        guard let index = indexPath else {
            return
        }
        
        delegate?.onSharedButtonPressed(at: index)
    }
    
    @objc func onEnteredButtonPressed(_ sender: UIButton) {
        guard let index = indexPath else {
            return
        }
        
        delegate?.onEnteredButtonPressed(at: index)
    }
    
    @objc func onCopiedButtonPressed(_ sender: UIButton) {
        guard let index = indexPath else {
            return
        }
        
        delegate?.onCopiedButtonPressed(at: index)
    }
}
