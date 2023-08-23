//
//  AgoraSharingLinkWidget.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/9/28.
//

import AgoraWidget

class AgoraSharingLinkWidget: AgoraBaseWidget {
    private let contentView = UIView()
    
    private let closeButton = UIButton(type: .custom)
    
    private let titleLabel = UILabel()
    
    private let roomIdTitleLabel = UILabel()
    
    private let roomIdDetailLabel = UILabel()
    
    private let roomIdCopyButton = UIButton(type: .custom)
    
    private let invitationTitleLabel = UILabel()
    
    private let sharingContentView = UIView()
    
    private let sharingLinkLabel = UILabel()
    
    private let sharingButton = UIButton(type: .custom)
    
    private let copyLinkButton = UIButton(type: .custom)
    
    private var roomId: String? {
        didSet {
            roomIdDetailLabel.text = roomId
        }
    }
    
    private var sharingLink: String = "" {
        didSet {
            sharingLinkLabel.text = sharingLink
        }
    }
        
    public override func onLoad() {
        super.onLoad()
        initViews()
        initViewFrame()
        updateViewProperties()
        updateInfo()
    }
    
    func updateInfo() {
        if let extra = info.extraInfo as? [String: Any],
           let link = extra["sharingLink"] as? String {
            sharingLink = link
        }
        roomId = info.roomInfo.roomUuid
    }
}
// MARK: - Actions
private extension AgoraSharingLinkWidget {
    @objc func onClickClose(_ sender: UIButton) {
        view.removeFromSuperview()
    }
    
    @objc func onClickCopyId(_ sender: UIButton) {
        guard let rid = roomId else {
            return
        }
        UIPasteboard.general.string = rid
        AgoraToast.toast(message: "fcr_joinroom_tips_copy".localized(),
                         type: .notice)
    }
    
    @objc func onClickCopyLink(_ sender: UIButton) {
        UIPasteboard.general.string = sharingLink
        AgoraToast.toast(message: "fcr_joinroom_tips_copy".localized(),
                         type: .notice)
    }
    
    @objc func onClickSendToFriend(_ sender: UIButton) {
        let topVC = UIViewController.agora_top_view_controller()
        let shareURL = URL(string: sharingLink)
        let activity = UIActivity()
        let shareVC = UIActivityViewController(activityItems: [sharingLink, shareURL],
                                               applicationActivities: [activity])
        if UIDevice.current.agora_is_pad {
            var frame = topVC.view.frame
            frame.size.height /= 2
            frame.origin = CGPoint(x: 0, y: 0)
            shareVC.popoverPresentationController?.sourceView = contentView
            shareVC.popoverPresentationController?.sourceRect = frame
            shareVC.popoverPresentationController?.permittedArrowDirections = .right
        }
        topVC.present(shareVC,
                      animated: true)
    }
}

