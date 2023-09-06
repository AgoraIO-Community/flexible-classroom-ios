//
//  FcrAppUIRoomDurationViewController.swift
//  AgoraEducation
//
//  Created by Cavan on 2023/9/5.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

class FcrAppUIRoomDurationViewController: FcrAppUIViewController {
    private let textField = FcrAppUIIconTextField(leftViewType: .text)
    private let line = UIView()
    private var center = FcrAppCenter()
    
    init(center: FcrAppCenter) {
        super.init(nibName: nil,
                   bundle: nil)
        
        self.center = center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        initViewFrame()
        updateViewProperties()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let text = textField.getText(),
              let duration = UInt(text)
        else {
            return
        }
        
        center.room.duration = duration
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        super.touchesBegan(touches,
                           with: event)
        textField.resignFirstResponder()
    }
}

extension FcrAppUIRoomDurationViewController: AgoraUIContentContainer {
    func initViews() {
        let label = UILabel()
        label.text = "Minute:"
        
        textField.leftView = label
        textField.text = "\(center.room.duration)"
        textField.keyboardType = .numberPad
        textField.clearButtonMode = .whileEditing
        
        view.addSubview(textField)
//        view.addSubview(line)
    }
    
    func initViewFrame() {
        textField.mas_makeConstraints { make in
            make?.top.equalTo()(self.mas_topLayoutGuideBottom)
            make?.left.equalTo()(16)
            make?.right.equalTo()(-16)
            make?.height.equalTo()(52)
        }
        
//        line.mas_makeConstraints { make in
//            make?.left.right().equalTo()(0)
//            make?.height.equalTo()(1)
//            make?.top.equalTo()(textField.mas_bottom)
//        }
    }
    
    func updateViewProperties() {
        title = "Room duration"
        view.backgroundColor = .white
    }
}
