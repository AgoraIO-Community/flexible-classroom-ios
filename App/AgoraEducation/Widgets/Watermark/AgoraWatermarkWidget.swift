//
//  AgoraWatermarkWidget.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/9/28.
//

import AgoraWidget
import UIKit

class AgoraWatermarkWidget: AgoraBaseWidget {
    private let label = UILabel()
        
    public override func onLoad() {
        super.onLoad()
        createViews()
        circleText()
        updateInfo()
    }
    
    func updateInfo() {
        if let extra = info.extraInfo as? [String: Any],
           let text = extra["watermark"] as? String {
            label.text = text
        }
    }
    
    func circleText() {
        UIView.animate(withDuration: 20,
                       delay: 0,
                       options: .curveLinear,
                       animations: {
            let leftEnd = -self.label.width - self.view.width
            self.label.transform = .init(translationX: leftEnd,
                                         y: 0)
        }) { [weak self] (bool)  in
            self?.label.transform = .identity
            self?.circleText()
        }
    }
}

// MARK: - View
private extension AgoraWatermarkWidget {
    func createViews() {
        label.alpha = 0.15
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 40)
        view.addSubview(label)
        label.mas_makeConstraints { make in
            make?.top.equalTo()(30)
            make?.left.equalTo()(view.mas_right)
        }
    }
}