extension AgoraSharingLinkWidget: AgoraUIContentContainer {
    public func initViews() {
        view.addSubview(contentView)
        contentView.addSubview(closeButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(roomIdTitleLabel)
        contentView.addSubview(roomIdDetailLabel)
        contentView.addSubview(roomIdCopyButton)
        contentView.addSubview(invitationTitleLabel)
        contentView.addSubview(sharingContentView)
        contentView.addSubview(sharingLinkLabel)
        contentView.addSubview(copyLinkButton)
        contentView.addSubview(sharingButton)
       
        closeButton.addTarget(self,
                              action: #selector(onClickClose(_:)),
                              for: .touchUpInside)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        roomIdTitleLabel.font = UIFont.boldSystemFont(ofSize: 12)
       
        roomIdDetailLabel.text = info.roomInfo.roomUuid
        roomIdDetailLabel.font = UIFont.systemFont(ofSize: 12)
        
        roomIdCopyButton.addTarget(self,
                                   action: #selector(onClickCopyId(_:)),
                                   for: .touchUpInside)
        
        invitationTitleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        sharingContentView.layer.cornerRadius = 4
        sharingContentView.clipsToBounds = true
        
        
        sharingLinkLabel.numberOfLines = 0
        
        sharingLinkLabel.font = UIFont.systemFont(ofSize: 12)
        
        copyLinkButton.addTarget(self,
                                 action: #selector(onClickCopyLink(_:)),
                                 for: .touchUpInside)
        
        sharingButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        sharingButton.layer.cornerRadius = 6
        sharingButton.clipsToBounds = true
        
        sharingButton.addTarget(self,
                                action: #selector(onClickSendToFriend(_:)),
                                for: .touchUpInside)
    }
    
    public func initViewFrame() {
        contentView.mas_makeConstraints { make in
            make?.top.bottom().right().equalTo()(0)
            make?.width.equalTo()(280)
        }
        
        closeButton.mas_makeConstraints { make in
            make?.top.right().equalTo()(0)
            make?.width.height().equalTo()(44)
        }
        
        titleLabel.mas_makeConstraints { make in
            make?.top.equalTo()(19)
            make?.left.equalTo()(15)
        }
        
        roomIdTitleLabel.mas_makeConstraints { make in
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(24)
            make?.left.equalTo()(titleLabel)
        }
        
        roomIdDetailLabel.mas_makeConstraints { make in
            make?.left.equalTo()(roomIdTitleLabel.mas_right)?.offset()(10)
            make?.centerY.equalTo()(roomIdTitleLabel)
            make?.width.lessThanOrEqualTo()(160)
        }
        
        roomIdCopyButton.mas_makeConstraints { make in
            make?.left.equalTo()(roomIdDetailLabel.mas_right)
            make?.width.height().equalTo()(44)
            make?.centerY.equalTo()(roomIdDetailLabel)
        }
        
        invitationTitleLabel.mas_makeConstraints { make in
            make?.top.equalTo()(roomIdTitleLabel.mas_bottom)?.offset()(24)
            make?.left.equalTo()(titleLabel)
        }
        
        sharingContentView.mas_makeConstraints { make in
            make?.top.equalTo()(invitationTitleLabel.mas_bottom)?.offset()(16)
            make?.left.equalTo()(15)
            make?.right.equalTo()(-15)
            make?.height.greaterThanOrEqualTo()(118)
        }
        sharingLinkLabel.mas_makeConstraints { make in
            make?.top.equalTo()(sharingContentView)?.offset()(10)
            make?.left.equalTo()(sharingContentView)?.offset()(10)
            make?.right.equalTo()(sharingContentView)?.offset()(-10)
            make?.bottom.equalTo()(sharingContentView)?.offset()(-44)
        }
        
        copyLinkButton.mas_makeConstraints { make in
            make?.width.height().equalTo()(24)
            make?.right.equalTo()(sharingContentView)?.offset()(-10)
            make?.bottom.equalTo()(sharingContentView)?.offset()(-10)
        }
        
        sharingButton.mas_makeConstraints { make in
            make?.left.equalTo()(sharingContentView)?.offset()(10)
            make?.bottom.equalTo()(sharingContentView)?.offset()(-10)
            make?.height.equalTo()(22)
            make?.right.equalTo()(copyLinkButton.mas_left)?.offset()(-6)
        }
    }
    
    public func updateViewProperties() {
        view.backgroundColor = .black.withAlphaComponent(0.4)
        contentView.backgroundColor = .white
        
        closeButton.setImage(UIImage(named: "fcr_share_close"),
                             for: .normal)
        
        titleLabel.text = "fcr_inshare_label_share".localized()
        titleLabel.textColor = UIColor(hex: 0x191919)
        
        roomIdTitleLabel.text = "fcr_inshare_label_room_id".localized()
        roomIdTitleLabel.textColor = UIColor(hex: 0x586376)
        
        roomIdDetailLabel.textColor = UIColor(hex: 0x191919)
        
        roomIdCopyButton.setImage(UIImage(named: "fcr_share_id_copy"),
                                  for: .normal)
        
        invitationTitleLabel.text = "fcr_inshare_label_invitation".localized()
        invitationTitleLabel.textColor = UIColor(hex: 0x586376)
        
        sharingContentView.backgroundColor = UIColor(hex: 0xF9F9FC)
        
        
        copyLinkButton.setImage(UIImage(named: "fcr_share_link_copy"),
                                for: .normal)
        
        sharingLinkLabel.textColor = UIColor(hex: 0xBDBDCA)
        
        sharingButton.setImage(UIImage(named: "fcr_share_link_send"),
                               for: .normal)
        
        sharingButton.setTitle("fcr_inshare_button_share_friends".localized(),
                               for: .normal)
        
        sharingButton.titleLabel?.textColor = .white
        sharingButton.backgroundColor = UIColor(hex: 0x357BF6)
    }
}
