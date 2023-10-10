//
//  FcrAppUIPolicyView.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/9/22.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraUIBaseViews

fileprivate class FcrAppUIPolicyCheckBox: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let `imageView` = imageView else {
            return
        }
        
        imageView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: 16,
                                 height: 16)
    }
}

class FcrAppUIPolicyView: UIView,
                          AgoraUIContentContainer {
    let checkBoxNormalImage: String
    let checkBoxSelectedImage: String
    
    let checkBox: UIButton = FcrAppUIPolicyCheckBox(frame: .zero)
    let textView = FcrAppUITextView(frame: .zero,
                                    textContainer: nil)
    
    init(checkBoxNormalImage: String,
         checkBoxSelectedImage: String) {
        self.checkBoxNormalImage = checkBoxNormalImage
        self.checkBoxSelectedImage = checkBoxSelectedImage
        super.init(frame: .zero)
        initViews()
        initViewFrame()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        addSubview(checkBox)
        addSubview(textView)
    }
    
    func initViewFrame() {
        checkBox.mas_makeConstraints { make in
            make?.top.equalTo()(1)
            make?.left.equalTo()(0)
            make?.width.height().equalTo()(19)
        }
        
        textView.mas_makeConstraints { make in
            make?.left.equalTo()(self.checkBox.mas_right)?.offset()(0)
            make?.right.top().bottom().equalTo()(0)
        }
    }
    
    func updateViewProperties() {
        checkBox.setImage(UIImage(named: checkBoxNormalImage),
                          for: .normal)
        checkBox.setImage(UIImage(named: checkBoxSelectedImage),
                          for: .selected)
    }
}
