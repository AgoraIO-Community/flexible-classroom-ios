//
//  FcrAppUITextView.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/8/24.
//  Copyright © 2023 Agora. All rights reserved.
//

import UIKit

class FcrAppUITextView: UITextView {
    override init(frame: CGRect,
                  textContainer: NSTextContainer?) {
        super.init(frame: frame,
                   textContainer: textContainer)
        
        self.isEditable = false
        self.isSelectable = true
        self.dataDetectorTypes = .link
        self.textContainerInset = UIEdgeInsets(top: 2,
                                               left: 0,
                                               bottom: 0,
                                               right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
