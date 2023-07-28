//
//  FcrAppUICreateRoomViews.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/7/28.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUICreateRoomTopView: UIView, AgoraUIContentContainer {
    private let roomNameTextField = FcrAppUIRoomNameTextField(frame: .zero)
    private let userNameTextField = FcrAppUIRoomNameTextField(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        initViewFrame()
        updateViewProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(roomNameTextField)
        addSubview(userNameTextField)
    }
    
    func initViewFrame() {
        roomNameTextField.mas_makeConstraints { make in
            make?.top.equalTo()(self.mas_top)
            make?.left.equalTo()(self.mas_left)
            make?.right.equalTo()(self.mas_right)
            make?.height.equalTo()(60)
        }
        
        userNameTextField.mas_makeConstraints { make in
            make?.top.equalTo()(self.roomNameTextField.mas_bottom)
            make?.left.equalTo()(self.mas_left)
            make?.right.equalTo()(self.mas_right)
            make?.height.equalTo()(60)
        }
    }
    
    func updateViewProperties() {
        backgroundColor = .white
        
        roomNameTextField.backgroundColor = .white
        userNameTextField.backgroundColor = .white
    }
}
